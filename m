Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33097 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab1J1WVz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 18:21:55 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [wireless-next PATCH v2 3/4] wifi: Allow overriding some HT information.
Date: Fri, 28 Oct 2011 15:21:13 -0700
Message-Id: <1319840474-2618-3-git-send-email-greearb@candelatech.com> (sfid-20111029_002159_424739_639E90F0)
In-Reply-To: <1319840474-2618-1-git-send-email-greearb@candelatech.com>
References: <1319840474-2618-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

* Allow configuring the mcs (/n) rates available.
* Allow configuration of MAX-A-MSDU
* Allow configuration of A-MPDU factor & density.

Users can only remove existing rates.  The MSDU and MPDU
values can be set to any value allowed by the 802.11n
specification, provided the hardware has enabled the
proper feature bits (IEEE80211_HW_SUPPORTS_AMPDU_MOD
and/or IEEE80211_HW_SUPPORTS_AMSDU_MOD)

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

* Added HW capability flags so that only drivers with these flags
  may modify the MPDU and MSDU settings.
* Add #define for the minimum required MCS rates instead of hard-coding 8.

:100644 100644 48363c3... 25ea406... M	include/linux/ieee80211.h
:100644 100644 9f50f90... 971da1d... M	include/linux/nl80211.h
:100644 100644 9d7a5e0... 802ff5f... M	include/net/cfg80211.h
:100644 100644 dc1123a... a2cbe4a... M	include/net/mac80211.h
:100644 100644 c63d7f0... 1ac1910... M	net/mac80211/cfg.c
:100644 100644 f80a35c... 0753c96... M	net/mac80211/ht.c
:100644 100644 f4a7618... f279ee9... M	net/mac80211/ieee80211_i.h
:100644 100644 164cdb1... 681ba4e... M	net/mac80211/mlme.c
:100644 100644 94472eb... 9b614f8... M	net/mac80211/work.c
:100644 100644 404378d... 9507f2f... M	net/wireless/nl80211.c
 include/linux/ieee80211.h  |    6 ++++
 include/linux/nl80211.h    |    3 ++
 include/net/cfg80211.h     |    4 ++
 include/net/mac80211.h     |    6 ++++
 net/mac80211/cfg.c         |   40 ++++++++++++++++++++++++-
 net/mac80211/ht.c          |   70 +++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/ieee80211_i.h |    9 +++++-
 net/mac80211/mlme.c        |    4 +-
 net/mac80211/work.c        |   35 +++++++++++++++------
 net/wireless/nl80211.c     |   14 +++++++++
 10 files changed, 176 insertions(+), 15 deletions(-)

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
index 9f50f90..971da1d 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1113,6 +1113,8 @@ enum nl80211_commands {
  *      function as /a/b/g interfaces.
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
index 9d7a5e0..802ff5f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -256,11 +256,15 @@ struct ieee80211_supported_band {
  * @use_4addr: use 4-address frames
  * @disable_11n:  Don't use 11n features (HT, etc)
  * @disable_ht40:  Don't use HT40, even if hardware & AP support it.
+ * @ht_capa:  HT Capabilities for this interface.
+ * @ht_capa_mask:  Bits of ht_capa that are to be used.
  */
 struct vif_params {
 	int use_4addr;
 	int disable_11n;
 	int disable_ht40;
+	struct ieee80211_ht_cap *ht_capa;
+	struct ieee80211_ht_cap *ht_capa_mask;
 };
 
 /**
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index dc1123a..a2cbe4a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1128,6 +1128,10 @@ enum sta_notify_cmd {
  * @IEEE80211_HW_TX_AMPDU_SETUP_IN_HW: The device handles TX A-MPDU session
  *	setup strictly in HW. mac80211 should not attempt to do this in
  *	software.
+ * @IEEE80211_HW_SUPPORTS_AMPDU_MOD:  The hardware can handle the full
+ *	range of ampdu factor & density settings.
+ * @IEEE80211_HW_SUPPORTS_AMSDU_MOD:  The hardware supports enabling
+ *	and disabling IEEE80211_HT_CAP_MAX_AMSDU.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1154,6 +1158,8 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_PER_STA_GTK		= 1<<21,
 	IEEE80211_HW_AP_LINK_PS				= 1<<22,
 	IEEE80211_HW_TX_AMPDU_SETUP_IN_HW		= 1<<23,
+	IEEE80211_HW_SUPPORTS_AMPDU_MOD			= 1<<24,
+	IEEE80211_HW_SUPPORTS_AMSDU_MOD			= 1<<25,
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c63d7f0..1ac1910 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -105,6 +105,44 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 		}
 	}
 
+	if (params->ht_capa) {
+		u8 *caps = (u8 *)(params->ht_capa);
+		u8 *mask = (u8 *)(params->ht_capa_mask);
+		u8 *scaps = (u8 *)(&sdata->ht_capa);
+		u8 *smask = (u8 *)(&sdata->ht_capa_mask);
+		int i;
+
+		/* Check AMPDU and AMSDU capabilities */
+		if ((params->ht_capa_mask->ampdu_params_info &
+		     (IEEE80211_HT_AMPDU_PARM_FACTOR |
+		      IEEE80211_HT_AMPDU_PARM_DENSITY)) &&
+		    !(sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_AMPDU_MOD))
+			return -EINVAL;
+
+		if ((params->ht_capa_mask->cap_info &
+		     IEEE80211_HT_CAP_MAX_AMSDU) &&
+		    !(sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_AMSDU_MOD))
+			return -EINVAL;
+
+		for (i = 0; i < sizeof(sdata->ht_capa); i++) {
+			if (mask[i]) {
+				int q;
+				smask[i] |= mask[i];
+				for (q = 0; q < 8; q++) {
+					if (mask[i] & (1<<q)) {
+						if (caps[i] & (1<<q))
+							scaps[i] |= (1<<q);
+						else
+							scaps[i] &= ~(1<<q);
+					}
+				}
+			}
+		}
+	} else if (params->ht_capa_mask) {
+		memcpy(&sdata->ht_capa_mask, params->ht_capa_mask,
+		       sizeof(sdata->ht_capa_mask));
+	}
+
 	return 0;
 }
 
