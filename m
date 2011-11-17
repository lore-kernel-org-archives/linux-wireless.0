Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35147 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab1KQVyu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 16:54:50 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v9 1/2] wireless:  Support ht-capabilities over-rides.
Date: Thu, 17 Nov 2011 13:54:43 -0800
Message-Id: <1321566884-31757-1-git-send-email-greearb@candelatech.com> (sfid-20111117_225454_269234_8D9DA167)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This allows users to disable features such as HT, HT40,
and to modify the MCS, AMPDU, and AMSDU settings for
drivers that support it.

The MCS, AMPDU, and AMSDU features that may be disabled are
are reported in the phy-info netlink message as a mask.

Attemping to disable features that are not supported will
take no affect, but will not return errors.  This is to aid
backwards compatibility in user-space apps that may not be
clever enough to deal with parsing the the capabilities mask.

This patch only enables the infrastructure.  An additional
patch will enable the feature in mac80211.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 f9261c2... 0df2062... M	include/linux/nl80211.h
:100644 100644 8d7ba09... 4f6d131... M	include/net/cfg80211.h
:100644 100644 1c7d4df... fb08c28... M	net/wireless/core.h
:100644 100644 6c1bafd... 438dfc1... M	net/wireless/mlme.c
:100644 100644 6bc7c4b... aa98ec2... M	net/wireless/nl80211.c
:100644 100644 0acfdc9... f0c900c... M	net/wireless/sme.c
 include/linux/nl80211.h |   14 ++++++++++++++
 include/net/cfg80211.h  |   27 +++++++++++++++++++++++++++
 net/wireless/core.h     |   10 ++++++++--
 net/wireless/mlme.c     |   37 ++++++++++++++++++++++++++++++++++---
 net/wireless/nl80211.c  |   44 +++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/sme.c      |    7 ++++++-
 6 files changed, 132 insertions(+), 7 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index f9261c2..0df2062 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1169,6 +1169,17 @@ enum nl80211_commands {
  * @NL80211_ATTR_PROBE_RESP: Probe Response template data. Contains the entire
  *	probe-response frame. The DA field in the 802.11 header is zero-ed out,
  *	to be filled by the FW.
+ * @NL80211_ATTR_DISABLE_HT:  Force HT capable interfaces to disable
+ *      this feature.  Currently, only supported in mac80211 drivers.
+ * @NL80211_ATTR_HT_CAPABILITY_MASK: Specify which bits of the
+ *      ATTR_HT_CAPABILITY to which attention should be paid.
+ *      Currently, only mac80211 NICs support this feature.
+ *      The values that may be configured are:
+ *       MCS rates, MAX-AMSDU, HT-20-40 and HT_CAP_SGI_40
+ *       AMPDU density and AMPDU factor.
+ *      All values are treated as suggestions and may be ignored
+ *      by the driver as required.  The actual values may be seen in
+ *      the station debugfs ht_caps file.
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -1408,6 +1419,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PROBE_RESP,
 
+	NL80211_ATTR_DISABLE_HT,
+	NL80211_ATTR_HT_CAPABILITY_MASK,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8d7ba09..4f6d131 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1044,6 +1044,15 @@ struct cfg80211_auth_request {
 };
 
 /**
+ * enum cfg80211_assoc_req_flags - Over-ride default behaviour in association.
+ *
+ * @ASSOC_REQ_DISABLE_HT:  Disable HT (802.11n)
+ */
+enum cfg80211_assoc_req_flags {
+	ASSOC_REQ_DISABLE_HT		= BIT(0),
+};
+
+/**
  * struct cfg80211_assoc_request - (Re)Association request data
  *
  * This structure provides information needed to complete IEEE 802.11
@@ -1054,6 +1063,10 @@ struct cfg80211_auth_request {
  * @use_mfp: Use management frame protection (IEEE 802.11w) in this association
  * @crypto: crypto settings
  * @prev_bssid: previous BSSID, if not %NULL use reassociate frame
+ * @flags:  See &enum cfg80211_assoc_req_flags
+ * @ht_capa:  HT Capabilities over-rides.  Values set in ht_capa_mask
+ *   will be used in ht_capa.  Un-supported values will be ignored.
+ * @ht_capa_mask:  The bits of ht_capa which are to be used.
  */
 struct cfg80211_assoc_request {
 	struct cfg80211_bss *bss;
@@ -1061,6 +1074,9 @@ struct cfg80211_assoc_request {
 	size_t ie_len;
 	struct cfg80211_crypto_settings crypto;
 	bool use_mfp;
+	u32 flags;
+	struct ieee80211_ht_cap ht_capa;
+	struct ieee80211_ht_cap ht_capa_mask;
 };
 
 /**
@@ -1159,6 +1175,10 @@ struct cfg80211_ibss_params {
  * @key_len: length of WEP key for shared key authentication
  * @key_idx: index of WEP key for shared key authentication
  * @key: WEP key for shared key authentication
+ * @flags:  See &enum cfg80211_assoc_req_flags
+ * @ht_capa:  HT Capabilities over-rides.  Values set in ht_capa_mask
+ *   will be used in ht_capa.  Un-supported values will be ignored.
+ * @ht_capa_mask:  The bits of ht_capa which are to be used.
  */
 struct cfg80211_connect_params {
 	struct ieee80211_channel *channel;
@@ -1172,6 +1192,9 @@ struct cfg80211_connect_params {
 	struct cfg80211_crypto_settings crypto;
 	const u8 *key;
 	u8 key_len, key_idx;
+	u32 flags;
+	struct ieee80211_ht_cap ht_capa;
+	struct ieee80211_ht_cap ht_capa_mask;
 };
 
 /**
@@ -1934,6 +1957,8 @@ struct wiphy_wowlan_support {
  * @wowlan: WoWLAN support information
  *
  * @ap_sme_capa: AP SME capabilities, flags from &enum nl80211_ap_sme_features.
+ * @ht_capa_mod_mask:  Specify what ht_cap values can be over-ridden.
+ *	If null, then none can be over-ridden.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -2023,6 +2048,8 @@ struct wiphy {
 	/* dir in debugfs: ieee80211/<wiphyname> */
 	struct dentry *debugfsdir;
 
+	const struct ieee80211_ht_cap *ht_capa_mod_mask;
+
 #ifdef CONFIG_NET_NS
 	/* the network namespace this phy lives in currently */
 	struct net *_net;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 1c7d4df..fb08c28 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -341,13 +341,17 @@ int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			  const u8 *bssid, const u8 *prev_bssid,
 			  const u8 *ssid, int ssid_len,
 			  const u8 *ie, int ie_len, bool use_mfp,
-			  struct cfg80211_crypto_settings *crypt);
+			  struct cfg80211_crypto_settings *crypt,
+			  u32 assoc_flags, struct ieee80211_ht_cap *ht_capa,
+			  struct ieee80211_ht_cap *ht_capa_mask);
 int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, struct ieee80211_channel *chan,
 			const u8 *bssid, const u8 *prev_bssid,
 			const u8 *ssid, int ssid_len,
 			const u8 *ie, int ie_len, bool use_mfp,
-			struct cfg80211_crypto_settings *crypt);
+			struct cfg80211_crypto_settings *crypt,
+			u32 assoc_flags, struct ieee80211_ht_cap *ht_capa,
+			struct ieee80211_ht_cap *ht_capa_mask);
 int __cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
 			   struct net_device *dev, const u8 *bssid,
 			   const u8 *ie, int ie_len, u16 reason,
