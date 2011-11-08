Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42647 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab1KHXPW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 18:15:22 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v9 2/2] mac80211:  Support ht-cap over-rides.
Date: Tue,  8 Nov 2011 15:15:14 -0800
Message-Id: <1320794114-330-1-git-send-email-greearb@candelatech.com> (sfid-20111109_001525_503414_3752825C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This implements ht-cap over-rides for mac80211 drivers.
HT may be disabled, making an /a/b/g/n station act like an
a/b/g station.  HT40 may be disabled forcing the station to
be HT20 even if the AP and local hardware support HT40.

MAX-AMSDU may be disabled.
AMPDU-Density may be increased.
AMPDU-Factor may be decreased.

This has been successfully tested with ath9k using patched
wpa_supplicant and iw.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v9:  Remove minimum mcs rate advertising.  Just let
     users advertise as few rates as they desire.

NOTE:  Did not make the suggested change of caching the
     derived ht-cap struct.

:100644 100644 a9ded52... 7f4389e... M	net/mac80211/cfg.c
:100644 100644 f80a35c... e631925... M	net/mac80211/ht.c
:100644 100644 ea10a51... cefcbc6... M	net/mac80211/ieee80211_i.h
:100644 100644 d4ee6d2... 7be5ad8... M	net/mac80211/main.c
:100644 100644 2fbd652... 84d6943... M	net/mac80211/mlme.c
:100644 100644 6c53b6d... dd1e00b... M	net/mac80211/work.c
 net/mac80211/cfg.c         |    2 +-
 net/mac80211/ht.c          |   75 +++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/ieee80211_i.h |    9 +++++-
 net/mac80211/main.c        |   14 ++++++++
 net/mac80211/mlme.c        |   12 ++++++-
 net/mac80211/work.c        |   30 ++++++++++++------
 6 files changed, 127 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a9ded52..7f4389e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -778,7 +778,7 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 	}
 
 	if (params->ht_capa)
-		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 						  params->ht_capa,
 						  &sta->sta.ht_cap);
 
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index f80a35c..e631925 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -18,7 +18,74 @@
 #include "ieee80211_i.h"
 #include "rate.h"
 
