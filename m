Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A04CC43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 20:57:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E55FF218A1
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 20:57:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="XWzeaQUe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfCPU5n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 16:57:43 -0400
Received: from 8.mo69.mail-out.ovh.net ([46.105.56.233]:57014 "EHLO
        8.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfCPU5n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 16:57:43 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Mar 2019 16:57:41 EDT
Received: from player693.ha.ovh.net (unknown [10.109.146.5])
        by mo69.mail-out.ovh.net (Postfix) with ESMTP id 6D92F4A73C
        for <linux-wireless@vger.kernel.org>; Sat, 16 Mar 2019 21:42:23 +0100 (CET)
Received: from awhome.eu (p4FF91B93.dip0.t-ipconnect.de [79.249.27.147])
        (Authenticated sender: postmaster@awhome.eu)
        by player693.ha.ovh.net (Postfix) with ESMTPSA id 1386D3B8EB58;
        Sat, 16 Mar 2019 20:42:22 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1552768941;
        bh=Mm5WJmP1LlnoIR5Nr7742HVlV8w0jWAt7447vqNGjis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=XWzeaQUexw5lDgupzvdOgU3uUihEKqqy7d6pH7Yqi3owvoqz6Dg0fCy8U1Iua0XWo
         bIx9cfMFL4jjvfctYgBG+q5xIpUe1LTkMnpplY2m0ydiT5COMI1Y70ZsX74gze0fmj
         qq+8YjcwppfjcNWnxo8vr7qSEp3jI7SIzWhqTpbI=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH 1/5] nl80211/cfg80211: Extended Key ID support
Date:   Sat, 16 Mar 2019 21:42:04 +0100
Message-Id: <20190316204208.16497-2-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190316204208.16497-1-alexander@wetzel-home.de>
References: <20190316204208.16497-1-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6894729556258659527
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddrheejgddugeefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenuc
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add support for IEEE 802.11-2016 "Extended Key ID for Individually
Addressed Frames".