@@ -379,6 +383,8 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			  bool channel_type_valid, unsigned int wait,
 			  const u8 *buf, size_t len, bool no_cck,
 			  bool dont_wait_for_ack, u64 *cookie);
+void cfg80211_oper_and_ht_capa(struct ieee80211_ht_cap *ht_capa,
+			       const struct ieee80211_ht_cap *ht_capa_mask);
 
 /* SME */
 int __cfg80211_connect(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 6c1bafd..438dfc1 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -501,13 +501,32 @@ int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 	return err;
 }
 
+/*  Do a logical ht_capa &= ht_capa_mask.  */
+void cfg80211_oper_and_ht_capa(struct ieee80211_ht_cap *ht_capa,
+			       const struct ieee80211_ht_cap *ht_capa_mask)
+{
+	int i;
+	u8 *p1, *p2;
+	if (!ht_capa_mask) {
+		memset(ht_capa, 0, sizeof(*ht_capa));
+		return;
+	}
+
+	p1 = (u8*)(ht_capa);
+	p2 = (u8*)(ht_capa_mask);
+	for (i = 0; i<sizeof(*ht_capa); i++)
+		p1[i] &= p2[i];
+}
+
 int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev,
 			  struct ieee80211_channel *chan,
 			  const u8 *bssid, const u8 *prev_bssid,
 			  const u8 *ssid, int ssid_len,
 			  const u8 *ie, int ie_len, bool use_mfp,
-			  struct cfg80211_crypto_settings *crypt)
+			  struct cfg80211_crypto_settings *crypt,
+			  u32 assoc_flags, struct ieee80211_ht_cap *ht_capa,
+			  struct ieee80211_ht_cap *ht_capa_mask)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_assoc_request req;
@@ -537,6 +556,15 @@ int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 	memcpy(&req.crypto, crypt, sizeof(req.crypto));
 	req.use_mfp = use_mfp;
 	req.prev_bssid = prev_bssid;
