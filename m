Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56000 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3BUTLy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 14:11:54 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: greearb@candelatech.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] cfg80211: add ability to override VHT capabilities
Date: Thu, 21 Feb 2013 20:11:44 +0100
Message-Id: <1361473906-14941-2-git-send-email-johannes@sipsolutions.net> (sfid-20130221_201159_274942_A10427D2)
In-Reply-To: <1361473906-14941-1-git-send-email-johannes@sipsolutions.net>
References: <1361473906-14941-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For testing it's sometimes useful to be able to
override certain VHT capability advertisement,
add the ability to do that in cfg80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 12 +++++++++++
 include/uapi/linux/nl80211.h |  3 +++
 net/wireless/core.h          | 10 ++++++++--
 net/wireless/mlme.c          | 35 ++++++++++++++++++++++++++++++---
 net/wireless/nl80211.c       | 47 +++++++++++++++++++++++++++++++++++++++++---
 net/wireless/sme.c           |  4 +++-
 6 files changed, 102 insertions(+), 9 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e2ebd93..d2ab509 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1430,9 +1430,11 @@ struct cfg80211_auth_request {
  * enum cfg80211_assoc_req_flags - Over-ride default behaviour in association.
  *
  * @ASSOC_REQ_DISABLE_HT:  Disable HT (802.11n)
+ * @ASSOC_REQ_DISABLE_VHT:  Disable VHT
  */
 enum cfg80211_assoc_req_flags {
 	ASSOC_REQ_DISABLE_HT		= BIT(0),
+	ASSOC_REQ_DISABLE_VHT		= BIT(1),
 };
 
 /**
@@ -1454,6 +1456,8 @@ enum cfg80211_assoc_req_flags {
  * @ht_capa:  HT Capabilities over-rides.  Values set in ht_capa_mask
  *   will be used in ht_capa.  Un-supported values will be ignored.
  * @ht_capa_mask:  The bits of ht_capa which are to be used.
+ * @vht_capa: VHT capability override
+ * @vht_capa_mask: VHT capability mask indicating which fields to use
  */
 struct cfg80211_assoc_request {
 	struct cfg80211_bss *bss;
@@ -1464,6 +1468,7 @@ struct cfg80211_assoc_request {
 	u32 flags;
 	struct ieee80211_ht_cap ht_capa;
 	struct ieee80211_ht_cap ht_capa_mask;
+	struct ieee80211_vht_cap vht_capa, vht_capa_mask;
 };
 
 /**
@@ -1574,6 +1579,8 @@ struct cfg80211_ibss_params {
  * @ht_capa:  HT Capabilities over-rides.  Values set in ht_capa_mask
  *   will be used in ht_capa.  Un-supported values will be ignored.
  * @ht_capa_mask:  The bits of ht_capa which are to be used.
+ * @vht_capa:  VHT Capability overrides
+ * @vht_capa_mask: The bits of vht_capa which are to be used.
  */
 struct cfg80211_connect_params {
 	struct ieee80211_channel *channel;
@@ -1592,6 +1599,8 @@ struct cfg80211_connect_params {
 	int bg_scan_period;
 	struct ieee80211_ht_cap ht_capa;
 	struct ieee80211_ht_cap ht_capa_mask;
+	struct ieee80211_vht_cap vht_capa;
+	struct ieee80211_vht_cap vht_capa_mask;
 };
 
 /**
@@ -2516,6 +2525,8 @@ struct wiphy_wowlan_support {
  * @ap_sme_capa: AP SME capabilities, flags from &enum nl80211_ap_sme_features.
  * @ht_capa_mod_mask:  Specify what ht_cap values can be over-ridden.
  *	If null, then none can be over-ridden.
+ * @vht_capa_mod_mask:  Specify what VHT capabilities can be over-ridden.
+ *	If null, then none can be over-ridden.
  *
  * @max_acl_mac_addrs: Maximum number of MAC addresses that the device
  *	supports for ACL.
@@ -2624,6 +2635,7 @@ struct wiphy {
 	struct dentry *debugfsdir;
 
 	const struct ieee80211_ht_cap *ht_capa_mod_mask;
+	const struct ieee80211_vht_cap *vht_capa_mod_mask;
 
 #ifdef CONFIG_NET_NS
 	/* the network namespace this phy lives in currently */
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9844c10..2c3e883 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1685,6 +1685,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_PROTOCOL_FEATURES,
 	NL80211_ATTR_SPLIT_WIPHY_DUMP,
 
+	NL80211_ATTR_DISABLE_VHT,
+	NL80211_ATTR_VHT_CAPABILITY_MASK,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 3aec0e4..c2f94f2 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -335,7 +335,9 @@ int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			  const u8 *ie, int ie_len, bool use_mfp,
 			  struct cfg80211_crypto_settings *crypt,
 			  u32 assoc_flags, struct ieee80211_ht_cap *ht_capa,
-			  struct ieee80211_ht_cap *ht_capa_mask);
+			  struct ieee80211_ht_cap *ht_capa_mask,
+			  struct ieee80211_vht_cap *vht_capa,
+			  struct ieee80211_vht_cap *vht_capa_mask);
 int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, struct ieee80211_channel *chan,
 			const u8 *bssid, const u8 *prev_bssid,
@@ -343,7 +345,9 @@ int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			const u8 *ie, int ie_len, bool use_mfp,
 			struct cfg80211_crypto_settings *crypt,
 			u32 assoc_flags, struct ieee80211_ht_cap *ht_capa,
-			struct ieee80211_ht_cap *ht_capa_mask);
+			struct ieee80211_ht_cap *ht_capa_mask,
+			struct ieee80211_vht_cap *vht_capa,
+			struct ieee80211_vht_cap *vht_capa_mask);
 int __cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
 			   struct net_device *dev, const u8 *bssid,
 			   const u8 *ie, int ie_len, u16 reason,
