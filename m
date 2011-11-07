Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60703 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1KGVfQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 16:35:16 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v5 2/2] mac80211:  Support ht-cap over-rides.
Date: Mon,  7 Nov 2011 13:35:02 -0800
Message-Id: <1320701702-13968-2-git-send-email-greearb@candelatech.com> (sfid-20111107_223533_160675_B3D78666)
In-Reply-To: <1320701702-13968-1-git-send-email-greearb@candelatech.com>
References: <1320701702-13968-1-git-send-email-greearb@candelatech.com>
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

* Remove disable-ht40 option...just modify the ht-cap flags instead.

* Use static for ht-cap-mod-mask struct.

:100644 100644 48363c3... 25ea406... M	include/linux/ieee80211.h
:100644 100644 a9ded52... 7f4389e... M	net/mac80211/cfg.c
:100644 100644 f80a35c... 47b89bb... M	net/mac80211/ht.c
:100644 100644 ea10a51... 6afa409... M	net/mac80211/ieee80211_i.h
:100644 100644 d4ee6d2... 7be5ad8... M	net/mac80211/main.c
:100644 100644 57fb58f... 7c71db0... M	net/mac80211/mlme.c
:100644 100644 6c53b6d... 3f318df... M	net/mac80211/work.c
 include/linux/ieee80211.h  |    6 +++
 net/mac80211/cfg.c         |    2 +-
 net/mac80211/ht.c          |   90 +++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/ieee80211_i.h |   10 ++++-
 net/mac80211/main.c        |   14 +++++++
 net/mac80211/mlme.c        |   12 +++++-
 net/mac80211/work.c        |   35 ++++++++++++-----
 7 files changed, 154 insertions(+), 15 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 48363c3..25ea406 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -906,6 +906,12 @@ struct ieee80211_mcs_info {
 #define IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT	2
 #define		IEEE80211_HT_MCS_TX_MAX_STREAMS	4
 #define IEEE80211_HT_MCS_TX_UNEQUAL_MODULATION	0x10
+/*
+ * Stations supporting 802.11n are required to support
+ * at least the first 8 MCS rates.  See section 7.3.2.56.4
+ * and 20.1.1 of the 802.11n spec.
+ */
+#define IEEE80211_HT_MCS_REQ_RATES_STA		8
 
 /*
  * 802.11n D5.0 20.3.5 / 20.6 says:
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
index f80a35c..47b89bb 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -18,7 +18,89 @@
 #include "ieee80211_i.h"
 #include "rate.h"
 
-void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
+bool ieee80111_cfg_override_disables_ht40(struct ieee80211_sub_if_data *sdata)
+{
+	if ((sdata->u.mgd.ht_capa_mask.cap_info &
+	     IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
+	    !(sdata->u.mgd.ht_capa.cap_info &
+	      IEEE80211_HT_CAP_SUP_WIDTH_20_40))
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
+				     struct ieee80211_sta_ht_cap *ht_cap,
+				     int min_rates)
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
+		int q;
+		for (q = 0; q < 8; q++) {
+			/*
+			 * We always need to advert at least MCS0-7, to
+			 * be a compliant HT station, for instance
+			 */
+			if (((i * 8 + q) >= min_rates) &&
+			    (smask[i] & (1<<q))) {
+				if (!(scaps[i] & (1<<q))) {
+					/*
+					 * Can only disable rates, not force
+					 * new ones
+					 */
+					ht_cap->mcs.rx_mask[i] &= ~(1<<q);
+				}
+			}
+		}
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
@@ -102,6 +184,12 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
 	/* handle MCS rate 32 too */
 	if (sband->ht_cap.mcs.rx_mask[32/8] & ht_cap_ie->mcs.rx_mask[32/8] & 1)
 		ht_cap->mcs.rx_mask[32/8] |= 1;
+
+	/*
+	 * If user has specified capability over-rides, take care
+	 * of that here.
+	 */
+	ieee80211_apply_htcap_overrides(sdata, ht_cap, 0);
 }
 
 void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta, bool tx)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ea10a51..6afa409 100644
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
@@ -1179,7 +1182,12 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 				       struct net_device *dev);
 
 /* HT */
-void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
+bool ieee80111_cfg_override_disables_ht40(struct ieee80211_sub_if_data *sdata);
+void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_sta_ht_cap *ht_cap,
+				     int min_rates);
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
index 57fb58f..7c71db0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -207,6 +207,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		channel_type = NL80211_CHAN_HT20;
 
 		if (!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
+		    !ieee80111_cfg_override_disables_ht40(sdata) &&
 		    (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
 		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
 			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
@@ -1584,7 +1585,7 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
 
 	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
-		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 				elems.ht_cap_elem, &sta->sta.ht_cap);
 
 	ap_ht_cap_flags = sta->sta.ht_cap.cap;
@@ -1953,7 +1954,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
-		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 				elems.ht_cap_elem, &sta->sta.ht_cap);
 
 		ap_ht_cap_flags = sta->sta.ht_cap.cap;
@@ -2611,6 +2612,13 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
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
index 6c53b6d..3f318df 100644
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
@@ -114,6 +115,20 @@ static void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
 	if (ht_info_ie[1] < sizeof(struct ieee80211_ht_info))
 		return;
 
+	memcpy(&ht_cap, &sband->ht_cap, sizeof(ht_cap));
+	/*
+	 * This is for an association attempt, and stations must
+	 * support at least the first 8 MCS rates.  See section 20.1.1
+	 * of the 802.11n spec for details.
+	 */
+	ieee80211_apply_htcap_overrides(sdata, &ht_cap,
+					IEEE80211_HT_MCS_REQ_RATES_STA);
+
+	cap = ht_cap.cap;
+
+	if (!ht_cap.ht_supported)
+		return;
+
 	ht_info = (struct ieee80211_ht_info *)(ht_info_ie + 2);
 
 	/* determine capability flags */
@@ -166,13 +181,13 @@ static void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
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
@@ -356,7 +371,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 
 	if (wk->assoc.use_11n && wk->assoc.wmm_used &&
 	    local->hw.queues >= 4)
-		ieee80211_add_ht_ie(skb, wk->assoc.ht_information_ie,
+		ieee80211_add_ht_ie(sdata, skb, wk->assoc.ht_information_ie,
 				    sband, wk->chan, wk->assoc.smps);
 
 	/* if present, add any custom non-vendor IEs that go after HT */
-- 
1.7.3.4

