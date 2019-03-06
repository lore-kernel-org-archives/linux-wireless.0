Return-Path: <SRS0=PZxT=RJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E776C43381
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 18:03:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0B3E20652
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 18:03:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Nhc8jRt9";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jsRCobnc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730673AbfCFSDL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Mar 2019 13:03:11 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:53604 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730665AbfCFSDK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Mar 2019 13:03:10 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3CC166115A; Wed,  6 Mar 2019 18:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551895389;
        bh=qQculH44J7VJfXMCAF9pmx7Qr/+gIlYijWPdOm7EvUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nhc8jRt9JNhIstRLp0u0TyLGzvznJz35f0SBncctF6RxfWwW9OWwGkIAuNh7i73+n
         NZswwQpdFYevCxOFV+6qYQU6MG6/Zm7vlZ1Jny/90ODmedPJRYVaR33JvP2WH+B+qH
         zONnkctWpgnNpSkss6ayBnNoKGe6e7wRBJZH4QoQ=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 16B0260DB4;
        Wed,  6 Mar 2019 18:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551895385;
        bh=qQculH44J7VJfXMCAF9pmx7Qr/+gIlYijWPdOm7EvUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jsRCobnclbH5LwlgM0crurk9NtHL8aT1vwuykrcKPQCW0qjsCGNx5hxH8+xkCf25x
         lIdf0Vu3otQs8N6Z0nhRYhuwwRa4ZfGnIJDDWA8ggFk4Tpccz9P8vvpqw1KQ7GR1V8
         03pXYjmRRsxF+HyanF98sdsuOX6EeYJ+Zml9VdyQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 16B0260DB4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv3 5/9] nl80211: Add netlink attribute to configure TID specific tx rate
Date:   Wed,  6 Mar 2019 23:30:47 +0530
Message-Id: <1551895251-22941-6-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1551895251-22941-1-git-send-email-tamizhr@codeaurora.org>
References: <1551895251-22941-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce NL80211_ATTR_TID_CONFIG_TX_RATES in nl80211_attr_tid_config
to accept data TID specific TX bitrate configuration
through NL80211_CMD_SET_TID_CONFIG command. TID for which the
this configuration is to be applied is passed in
NL80211_ATTR_TID_CONFIG_TID attribute. TX bitrate mask values passed
in NL80211_ATTR_TX_RATES attribute and NL80211_ATTR_TID_CONFIG_TX_RATES
attribute will have types of the TX rate should be applied.
When the user-space wants this configuration peer specific
rather than being applied for all the connected stations,
MAC address of the peer can be passed in NL80211_ATTR_MAC attribute.

