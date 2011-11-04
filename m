Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40852 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab1KDULI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 16:11:08 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v4 2/2] mac80211:  Support ht-cap over-rides.
Date: Fri,  4 Nov 2011 13:10:40 -0700
Message-Id: <1320437440-6463-2-git-send-email-greearb@candelatech.com> (sfid-20111104_211114_679516_4CC16ABF)
In-Reply-To: <1320437440-6463-1-git-send-email-greearb@candelatech.com>
References: <1320437440-6463-1-git-send-email-greearb@candelatech.com>
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
:100644 100644 48363c3... 25ea406... M	include/linux/ieee80211.h
:100644 100644 a9ded52... 7f4389e... M	net/mac80211/cfg.c
:100644 100644 f80a35c... 8031fe2... M	net/mac80211/ht.c
:100644 100644 ea10a51... aa61189... M	net/mac80211/ieee80211_i.h
:100644 100644 d4ee6d2... 764a5ee... M	net/mac80211/main.c
:100644 100644 57fb58f... dc2e124... M	net/mac80211/mlme.c
:100644 100644 6c53b6d... 3f318df... M	net/mac80211/work.c
 include/linux/ieee80211.h  |    6 +++
 net/mac80211/cfg.c         |    2 +-
 net/mac80211/ht.c          |   76 +++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/ieee80211_i.h |   10 +++++-
 net/mac80211/main.c        |   15 +++++++++
 net/mac80211/mlme.c        |   16 ++++++++-
 net/mac80211/work.c        |   35 ++++++++++++++------
 7 files changed, 145 insertions(+), 15 deletions(-)

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
index f80a35c..8031fe2 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -18,7 +18,75 @@
 #include "ieee80211_i.h"
 #include "rate.h"
 
-void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
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
+	if (sdata->u.mgd.flags & IEEE80211_STA_DISABLE_HT40) {
+		ht_cap->cap &= ~(IEEE80211_HT_CAP_SUP_WIDTH_20_40
+				 | IEEE80211_HT_CAP_SGI_40);
+	}
+
+	/* Allow user to disable the max-AMSDU bit. */
+	if (sdata->u.mgd.ht_capa_mask.cap_info & IEEE80211_HT_CAP_MAX_AMSDU) {
+		if (!(sdata->u.mgd.ht_capa.cap_info
+		      & IEEE80211_HT_CAP_MAX_AMSDU))
+			ht_cap->cap &= ~IEEE80211_HT_CAP_MAX_AMSDU;
+	}
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
@@ -102,6 +170,12 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
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
index ea10a51..aa61189 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -364,6 +364,7 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_UAPSD_ENABLED	= BIT(7),
 	IEEE80211_STA_NULLFUNC_ACKED	= BIT(8),
 	IEEE80211_STA_RESET_SIGNAL_AVE	= BIT(9),
+	IEEE80211_STA_DISABLE_HT40	= BIT(10),
 };
 
 struct ieee80211_if_managed {
@@ -443,6 +444,9 @@ struct ieee80211_if_managed {
 	 */
 	int rssi_min_thold, rssi_max_thold;
 	int last_ave_beacon_signal;
+	struct ieee80211_ht_cap ht_capa; /* configured ht-cap over-rides */
+	struct ieee80211_ht_cap ht_capa_mask; /* Valid parts of ht_capa */
+
 };
 
 struct ieee80211_if_ibss {
@@ -1179,7 +1183,11 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 				       struct net_device *dev);
 
 /* HT */
-void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
+void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_sta_ht_cap *ht_cap,
+				     int min_rates);
+void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
+				       struct ieee80211_supported_band *sband,
 				       struct ieee80211_ht_cap *ht_cap_ie,
 				       struct ieee80211_sta_ht_cap *ht_cap);
 void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d4ee6d2..764a5ee 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -881,6 +881,19 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (local->hw.wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS)
 		local->hw.wiphy->flags |= WIPHY_FLAG_TDLS_EXTERNAL_SETUP;
 
+	/* mac80211 allows over-riding some of the ht-capabilities */
+	local->hw.wiphy->ht_capa_mod_mask =
+		kzalloc(sizeof(*local->hw.wiphy->ht_capa_mod_mask),
+			GFP_KERNEL);
+	if (local->hw.wiphy->ht_capa_mod_mask) {
+		struct ieee80211_ht_cap *cm = local->hw.wiphy->ht_capa_mod_mask;
+		u8 *r = (u8 *)(&cm->mcs.rx_mask);
+		memset(r, 0xff, IEEE80211_HT_MCS_MASK_LEN);
+		cm->cap_info |= IEEE80211_HT_CAP_MAX_AMSDU;
+		cm->ampdu_params_info |= IEEE80211_HT_AMPDU_PARM_FACTOR;
+		cm->ampdu_params_info |= IEEE80211_HT_AMPDU_PARM_DENSITY;
+	}
+
 	result = wiphy_register(local->hw.wiphy);
 	if (result < 0)
 		goto fail_wiphy_register;
@@ -988,6 +1001,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
  fail_wiphy_register:
 	if (local->wiphy_ciphers_allocated)
 		kfree(local->hw.wiphy->cipher_suites);
+	kfree(local->hw.wiphy->ht_capa_mod_mask);
+	local->hw.wiphy->ht_capa_mod_mask = NULL;
 	kfree(local->int_scan_req);
 	return result;
 }
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 57fb58f..dc2e124 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -207,6 +207,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		channel_type = NL80211_CHAN_HT20;
 
 		if (!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
+		    !(sdata->u.mgd.flags & IEEE80211_STA_DISABLE_HT40) &&
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
@@ -2601,6 +2602,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	ifmgd->flags &= ~IEEE80211_STA_DISABLE_11N;
 	ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
+	ifmgd->flags &= ~IEEE80211_STA_DISABLE_HT40;
 
 	ifmgd->beacon_crc_valid = false;
 
@@ -2611,6 +2613,16 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
 
 
+	if (req->flags & ASSOC_REQ_DISABLE_HT)
+		ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
+
+	if (req->flags & ASSOC_REQ_DISABLE_HT40)
+		ifmgd->flags |= IEEE80211_STA_DISABLE_HT40;
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

