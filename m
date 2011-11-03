Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46600 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab1KCFzq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 01:55:46 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 3/3] mac80211: Allow overriding some HT information.
Date: Wed,  2 Nov 2011 22:55:22 -0700
Message-Id: <1320299722-30113-3-git-send-email-greearb@candelatech.com> (sfid-20111103_065549_863747_7FFD5818)
In-Reply-To: <1320299722-30113-1-git-send-email-greearb@candelatech.com>
References: <1320299722-30113-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

* Allow configuring the MCS (/n) rates available.
* Allow configuration of MAX-A-MSDU
* Allow configuration of A-MPDU factor & density.

Users can only remove existing rates.  The MPDU factor
can only be decreased.  The MPDU density can be set to
any value, but at least ath9k will not honor settings below
1us.  The MAX-AMSDU can only be disabled.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 48363c3... 25ea406... M	include/linux/ieee80211.h
:100644 100644 61b45aa... 9e9ed9d... M	include/linux/nl80211.h
:100644 100644 eeeef41... da5a7f9... M	include/net/cfg80211.h
:100644 100644 a9ded52... 7f4389e... M	net/mac80211/cfg.c
:100644 100644 f80a35c... 39c10a1... M	net/mac80211/ht.c
:100644 100644 e4cfeda... aa61189... M	net/mac80211/ieee80211_i.h
:100644 100644 149fb1d... dc2e124... M	net/mac80211/mlme.c
:100644 100644 6c53b6d... 3f318df... M	net/mac80211/work.c
:100644 100644 72e19e4... dd6feda... M	net/wireless/core.h
:100644 100644 5c41411... a37e4bc... M	net/wireless/mlme.c
:100644 100644 7924e28... 1c544db... M	net/wireless/nl80211.c
:100644 100644 449a19f... d144e2d... M	net/wireless/sme.c
 include/linux/ieee80211.h  |    6 ++++
 include/linux/nl80211.h    |    3 ++
 include/net/cfg80211.h     |   12 +++++++
 net/mac80211/cfg.c         |    2 +-
 net/mac80211/ht.c          |   70 +++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/ieee80211_i.h |    9 +++++-
 net/mac80211/mlme.c        |    8 ++++-
 net/mac80211/work.c        |   35 +++++++++++++++------
 net/wireless/core.h        |    6 ++-
 net/wireless/mlme.c        |   13 ++++++--
 net/wireless/nl80211.c     |   32 +++++++++++++++++++-
 net/wireless/sme.c         |    3 +-
 12 files changed, 177 insertions(+), 22 deletions(-)

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
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 61b45aa..9e9ed9d 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1113,6 +1113,8 @@ enum nl80211_commands {
  *      this feature.
  * @NL80211_ATTR_DISABLE_HT40:  Disable HT-40 even if AP and hardware
  *      support it.
+ * @NL80211_ATTR_HT_CAPABILITY_MASK: Specify which bits of the HT_CAPs
+ *      to pay attention to.
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -1344,6 +1346,7 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_DISABLE_HT,
 	NL80211_ATTR_DISABLE_HT40,
+	NL80211_ATTR_HT_CAPABILITY_MASK,
 
 	/* add attributes here, update the policy in nl80211.c */
 
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index eeeef41..da5a7f9 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1050,6 +1050,10 @@ struct cfg80211_auth_request {
  * @crypto: crypto settings
  * @prev_bssid: previous BSSID, if not %NULL use reassociate frame
  * @flags:  See ASSOC_REQ_* flags above.
+ * @ht_capa:  HT Capabilities over-rides.  Values set in ht_capa_mask
+ *   will be used in ht_capa.  Only the MCS rates, MPDU and MSDU
+ *   are currently supported.
+ * @ht_capa_mask:  The bits of ht_capa which are to be used.
  */
 struct cfg80211_assoc_request {
 	struct cfg80211_bss *bss;
@@ -1058,6 +1062,8 @@ struct cfg80211_assoc_request {
 	struct cfg80211_crypto_settings crypto;
 	bool use_mfp;
 	u32 flags;
+	struct ieee80211_ht_cap ht_capa;
+	struct ieee80211_ht_cap ht_capa_mask;
 };
 
 /**
@@ -1157,6 +1163,10 @@ struct cfg80211_ibss_params {
  * @key_len: length of WEP key for shared key authentication
  * @key_idx: index of WEP key for shared key authentication
  * @key: WEP key for shared key authentication
+ * @ht_capa:  HT Capabilities over-rides.  Values set in ht_capa_mask
+ *   will be used in ht_capa.  Only the MCS rates, MPDU and MSDU
+ *   are currently supported.
+ * @ht_capa_mask:  The bits of ht_capa which are to be used.
  */
 struct cfg80211_connect_params {
 	struct ieee80211_channel *channel;
@@ -1171,6 +1181,8 @@ struct cfg80211_connect_params {
 	const u8 *key;
 	u8 key_len, key_idx;
 	u32 flags;
+	struct ieee80211_ht_cap ht_capa;
+	struct ieee80211_ht_cap ht_capa_mask;
 };
 
 /**
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
index f80a35c..39c10a1 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -18,7 +18,69 @@
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
+	/* Set the AMPDU density. */
+	if (sdata->u.mgd.ht_capa_mask.ampdu_params_info &
+	    IEEE80211_HT_AMPDU_PARM_DENSITY)
+		ht_cap->ampdu_density =
+			(sdata->u.mgd.ht_capa.ampdu_params_info &
+			 IEEE80211_HT_AMPDU_PARM_DENSITY)
+			>> IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT;
+}
+
+
+void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
+				       struct ieee80211_supported_band *sband,
 				       struct ieee80211_ht_cap *ht_cap_ie,
 				       struct ieee80211_sta_ht_cap *ht_cap)
 {
@@ -102,6 +164,12 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
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
index e4cfeda..aa61189 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -444,6 +444,9 @@ struct ieee80211_if_managed {
 	 */
 	int rssi_min_thold, rssi_max_thold;
 	int last_ave_beacon_signal;
+	struct ieee80211_ht_cap ht_capa; /* configured ht-cap over-rides */
+	struct ieee80211_ht_cap ht_capa_mask; /* Valid parts of ht_capa */
+
 };
 
 struct ieee80211_if_ibss {
@@ -1180,7 +1183,11 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
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
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 149fb1d..dc2e124 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1585,7 +1585,7 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
 
 	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
-		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 				elems.ht_cap_elem, &sta->sta.ht_cap);
 
 	ap_ht_cap_flags = sta->sta.ht_cap.cap;
@@ -1954,7 +1954,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
-		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 				elems.ht_cap_elem, &sta->sta.ht_cap);
 
 		ap_ht_cap_flags = sta->sta.ht_cap.cap;
@@ -2619,6 +2619,10 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	if (req->flags & ASSOC_REQ_DISABLE_HT40)
 		ifmgd->flags |= IEEE80211_STA_DISABLE_HT40;
 
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
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 72e19e4..dd6feda 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -340,14 +340,16 @@ int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			  const u8 *ssid, int ssid_len,
 			  const u8 *ie, int ie_len, bool use_mfp,
 			  struct cfg80211_crypto_settings *crypt,
-			  u32 assoc_flags);
+			  u32 assoc_flags, struct ieee80211_ht_cap *ht_capa,
+			  struct ieee80211_ht_cap *ht_capa_mask);
 int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, struct ieee80211_channel *chan,
 			const u8 *bssid, const u8 *prev_bssid,
 			const u8 *ssid, int ssid_len,
 			const u8 *ie, int ie_len, bool use_mfp,
 			struct cfg80211_crypto_settings *crypt,