@@ -375,6 +379,8 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			  bool no_cck, bool dont_wait_for_ack, u64 *cookie);
 void cfg80211_oper_and_ht_capa(struct ieee80211_ht_cap *ht_capa,
 			       const struct ieee80211_ht_cap *ht_capa_mask);
+void cfg80211_oper_and_vht_capa(struct ieee80211_vht_cap *vht_capa,
+				const struct ieee80211_vht_cap *vht_capa_mask);
 
 /* SME */
 int __cfg80211_connect(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index caddca3..1372a13 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -367,6 +367,23 @@ void cfg80211_oper_and_ht_capa(struct ieee80211_ht_cap *ht_capa,
 		p1[i] &= p2[i];
 }
 
+/*  Do a logical ht_capa &= ht_capa_mask.  */
+void cfg80211_oper_and_vht_capa(struct ieee80211_vht_cap *vht_capa,
+				const struct ieee80211_vht_cap *vht_capa_mask)
+{
+	int i;
+	u8 *p1, *p2;
+	if (!vht_capa_mask) {
+		memset(vht_capa, 0, sizeof(*vht_capa));
+		return;
+	}
+
+	p1 = (u8*)(vht_capa);
+	p2 = (u8*)(vht_capa_mask);
+	for (i = 0; i < sizeof(*vht_capa); i++)
+		p1[i] &= p2[i];
+}
+
 int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev,
 			  struct ieee80211_channel *chan,
@@ -375,7 +392,9 @@ int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			  const u8 *ie, int ie_len, bool use_mfp,
 			  struct cfg80211_crypto_settings *crypt,
 			  u32 assoc_flags, struct ieee80211_ht_cap *ht_capa,
-			  struct ieee80211_ht_cap *ht_capa_mask)
+			  struct ieee80211_ht_cap *ht_capa_mask,
+			  struct ieee80211_vht_cap *vht_capa,
+			  struct ieee80211_vht_cap *vht_capa_mask)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_assoc_request req;
@@ -412,6 +431,13 @@ int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 		       sizeof(req.ht_capa_mask));
 	cfg80211_oper_and_ht_capa(&req.ht_capa_mask,
 				  rdev->wiphy.ht_capa_mod_mask);
+	if (vht_capa)
+		memcpy(&req.vht_capa, vht_capa, sizeof(req.vht_capa));
+	if (vht_capa_mask)
+		memcpy(&req.vht_capa_mask, vht_capa_mask,
+		       sizeof(req.vht_capa_mask));
+	cfg80211_oper_and_vht_capa(&req.vht_capa_mask,
+				   rdev->wiphy.vht_capa_mod_mask);
 
 	req.bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
 				   WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
@@ -446,7 +472,9 @@ int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			const u8 *ie, int ie_len, bool use_mfp,
 			struct cfg80211_crypto_settings *crypt,
 			u32 assoc_flags, struct ieee80211_ht_cap *ht_capa,
-			struct ieee80211_ht_cap *ht_capa_mask)
+			struct ieee80211_ht_cap *ht_capa_mask,
+			struct ieee80211_vht_cap *vht_capa,
+			struct ieee80211_vht_cap *vht_capa_mask)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
@@ -455,7 +483,8 @@ int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 	wdev_lock(wdev);
 	err = __cfg80211_mlme_assoc(rdev, dev, chan, bssid, prev_bssid,
 				    ssid, ssid_len, ie, ie_len, use_mfp, crypt,
-				    assoc_flags, ht_capa, ht_capa_mask);
+				    assoc_flags, ht_capa, ht_capa_mask,
+				    vht_capa, vht_capa_mask);
 	wdev_unlock(wdev);
 	mutex_unlock(&rdev->devlist_mtx);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4701893a..a52107d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -371,6 +371,10 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_STA_CAPABILITY] = { .type = NLA_U16 },
 	[NL80211_ATTR_STA_EXT_CAPABILITY] = { .type = NLA_BINARY, },
 	[NL80211_ATTR_SPLIT_WIPHY_DUMP] = { .type = NLA_FLAG, },
