Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FFE1C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 05:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33096207E0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 05:34:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JGVfromD";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BGdZeacz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbfBVFea (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 00:34:30 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:48852 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfBVFea (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 00:34:30 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D5E3F609FD; Fri, 22 Feb 2019 05:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550813668;
        bh=xpefMl2e8xaNfF5sJZ+m1eo7cDeBRiJIERfGoh5dfv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGVfromDLiSj5QdIsxEm5GL8pyHSh/pi+evFv0DKPrMRIYAnga0zftrGpjK0t2DXN
         FlU3c5qHMMRLHVAEagJilaMhedHthdHMajXsdsTjT7aZZmYbbJGH8cA+mPQVYPhIMN
         z8D5x8YY6X76sb+V2WbX5qxRjIHu3JC2qlAl/TiY=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2AB62609D4;
        Fri, 22 Feb 2019 05:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550813667;
        bh=xpefMl2e8xaNfF5sJZ+m1eo7cDeBRiJIERfGoh5dfv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGdZeaczxey7y9kWl8ZGHH/5joyCcMDIboFbYYRVbYAvHja1DtK+3dwHTKwMCny2o
         BdW1EedkkK3H6GE8CMDmwaeBW8y9ekEeaHAkZcOex6n65nvOFk+oe8+eLpqHbM7PJ4
         JqxnQtFpwKnfU0pIrZw1OYtOwEvZl2Auqs7Hmzdw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2AB62609D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv2 5/9] nl80211: Add netlink attribute to configure TID specific tx rate
Date:   Fri, 22 Feb 2019 11:02:30 +0530
Message-Id: <1550813554-11581-6-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550813554-11581-1-git-send-email-tamizhr@codeaurora.org>
References: <1550813554-11581-1-git-send-email-tamizhr@codeaurora.org>
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
NL80211_ATTR_TX_RATES attribute can hold single value at a time, so the
TX bitrate configuration can be set one TID at a time.

Driver supporting this feature should advertise
NL80211_EXT_FEATURE_PER_TID_TX_BITRATE_MASK and supporting per-STA data TID
TX bitrate configuration should advertise
NL80211_EXT_FEATURE_PER_STA_TX_BITRATE_MASK.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/cfg80211.h       |  5 +++++
 include/uapi/linux/nl80211.h | 38 ++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       | 41 +++++++++++++++++++++++++++++++++++++++--
 3 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index cf4a3f0..713de1e 100644
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
index 996b4d4..9a6f63e 100644
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
@@ -4655,6 +4686,7 @@ enum nl80211_attr_tid_config {
 	NL80211_ATTR_TID_CONFIG_RETRY_LONG,
 	NL80211_ATTR_TID_CONFIG_AMPDU_CTRL,
 	NL80211_ATTR_TID_CONFIG_RTSCTS_CTRL,
+	NL80211_ATTR_TID_CONFIG_TX_RATES,
 
 	/* keep last */
 	__NL80211_ATTR_TID_CONFIG_AFTER_LAST,
@@ -5477,6 +5509,10 @@ enum nl80211_feature_flags {
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
@@ -5527,6 +5563,8 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_PER_STA_AMPDU_CTRL,
 	NL80211_EXT_FEATURE_PER_TID_RTSCTS_CTRL,
 	NL80211_EXT_FEATURE_PER_STA_RTSCTS_CTRL,
+	NL80211_EXT_FEATURE_PER_TID_TX_BITRATE_MASK,
+	NL80211_EXT_FEATURE_PER_STA_TX_BITRATE_MASK,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cd1e1e8..25ed505 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -292,6 +292,8 @@ static int validate_ie_attr(const struct nlattr *attr,
 			NLA_POLICY_MAX(NLA_U8, NL80211_TID_CONFIG_DISABLE),
 	[NL80211_ATTR_TID_CONFIG_RTSCTS_CTRL] =
 			NLA_POLICY_MAX(NLA_U8, NL80211_TID_CONFIG_DISABLE),
+	[NL80211_ATTR_TID_CONFIG_TX_RATES] =
+			NLA_POLICY_MAX(NLA_U8, NL80211_TX_RATE_FIXED),
 };
 
 const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
@@ -13260,8 +13262,10 @@ static int nl80211_get_ftm_responder_stats(struct sk_buff *skb,
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
@@ -13336,6 +13340,39 @@ static int parse_tid_conf(struct cfg80211_registered_device *rdev,
 			nla_get_u8(attrs[NL80211_ATTR_TID_CONFIG_RTSCTS_CTRL]);
 	}
 
+	if (attrs[NL80211_ATTR_TID_CONFIG_TX_RATES]) {
+		int idx;
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
+		idx = NL80211_ATTR_TID_CONFIG_TX_RATES;
+		tid_conf->txrate_type = nla_get_u8(attrs[idx]);
+
+		tid_conf->tid_conf_mask |= IEEE80211_TID_CONF_TX_BITRATE;
+		if (tid_conf->txrate_type != NL80211_TX_RATE_AUTOMATIC) {
+			tid_conf->mask =
+				kzalloc(sizeof(struct cfg80211_bitrate_mask),
+					GFP_KERNEL);
+			if (!tid_conf->mask)
+				return -ENOMEM;
+			ret = nl80211_parse_tx_bitrate_mask(info,
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
 
@@ -13387,7 +13424,7 @@ static int nl80211_set_tid_config(struct sk_buff *skb,
 			return -EINVAL;
 
 		ret = parse_tid_conf(rdev, attrs, &tid_conf->tid_conf[conf_idx],
-				     tid_conf->peer);
+				     info, tid_conf->peer);
 		if (ret)
 			goto bad_tid_conf;
 
-- 
1.9.1

