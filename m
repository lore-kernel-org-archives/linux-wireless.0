Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90BC7C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 06:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B56920657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 06:50:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="njrsmncw";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="A9uAWM7W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfCKGun (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 02:50:43 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54180 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfCKGun (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 02:50:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 48732602AE; Mon, 11 Mar 2019 06:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552287041;
        bh=GRk9t+9/rDFCc7uX8Wp0fU9Cv0CbTY3BLa3PEeA2Z0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=njrsmncw+fhVQID08BDo7QLW1dmkrSd1FSn4a0VRsvpQF4uD9mxYn2fAGBHQ/9Ed2
         bZ6xM6xYvoRsQQ3U71yVq46rCz+UJ/hlBazQYM2oZaPv+fsYy2l6OfU9qNn4WjyhiT
         N9HvSQFrC1pPxBywIofaLLugoj4peJeucWkwvCfw=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 829EB60ACA;
        Mon, 11 Mar 2019 06:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552287040;
        bh=GRk9t+9/rDFCc7uX8Wp0fU9Cv0CbTY3BLa3PEeA2Z0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A9uAWM7WZkAJGYm2gBfZkH7kdwnuIFqFlk4e+7toBLrhHMHq2Imn0INJGIJbTsoGT
         1Z5HJn0yYUZ1juTDUpwM+65Zj23UeHUBRgB1Cg1nvpejY+RfokkuravEhHJzoO9Eap
         6xA/VGJ5f968xOaJg5fxKcbx9RVneT/oOzLWivgI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 829EB60ACA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv4 2/9] nl80211: Add new netlink attribute for TID speicific retry count
Date:   Mon, 11 Mar 2019 12:18:14 +0530
Message-Id: <1552286901-28285-3-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1552286901-28285-1-git-send-email-tamizhr@codeaurora.org>
References: <1552286901-28285-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch introduced below NL attributes to add support for
configuring data TID specific retry count

NL80211_ATTR_TID_CONFIG_RETRY
NL80211_ATTR_TID_CONFIG_RETRY_LONG
NL80211_ATTR_TID_CONFIG_RETRY_SHORT

These attributes are added in NL80211_ATTR_TID_CONFIG nested attribute.
This will be useful for the driver which supports data TID specific retry
count configuration rather using phy level retry configuration.
This TID specific retry configuration will have more precedence than
phy level configuration. This configuration can be applied for a
specific peer. To apply this configuration specific to a peer
rather than being applied for all the connected stations,
MAC address of the peer can be passed in NL80211_ATTR_MAC attribute.

Driver should advertise WIPHY_FLAG_HAS_MAX_DATA_RETRY_COUNT and
max_data_retry_count value to notify user space to avoid of passing
greater than the allowed limit.