-			u32 assoc_flags);
+			u32 assoc_flags, struct ieee80211_ht_cap *ht_capa,
+			struct ieee80211_ht_cap *ht_capa_mask);
 int __cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
 			   struct net_device *dev, const u8 *bssid,
 			   const u8 *ie, int ie_len, u16 reason,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 5c41411..a37e4bc 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -508,7 +508,8 @@ int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			  const u8 *ssid, int ssid_len,
 			  const u8 *ie, int ie_len, bool use_mfp,
 			  struct cfg80211_crypto_settings *crypt,
-			  u32 assoc_flags)
+			  u32 assoc_flags, struct ieee80211_ht_cap *ht_capa,
+			  struct ieee80211_ht_cap *ht_capa_mask)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_assoc_request req;
@@ -539,6 +540,11 @@ int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 	req.use_mfp = use_mfp;
 	req.prev_bssid = prev_bssid;
 	req.flags = assoc_flags;
+	if (ht_capa)
+		memcpy(&req.ht_capa, ht_capa, sizeof(req.ht_capa));
+	if (ht_capa_mask)
+		memcpy(&req.ht_capa_mask, ht_capa_mask,
+		       sizeof(req.ht_capa_mask));
 	req.bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
 				   WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
 	if (!req.bss) {
@@ -577,7 +583,8 @@ int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			const u8 *ssid, int ssid_len,
 			const u8 *ie, int ie_len, bool use_mfp,
 			struct cfg80211_crypto_settings *crypt,
-			u32 assoc_flags)
+			u32 assoc_flags, struct ieee80211_ht_cap *ht_capa,
+			struct ieee80211_ht_cap *ht_capa_mask)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
@@ -585,7 +592,7 @@ int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 	wdev_lock(wdev);
 	err = __cfg80211_mlme_assoc(rdev, dev, chan, bssid, prev_bssid,
 				    ssid, ssid_len, ie, ie_len, use_mfp, crypt,
-				    assoc_flags);
+				    assoc_flags, ht_capa, ht_capa_mask);
 	wdev_unlock(wdev);
 
 	return err;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7924e28..1c544db 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -199,6 +199,10 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_TDLS_EXTERNAL_SETUP] = { .type = NLA_FLAG },
 	[NL80211_ATTR_DISABLE_HT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_DISABLE_HT40] = { .type = NLA_FLAG },
