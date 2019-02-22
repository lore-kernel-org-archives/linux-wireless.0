Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 710C3C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 06:33:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FB9C20818
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 06:33:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HjM2Qb9z";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LpIHaP7z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbfBVGdf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 01:33:35 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:55036 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfBVGdf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 01:33:35 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 84FB7608CB; Fri, 22 Feb 2019 06:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550817214;
        bh=lgj6uAIEgZj5+U0kIsUF2wZGq5jH2Q4ilOC3Z9Hd7w0=;
        h=From:To:Cc:Subject:Date:From;
        b=HjM2Qb9zbpRysItpmHUq3bjg6THlkq/C2UMf1WDHGobOYTysdI8LeMVLWgzDZLc/B
         ZWFwawDJ68SBMVS354Mw7xQd6QFW1Bu07NYVbaAE3w60zVmxrXoWjxTuKQX1k8la44
         rA2pMINdhQdZwLFNBqMctd2+qY1P2clZhSHrvbAA=
Received: from checstex0244823-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bpothuno@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ABB566079B;
        Fri, 22 Feb 2019 06:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550817213;
        bh=lgj6uAIEgZj5+U0kIsUF2wZGq5jH2Q4ilOC3Z9Hd7w0=;
        h=From:To:Cc:Subject:Date:From;
        b=LpIHaP7zvZHUq9UYGo8bgIIERlNWsrJHbU0TdL7JqWTsHa9B04DUrb/IMDyTEAzNZ
         v6aiwVoD7Olb+PuEfEfVmtMhUiVkNCbpIFtD9n4mRTMokEkDRA5M5yLDOcC6b64Zop
         FESFA2KoLaYVQyDRbTfunk/OQXw3g8xcDa1crCT4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org ABB566079B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=bpothuno@codeaurora.org
From:   Balaji Pothunoori <bpothuno@codeaurora.org>
To:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc:     ath10k@lists.infradead.org,
        Ashok Raj Nagarajan <arnagara@codeaurora.org>,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: [PATCH v3 1/3] cfg80211: Add support to set tx power for a station associated
Date:   Fri, 22 Feb 2019 12:03:23 +0530
Message-Id: <1550817203-18516-1-git-send-email-bpothuno@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ashok Raj Nagarajan <arnagara@codeaurora.org>

This patch adds support to set transmit power setting type and transmit
power level attributes to NL80211_CMD_SET_STATION in order to facilitate
adjusting the transmit power level of a station associated to the AP.

The added attributes allow selection of automatic and limited transmit
power level, with the level defined in dBm format.

