Return-Path: <SRS0=PZxT=RJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0984FC10F0C
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 18:03:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D454C20684
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 18:03:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bIAFcEqC";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="oz0nJLgD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730572AbfCFSDF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Mar 2019 13:03:05 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:53058 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfCFSDE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Mar 2019 13:03:04 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D783660364; Wed,  6 Mar 2019 18:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551895383;
        bh=P1IFHATdPlrhrY4ZCHMwRUU2NAm925fTWCUQXee9JDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIAFcEqC7fXNXMwwIndWInR1ZKl6yALgrPUMZVFbbHg1Bw94Zn2YDaGYwGYfFyWmC
         fm/J9atA5wkWrNFF3aciDSoZDVxb90mAQGlxc7bB6DdK21rivqJG/ZWpYMX4tAID2J
         15Wf7xaYm7EXii/MhXNBc3YWVct0oWNIAePhKIiI=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E210D60ACE;
        Wed,  6 Mar 2019 18:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551895381;
        bh=P1IFHATdPlrhrY4ZCHMwRUU2NAm925fTWCUQXee9JDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oz0nJLgD7NPPzAmr/5oO4bvW1XUuDIv0OA7r9Hzl059uT0Z/2gYyJUDuSzmaglyk6
         RnMislrzKBn47nuOkfxDUQllM4mRGaqIikYDWrqCh5gqks3IGfFAb+UlcQO9WKqkOW
         cOo1dUYPbGGgAJePW1A+OEb6WSj0eo+7OJB9YFp4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E210D60ACE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv3 3/9] nl80211: Add netlink attribute for AMPDU aggregation enable/disable
Date:   Wed,  6 Mar 2019 23:30:45 +0530
Message-Id: <1551895251-22941-4-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1551895251-22941-1-git-send-email-tamizhr@codeaurora.org>
References: <1551895251-22941-1-git-send-email-tamizhr@codeaurora.org>
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
 include/net/cfg80211.h       |  3 +++
 include/uapi/linux/nl80211.h | 22 ++++++++++++++++++++++
 net/wireless/nl80211.c       | 15 +++++++++++++++
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
index d53eb40..1a001d0 100644
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
1.9.1