+	[NL80211_ATTR_HT_CAPABILITY_MASK] = {
+		.type = NLA_BINARY,
+		.len = NL80211_HT_CAPABILITY_LEN
+	},
 };
 
 /* policy for the key attributes */
@@ -4357,6 +4361,8 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 	int err, ssid_len, ie_len = 0;
 	bool use_mfp = false;
 	u32 flags = 0;
+	struct ieee80211_ht_cap *ht_capa = NULL;
+	struct ieee80211_ht_cap *ht_capa_mask = NULL;
 
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
@@ -4406,11 +4412,22 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 	if (nla_get_flag(info->attrs[NL80211_ATTR_DISABLE_HT40]))
 		flags |= ASSOC_REQ_DISABLE_HT40;
 
+	if (info->attrs[NL80211_ATTR_HT_CAPABILITY_MASK])
+		ht_capa_mask =
+			nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY_MASK]);
+
+	if (info->attrs[NL80211_ATTR_HT_CAPABILITY]) {
+		if (!ht_capa_mask)
+			return -EINVAL;
+		ht_capa = nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]);
+	}
+
 	err = nl80211_crypto_settings(rdev, info, &crypto, 1);
 	if (!err)
 		err = cfg80211_mlme_assoc(rdev, dev, chan, bssid, prev_bssid,
 					  ssid, ssid_len, ie, ie_len, use_mfp,
-					  &crypto, flags);
+					  &crypto, flags, ht_capa,
+					  ht_capa_mask);
 
 	return err;
 }
@@ -4906,6 +4923,19 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 	if (nla_get_flag(info->attrs[NL80211_ATTR_DISABLE_HT40]))
 		connect.flags |= ASSOC_REQ_DISABLE_HT40;
 
+	if (info->attrs[NL80211_ATTR_HT_CAPABILITY_MASK])
+		memcpy(&connect.ht_capa_mask,
+		       nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY_MASK]),
+		       sizeof(connect.ht_capa_mask));
+
+	if (info->attrs[NL80211_ATTR_HT_CAPABILITY]) {
+		if (!info->attrs[NL80211_ATTR_HT_CAPABILITY_MASK])
+			return -EINVAL;
+		memcpy(&connect.ht_capa,
+		       nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]),
+		       sizeof(connect.ht_capa));
+	}
+
 	err = cfg80211_connect(rdev, dev, &connect, connkeys);
 	if (err)
 		kfree(connkeys);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 449a19f..d144e2d 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -190,7 +190,8 @@ static int cfg80211_conn_do_work(struct wireless_dev *wdev)
 					    params->ssid, params->ssid_len,
 					    params->ie, params->ie_len,
 					    false, &params->crypto,
-					    params->flags);
+					    params->flags, &params->ht_capa,
+					    &params->ht_capa_mask);
 		if (err)
 			__cfg80211_mlme_deauth(rdev, wdev->netdev, params->bssid,
 					       NULL, 0,
-- 
1.7.3.4

