Return-Path: <SRS0=mdyG=NV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2807C43441
	for <linux-wireless@archiver.kernel.org>; Sat, 10 Nov 2018 15:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 575ED20818
	for <linux-wireless@archiver.kernel.org>; Sat, 10 Nov 2018 15:22:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="FgDB61/h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 575ED20818
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=wetzel-home.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbeKKBHX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 10 Nov 2018 20:07:23 -0500
Received: from 5.mo179.mail-out.ovh.net ([46.105.43.140]:36611 "EHLO
        5.mo179.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbeKKBHW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Nov 2018 20:07:22 -0500
X-Greylist: delayed 6622 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Nov 2018 20:07:18 EST
Received: from player770.ha.ovh.net (unknown [10.109.160.239])
        by mo179.mail-out.ovh.net (Postfix) with ESMTP id E08EF107759
        for <linux-wireless@vger.kernel.org>; Sat, 10 Nov 2018 13:54:06 +0100 (CET)
Received: from awhome.eu (p57B7E4EB.dip0.t-ipconnect.de [87.183.228.235])
        (Authenticated sender: postmaster@awhome.eu)
        by player770.ha.ovh.net (Postfix) with ESMTPSA id 76780C00A4;
        Sat, 10 Nov 2018 13:54:05 +0100 (CET)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1541854444;
        bh=RsNxUqD41l7pD23Y1P0zkkMeLdSomykD0KftC5ZIAFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=FgDB61/h3kFRTS0Pi8ZaB3mkmlFC8sz2k22gD4loOqreSKJ8IX3muHc4UEZb/ckC5
         a+wKAzX20B5Ta9RIEZsAsWyo0l7F8YiHesdZaYM66FnR1nIjoU9QFyQAKW6ScBxNok
         ZtSc18TVDOoYXqVjAjsPqOyTsKWj/9uAdyWDkn2Q=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [RFC PATCH 1/2] nl80211/cfg80211: Add support for Extended Key ID
Date:   Sat, 10 Nov 2018 13:53:30 +0100
Message-Id: <20181110125331.2726-2-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181110125331.2726-1-alexander@wetzel-home.de>
References: <20181110125331.2726-1-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 15343200980804312263
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrkeehgdegiecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecu
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Extend cfg80211 and nl80211 to allow pairwise keys to be installed for
RX only and allowing to switching over TX independently, as required by
IEEE-802.11-2016 to support "Extended Key ID for Individually Addressed
Frames"
PTK and STK keys are now also allowed to use Key ID 1.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---
 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h | 41 ++++++++++++++++++++++++++---
 net/wireless/nl80211.c       | 51 ++++++++++++++++++++++++++++++++----
 net/wireless/rdev-ops.h      |  3 ++-
 net/wireless/trace.h         | 31 ++++++++++++++++++----
 net/wireless/util.c          |  9 ++++---
 6 files changed, 119 insertions(+), 18 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1fa41b7a1be3..0d59340563e0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -485,6 +485,7 @@ struct vif_params {
  *	with the get_key() callback, must be in little endian,
  *	length given by @seq_len.
  * @seq_len: length of @seq.
+ * @flag: One flag from &enum key_params_flag
  */
 struct key_params {
 	const u8 *key;
@@ -492,6 +493,7 @@ struct key_params {
 	int key_len;
 	int seq_len;
 	u32 cipher;
+	enum key_params_flag flag;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 6d610bae30a9..d6c7fa72f433 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2254,6 +2254,14 @@ enum nl80211_commands {
  * @NL80211_ATTR_FTM_RESPONDER_STATS: Nested attribute with FTM responder
  *	statistics, see &enum nl80211_ftm_responder_stats.
  *
+ * @NL80211_ATTR_KEY_RXONLY: Flag attribute to request RX key install only for
+ *      a pairwise key. Only supported for keyid's 0 and 1 when driver is
+ *      supporting Extended Key ID.
+ *
+ * @NL80211_ATTR_KEY_SETTX: Flag attribute to switch TX to a specified keyid.
+ *      Only supported for keyid's 0 and 1 when driver is supporting Extended
+ *      Key ID.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2699,6 +2707,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_FTM_RESPONDER_STATS,
 
+	NL80211_ATTR_KEY_RXONLY,
+	NL80211_ATTR_KEY_SETTX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4056,6 +4067,22 @@ enum nl80211_channel_type {
 	NL80211_CHAN_HT40PLUS
 };
 
+/**
+ * enum key_params_flag - additional key flag for drivers
+ *
+ * Actions other than @NL80211_KEY_DEFAULT_RX_TX are only required from drivers
+ * supporting Extended Key ID for pairwise keys using keyid 0 or 1.
+ *
+ * @NL80211_KEY_DEFAULT_RX_TX: key can be immediately used for Rx and Tx
+ * @NL80211_KEY_RX_ONLY: key must be installed for Rx only
+ * @NL80211_KEY_SET_TX: switch Tx for sta to specified keyid
+ */
+enum key_params_flag {
+	NL80211_KEY_DEFAULT_RX_TX,
+	NL80211_KEY_RX_ONLY,
+	NL80211_KEY_SET_TX
+};
+
 /**
  * enum nl80211_chan_width - channel width definitions
  *
@@ -4299,6 +4326,10 @@ enum nl80211_key_default_types {
  * @NL80211_KEY_DEFAULT_TYPES: A nested attribute containing flags
  *	attributes, specifying what a key should be set as default as.
  *	See &enum nl80211_key_default_types.
+ * @NL80211_KEY_RXONLY: Flag attribute to request RX key install only for
+ *      a pairwise key.
+ * @NL80211_KEY_SETTX: Flag attribute to switch TX to a selected key.
+ *
  * @__NL80211_KEY_AFTER_LAST: internal
  * @NL80211_KEY_MAX: highest key attribute
  */
@@ -4312,6 +4343,8 @@ enum nl80211_key_attributes {
 	NL80211_KEY_DEFAULT_MGMT,
 	NL80211_KEY_TYPE,
 	NL80211_KEY_DEFAULT_TYPES,
+	NL80211_KEY_RXONLY,
+	NL80211_KEY_SETTX,
 
 	/* keep last */
 	__NL80211_KEY_AFTER_LAST,
@@ -5250,13 +5283,14 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT: Driver/device can omit all data
  *	except for supported rates from the probe request content if requested
  *	by the %NL80211_SCAN_FLAG_MIN_PREQ_CONTENT flag.
- * @NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER: Driver supports enabling fine
- *	timing measurement responder role.
- *
  * @NL80211_EXT_FEATURE_CAN_REPLACE_PTK0: Driver/device confirm that they are
  *      able to rekey an in-use key correctly. Userspace must not rekey PTK keys
  *      if this flag is not set. Ignoring this can leak clear text packets and/or
  *      freeze the connection.
+ * @NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER: Driver supports enabling fine
+ *	timing measurement responder role.
+ * @NL80211_EXT_FEATURE_EXT_KEY_ID: Driver supports "Extended Key ID for
+ *      Individually Addressed Frames" from IEEE802.11-2016.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5297,6 +5331,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT,
 	NL80211_EXT_FEATURE_CAN_REPLACE_PTK0,
 	NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER,
+	NL80211_EXT_FEATURE_EXT_KEY_ID,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 744b5851bbf9..51ba4c9bffc5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -275,6 +275,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_KEY_SEQ] = { .type = NLA_BINARY, .len = 16 },
 	[NL80211_ATTR_KEY_TYPE] =
 		NLA_POLICY_MAX(NLA_U32, NUM_NL80211_KEYTYPES),
+	[NL80211_ATTR_KEY_RXONLY] = { .type = NLA_FLAG },
+	[NL80211_ATTR_KEY_SETTX] = { .type = NLA_FLAG },
 
 	[NL80211_ATTR_BEACON_INTERVAL] = { .type = NLA_U32 },
 	[NL80211_ATTR_DTIM_PERIOD] = { .type = NLA_U32 },
@@ -509,6 +511,8 @@ static const struct nla_policy nl80211_key_policy[NL80211_KEY_MAX + 1] = {
 	[NL80211_KEY_DEFAULT_MGMT] = { .type = NLA_FLAG },
 	[NL80211_KEY_TYPE] = NLA_POLICY_MAX(NLA_U32, NUM_NL80211_KEYTYPES - 1),
 	[NL80211_KEY_DEFAULT_TYPES] = { .type = NLA_NESTED },
+	[NL80211_KEY_RXONLY] = { .type = NLA_FLAG },
+	[NL80211_KEY_SETTX] = { .type = NLA_FLAG },
 };
 
 /* policy for the key default flags */
@@ -860,6 +864,7 @@ struct key_parse {
 	int type;
 	bool def, defmgmt;
 	bool def_uni, def_multi;
+	bool rx_only, set_tx;
 };
 
 static int nl80211_parse_key_new(struct genl_info *info, struct nlattr *key,
@@ -881,6 +886,16 @@ static int nl80211_parse_key_new(struct genl_info *info, struct nlattr *key,
 	if (k->defmgmt)
 		k->def_multi = true;
 
+	k->rx_only = !!tb[NL80211_KEY_RXONLY];
+	k->set_tx = !!tb[NL80211_KEY_SETTX];
+
+	if (k->rx_only && k->set_tx)
+		return -EINVAL;
+	else if (k->rx_only)
+		k->p.flag = NL80211_KEY_RX_ONLY;
+	else if (k->set_tx)
+		k->p.flag = NL80211_KEY_SET_TX;
+
 	if (tb[NL80211_KEY_IDX])
 		k->idx = nla_get_u8(tb[NL80211_KEY_IDX]);
 
@@ -945,6 +960,16 @@ static int nl80211_parse_key_old(struct genl_info *info, struct key_parse *k)
 	if (k->defmgmt)
 		k->def_multi = true;
 
+	k->rx_only = !!info->attrs[NL80211_ATTR_KEY_RXONLY];
+	k->set_tx = !!info->attrs[NL80211_ATTR_KEY_SETTX];
+
+	if (k->rx_only && k->set_tx)
+		return -EINVAL;
+	else if (k->rx_only)
+		k->p.flag = NL80211_KEY_RX_ONLY;
+	else if (k->set_tx)
+		k->p.flag = NL80211_KEY_SET_TX;
+
 	if (info->attrs[NL80211_ATTR_KEY_TYPE])
 		k->type = nla_get_u32(info->attrs[NL80211_ATTR_KEY_TYPE]);
 
@@ -3471,6 +3496,7 @@ static int nl80211_set_key(struct sk_buff *skb, struct genl_info *info)
 	struct key_parse key;
 	int err;
 	struct net_device *dev = info->user_ptr[1];
+	u8 *mac_addr = NULL;
 
 	err = nl80211_parse_key(info, &key);
 	if (err)
@@ -3479,8 +3505,9 @@ static int nl80211_set_key(struct sk_buff *skb, struct genl_info *info)
 	if (key.idx < 0)
 		return -EINVAL;
 
-	/* only support setting default key */
-	if (!key.def && !key.defmgmt)
+	/* only support setting default key and
+	 * Extended Key ID action NL80211_KEY_SET_TX */
+	if (!key.def && !key.defmgmt && !key.set_tx)
 		return -EINVAL;
 
 	wdev_lock(dev->ieee80211_ptr);
@@ -3504,7 +3531,7 @@ static int nl80211_set_key(struct sk_buff *skb, struct genl_info *info)
 #ifdef CONFIG_CFG80211_WEXT
 		dev->ieee80211_ptr->wext.default_key = key.idx;
 #endif
-	} else {
+	} else if (key.defmgmt){
 		if (key.def_uni || !key.def_multi) {
 			err = -EINVAL;
 			goto out;
@@ -3526,8 +3553,22 @@ static int nl80211_set_key(struct sk_buff *skb, struct genl_info *info)
 #ifdef CONFIG_CFG80211_WEXT
 		dev->ieee80211_ptr->wext.default_mgmt_key = key.idx;
 #endif
-	}
+	} else if (wiphy_ext_feature_isset(&rdev->wiphy,
+					   NL80211_EXT_FEATURE_EXT_KEY_ID)) {
+		if (info->attrs[NL80211_ATTR_MAC])
+			mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
+		if (!mac_addr || key.idx < 0 || key.idx > 1) {
+			err = -EOPNOTSUPP;
+			goto out;
+		}
+
+		err = rdev_add_key(rdev, dev, key.idx,
+				   NL80211_KEYTYPE_PAIRWISE,
+				   mac_addr, &key.p);
+	} else {
+		err = -EOPNOTSUPP;
+	}
  out:
 	wdev_unlock(dev->ieee80211_ptr);
 
@@ -3546,7 +3587,7 @@ static int nl80211_new_key(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
-	if (!key.p.key)
+	if (!key.p.key || key.set_tx)
 		return -EINVAL;
 
 	if (info->attrs[NL80211_ATTR_MAC])
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 51380b5c32f2..bc2f6f26b729 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -77,7 +77,8 @@ static inline int rdev_add_key(struct cfg80211_registered_device *rdev,
 			       struct key_params *params)
 {
 	int ret;
-	trace_rdev_add_key(&rdev->wiphy, netdev, key_index, pairwise, mac_addr);
+	trace_rdev_add_key(&rdev->wiphy, netdev, key_index, pairwise,
+			   mac_addr, params->flag);
 	ret = rdev->ops->add_key(&rdev->wiphy, netdev, key_index, pairwise,
 				  mac_addr, params);
 	trace_rdev_return_int(&rdev->wiphy, ret);
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index c6a9446b4e6b..903e4cda930c 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -412,22 +412,43 @@ DECLARE_EVENT_CLASS(key_handle,
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
+		 bool pairwise, const u8 *mac_addr, u8 flag),
+	TP_ARGS(wiphy, netdev, key_index, pairwise, mac_addr, flag),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(mac_addr)
+		__field(u8, key_index)
+		__field(bool, pairwise)
+		__field(u8, flag)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(mac_addr, mac_addr);
+		__entry->key_index = key_index;
+		__entry->pairwise = pairwise;
+		__entry->flag = flag;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", key_index: %u, flag: %u, "
+		  "pairwise: %s, mac addr: " MAC_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->key_index,
+		  __entry->flag, BOOL_TO_STR(__entry->pairwise),
+		  MAC_PR_ARG(mac_addr))
 );
 
 TRACE_EVENT(rdev_set_default_key,
diff --git a/net/wireless/util.c b/net/wireless/util.c
index ef14d80ca03e..3f2d116b8557 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -236,13 +236,14 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 	case WLAN_CIPHER_SUITE_CCMP_256:
 	case WLAN_CIPHER_SUITE_GCMP:
 	case WLAN_CIPHER_SUITE_GCMP_256:
-		/* Disallow pairwise keys with non-zero index unless it's WEP
+		/* IEEE802.11-2016 allows only 0 and 1 for pairwise keys.
+		 * Disallow pairwise keys with index above 1 unless it's WEP
 		 * or a vendor specific cipher (because current deployments use
-		 * pairwise WEP keys with non-zero indices and for vendor
+		 * pairwise WEP keys with higher indices and for vendor
 		 * specific ciphers this should be validated in the driver or
-		 * hardware level - but 802.11i clearly specifies to use zero)
+		 * hardware level.
 		 */
-		if (pairwise && key_idx)
+		if (pairwise && key_idx > 1)
 			return -EINVAL;
 		break;
 	case WLAN_CIPHER_SUITE_AES_CMAC:
-- 
2.19.1