Driver supporting this feature should advertise
NL80211_EXT_FEATURE_PER_TID_TX_BITRATE_MASK and supporting per-STA data TID
TX bitrate configuration should advertise
NL80211_EXT_FEATURE_PER_STA_TX_BITRATE_MASK.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/cfg80211.h       |  5 +++
 include/uapi/linux/nl80211.h | 39 +++++++++++++++++++
 net/wireless/nl80211.c       | 89 ++++++++++++++++++++++++++++++++++----------
 3 files changed, 113 insertions(+), 20 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 86dee3d..ebf041b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -514,6 +514,7 @@ enum ieee80211_tid_conf_mask {
 	IEEE80211_TID_CONF_RETRY	= BIT(1),
 	IEEE80211_TID_CONF_AMPDU	= BIT(2),
 	IEEE80211_TID_CONF_RTSCTS	= BIT(3),
+	IEEE80211_TID_CONF_TX_BITRATE	= BIT(4),
 };
 
 /**
@@ -526,6 +527,8 @@ enum ieee80211_tid_conf_mask {
  * @retry_short: retry count value
  * @ampdu: Enable/Disable aggregation
  * @rtscts: Enable/Disable RTS/CTS
+ * @txrate_type: TX bitrate mask type
+ * @mask: bitrate to be applied for the TID
  */
 struct ieee80211_tid_cfg {
 	u8 tid;
@@ -535,6 +538,8 @@ struct ieee80211_tid_cfg {
 	int retry_short;
 	u8 ampdu;
 	u8 rtscts;
+	enum nl80211_tx_rate_setting txrate_type;
+	struct cfg80211_bitrate_mask *mask;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 996b4d4..c8aa3ba 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4557,6 +4557,18 @@ enum nl80211_tx_power_setting {
 	NL80211_TX_POWER_FIXED,
 };
 
+/**
+ * enum nl80211_tx_rate_setting - TX rate configuration type
+ * @NL80211_TX_RATE_AUTOMATIC: automatically determine TX rate
+ * @NL80211_TX_RATE_LIMITED: limit the TX rate by the TX rate parameter
+ * @NL80211_TX_RATE_FIXED: fix TX rate to the TX rate parameter
+ */
+enum nl80211_tx_rate_setting {
+	NL80211_TX_RATE_AUTOMATIC,
+	NL80211_TX_RATE_LIMITED,
+	NL80211_TX_RATE_FIXED,
+};
+
 enum nl80211_tid_config {
 	NL80211_TID_CONFIG_DEFAULT,
 	NL80211_TID_CONFIG_ENABLE,
@@ -4645,6 +4657,25 @@ enum nl80211_tid_config {
  *	NL80211_EXT_FEATURE_PER_TID_RTSCTS_CTRL and supporting per station
  *	RTS_CTS configuration should advertise
  *	NL80211_EXT_FEATURE_PER_STA_RTSCTS_CTRL.
+ * @NL80211_ATTR_TID_CONFIG_TX_RATES: Data frame TX rate mask should be applied
+ *	with the parameters passed through %NL80211_ATTR_TX_RATES. This
+ *	configuration is per TID, TID is specified with
+ *	%NL80211_ATTR_TID_CONFIG_TID.
+ *	If the peer MAC address is passed in %NL80211_ATTR_MAC, then this
+ *	configuration is applied to the data frame for the tid to that connected
+ *	station. This attribute will be useful to notfiy the driver that what
+ *	type of txrate should be applied(%enum enum nl80211_tx_rate_setting)
+ *	for the connected station (%NL80211_ATTR_MAC),
+ *	Station specific retry configuration is valid only for STA's
+ *	current connection. i.e. the configuration will be reset to default when
+ *	the station connects back after disconnection/roaming.
+ *	when user-space does not include %NL80211_ATTR_MAC, this configuration
+ *	should be treated as per-netdev configuration. This configuration will
+ *	be cleared when the interface goes down and on the disconnection from a
+ *	BSS. Driver supporting this feature should advertise
+ *	NL80211_EXT_FEATURE_PER_TID_TX_BITRATE_MASK and supporting per station
+ *	TX bitrate configuration should advertise
+ *	NL80211_EXT_FEATURE_PER_STA_TX_BITRATE_MASK.
  */
 enum nl80211_attr_tid_config {
 	__NL80211_ATTR_TID_INVALID,
@@ -4655,6 +4686,8 @@ enum nl80211_attr_tid_config {
 	NL80211_ATTR_TID_CONFIG_RETRY_LONG,
 	NL80211_ATTR_TID_CONFIG_AMPDU_CTRL,
 	NL80211_ATTR_TID_CONFIG_RTSCTS_CTRL,
+	NL80211_ATTR_TID_CONFIG_TX_RATES_TYPE,
+	NL80211_ATTR_TID_CONFIG_TX_RATES,
 
 	/* keep last */
 	__NL80211_ATTR_TID_CONFIG_AFTER_LAST,
@@ -5477,6 +5510,10 @@ enum nl80211_feature_flags {
  *	RTS_CTS control(enable/disable).
  * @NL80211_EXT_FEATURE_PER_STA_RTSCTS_CTRL: Driver supports STA specific
  *	RTS_CTS control(enable/disable).
+ * @NL80211_EXT_FEATURE_PER_TID_TX_BITRATE_MASK: Driver supports TID specific
+ *	TX bitrate configuration.
+ * @NL80211_EXT_FEATURE_PER_STA_TX_BITRATE_MASK: Driver supports STA specific
+ *	TX bitrate configuration.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5527,6 +5564,8 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_PER_STA_AMPDU_CTRL,
 	NL80211_EXT_FEATURE_PER_TID_RTSCTS_CTRL,
 	NL80211_EXT_FEATURE_PER_STA_RTSCTS_CTRL,
+	NL80211_EXT_FEATURE_PER_TID_TX_BITRATE_MASK,
+	NL80211_EXT_FEATURE_PER_STA_TX_BITRATE_MASK,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 47bfc62..1e46778 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -280,6 +280,15 @@ static int validate_ie_attr(const struct nlattr *attr,
 		NLA_POLICY_NESTED_ARRAY(nl80211_psmr_peer_attr_policy),
 };
 
+static const struct nla_policy nl80211_txattr_policy[NL80211_TXRATE_MAX + 1] = {
+	[NL80211_TXRATE_LEGACY] = { .type = NLA_BINARY,
+				    .len = NL80211_MAX_SUPP_RATES },
+	[NL80211_TXRATE_HT] = { .type = NLA_BINARY,
+				.len = NL80211_MAX_SUPP_HT_RATES },
+	[NL80211_TXRATE_VHT] = { .len = sizeof(struct nl80211_txrate_vht)},
+	[NL80211_TXRATE_GI] = { .type = NLA_U8 },
+};
+
 static const struct nla_policy
 nl80211_attr_tid_config_policy[NL80211_ATTR_TID_CONFIG_MAX + 1] = {
 	[NL80211_ATTR_TID_CONFIG_TID] = { .type = NLA_U8 },
@@ -292,6 +301,10 @@ static int validate_ie_attr(const struct nlattr *attr,
 			NLA_POLICY_MAX(NLA_U8, NL80211_TID_CONFIG_DISABLE),
 	[NL80211_ATTR_TID_CONFIG_RTSCTS_CTRL] =
 			NLA_POLICY_MAX(NLA_U8, NL80211_TID_CONFIG_DISABLE),
+	[NL80211_ATTR_TID_CONFIG_TX_RATES_TYPE] =
+			NLA_POLICY_MAX(NLA_U8, NL80211_TX_RATE_FIXED),
+	[NL80211_ATTR_TID_CONFIG_TX_RATES] =
+			NLA_POLICY_NESTED(nl80211_txattr_policy),
 };
 
 const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
@@ -397,7 +410,8 @@ static int validate_ie_attr(const struct nlattr *attr,
 	[NL80211_ATTR_PMKID] = { .len = WLAN_PMKID_LEN },
 	[NL80211_ATTR_DURATION] = { .type = NLA_U32 },
 	[NL80211_ATTR_COOKIE] = { .type = NLA_U64 },
-	[NL80211_ATTR_TX_RATES] = { .type = NLA_NESTED },
+	[NL80211_ATTR_TX_RATES] =
+			NLA_POLICY_NESTED(nl80211_txattr_policy),
 	[NL80211_ATTR_FRAME] = { .type = NLA_BINARY,
 				 .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_FRAME_MATCH] = { .type = NLA_BINARY, },
@@ -4014,20 +4028,12 @@ static bool vht_set_mcs_mask(struct ieee80211_supported_band *sband,
 	return true;
 }
 
-static const struct nla_policy nl80211_txattr_policy[NL80211_TXRATE_MAX + 1] = {
-	[NL80211_TXRATE_LEGACY] = { .type = NLA_BINARY,
-				    .len = NL80211_MAX_SUPP_RATES },
-	[NL80211_TXRATE_HT] = { .type = NLA_BINARY,
-				.len = NL80211_MAX_SUPP_HT_RATES },
-	[NL80211_TXRATE_VHT] = { .len = sizeof(struct nl80211_txrate_vht)},
-	[NL80211_TXRATE_GI] = { .type = NLA_U8 },
-};
-
-static int nl80211_parse_tx_bitrate_mask(struct genl_info *info,
+static int nl80211_parse_tx_bitrate_mask(struct nlattr *attrs[],
+					 struct cfg80211_registered_device *rdev,
+					 enum nl80211_attrs attr,
 					 struct cfg80211_bitrate_mask *mask)
 {
 	struct nlattr *tb[NL80211_TXRATE_MAX + 1];
-	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	int rem, i;
 	struct nlattr *tx_rates;
 	struct ieee80211_supported_band *sband;
@@ -4054,14 +4060,14 @@ static int nl80211_parse_tx_bitrate_mask(struct genl_info *info,
 	}
 
 	/* if no rates are given set it back to the defaults */
-	if (!info->attrs[NL80211_ATTR_TX_RATES])
+	if (!attrs[attr])
 		goto out;
 
 	/* The nested attribute uses enum nl80211_band as the index. This maps
 	 * directly to the enum nl80211_band values used in cfg80211.
 	 */
 	BUILD_BUG_ON(NL80211_MAX_SUPP_HT_RATES > IEEE80211_HT_MCS_MASK_LEN * 8);
-	nla_for_each_nested(tx_rates, info->attrs[NL80211_ATTR_TX_RATES], rem) {
+	nla_for_each_nested(tx_rates, attrs[attr], rem) {
 		enum nl80211_band band = nla_type(tx_rates);
 		int err;
 
@@ -4071,7 +4077,7 @@ static int nl80211_parse_tx_bitrate_mask(struct genl_info *info,
 		if (sband == NULL)
 			return -EINVAL;
 		err = nla_parse_nested(tb, NL80211_TXRATE_MAX, tx_rates,
-				       nl80211_txattr_policy, info->extack);
+				       NULL, NULL);
 		if (err)
 			return err;
 		if (tb[NL80211_TXRATE_LEGACY]) {
@@ -4504,7 +4510,9 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	if (info->attrs[NL80211_ATTR_TX_RATES]) {
-		err = nl80211_parse_tx_bitrate_mask(info, &params.beacon_rate);
+		err = nl80211_parse_tx_bitrate_mask(info->attrs, rdev,
+						    NL80211_ATTR_TX_RATES,
+						    &params.beacon_rate);
 		if (err)
 			return err;
 
@@ -10110,7 +10118,8 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 	if (!rdev->ops->set_bitrate_mask)
 		return -EOPNOTSUPP;
 
-	err = nl80211_parse_tx_bitrate_mask(info, &mask);
+	err = nl80211_parse_tx_bitrate_mask(info->attrs, rdev, NL80211_ATTR_TX_RATES,
+					    &mask);
 	if (err)
 		return err;
 
@@ -10702,7 +10711,9 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (info->attrs[NL80211_ATTR_TX_RATES]) {
-		err = nl80211_parse_tx_bitrate_mask(info, &setup.beacon_rate);
+		err = nl80211_parse_tx_bitrate_mask(info->attrs, rdev,
+						    NL80211_ATTR_TX_RATES,
+						    &setup.beacon_rate);
 		if (err)
 			return err;
 
@@ -13278,8 +13289,10 @@ static int nl80211_get_ftm_responder_stats(struct sk_buff *skb,
 static int parse_tid_conf(struct cfg80211_registered_device *rdev,
 			  struct nlattr *attrs[],
 			  struct ieee80211_tid_cfg *tid_conf,
-			  const u8 *peer)
+			  struct genl_info *info, const u8 *peer)
 {
+	int ret;
+
 	tid_conf->tid = nla_get_u8(attrs[NL80211_ATTR_TID_CONFIG_TID]);
 	if (attrs[NL80211_ATTR_TID_CONFIG_NOACK]) {
 		if (!wiphy_ext_feature_isset(&rdev->wiphy,
@@ -13354,6 +13367,42 @@ static int parse_tid_conf(struct cfg80211_registered_device *rdev,
 			nla_get_u8(attrs[NL80211_ATTR_TID_CONFIG_RTSCTS_CTRL]);
 	}
 
+	if (attrs[NL80211_ATTR_TID_CONFIG_TX_RATES_TYPE]) {
+		int idx;
+		enum nl80211_attrs attr;
+
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+				NL80211_EXT_FEATURE_PER_TID_TX_BITRATE_MASK))
+			return -EOPNOTSUPP;
+
+		if (peer &&
+		    !wiphy_ext_feature_isset(&rdev->wiphy,
+				NL80211_EXT_FEATURE_PER_STA_TX_BITRATE_MASK))
+			return -EOPNOTSUPP;
+
+		idx = NL80211_ATTR_TID_CONFIG_TX_RATES_TYPE;
+		tid_conf->txrate_type = nla_get_u8(attrs[idx]);
+
+		tid_conf->tid_conf_mask |= IEEE80211_TID_CONF_TX_BITRATE;
+		if (tid_conf->txrate_type != NL80211_TX_RATE_AUTOMATIC) {
+			tid_conf->mask =
+				kzalloc(sizeof(struct cfg80211_bitrate_mask),
+					GFP_KERNEL);
+			if (!tid_conf->mask)
+				return -ENOMEM;
+
+			attr = NL80211_ATTR_TID_CONFIG_TX_RATES;
+			ret = nl80211_parse_tx_bitrate_mask(attrs, rdev, attr,
+							    tid_conf->mask);
+			if (ret) {
+				kfree(tid_conf->mask);
+				return ret;
+			}
+		} else {
+			tid_conf->mask = NULL;
+		}
+	}
+
 	return 0;
 }
 
@@ -13405,7 +13454,7 @@ static int nl80211_set_tid_config(struct sk_buff *skb,
 			return -EINVAL;
 
 		ret = parse_tid_conf(rdev, attrs, &tid_conf->tid_conf[conf_idx],
-				     tid_conf->peer);
+				     info, tid_conf->peer);
 		if (ret)
 			goto bad_tid_conf;
 
-- 
1.9.1