Driver supporting TID specific retry configuration should advertise
NL80211_EXT_FEATURE_PER_TID_RETRY_CONFIG and per STA specific
data TID retry configuration should advertise
NL80211_EXT_FEATURE_PER_STA_RETRY_CONFIG.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/cfg80211.h       |   11 ++++++++++
 include/uapi/linux/nl80211.h |   48 ++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       |   34 ++++++++++++++++++++++++++++++
 3 files changed, 93 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c606e78..888de00 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -511,6 +511,7 @@ struct cfg80211_chan_def {
 
 enum ieee80211_tid_conf_mask {
 	IEEE80211_TID_CONF_NOACK	= BIT(0),
+	IEEE80211_TID_CONF_RETRY	= BIT(1),
 };
 
 /**
@@ -519,11 +520,15 @@ enum ieee80211_tid_conf_mask {
  * @tid_conf_mask: bitmap indicating which parameter changed
  *	see %enum ieee80211_tid_conf_mask
  * @noack: noack configuration value for the TID
+ * @retry_long: retry count value
+ * @retry_short: retry count value
  */
 struct ieee80211_tid_cfg {
 	u8 tid;
 	enum ieee80211_tid_conf_mask tid_conf_mask;
 	u8 noack;
+	int retry_long;
+	int retry_short;
 };
 
 /**
@@ -3832,6 +3837,7 @@ struct cfg80211_ops {
  *	beaconing mode (AP, IBSS, Mesh, ...).
  * @WIPHY_FLAG_HAS_STATIC_WEP: The device supports static WEP key installation
  *	before connection.
+ * @WIPHY_FLAG_HAS_MAX_DATA_RETRY_COUNT: Device supports data retry count call.
  */
 enum wiphy_flags {
 	/* use hole at 0 */
@@ -3858,6 +3864,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_SUPPORTS_5_10_MHZ		= BIT(22),
 	WIPHY_FLAG_HAS_CHANNEL_SWITCH		= BIT(23),
 	WIPHY_FLAG_HAS_STATIC_WEP		= BIT(24),
+	WIPHY_FLAG_HAS_MAX_DATA_RETRY_COUNT	= BIT(25),
 };
 
 /**
@@ -4365,6 +4372,8 @@ struct cfg80211_pmsr_capabilities {
  *	@support_mbssid must be set for this to have any effect.
  *
  * @pmsr_capa: peer measurement capabilities
+ * @max_data_retry_count: Maximum limit can be configured as retry count
+ *	for a TID.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -4509,6 +4518,8 @@ struct wiphy {
 
 	const struct cfg80211_pmsr_capabilities *pmsr_capa;
 
+	u8 max_data_retry_count;
+
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c901a48..f2ce845 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2316,6 +2316,8 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_TID_CONFIG: TID specific configuration in a
  *	nested attribute with %NL80211_ATTR_TID_* sub-attributes.
+ * @NL80211_ATTR_MAX_RETRY_COUNT: The upper limit for the retry count
+ *	configuration that the driver can accept.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -2769,6 +2771,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_AIRTIME_WEIGHT,
 
 	NL80211_ATTR_TID_CONFIG,
+	NL80211_ATTR_MAX_RETRY_COUNT,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -4576,11 +4579,50 @@ enum nl80211_tid_config {
  *	advertise NL80211_EXT_FEATURE_PER_TID_NOACK_CONFIG and
  *	NL80211_EXT_FEATURE_PER_STA_NOACK_CONFIG for supporting  per sta
  *	configuration.
+ * @NL80211_ATTR_TID_CONFIG_RETRY: Data TID retry count should be applied
+ *	with the value passed through %NL80211_ATTR_TID_CONFIG_RETRY_LONG
+ *	and/or %NL80211_ATTR_TID_CONFIG_RETRY_SHORT. This configuration
+ *	is per-TID, and the TID is specified with %NL80211_ATTR_TID_CONFIG_TID.
+ *	If the peer MAC address is passed in %NL80211_ATTR_MAC, the retry
+ *	configuration is applied to the data frame for the tid to that
+ *	connected station.
+ *	This attribute will be useful to notfiy the driver to apply default
+ *	retry values for the connected station (%NL80211_ATTR_MAC), when the
+ *	command received without %NL80211_ATTR_RETRY_LONG and/or
+ *	%NL80211_ATTR_RETRY_SHORT.
+ *	Station specific retry configuration is valid only for STA's
+ *	current connection. i.e. the configuration will be reset to default when
+ *	the station connects back after disconnection/roaming.
+ *	when user-space does not include %NL80211_ATTR_MAC, this configuration
+ *	should be treated as per-netdev configuration. This configuration will
+ *	be cleared when the interface goes down and on the disconnection from a
+ *	BSS. When retry count has never been configured using this command, the
+ *	other available radio level retry configuration
+ *	(%NL80211_ATTR_WIPHY_RETRY_SHORT and %NL80211_ATTR_WIPHY_RETRY_LONG)
+ *	should be used. Driver supporting this feature should advertise
+ *	NL80211_EXT_FEATURE_PER_TID_RETRY_CONFIG and supporting per station
+ *	retry count configuration should advertise
+ *	NL80211_EXT_FEATURE_PER_STA_RETRY_CONFIG.
+ * @NL80211_ATTR_TID_CONFIG_RETRY_SHORT: Number of retries used with data frame
+ *	transmission, user-space sets this configuration in
+ *	&NL80211_CMD_SET_TID_CONFIG. It is u8 type, min value is 1 and
+ *	the max value should be advertised by the driver through
+ *	max_data_retry_count. when this attribute is not present, the driver
+ *	would use the default configuration.
+ * @NL80211_ATTR_TID_CONFIG_RETRY_LONG: Number of retries used with data frame
+ *	transmission, user-space sets this configuration in
+ *	&NL80211_CMD_SET_TID_CONFIG. Its type is u8, min value is 1 and
+ *	the max value should be advertised by the driver through
+ *	max_data_retry_count. when this attribute is not present, the driver
+ *	would use the default configuration.
  */
 enum nl80211_attr_tid_config {
 	__NL80211_ATTR_TID_INVALID,
 	NL80211_ATTR_TID_CONFIG_TID,
 	NL80211_ATTR_TID_CONFIG_NOACK,
+	NL80211_ATTR_TID_CONFIG_RETRY,
+	NL80211_ATTR_TID_CONFIG_RETRY_SHORT,
+	NL80211_ATTR_TID_CONFIG_RETRY_LONG,
 
 	/* keep last */
 	__NL80211_ATTR_TID_CONFIG_AFTER_LAST,
@@ -5391,6 +5433,10 @@ enum nl80211_feature_flags {
  *	policy functionality.
  * @NL80211_EXT_FEATURE_PER_STA_NOACK_CONFIG: Driver supports STA specific NoAck
  *	policy functionality.
+ * @NL80211_EXT_FEATURE_PER_TID_RETRY_CONFIG: Driver supports per TID data retry
+ *	count functionality.
+ * @NL80211_EXT_FEATURE_PER_STA_RETRY_CONFIG: Driver supports STA specific
+ *	data retry count functionality.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5435,6 +5481,8 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_AP_PMKSA_CACHING,
 	NL80211_EXT_FEATURE_PER_TID_NOACK_CONFIG,
 	NL80211_EXT_FEATURE_PER_STA_NOACK_CONFIG,
+	NL80211_EXT_FEATURE_PER_TID_RETRY_CONFIG,
+	NL80211_EXT_FEATURE_PER_STA_RETRY_CONFIG,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f0e44ee..d53eb40 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -285,6 +285,9 @@ static int validate_ie_attr(const struct nlattr *attr,
 	[NL80211_ATTR_TID_CONFIG_TID] = { .type = NLA_U8 },
 	[NL80211_ATTR_TID_CONFIG_NOACK] =
 			NLA_POLICY_MAX(NLA_U8, NL80211_TID_CONFIG_DISABLE),
+	[NL80211_ATTR_TID_CONFIG_RETRY] = { .type = NLA_FLAG },
+	[NL80211_ATTR_TID_CONFIG_RETRY_SHORT] = NLA_POLICY_MIN(NLA_U8, 1),
+	[NL80211_ATTR_TID_CONFIG_RETRY_LONG] = NLA_POLICY_MIN(NLA_U8, 1),
 };
 
 const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
@@ -13288,6 +13291,37 @@ static int parse_tid_conf(struct cfg80211_registered_device *rdev,
 			nla_get_u8(attrs[NL80211_ATTR_TID_CONFIG_NOACK]);
 	}
 
+	if (nla_get_flag(attrs[NL80211_ATTR_TID_CONFIG_RETRY])) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+				NL80211_EXT_FEATURE_PER_TID_RETRY_CONFIG))
+			return -ENOTSUPP;
+
+		if (peer && !wiphy_ext_feature_isset(&rdev->wiphy,
+				NL80211_EXT_FEATURE_PER_STA_RETRY_CONFIG))
+			return -ENOTSUPP;
+
+		tid_conf->tid_conf_mask |= IEEE80211_TID_CONF_RETRY;
+		if (attrs[NL80211_ATTR_TID_CONFIG_RETRY_SHORT]) {
+			tid_conf->retry_short =
+			nla_get_u8(attrs[NL80211_ATTR_TID_CONFIG_RETRY_SHORT]);
+			if (tid_conf->retry_short >
+					rdev->wiphy.max_data_retry_count)
+				return -EINVAL;
+		} else {
+			tid_conf->retry_short = -1;
+		}
+
+		if (attrs[NL80211_ATTR_TID_CONFIG_RETRY_LONG]) {
+			tid_conf->retry_long =
+			nla_get_u8(attrs[NL80211_ATTR_TID_CONFIG_RETRY_LONG]);
+			if (tid_conf->retry_long >
+					rdev->wiphy.max_data_retry_count)
+				return -EINVAL;
+		} else {
+			tid_conf->retry_long = -1;
+		}
+	}
+
 	return 0;
 }
 
-- 
1.7.9.5