-void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
+bool ieee80111_cfg_override_disables_ht40(struct ieee80211_sub_if_data *sdata)
+{
+	const u16 flg = IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+	if ((sdata->u.mgd.ht_capa_mask.cap_info & flg) &&
+	    !(sdata->u.mgd.ht_capa.cap_info & flg))
+		return true;
+	return false;
+}
+
+void __check_htcap_disable(struct ieee80211_sub_if_data *sdata,
+			   struct ieee80211_sta_ht_cap *ht_cap,
+			   u16 flag)
+{
+	if (sdata->u.mgd.ht_capa_mask.cap_info & flag) {
+		if (!(sdata->u.mgd.ht_capa.cap_info & flag))
+			ht_cap->cap &= ~flag;
+	}
+}
+
+void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_sta_ht_cap *ht_cap)
+{
+	u8 *scaps = (u8 *)(&sdata->u.mgd.ht_capa.mcs.rx_mask);
+	u8 *smask = (u8 *)(&sdata->u.mgd.ht_capa_mask.mcs.rx_mask);
+	int i;
+
+	/* NOTE:  If you add more over-rides here, update register_hw
+	 * ht_capa_mod_msk logic in main.c as well.
+	 */
+
+	/* check for HT over-rides, MCS rates first. */
+	for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++) {
+		u8 m = smask[i];
+		ht_cap->mcs.rx_mask[i] &= ~m; /* turn off all masked bits */
+		/* Add back rates that are supported */
+		ht_cap->mcs.rx_mask[i] |= (m & scaps[i]);
+	}
+
+	/* Force removal of HT-40 capabilities? */
+	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_SUP_WIDTH_20_40);
+	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_SGI_40);
+
+	/* Allow user to disable the max-AMSDU bit. */
+	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_MAX_AMSDU);
+
+	/* Allow user to decrease AMPDU factor */
+	if (sdata->u.mgd.ht_capa_mask.ampdu_params_info &
+	    IEEE80211_HT_AMPDU_PARM_FACTOR) {
+		u16 n = sdata->u.mgd.ht_capa.ampdu_params_info
+			& IEEE80211_HT_AMPDU_PARM_FACTOR;
+		if (n < ht_cap->ampdu_factor)
+			ht_cap->ampdu_factor = n;
+	}
+
+	/* Allow the user to increase AMPDU density. */
+	if (sdata->u.mgd.ht_capa_mask.ampdu_params_info &
+	    IEEE80211_HT_AMPDU_PARM_DENSITY) {
+		u16 n = (sdata->u.mgd.ht_capa.ampdu_params_info &
+			 IEEE80211_HT_AMPDU_PARM_DENSITY)
+			>> IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT;
+		if (n > ht_cap->ampdu_density)
+			ht_cap->ampdu_density = n;
+	}
+}
+
+
+void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
+				       struct ieee80211_supported_band *sband,
 				       struct ieee80211_ht_cap *ht_cap_ie,
 				       struct ieee80211_sta_ht_cap *ht_cap)
 {
@@ -102,6 +169,12 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
 	/* handle MCS rate 32 too */
 	if (sband->ht_cap.mcs.rx_mask[32/8] & ht_cap_ie->mcs.rx_mask[32/8] & 1)
 		ht_cap->mcs.rx_mask[32/8] |= 1;
+
+	/*
+	 * If user has specified capability over-rides, take care
+	 * of that here.
+	 */
+	ieee80211_apply_htcap_overrides(sdata, ht_cap);
 }
 
 void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta, bool tx)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ea10a51..cefcbc6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -443,6 +443,9 @@ struct ieee80211_if_managed {
 	 */
 	int rssi_min_thold, rssi_max_thold;
 	int last_ave_beacon_signal;
+	struct ieee80211_ht_cap ht_capa; /* configured ht-cap over-rides */
+	struct ieee80211_ht_cap ht_capa_mask; /* Valid parts of ht_capa */
+
 };
 
 struct ieee80211_if_ibss {
@@ -1179,7 +1182,11 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 				       struct net_device *dev);
 
 /* HT */
-void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
+bool ieee80111_cfg_override_disables_ht40(struct ieee80211_sub_if_data *sdata);
+void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_sta_ht_cap *ht_cap);
+void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
+				       struct ieee80211_supported_band *sband,
 				       struct ieee80211_ht_cap *ht_cap_ie,
 				       struct ieee80211_sta_ht_cap *ht_cap);
 void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d4ee6d2..7be5ad8 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -560,6 +560,19 @@ ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 	},
 };
 