Extend cfg80211 and nl80211 to allow pairwise keys to be installed for
Rx only, enable Tx separately and allow Key ID 1 for pairwise keys.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---
 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h | 28 ++++++++++++++++++++++++++++
 net/wireless/nl80211.c       | 32 ++++++++++++++++++++++++++++----
 net/wireless/rdev-ops.h      |  3 ++-
 net/wireless/trace.h         | 31 ++++++++++++++++++++++++++-----
 net/wireless/util.c          | 21 +++++++++++++++------
 6 files changed, 101 insertions(+), 16 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bb307a11ee63..d89053de2fbb 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -485,6 +485,7 @@ struct vif_params {
  *	with the get_key() callback, must be in little endian,
  *	length given by @seq_len.
  * @seq_len: length of @seq.
+ * @mode: key install mode (RX_TX, NO_TX or SET_TX)
  */
 struct key_params {
 	const u8 *key;
@@ -492,6 +493,7 @@ struct key_params {
 	int key_len;
 	int seq_len;
 	u32 cipher;
+	enum nl80211_key_mode mode;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index dd4f86ee286e..098534d8a573 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4134,6 +4134,27 @@ enum nl80211_channel_type {
 	NL80211_CHAN_HT40PLUS
 };
 
+/**
+ * enum nl80211_key_mode - Key mode
+ *
+ * @NL80211_KEY_RX_TX: (Default)
+ *	Key can be used for Rx and Tx immediately
+ *
+ * The following modes can only be selected for unicast keys and when the
+ * driver supports @NL80211_EXT_FEATURE_EXT_KEY_ID:
+ *
+ * @NL80211_KEY_NO_TX: Only allowed in combination with @NL80211_CMD_NEW_KEY:
+ *	Unicast key can only be used for Rx, Tx not allowed, yet
+ * @NL80211_KEY_SET_TX: Only allowed in combination with @NL80211_CMD_SET_KEY:
+ *	The unicast key identified by idx and mac is cleared for Tx and becomes
+ *	the preferred Tx key for the station.
+ */
+enum nl80211_key_mode {
+	NL80211_KEY_RX_TX,
+	NL80211_KEY_NO_TX,
+	NL80211_KEY_SET_TX
+};
+
 /**
  * enum nl80211_chan_width - channel width definitions
  *
@@ -4377,6 +4398,9 @@ enum nl80211_key_default_types {
  * @NL80211_KEY_DEFAULT_TYPES: A nested attribute containing flags
  *	attributes, specifying what a key should be set as default as.
  *	See &enum nl80211_key_default_types.
+ * @NL80211_KEY_MODE: the mode from enum nl80211_key_mode.
+ *	Defaults to @NL80211_KEY_RX_TX.
+ *
  * @__NL80211_KEY_AFTER_LAST: internal
  * @NL80211_KEY_MAX: highest key attribute
  */
@@ -4390,6 +4414,7 @@ enum nl80211_key_attributes {
 	NL80211_KEY_DEFAULT_MGMT,
 	NL80211_KEY_TYPE,
 	NL80211_KEY_DEFAULT_TYPES,
+	NL80211_KEY_MODE,
 
 	/* keep last */
 	__NL80211_KEY_AFTER_LAST,
@@ -5335,6 +5360,8 @@ enum nl80211_feature_flags {
  *      able to rekey an in-use key correctly. Userspace must not rekey PTK keys
  *      if this flag is not set. Ignoring this can leak clear text packets and/or
  *      freeze the connection.
+ * @NL80211_EXT_FEATURE_EXT_KEY_ID: Driver supports "Extended Key ID for
+ *      Individually Addressed Frames" from IEEE802.11-2016.
  *
  * @NL80211_EXT_FEATURE_AIRTIME_FAIRNESS: Driver supports getting airtime
  *	fairness for transmitted packets and has enabled airtime fairness
@@ -5384,6 +5411,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER,
 	NL80211_EXT_FEATURE_AIRTIME_FAIRNESS,
 	NL80211_EXT_FEATURE_AP_PMKSA_CACHING,
+	NL80211_EXT_FEATURE_EXT_KEY_ID,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 25a9e3b5c154..4167dcdf516e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -553,6 +553,7 @@ static const struct nla_policy nl80211_key_policy[NL80211_KEY_MAX + 1] = {
 	[NL80211_KEY_DEFAULT_MGMT] = { .type = NLA_FLAG },
 	[NL80211_KEY_TYPE] = NLA_POLICY_MAX(NLA_U32, NUM_NL80211_KEYTYPES - 1),
 	[NL80211_KEY_DEFAULT_TYPES] = { .type = NLA_NESTED },
+	[NL80211_KEY_MODE] = { .type = NLA_U8 },
 };
 
 /* policy for the key default flags */
@@ -958,6 +959,9 @@ static int nl80211_parse_key_new(struct genl_info *info, struct nlattr *key,
 		k->def_multi = kdt[NL80211_KEY_DEFAULT_TYPE_MULTICAST];
 	}
 
+	if (tb[NL80211_KEY_MODE])
+		k->p.mode = nla_get_u8(tb[NL80211_KEY_MODE]);
+
 	return 0;
 }
 
@@ -3634,8 +3638,11 @@ static int nl80211_set_key(struct sk_buff *skb, struct genl_info *info)
 	if (key.idx < 0)
 		return -EINVAL;
 
-	/* only support setting default key */
-	if (!key.def && !key.defmgmt)
+	/* Only support setting default key and
+	 * Extended Key ID action NL80211_KEY_SET_TX.
+	 */
+	if (!key.def && !key.defmgmt &&
+	    !(key.p.mode == NL80211_KEY_SET_TX))
 		return -EINVAL;
 
 	wdev_lock(dev->ieee80211_ptr);
@@ -3659,7 +3666,7 @@ static int nl80211_set_key(struct sk_buff *skb, struct genl_info *info)
 #ifdef CONFIG_CFG80211_WEXT
 		dev->ieee80211_ptr->wext.default_key = key.idx;
 #endif
-	} else {
+	} else if (key.defmgmt) {
 		if (key.def_uni || !key.def_multi) {
 			err = -EINVAL;
 			goto out;
@@ -3681,8 +3688,25 @@ static int nl80211_set_key(struct sk_buff *skb, struct genl_info *info)
 #ifdef CONFIG_CFG80211_WEXT
 		dev->ieee80211_ptr->wext.default_mgmt_key = key.idx;
 #endif
-	}
+	} else if (key.p.mode == NL80211_KEY_SET_TX &&
+		   wiphy_ext_feature_isset(&rdev->wiphy,
+					   NL80211_EXT_FEATURE_EXT_KEY_ID)) {
+		u8 *mac_addr = NULL;
 
+		if (info->attrs[NL80211_ATTR_MAC])
+			mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+		if (!mac_addr || key.idx < 0 || key.idx > 1) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		err = rdev_add_key(rdev, dev, key.idx,
+				   NL80211_KEYTYPE_PAIRWISE,
+				   mac_addr, &key.p);
+	} else {
+		err = -EINVAL;
+	}
  out:
 	wdev_unlock(dev->ieee80211_ptr);
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 5cb48d135fab..5044e634a455 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -77,7 +77,8 @@ static inline int rdev_add_key(struct cfg80211_registered_device *rdev,
 			       struct key_params *params)
 {
 	int ret;
-	trace_rdev_add_key(&rdev->wiphy, netdev, key_index, pairwise, mac_addr);
+	trace_rdev_add_key(&rdev->wiphy, netdev, key_index, pairwise,
+			   mac_addr, params->mode);
 	ret = rdev->ops->add_key(&rdev->wiphy, netdev, key_index, pairwise,
 				  mac_addr, params);
 	trace_rdev_return_int(&rdev->wiphy, ret);
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 44b2ce1bb13a..0876f3eb3b3b 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -430,22 +430,43 @@ DECLARE_EVENT_CLASS(key_handle,
 		  BOOL_TO_STR(__entry->pairwise), MAC_PR_ARG(mac_addr))
 );
 
-DEFINE_EVENT(key_handle, rdev_add_key,
+DEFINE_EVENT(key_handle, rdev_get_key,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 		 bool pairwise, const u8 *mac_addr),
 	TP_ARGS(wiphy, netdev, key_index, pairwise, mac_addr)
 );
 
-DEFINE_EVENT(key_handle, rdev_get_key,
+DEFINE_EVENT(key_handle, rdev_del_key,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 		 bool pairwise, const u8 *mac_addr),
 	TP_ARGS(wiphy, netdev, key_index, pairwise, mac_addr)
 );
 
-DEFINE_EVENT(key_handle, rdev_del_key,
+TRACE_EVENT(rdev_add_key,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
-		 bool pairwise, const u8 *mac_addr),
-	TP_ARGS(wiphy, netdev, key_index, pairwise, mac_addr)
+		 bool pairwise, const u8 *mac_addr, u8 mode),
+	TP_ARGS(wiphy, netdev, key_index, pairwise, mac_addr, mode),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(mac_addr)
+		__field(u8, key_index)
+		__field(bool, pairwise)
+		__field(u8, mode)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(mac_addr, mac_addr);
+		__entry->key_index = key_index;
+		__entry->pairwise = pairwise;
+		__entry->mode = mode;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", key_index: %u, "
+		  "mode: %u, pairwise: %s, mac addr: " MAC_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->key_index,
+		  __entry->mode, BOOL_TO_STR(__entry->pairwise),
+		  MAC_PR_ARG(mac_addr))
 );
 
 TRACE_EVENT(rdev_set_default_key,
diff --git a/net/wireless/util.c b/net/wireless/util.c
index e4b8db5e81ec..6c02c9cf7aa9 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -237,14 +237,23 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 	case WLAN_CIPHER_SUITE_CCMP_256:
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
-		/* Disallow pairwise keys with non-zero index unless it's WEP
-		 * or a vendor specific cipher (because current deployments use
-		 * pairwise WEP keys with non-zero indices and for vendor
-		 * specific ciphers this should be validated in the driver or
-		 * hardware level - but 802.11i clearly specifies to use zero)
+		/* IEEE802.11-2016 allows only 0 and - when using Extended Key
+		 * ID - 1 as index for pairwise keys.
+		 * @NL80211_KEY_NO_TX is only allowed for pairwise keys when
+		 * the driver supports Extended Key ID.
+		 * @NL80211_KEY_SET_TX can't be set when installing and
+		 * validating a key.
 		 */
-		if (pairwise && key_idx)
+		if (params->mode == NL80211_KEY_NO_TX) {
+			if (!wiphy_ext_feature_isset(&rdev->wiphy,
+						     NL80211_EXT_FEATURE_EXT_KEY_ID))
+				return -EINVAL;
+			else if (!pairwise || key_idx < 0 || key_idx > 1)
+				return -EINVAL;
+		} else if ((pairwise && key_idx) ||
+			   params->mode == NL80211_KEY_SET_TX) {
 			return -EINVAL;
+		}
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
-- 
2.21.0