@@ -784,7 +822,7 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 	}
 
 	if (params->ht_capa)
-		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 						  params->ht_capa,
 						  &sta->sta.ht_cap);
 
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index f80a35c..0753c96 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -18,7 +18,70 @@
 #include "ieee80211_i.h"
 #include "rate.h"
 
-void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
+void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_sta_ht_cap *ht_cap,
+				     int min_rates)
+{
+	u8 *scaps = (u8 *)(&sdata->ht_capa.mcs.rx_mask);
+	u8 *smask = (u8 *)(&sdata->ht_capa_mask.mcs.rx_mask);
+	int i;
+
+	/* check for HT over-rides, mcs rates only at this time,
+	 * and can only disable them, not force new ones to be
+	 * made available.
+	 */
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
+	if (sdata->cfg_disable_ht40) {
+		ht_cap->cap &= ~(IEEE80211_HT_CAP_SUP_WIDTH_20_40
+				 | IEEE80211_HT_CAP_SGI_40);
+	}
+
+	/* Allow user to set max AMDSU bit. */
+	if (sdata->ht_capa_mask.cap_info & IEEE80211_HT_CAP_MAX_AMSDU) {
+		if (sdata->ht_capa.cap_info & IEEE80211_HT_CAP_MAX_AMSDU)
+			ht_cap->cap |= IEEE80211_HT_CAP_MAX_AMSDU;
+		else
+			ht_cap->cap &= ~IEEE80211_HT_CAP_MAX_AMSDU;
+	}
+
+	/* Set the AMPDU factor */
+	if (sdata->ht_capa_mask.ampdu_params_info &
+	    IEEE80211_HT_AMPDU_PARM_FACTOR)
+		ht_cap->ampdu_factor = sdata->ht_capa.ampdu_params_info &
+			IEEE80211_HT_AMPDU_PARM_FACTOR;
+
+	/* Set the AMPDU density */
+	if (sdata->ht_capa_mask.ampdu_params_info &
+	    IEEE80211_HT_AMPDU_PARM_DENSITY)
+		ht_cap->ampdu_density =
+			(sdata->ht_capa.ampdu_params_info &
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
@@ -102,6 +165,11 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
 	/* handle MCS rate 32 too */
 	if (sband->ht_cap.mcs.rx_mask[32/8] & ht_cap_ie->mcs.rx_mask[32/8] & 1)
 		ht_cap->mcs.rx_mask[32/8] |= 1;
+
+	/* If user has specified capability over-rides, take care
+	 * of that here.
+	 */
+	ieee80211_apply_htcap_overrides(sdata, ht_cap, 0);
 }
 
 void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta, bool tx)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f4a7618..f279ee9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -598,6 +598,9 @@ struct ieee80211_sub_if_data {
 	bool cfg_disable_11n; /* configured to disable 11n? */
 	bool cfg_disable_ht40; /* configured to not use HT-40 */
 
+	struct ieee80211_ht_cap ht_capa; /* configured ht-cap over-rides */
+	struct ieee80211_ht_cap ht_capa_mask; /* Valid parts of ht_capa */
+
 	/* Fragment table for host-based reassembly */
 	struct ieee80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
 	unsigned int fragment_next;
@@ -1181,7 +1184,11 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
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
index 164cdb1..681ba4e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1571,7 +1571,7 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
 
 	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
-		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 				elems.ht_cap_elem, &sta->sta.ht_cap);
 
 	ap_ht_cap_flags = sta->sta.ht_cap.cap;
@@ -1940,7 +1940,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
-		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 				elems.ht_cap_elem, &sta->sta.ht_cap);
 
 		ap_ht_cap_flags = sta->sta.ht_cap.cap;
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 94472eb..9b614f8 100644
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
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 404378d..9507f2f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1655,6 +1655,20 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 		params.disable_ht40 = -1;
 	}
 
+	if (info->attrs[NL80211_ATTR_HT_CAPABILITY_MASK]) {
+		params.ht_capa_mask =
+			nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY_MASK]);
+		change = true;
+	}
+
+	if (info->attrs[NL80211_ATTR_HT_CAPABILITY]) {
+		if (!params.ht_capa_mask)
+			return -EINVAL;
+		params.ht_capa =
+			nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]);
+		change = true;
+	}
+
 	if (change)
 		err = cfg80211_change_iface(rdev, dev, ntype, flags, &params);
 	else
-- 
1.7.3.4

