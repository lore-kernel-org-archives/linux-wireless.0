Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B02C282C2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C038D2145D
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 21:21:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="Mn/CzWXE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfBJVV6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 16:21:58 -0500
Received: from 3.mo177.mail-out.ovh.net ([46.105.36.172]:60392 "EHLO
        3.mo177.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfBJVV5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 16:21:57 -0500
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Feb 2019 16:21:54 EST
Received: from player776.ha.ovh.net (unknown [10.109.143.209])
        by mo177.mail-out.ovh.net (Postfix) with ESMTP id C79FBDAD82
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2019 22:06:46 +0100 (CET)
Received: from awhome.eu (p579AAB97.dip0.t-ipconnect.de [87.154.171.151])
        (Authenticated sender: postmaster@awhome.eu)
        by player776.ha.ovh.net (Postfix) with ESMTPSA id 1F14728731D6;
        Sun, 10 Feb 2019 21:06:44 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1549832804;
        bh=1TjtHQtHICvx+c1FmoCu1hYWzGIvlnAKJj3Tp3n0Ars=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Mn/CzWXEv5rK7YL4+UMAbMxSH22tobkfx4f7xj9R1kOwTZxZiSXujvE7gnFc76E5C
         5knPeMT02BuexOorPFhDcQRyGrPd9zZJBI7iWnopHqso6ZLCE8zYEfpiNmgI3y07Pu
         GmwBOsFgJ9g8KmaZ2gg5OJw3EbA7TlDCj8IS9x/c=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [RFC PATCH v3 02/12] nl80211/cfg80211: Extended Key ID support
Date:   Sun, 10 Feb 2019 22:06:10 +0100
Message-Id: <20190210210620.31181-3-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190210210620.31181-1-alexander@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10549119180040707271
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrleefgddvfecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecu
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add support for IEEE 802.11-2016 "Extended Key ID for Individually
Addressed Frames".

Extends cfg80211 and nl80211 to allow pairwise keys to be installed Rx
only, switch Tx over separately and to use keyidx 1 for pairwise keys.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---
 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h | 23 ++++++++++++++++++++++-
 net/wireless/nl80211.c       | 32 ++++++++++++++++++++++++++++----
 net/wireless/rdev-ops.h      |  3 ++-
 net/wireless/trace.h         | 31 ++++++++++++++++++++++++++-----
 net/wireless/util.c          | 20 ++++++++++++++------
 6 files changed, 94 insertions(+), 17 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7f2739a90bdb..71ebb3492e21 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -485,6 +485,7 @@ struct vif_params {
  *	with the get_key() callback, must be in little endian,
  *	length given by @seq_len.
  * @seq_len: length of @seq.
+ * @install_mode: key install mode (Rx/Tx, Rx only or set Tx)
  */
 struct key_params {
 	const u8 *key;
@@ -492,6 +493,7 @@ struct key_params {
 	int key_len;
 	int seq_len;
 	u32 cipher;
+	enum nl80211_key_install_mode install_mode;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index dd4f86ee286e..8ccede541913 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4134,6 +4134,21 @@ enum nl80211_channel_type {
 	NL80211_CHAN_HT40PLUS
 };
 
+/**
+ * enum nl80211_key_install_mode - Key install mode
+ *
+ * @NL80211_KEY_RX_TX: Key must be installed for Rx and Tx
+ * @NL80211_KEY_RX_ONLY: Allowed in combination with @NL80211_CMD_NEW_KEY:
+ *	Unicast key has to be installed for Rx only.
+ * @NL80211_KEY_SWITCH_TX: Allowed in combination with @NL80211_CMD_SET_KEY:
+ *	Switch Tx to a Rx only, referenced by sta mac and idx.
+ */
+enum nl80211_key_install_mode {
+	NL80211_KEY_RX_TX,
+	NL80211_KEY_RX_ONLY,
+	NL80211_KEY_SWITCH_TX
+};
+
 /**
  * enum nl80211_chan_width - channel width definitions
  *
@@ -4377,6 +4392,9 @@ enum nl80211_key_default_types {
  * @NL80211_KEY_DEFAULT_TYPES: A nested attribute containing flags
  *	attributes, specifying what a key should be set as default as.
  *	See &enum nl80211_key_default_types.
+ * @NL80211_KEY_INSTALL_MODE: the install mode from
+ *	enum nl80211_key_install_mode. Defaults to @NL80211_KEY_RX_TX.
+ *
  * @__NL80211_KEY_AFTER_LAST: internal
  * @NL80211_KEY_MAX: highest key attribute
  */
@@ -4390,6 +4408,7 @@ enum nl80211_key_attributes {
 	NL80211_KEY_DEFAULT_MGMT,
 	NL80211_KEY_TYPE,
 	NL80211_KEY_DEFAULT_TYPES,
+	NL80211_KEY_INSTALL_MODE,
 
 	/* keep last */
 	__NL80211_KEY_AFTER_LAST,
@@ -5330,11 +5349,12 @@ enum nl80211_feature_flags {
  *	by the %NL80211_SCAN_FLAG_MIN_PREQ_CONTENT flag.
  * @NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER: Driver supports enabling fine
  *	timing measurement responder role.
- *
  * @NL80211_EXT_FEATURE_CAN_REPLACE_PTK0: Driver/device confirm that they are
  *      able to rekey an in-use key correctly. Userspace must not rekey PTK keys
  *      if this flag is not set. Ignoring this can leak clear text packets and/or
  *      freeze the connection.
+ * @NL80211_EXT_FEATURE_EXT_KEY_ID: Driver supports "Extended Key ID for
+ *      Individually Addressed Frames" from IEEE802.11-2016.
  *
  * @NL80211_EXT_FEATURE_AIRTIME_FAIRNESS: Driver supports getting airtime
  *	fairness for transmitted packets and has enabled airtime fairness
@@ -5384,6 +5404,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER,
 	NL80211_EXT_FEATURE_AIRTIME_FAIRNESS,
 	NL80211_EXT_FEATURE_AP_PMKSA_CACHING,
+	NL80211_EXT_FEATURE_EXT_KEY_ID,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a3cc039b9f55..2a076b99737e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -565,6 +565,7 @@ static const struct nla_policy nl80211_key_policy[NL80211_KEY_MAX + 1] = {
 	[NL80211_KEY_DEFAULT_MGMT] = { .type = NLA_FLAG },
 	[NL80211_KEY_TYPE] = NLA_POLICY_MAX(NLA_U32, NUM_NL80211_KEYTYPES - 1),
 	[NL80211_KEY_DEFAULT_TYPES] = { .type = NLA_NESTED },
+	[NL80211_KEY_INSTALL_MODE] = { .type = NLA_U8 },
 };
 
 /* policy for the key default flags */
@@ -970,6 +971,9 @@ static int nl80211_parse_key_new(struct genl_info *info, struct nlattr *key,
 		k->def_multi = kdt[NL80211_KEY_DEFAULT_TYPE_MULTICAST];
 	}
 
+	if (tb[NL80211_KEY_INSTALL_MODE])
+		k->p.install_mode = nla_get_u8(tb[NL80211_KEY_INSTALL_MODE]);
+
 	return 0;
 }
 
@@ -3646,8 +3650,11 @@ static int nl80211_set_key(struct sk_buff *skb, struct genl_info *info)
 	if (key.idx < 0)
 		return -EINVAL;
 
-	/* only support setting default key */
-	if (!key.def && !key.defmgmt)
+	/* Only support setting default key and
+	 * Extended Key ID action @NL80211_KEY_SWITCH_TX.
+	 */
+	if (!key.def && !key.defmgmt &&
+	    !(key.p.install_mode == NL80211_KEY_SWITCH_TX))
 		return -EINVAL;
 
 	wdev_lock(dev->ieee80211_ptr);
@@ -3671,7 +3678,7 @@ static int nl80211_set_key(struct sk_buff *skb, struct genl_info *info)
 #ifdef CONFIG_CFG80211_WEXT
 		dev->ieee80211_ptr->wext.default_key = key.idx;
 #endif
-	} else {
+	} else if (key.defmgmt) {
 		if (key.def_uni || !key.def_multi) {
 			err = -EINVAL;
 			goto out;
@@ -3693,8 +3700,25 @@ static int nl80211_set_key(struct sk_buff *skb, struct genl_info *info)
 #ifdef CONFIG_CFG80211_WEXT
 		dev->ieee80211_ptr->wext.default_mgmt_key = key.idx;
 #endif
-	}
+	} else if (key.p.install_mode == NL80211_KEY_SWITCH_TX &&
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
index 5cb48d135fab..4bf4e3774825 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -77,7 +77,8 @@ static inline int rdev_add_key(struct cfg80211_registered_device *rdev,
 			       struct key_params *params)
 {
 	int ret;
-	trace_rdev_add_key(&rdev->wiphy, netdev, key_index, pairwise, mac_addr);
+	trace_rdev_add_key(&rdev->wiphy, netdev, key_index, pairwise,
+			   mac_addr, params->install_mode);
 	ret = rdev->ops->add_key(&rdev->wiphy, netdev, key_index, pairwise,
 				  mac_addr, params);
 	trace_rdev_return_int(&rdev->wiphy, ret);
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 44b2ce1bb13a..b5c9e6729ff1 100644
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
+		 bool pairwise, const u8 *mac_addr, u8 install_mode),
+	TP_ARGS(wiphy, netdev, key_index, pairwise, mac_addr, install_mode),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(mac_addr)
+		__field(u8, key_index)
+		__field(bool, pairwise)
+		__field(u8, install_mode)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(mac_addr, mac_addr);
+		__entry->key_index = key_index;
+		__entry->pairwise = pairwise;
+		__entry->install_mode = install_mode;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", key_index: %u, "
+		  "install_mode: %u, pairwise: %s, mac addr: " MAC_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->key_index,
+		  __entry->install_mode, BOOL_TO_STR(__entry->pairwise),
+		  MAC_PR_ARG(mac_addr))
 );
 
 TRACE_EVENT(rdev_set_default_key,
diff --git a/net/wireless/util.c b/net/wireless/util.c
index cd48cdd582c0..a3338e611190 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -236,14 +236,22 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
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
+		 * @NL80211_KEY_RX_ONLY is only allowed for pairwise keys when
+		 * the driver supports Extended Key ID.
+		 * @NL80211_KEY_SWITCH_TX must not be set when validating a key.
 		 */
-		if (pairwise && key_idx)
+		if (params->install_mode == NL80211_KEY_RX_ONLY) {
+			if (!wiphy_ext_feature_isset(&rdev->wiphy,
+						     NL80211_EXT_FEATURE_EXT_KEY_ID))
+				return -EINVAL;
+			else if (!pairwise || key_idx < 0 || key_idx > 1)
+				return -EINVAL;
+		} else if ((pairwise && key_idx) ||
+			   params->install_mode == NL80211_KEY_SWITCH_TX) {
 			return -EINVAL;
+		}
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
 	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
-- 
2.20.1