+	[NL80211_ATTR_DISABLE_VHT] = { .type = NLA_FLAG },
+	[NL80211_ATTR_VHT_CAPABILITY_MASK] = {
+		.len = NL80211_VHT_CAPABILITY_LEN,
+	},
 };
 
 /* policy for the key attributes */
@@ -1511,7 +1515,11 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		(*split_start)++;
 		break;
 	case 9:
-		/* placeholder */
+		if (dev->wiphy.vht_capa_mod_mask &&
+		    nla_put(msg, NL80211_ATTR_VHT_CAPABILITY_MASK,
+			    sizeof(*dev->wiphy.vht_capa_mod_mask),
+			    dev->wiphy.vht_capa_mod_mask))
+			goto nla_put_failure;
 
 		/* done */
 		*split_start = 0;
@@ -5951,6 +5959,8 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 	u32 flags = 0;
 	struct ieee80211_ht_cap *ht_capa = NULL;
 	struct ieee80211_ht_cap *ht_capa_mask = NULL;
+	struct ieee80211_vht_cap *vht_capa = NULL;
+	struct ieee80211_vht_cap *vht_capa_mask = NULL;
 
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
@@ -6007,12 +6017,25 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 		ht_capa = nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]);
 	}
 
+	if (nla_get_flag(info->attrs[NL80211_ATTR_DISABLE_VHT]))
+		flags |= ASSOC_REQ_DISABLE_VHT;
+
+	if (info->attrs[NL80211_ATTR_VHT_CAPABILITY_MASK])
+		vht_capa_mask =
+			nla_data(info->attrs[NL80211_ATTR_VHT_CAPABILITY_MASK]);
+
+	if (info->attrs[NL80211_ATTR_VHT_CAPABILITY]) {
+		if (!vht_capa_mask)
+			return -EINVAL;
+		vht_capa = nla_data(info->attrs[NL80211_ATTR_VHT_CAPABILITY]);
+	}
+
 	err = nl80211_crypto_settings(rdev, info, &crypto, 1);
 	if (!err)
 		err = cfg80211_mlme_assoc(rdev, dev, chan, bssid, prev_bssid,
 					  ssid, ssid_len, ie, ie_len, use_mfp,
-					  &crypto, flags, ht_capa,
-					  ht_capa_mask);
+					  &crypto, flags, ht_capa, ht_capa_mask,
+					  vht_capa, vht_capa_mask);
 
 	return err;
 }
@@ -6592,6 +6615,24 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 		       sizeof(connect.ht_capa));
 	}
 
+	if (nla_get_flag(info->attrs[NL80211_ATTR_DISABLE_VHT]))
+		connect.flags |= ASSOC_REQ_DISABLE_VHT;
+
+	if (info->attrs[NL80211_ATTR_VHT_CAPABILITY_MASK])
+		memcpy(&connect.vht_capa_mask,
+		       nla_data(info->attrs[NL80211_ATTR_VHT_CAPABILITY_MASK]),
+		       sizeof(connect.vht_capa_mask));
+
+	if (info->attrs[NL80211_ATTR_VHT_CAPABILITY]) {
+		if (!info->attrs[NL80211_ATTR_VHT_CAPABILITY_MASK]) {
+			kfree(connkeys);
+			return -EINVAL;
+		}
+		memcpy(&connect.vht_capa,
+		       nla_data(info->attrs[NL80211_ATTR_VHT_CAPABILITY]),
+		       sizeof(connect.vht_capa));
+	}
+
 	err = cfg80211_connect(rdev, dev, &connect, connkeys);
 	if (err)
 		kfree(connkeys);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index f432bd3..7da118c 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -195,7 +195,9 @@ static int cfg80211_conn_do_work(struct wireless_dev *wdev)
 					    params->mfp != NL80211_MFP_NO,
 					    &params->crypto,
 					    params->flags, &params->ht_capa,
-					    &params->ht_capa_mask);
+					    &params->ht_capa_mask,
+					    &params->vht_capa,
+					    &params->vht_capa_mask);
 		if (err)
 			__cfg80211_mlme_deauth(rdev, wdev->netdev, params->bssid,
 					       NULL, 0,
-- 
1.8.0

