Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18023C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 11:23:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF7DE2054F
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 11:23:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ckgEzAoM";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="g1skfe77"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfAQLXD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 06:23:03 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38680 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbfAQLXC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 06:23:02 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6EC1260388; Thu, 17 Jan 2019 11:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547724181;
        bh=40bjy7KePq/+yi8rumoloWk2emEzyX5kUMKxteTE6wM=;
        h=From:To:Cc:Subject:Date:From;
        b=ckgEzAoMs3cYupP5iQQ8Z7Xpz+Z+OIS2y/6d/C+x/LkaMa65MB6uP9PhDpgcTyzJm
         sFSWXoh89PXBcv4ejmHK0f+q1TFtQh/fwjdl2XQNxXXz+7qqd8NZVZ/vxCDLPXYRPg
         kkvPjNgFT9Nc/xfFz0MLiwZstrTkmr7g2VBZiTFU=
Received: from checstex0244823-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bpothuno@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F3DD6601D3;
        Thu, 17 Jan 2019 11:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547724180;
        bh=40bjy7KePq/+yi8rumoloWk2emEzyX5kUMKxteTE6wM=;
        h=From:To:Cc:Subject:Date:From;
        b=g1skfe7734XzzF5Qp5VeE/dlSNiS3JHt+FaehVB9d3VjgKNTRRjhNk2Q3gXS9NHic
         hG19na79Bk7m0bfuF9VjMcmz8nGAPvGHW1Zfx3Meh4V4o7NuJouHiU1Q/jUniFYh3H
         P7pbHtIEfjwGag9iVRx/WJ9m5heTUFuw0aTq8sto=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F3DD6601D3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=bpothuno@codeaurora.org
From:   Balaji Pothunoori <bpothuno@codeaurora.org>
To:     johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Ashok Raj Nagarajan <arnagara@codeaurora.org>,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: [PATCH 1/3] cfg80211: Add support to set tx power for a station associated
Date:   Thu, 17 Jan 2019 16:52:47 +0530
Message-Id: <1547724167-11420-1-git-send-email-bpothuno@codeaurora.org>
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
power level, with the level defined in mBm format.

Co-developed-by: Balaji Pothunoori <bpothuno@codeaurora.org>
Signed-off-by: Ashok Raj Nagarajan <arnagara@codeaurora.org>
Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
---
 include/net/cfg80211.h       | 12 ++++++++++++
 include/uapi/linux/nl80211.h | 14 ++++++++++++++
 net/wireless/nl80211.c       | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ede7fcd..592f564 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -958,6 +958,7 @@ enum station_parameters_apply_mask {
 	STATION_PARAM_APPLY_UAPSD = BIT(0),
 	STATION_PARAM_APPLY_CAPABILITY = BIT(1),
 	STATION_PARAM_APPLY_PLINK_STATE = BIT(2),
+	STATION_PARAM_APPLY_STA_TXPOWER = BIT(3),
 };
 
 /**
@@ -1001,6 +1002,15 @@ enum station_parameters_apply_mask {
  * @support_p2p_ps: information if station supports P2P PS mechanism
  * @he_capa: HE capabilities of station
  * @he_capa_len: the length of the HE capabilities
+ * @txpwr: tx power (in mBm) to be used for sending data traffic. If tx power
+ *	is not provided, the default per-interface tx power setting will be
+ *	overriding. Driver should be picking up the lowest tx power, either tx
+ *	power per-interface or per-station.
+ * @type: In particular if TPC %type is NL80211_TX_POWER_LIMITED then txpwr will
+ *	be less than or equal to specified from userspace, whereas if TPC %type
+ *	is NL80211_TX_POWER_AUTOMATIC then it indicates default txpwr.
+ *	NL80211_TX_POWER_FIXED is not a valid configuration option for
+ *	per peer TPC.
  */
 struct station_parameters {
 	const u8 *supported_rates;
@@ -1030,6 +1040,8 @@ struct station_parameters {
 	int support_p2p_ps;
 	const struct ieee80211_he_cap_elem *he_capa;
 	u8 he_capa_len;
+	s16 txpwr;
+	enum nl80211_tx_power_setting type;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 2b53c0e..09c9e14 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2292,6 +2292,15 @@ enum nl80211_commands {
  *	This is also used for capability advertisement in the wiphy information,
  *	with the appropriate sub-attributes.
  *
+ * @NL80211_ATTR_STA_TX_POWER_SETTING: Transmit power setting type (u8) for
+ *	station associated with the AP. See &enum nl80211_tx_power_setting for
+ *	possible values.
+ * @NL80211_ATTR_STA_TX_POWER: Transmit power level (s16) in mBm units. This
+ *	allows to set Tx power for a station. If this attribute is not included,
+ *	the default per-interface tx power setting will be overriding. Driver
+ *	should be picking up the lowest tx power, either tx power per-interface
+ *	or per-station.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2740,6 +2749,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_TIMEOUT,
 
 	NL80211_ATTR_PEER_MEASUREMENTS,
+	NL80211_ATTR_STA_TX_POWER_SETTING,
+	NL80211_ATTR_STA_TX_POWER,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -5308,6 +5319,8 @@ enum nl80211_feature_flags {
  *      able to rekey an in-use key correctly. Userspace must not rekey PTK keys
  *      if this flag is not set. Ignoring this can leak clear text packets and/or
  *      freeze the connection.
+ * @NL80211_EXT_FEATURE_STA_TX_PWR: This driver supports controlling tx power
+ *	to a station.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5348,6 +5361,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT,
 	NL80211_EXT_FEATURE_CAN_REPLACE_PTK0,
 	NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER,
+	NL80211_EXT_FEATURE_STA_TX_PWR,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e20329b..753ab51 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -347,6 +347,8 @@ const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 					       .len = NL80211_MAX_SUPP_RATES },
 	[NL80211_ATTR_STA_PLINK_ACTION] =
 		NLA_POLICY_MAX(NLA_U8, NUM_NL80211_PLINK_ACTIONS - 1),
+	[NL80211_ATTR_STA_TX_POWER_SETTING] = { .type = NLA_U8 },
+	[NL80211_ATTR_STA_TX_POWER] = { .type = NLA_S16 },
 	[NL80211_ATTR_STA_VLAN] = { .type = NLA_U32 },
 	[NL80211_ATTR_MNTR_FLAGS] = { /* NLA_NESTED can't be empty */ },
 	[NL80211_ATTR_MESH_ID] = { .type = NLA_BINARY,
@@ -5377,6 +5379,31 @@ static int nl80211_set_station_tdls(struct genl_info *info,
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
+		params->type = nla_get_u32(info->attrs[idx]);
+
+		if (params->type == NL80211_TX_POWER_LIMITED) {
+			idx = NL80211_ATTR_STA_TX_POWER;
+			params->txpwr = nla_get_u32(info->attrs[idx]);
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
@@ -5461,6 +5488,10 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			nla_get_u8(info->attrs[NL80211_ATTR_OPMODE_NOTIF]);
 	}
 
+	err = nl80211_parse_sta_txpower_setting(info, &params);
+	if (err)
+		return err;
+
 	/* Include parameters for TDLS peer (will check later) */
 	err = nl80211_set_station_tdls(info, &params);
 	if (err)
@@ -5589,6 +5620,10 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		params.plink_action =
 			nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_ACTION]);
 
+	err = nl80211_parse_sta_txpower_setting(info, &params);
+	if (err)
+		return err;
+
 	err = nl80211_parse_sta_channel_info(info, &params);
 	if (err)
 		return err;
-- 
2.7.4