+static const struct ieee80211_ht_cap mac80211_ht_capa_mod_mask = {
+	.ampdu_params_info = IEEE80211_HT_AMPDU_PARM_FACTOR |
+			     IEEE80211_HT_AMPDU_PARM_DENSITY,
+
+	.cap_info = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
+		    IEEE80211_HT_CAP_MAX_AMSDU |
+		    IEEE80211_HT_CAP_SGI_40,
+	.mcs = {
+		.rx_mask = { 0xff, 0xff, 0xff, 0xff, 0xff,
+			     0xff, 0xff, 0xff, 0xff, 0xff, },
+	},
+};
+
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					const struct ieee80211_ops *ops)
 {
@@ -628,6 +641,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	local->user_power_level = -1;
 	local->uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
 	local->uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
+	wiphy->ht_capa_mod_mask = &mac80211_ht_capa_mod_mask;
 
 	INIT_LIST_HEAD(&local->interfaces);
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2fbd652..84d6943 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -207,6 +207,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		channel_type = NL80211_CHAN_HT20;
 
 		if (!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
+		    !ieee80111_cfg_override_disables_ht40(sdata) &&
 		    (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
 		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
 			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
@@ -1603,7 +1604,7 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
 
 	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
-		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 				elems.ht_cap_elem, &sta->sta.ht_cap);
 
 	ap_ht_cap_flags = sta->sta.ht_cap.cap;
@@ -1972,7 +1973,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
-		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 				elems.ht_cap_elem, &sta->sta.ht_cap);
 
 		ap_ht_cap_flags = sta->sta.ht_cap.cap;
@@ -2630,6 +2631,13 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
 
 
+	if (req->flags & ASSOC_REQ_DISABLE_HT)
+		ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
+
+	memcpy(&ifmgd->ht_capa, &req->ht_capa, sizeof(ifmgd->ht_capa));
+	memcpy(&ifmgd->ht_capa_mask, &req->ht_capa_mask,
+	       sizeof(ifmgd->ht_capa_mask));
+
 	if (req->ie && req->ie_len) {
 		memcpy(wk->ie, req->ie, req->ie_len);
 		wk->ie_len = req->ie_len;
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 6c53b6d..dd1e00b 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -94,7 +94,8 @@ static int ieee80211_compatible_rates(const u8 *supp_rates, int supp_rates_len,
 
 /* frame sending functions */
 
-static void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
+static void ieee80211_add_ht_ie(struct ieee80211_sub_if_data *sdata,
+				struct sk_buff *skb, const u8 *ht_info_ie,
 				struct ieee80211_supported_band *sband,
 				struct ieee80211_channel *channel,
 				enum ieee80211_smps_mode smps)
@@ -102,11 +103,11 @@ static void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
 	struct ieee80211_ht_info *ht_info;
 	u8 *pos;
 	u32 flags = channel->flags;
-	u16 cap = sband->ht_cap.cap;
+	u16 cap;
 	__le16 tmp;
+	struct ieee80211_sta_ht_cap ht_cap;
 
-	if (!sband->ht_cap.ht_supported)
-		return;
+	BUILD_BUG_ON(sizeof(ht_cap) != sizeof(sband->ht_cap));
 
 	if (!ht_info_ie)
 		return;
@@ -114,6 +115,15 @@ static void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
 	if (ht_info_ie[1] < sizeof(struct ieee80211_ht_info))
 		return;
 
+	memcpy(&ht_cap, &sband->ht_cap, sizeof(ht_cap));
+
+	ieee80211_apply_htcap_overrides(sdata, &ht_cap);
+
+	cap = ht_cap.cap;
+
+	if (!ht_cap.ht_supported)
+		return;
+
 	ht_info = (struct ieee80211_ht_info *)(ht_info_ie + 2);
 
 	/* determine capability flags */
@@ -166,13 +176,13 @@ static void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
 	pos += sizeof(u16);
 
 	/* AMPDU parameters */
-	*pos++ = sband->ht_cap.ampdu_factor |
-		 (sband->ht_cap.ampdu_density <<
-			IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
+	*pos++ = ht_cap.ampdu_factor |
+		 (ht_cap.ampdu_density <<
+		  IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
 
 	/* MCS set */
-	memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
-	pos += sizeof(sband->ht_cap.mcs);
+	memcpy(pos, &ht_cap.mcs, sizeof(ht_cap.mcs));
+	pos += sizeof(ht_cap.mcs);
 
 	/* extended capabilities */
 	pos += sizeof(__le16);
@@ -356,7 +366,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 
 	if (wk->assoc.use_11n && wk->assoc.wmm_used &&
 	    local->hw.queues >= 4)
-		ieee80211_add_ht_ie(skb, wk->assoc.ht_information_ie,
+		ieee80211_add_ht_ie(sdata, skb, wk->assoc.ht_information_ie,
 				    sband, wk->chan, wk->assoc.smps);
 
 	/* if present, add any custom non-vendor IEs that go after HT */
-- 
1.7.3.4