+	req.flags = assoc_flags;
+	if (ht_capa)
+		memcpy(&req.ht_capa, ht_capa, sizeof(req.ht_capa));
+	if (ht_capa_mask)
+		memcpy(&req.ht_capa_mask, ht_capa_mask,
+		       sizeof(req.ht_capa_mask));
+	cfg80211_oper_and_ht_capa(&req.ht_capa_mask,
+				  rdev->wiphy.ht_capa_mod_mask);
+
 	req.bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
 				   WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
 	if (!req.bss) {
@@ -574,14 +602,17 @@ int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			const u8 *bssid, const u8 *prev_bssid,
 			const u8 *ssid, int ssid_len,
 			const u8 *ie, int ie_len, bool use_mfp,
-			struct cfg80211_crypto_settings *crypt)
+			struct cfg80211_crypto_settings *crypt,
+			u32 assoc_flags, struct ieee80211_ht_cap *ht_capa,
+			struct ieee80211_ht_cap *ht_capa_mask)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
 
 	wdev_lock(wdev);
 	err = __cfg80211_mlme_assoc(rdev, dev, chan, bssid, prev_bssid,
-				    ssid, ssid_len, ie, ie_len, use_mfp, crypt);
+				    ssid, ssid_len, ie, ie_len, use_mfp, crypt,
+				    assoc_flags, ht_capa, ht_capa_mask);
 	wdev_unlock(wdev);
 
 	return err;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6bc7c4b..aa98ec2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -199,6 +199,10 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_DONT_WAIT_FOR_ACK] = { .type = NLA_FLAG },
 	[NL80211_ATTR_PROBE_RESP] = { .type = NLA_BINARY,
 				      .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_DISABLE_HT] = { .type = NLA_FLAG },
+	[NL80211_ATTR_HT_CAPABILITY_MASK] = {
+		.len = NL80211_HT_CAPABILITY_LEN
+	},
 };
 
 /* policy for the key attributes */
@@ -1025,6 +1029,11 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 
 	NLA_PUT_U32(msg, NL80211_ATTR_FEATURE_FLAGS, dev->wiphy.features);
 
+	if (dev->wiphy.ht_capa_mod_mask)
+		NLA_PUT(msg, NL80211_ATTR_HT_CAPABILITY_MASK,
+			sizeof(*dev->wiphy.ht_capa_mod_mask),
+			dev->wiphy.ht_capa_mod_mask);
+
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:
@@ -4384,6 +4393,9 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 	const u8 *bssid, *ssid, *ie = NULL, *prev_bssid = NULL;
 	int err, ssid_len, ie_len = 0;
 	bool use_mfp = false;
+	u32 flags = 0;
+	struct ieee80211_ht_cap *ht_capa = NULL;
+	struct ieee80211_ht_cap *ht_capa_mask = NULL;
 
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
@@ -4427,11 +4439,25 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_PREV_BSSID])
 		prev_bssid = nla_data(info->attrs[NL80211_ATTR_PREV_BSSID]);
 
+	if (nla_get_flag(info->attrs[NL80211_ATTR_DISABLE_HT]))
+		flags |= ASSOC_REQ_DISABLE_HT;
+
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
-					  &crypto);
+					  &crypto, flags, ht_capa,
+					  ht_capa_mask);
 
 	return err;
 }
@@ -4921,6 +4947,22 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 			return PTR_ERR(connkeys);
 	}
 
+	if (nla_get_flag(info->attrs[NL80211_ATTR_DISABLE_HT]))
+		connect.flags |= ASSOC_REQ_DISABLE_HT;
+
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
index 0acfdc9..f0c900c 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -190,7 +190,9 @@ static int cfg80211_conn_do_work(struct wireless_dev *wdev)
 					    prev_bssid,
 					    params->ssid, params->ssid_len,
 					    params->ie, params->ie_len,
-					    false, &params->crypto);
+					    false, &params->crypto,
+					    params->flags, &params->ht_capa,
+					    &params->ht_capa_mask);
 		if (err)
 			__cfg80211_mlme_deauth(rdev, wdev->netdev, params->bssid,
 					       NULL, 0,
@@ -774,6 +776,9 @@ int __cfg80211_connect(struct cfg80211_registered_device *rdev,
 		wdev->connect_keys = NULL;
 	}
 
+	cfg80211_oper_and_ht_capa(&connect->ht_capa_mask,
+				  rdev->wiphy.ht_capa_mod_mask);
+
 	if (connkeys && connkeys->def >= 0) {
 		int idx;
 		u32 cipher;
-- 
1.7.3.4