Co-developed-by: Balaji Pothunoori <bpothuno@codeaurora.org>
Signed-off-by: Ashok Raj Nagarajan <arnagara@codeaurora.org>
Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
---
 v2: add txpwr structure
    replaced nla_get_u32 with nla_get_u8/s16
    added NLA_POLICY_RANGE check
 v3: updated kernel-doc for sta_txpwr
     structure and rebased

 include/net/cfg80211.h       | 22 ++++++++++++++++++++++
 include/uapi/linux/nl80211.h | 14 ++++++++++++++
 net/wireless/nl80211.c       | 38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 74 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f81677f..410867a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -973,6 +973,27 @@ enum station_parameters_apply_mask {
 	STATION_PARAM_APPLY_UAPSD = BIT(0),
 	STATION_PARAM_APPLY_CAPABILITY = BIT(1),
 	STATION_PARAM_APPLY_PLINK_STATE = BIT(2),
+	STATION_PARAM_APPLY_STA_TXPOWER = BIT(3),
+};
+
+/**
+ * struct sta_txpwr - station txpower configuration
+ *
+ * Used to configure txpower for station.
+ *
+ * @power: tx power (in dBm) to be used for sending data traffic. If tx power
+ *	is not provided, the default per-interface tx power setting will be
+ *	overriding. Driver should be picking up the lowest tx power, either tx
+ *	power per-interface or per-station.
+ * @type: In particular if TPC %type is NL80211_TX_POWER_LIMITED then tx power
+ *	will be less than or equal to specified from userspace, whereas if TPC
+ *	%type is NL80211_TX_POWER_AUTOMATIC then it indicates default tx power.
+ *	NL80211_TX_POWER_FIXED is not a valid configuration option for
+ *	per peer TPC.
+ */
+struct sta_txpwr {
+	s16 power;
+	enum nl80211_tx_power_setting type;
 };
 
 /**
@@ -1047,6 +1068,7 @@ struct station_parameters {
 	const struct ieee80211_he_cap_elem *he_capa;
 	u8 he_capa_len;
 	u16 airtime_weight;
+	struct sta_txpwr txpwr;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index dd4f86e..83040c6 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2308,6 +2308,15 @@ enum nl80211_commands {
  * @NL80211_ATTR_AIRTIME_WEIGHT: Station's weight when scheduled by the airtime
  *	scheduler.
  *
+ * @NL80211_ATTR_STA_TX_POWER_SETTING: Transmit power setting type (u8) for
+ *	station associated with the AP. See &enum nl80211_tx_power_setting for
+ *	possible values.
+ * @NL80211_ATTR_STA_TX_POWER: Transmit power level (s16) in dBm units. This
+ *	allows to set Tx power for a station. If this attribute is not included,
+ *	the default per-interface tx power setting will be overriding. Driver
+ *	should be picking up the lowest tx power, either tx power per-interface
+ *	or per-station.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2758,6 +2767,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_PEER_MEASUREMENTS,
 
 	NL80211_ATTR_AIRTIME_WEIGHT,
+	NL80211_ATTR_STA_TX_POWER_SETTING,
+	NL80211_ATTR_STA_TX_POWER,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -5343,6 +5354,8 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_AP_PMKSA_CACHING: Driver/device supports PMKSA caching
  *	(set/del PMKSA operations) in AP mode.
  *
+ * @NL80211_EXT_FEATURE_STA_TX_PWR: This driver supports controlling tx power
+ 8	to a station.
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
@@ -5384,6 +5397,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER,
 	NL80211_EXT_FEATURE_AIRTIME_FAIRNESS,
 	NL80211_EXT_FEATURE_AP_PMKSA_CACHING,
+	NL80211_EXT_FEATURE_STA_TX_PWR,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 80878b4..f7bf282 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -331,6 +331,11 @@ const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 					       .len = NL80211_MAX_SUPP_RATES },
 	[NL80211_ATTR_STA_PLINK_ACTION] =
 		NLA_POLICY_MAX(NLA_U8, NUM_NL80211_PLINK_ACTIONS - 1),
+	[NL80211_ATTR_STA_TX_POWER_SETTING] =
+		NLA_POLICY_RANGE(NLA_U8,
+				 NL80211_TX_POWER_AUTOMATIC,
+				 NL80211_TX_POWER_FIXED),
+	[NL80211_ATTR_STA_TX_POWER] = { .type = NLA_S16 },
 	[NL80211_ATTR_STA_VLAN] = { .type = NLA_U32 },
 	[NL80211_ATTR_MNTR_FLAGS] = { /* NLA_NESTED can't be empty */ },
 	[NL80211_ATTR_MESH_ID] = { .type = NLA_BINARY,
@@ -5387,6 +5392,31 @@ static int nl80211_set_station_tdls(struct genl_info *info,
 	return nl80211_parse_sta_wme(info, params);
 }
 
+static int nl80211_parse_sta_txpower_setting(struct genl_info *info,
+					     struct station_parameters *params)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	int idx;
+
+	if (info->attrs[NL80211_ATTR_STA_TX_POWER_SETTING]) {
+		if (!rdev->ops->set_tx_power ||
+		    !wiphy_ext_feature_isset(&rdev->wiphy,
+					 NL80211_EXT_FEATURE_STA_TX_PWR))
+			return -EOPNOTSUPP;
+
+		idx = NL80211_ATTR_STA_TX_POWER_SETTING;
+		params->txpwr.type = nla_get_u8(info->attrs[idx]);
+
+		if (params->txpwr.type == NL80211_TX_POWER_LIMITED) {
+			idx = NL80211_ATTR_STA_TX_POWER;
+			params->txpwr.power = nla_get_s16(info->attrs[idx]);
+		}
+		params->sta_modify_mask |= STATION_PARAM_APPLY_STA_TXPOWER;
+	}
+
+	return 0;
+}
+
 static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -5480,6 +5510,10 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 				     NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
 		return -EOPNOTSUPP;
 
+	err = nl80211_parse_sta_txpower_setting(info, &params);
+	if (err)
+		return err;
+
 	/* Include parameters for TDLS peer (will check later) */
 	err = nl80211_set_station_tdls(info, &params);
 	if (err)
@@ -5617,6 +5651,10 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 				     NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
 		return -EOPNOTSUPP;
 
+	err = nl80211_parse_sta_txpower_setting(info, &params);
+	if (err)
+		return err;
+
 	err = nl80211_parse_sta_channel_info(info, &params);
 	if (err)
 		return err;
-- 
2.7.4

