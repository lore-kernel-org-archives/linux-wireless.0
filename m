Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855EAC10F05
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 09:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C4BD20856
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 09:29:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kL9Cszb5";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="C1SoYI66"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731023AbfCZJ3n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 05:29:43 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49560 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730918AbfCZJ3m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 05:29:42 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4845E60FEA; Tue, 26 Mar 2019 09:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553592581;
        bh=e+WnEEjYsOvbE+Hv7fKqs18EL+i8xV45k63wkSLTbHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kL9Cszb5DN/C33mR1Q46X1m48qCaRWdFbuPaqMspa0+iVKKcvVoRUHwf3YV25sIN8
         /w/9kp5sJ3lC+OxWf7QY4jBd66yZh3lVUPBLoX8okpiUzvReCkaG4K4jsIKvAdqAwT
         IX4Np9Q5wk4okYcmdeiTZGoDDy8YlL2x6H+3YCdQ=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F3C5E60E59;
        Tue, 26 Mar 2019 09:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553592580;
        bh=e+WnEEjYsOvbE+Hv7fKqs18EL+i8xV45k63wkSLTbHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C1SoYI661KXu9r4sEoW68nu93KSadCsVBGpngfGB8whxRhLkER807+VjxvObkuyW4
         Nlaov1ev17MbyTsSravTtfskWh2Md4uMksp12vqp1LuY7f+DSOPExiUe7EWov+3fXA
         9H+o/tMXe7RkW7enP4zAx956cObu8HhM4Cjhy1Hc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F3C5E60E59
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv5 3/9] nl80211: Add netlink attribute for AMPDU aggregation enable/disable
Date:   Tue, 26 Mar 2019 14:59:04 +0530
Message-Id: <1553592550-15282-4-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1553592550-15282-1-git-send-email-tamizhr@codeaurora.org>
References: <1553592550-15282-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce NL80211_ATTR_TID_CONFIG_AMPDU_CTRL in nl80211_attr_tid_config
to accept TID specific AMPDU aggregation enable/disable configuration
through NL80211_CMD_SET_TID_CONFIG command. TID for which the
aggregation control configuration is to be applied is passed in
NL80211_ATTR_TID_CONFIG_TID attribute. When the user-space wants this
configuration peer specific rather than being applied for all the
connected stations, MAC address of the peer can be passed in
NL80211_ATTR_MAC attribute.

Driver supporting this feature should advertise
NL80211_EXT_FEATURE_PER_TID_AMPDU_CTRL and supporting per-STA data TID
ampdu configuration should advertise NL80211_EXT_FEATURE_PER_STA_AMPDU_CTRL.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/cfg80211.h       |    3 +++
 include/uapi/linux/nl80211.h |   22 ++++++++++++++++++++++
 net/wireless/nl80211.c       |   15 +++++++++++++++
 3 files changed, 40 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 888de00..aa0f44c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -512,6 +512,7 @@ struct cfg80211_chan_def {
 enum ieee80211_tid_conf_mask {
 	IEEE80211_TID_CONF_NOACK	= BIT(0),
 	IEEE80211_TID_CONF_RETRY	= BIT(1),
+	IEEE80211_TID_CONF_AMPDU	= BIT(2),
 };
 
 /**
@@ -522,6 +523,7 @@ enum ieee80211_tid_conf_mask {
  * @noack: noack configuration value for the TID
  * @retry_long: retry count value
  * @retry_short: retry count value
+ * @ampdu: Enable/Disable aggregation
  */
 struct ieee80211_tid_cfg {
 	u8 tid;
@@ -529,6 +531,7 @@ struct ieee80211_tid_cfg {
 	u8 noack;
 	int retry_long;
 	int retry_short;
+	u8 ampdu;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f2ce845..f94651d 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4615,6 +4615,21 @@ enum nl80211_tid_config {
  *	the max value should be advertised by the driver through
  *	max_data_retry_count. when this attribute is not present, the driver
  *	would use the default configuration.
+ * @NL80211_ATTR_TID_CONFIG_AMPDU_CTRL: Enable/Disable aggregation for the TID
+ *	specified in %%NL80211_ATTR_TID_CONFIG_TID. Its type is u8,
+ *	if the peer MAC address	is passed in %NL80211_ATTR_MAC, the aggregation
+ *	configuration is applied
+ *	to the data frame for the tid to that connected station.
+ *	Station specific aggregation configuration is valid only for STA's
+ *	current connection. i.e. the configuration will be reset to default when
+ *	the station connects back after disconnection/roaming.
+ *	when user-space does not include %NL80211_ATTR_MAC, this configuration
+ *	should be treated as per-netdev configuration. This configuration will
+ *	be cleared when the interface goes down and on the disconnection from a
+ *	BSS. Driver supporting this feature should advertise
+ *	NL80211_EXT_FEATURE_PER_TID_AMPDU_CTRL and supporting per station
+ *	aggregation configuration should advertise
+ *	NL80211_EXT_FEATURE_PER_STA_AMPDU_CTRL.
  */
 enum nl80211_attr_tid_config {
 	__NL80211_ATTR_TID_INVALID,
@@ -4623,6 +4638,7 @@ enum nl80211_attr_tid_config {
 	NL80211_ATTR_TID_CONFIG_RETRY,
 	NL80211_ATTR_TID_CONFIG_RETRY_SHORT,
 	NL80211_ATTR_TID_CONFIG_RETRY_LONG,
+	NL80211_ATTR_TID_CONFIG_AMPDU_CTRL,
 
 	/* keep last */
 	__NL80211_ATTR_TID_CONFIG_AFTER_LAST,
@@ -5437,6 +5453,10 @@ enum nl80211_feature_flags {
  *	count functionality.
  * @NL80211_EXT_FEATURE_PER_STA_RETRY_CONFIG: Driver supports STA specific
  *	data retry count functionality.
+ * @NL80211_EXT_FEATURE_PER_TID_AMPDU_CTRL: Driver supports TID specific
+ *	aggregation control(enable/disable).
+ * @NL80211_EXT_FEATURE_PER_STA_AMPDU_CTRL: Driver supports per STA
+ *	specific TID aggregation control(enable/disable).
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5483,6 +5503,8 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_PER_STA_NOACK_CONFIG,
 	NL80211_EXT_FEATURE_PER_TID_RETRY_CONFIG,
 	NL80211_EXT_FEATURE_PER_STA_RETRY_CONFIG,
+	NL80211_EXT_FEATURE_PER_TID_AMPDU_CTRL,
+	NL80211_EXT_FEATURE_PER_STA_AMPDU_CTRL,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e2a4eb2..fb2bb01 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -288,6 +288,8 @@ static int validate_ie_attr(const struct nlattr *attr,
 	[NL80211_ATTR_TID_CONFIG_RETRY] = { .type = NLA_FLAG },
 	[NL80211_ATTR_TID_CONFIG_RETRY_SHORT] = NLA_POLICY_MIN(NLA_U8, 1),
 	[NL80211_ATTR_TID_CONFIG_RETRY_LONG] = NLA_POLICY_MIN(NLA_U8, 1),
+	[NL80211_ATTR_TID_CONFIG_AMPDU_CTRL] =
+			NLA_POLICY_MAX(NLA_U8, NL80211_TID_CONFIG_DISABLE),
 };
 
 const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
@@ -13322,6 +13324,19 @@ static int parse_tid_conf(struct cfg80211_registered_device *rdev,
 		}
 	}
 
+	if (attrs[NL80211_ATTR_TID_CONFIG_AMPDU_CTRL]) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+				NL80211_EXT_FEATURE_PER_TID_AMPDU_CTRL))
+			return -ENOTSUPP;
+
+		if (peer && !wiphy_ext_feature_isset(&rdev->wiphy,
+				NL80211_EXT_FEATURE_PER_STA_AMPDU_CTRL))
+			return -ENOTSUPP;
+
+		tid_conf->tid_conf_mask |= IEEE80211_TID_CONF_AMPDU;
+		tid_conf->ampdu =
+			nla_get_u8(attrs[NL80211_ATTR_TID_CONFIG_AMPDU_CTRL]);
+	}
 	return 0;
 }
 
-- 
1.7.9.5

