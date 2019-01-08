Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3968C43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 17:22:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8225E206A3
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 17:22:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ckFcwEd2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ckFcwEd2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbfAHRW6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 12:22:58 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39936 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbfAHRW6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 12:22:58 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DE12360234; Tue,  8 Jan 2019 17:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546968176;
        bh=VMIq3gugfHGRd+h/R3bm4Tt0t8ayYXubCCySLVam6ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ckFcwEd2KdtqL3szcdKlmlVoPH1DTDLI445UXjSWHanKAxUksQBeEnFY0ZSM40CG/
         WL4U/JK51O1NmkT76+czEuEn8pwUn+CBwr7+pyG3SsE7EC4DceV6ieU2YaJA0w97+G
         JSdn8jYVButpDWoxnqtOeNHx/6ZgTjSmB2ncrvag=
Received: from vamsin-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: vamsin@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5AA5960112;
        Tue,  8 Jan 2019 17:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1546968176;
        bh=VMIq3gugfHGRd+h/R3bm4Tt0t8ayYXubCCySLVam6ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ckFcwEd2KdtqL3szcdKlmlVoPH1DTDLI445UXjSWHanKAxUksQBeEnFY0ZSM40CG/
         WL4U/JK51O1NmkT76+czEuEn8pwUn+CBwr7+pyG3SsE7EC4DceV6ieU2YaJA0w97+G
         JSdn8jYVButpDWoxnqtOeNHx/6ZgTjSmB2ncrvag=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5AA5960112
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=vamsin@codeaurora.org
From:   vamsi krishna <vamsin@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, jouni@codeaurora.org,
        vamsin@codeaurora.org
Subject: [PATCH v2] nl80211/cfg80211: Add support to send tx packet specific params
Date:   Tue,  8 Jan 2019 22:52:02 +0530
Message-Id: <1546968122-4204-1-git-send-email-vamsin@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <899698ca-d8b5-45b1-5689-58096e2f0291@candelatech.com>
References: <899698ca-d8b5-45b1-5689-58096e2f0291@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add support to transmit the frames at a rate specified by userspace
when needed in NL80211_CMD_FRAME command. This commit adds support to
specify tx rate, number of retries and tx power.

Tx rate at which packet shall be transmitted can be specified in
%NL80211_ATTR_RATE_INFO, number of retries can be specified in
%NL80211_ATTR_WIPHY_RETRY_SHORT and %NL80211_ATTR_WIPHY_RETRY_LONG,
tx power can be specified in %NL80211_ATTR_WIPHY_TX_POWER_LEVEL.

The drivers shall indicate the support to send frames at rate specified
by userspace by setting %NL80211_EXT_FEATURE_CMD_FRAME_TXRATE flag in
wiphy capabilities. The userspace can specify the rate within
%NL80211_ATTR_RATE_INFO attribute while sending %NL80211_CMD_FRAME.
NL80211_ATTR_RATE_INFO is a nested attribute and encapsulates the
attributes defined in &enum nl80211_rate_info.

Signed-off-by: vamsi krishna <vamsin@codeaurora.org>

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c032375..bbaa5c3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2616,6 +2616,24 @@ struct cfg80211_update_ft_ies_params {
 };
 
 /**
+ * enum cfg80211_mgmt_tx_params_filled - Mgmt. tx params that are filled.
+ *
+ * This enum provides information on which all mgmt tx parameters are filled
+ * in struct cfg80211_mgmt_tx_params. The variables defined in this enum will
+ * be used as bitmap in cfg80211_mgmt_tx_params->filled.
+ *
+ * @MGMT_PACKET_TX_RATE: Indicates whether tx rate is filled.
+ * @MGMT_PACKET_TX_RETRIES: Indicates whether at least one of the short or long
+ *	retries are filled or not.
+ * @MGMT_PACKET_TX_POWER: Indicates whether tx power is specified or not.
+ */
+enum cfg80211_mgmt_tx_params_filled {
+	MGMT_PACKET_TX_RATE		= BIT(0),
+	MGMT_PACKET_TX_RETRIES		= BIT(1),
+	MGMT_PACKET_TX_POWER		= BIT(2),
+};
+
+/**
  * struct cfg80211_mgmt_tx_params - mgmt tx parameters
  *
  * This structure provides information needed to transmit a mgmt frame
@@ -2629,6 +2647,16 @@ struct cfg80211_update_ft_ies_params {
  * @dont_wait_for_ack: tells the low level not to wait for an ack
  * @n_csa_offsets: length of csa_offsets array
  * @csa_offsets: array of all the csa offsets in the frame
+ * @filled: bitmap of different optional mgmt tx parameters that are filled in
+ *	this structure. Bit mappings are defined in
+ *	enum cfg80211_mgmt_tx_params_filled.
+ * @txrate: Tx rate at which this frame shall be transmitted on-air.
+ *	txrate->legacy shall be used to determine 11abg rate only when none of
+ *	RATE_INFO_FLAGS_MCS, RATE_INFO_FLAGS_VHT_MCS and RATE_INFO_FLAGS_HE_MCS
+ *	flags in txrate->flags.
+ * @retry_short: Retry limit for short frames for this packet
+ * @retry_long: Retry limit for long frames for this packet
+ * @max_power: Transmission power for this packet (in mBm)
  */
 struct cfg80211_mgmt_tx_params {
 	struct ieee80211_channel *chan;
@@ -2640,6 +2668,11 @@ struct cfg80211_mgmt_tx_params {
 	bool dont_wait_for_ack;
 	int n_csa_offsets;
 	const u16 *csa_offsets;
+	u32 filled;
+	struct rate_info txrate;
+	u8 retry_short;
+	u8 retry_long;
+	s32 tx_power;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 0d4dd14..0d49c80 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -646,6 +646,16 @@
  *	%NL80211_ATTR_CSA_C_OFFSETS_TX is an array of offsets to CSA
  *	counters which will be updated to the current value. This attribute
  *	is used during CSA period.
+ *	Optionally the rate at which this frame shall be transmitted can be
+ *	specified using %NL80211_ATTR_RATE_INFO if the driver indicates the
+ *	support by setting %NL80211_EXT_FEATURE_CMD_FRAME_TXRATE feature flag.
+ *	NL80211_RATE_INFO_BITRATE* shall not be populated within
+ *	%NL80211_ATTR_RATE_INFO unless one of the 11abg rates is specified.
+ *	The number of retries that can be made to successfully transmit this
+ *	frame can be specified using %NL80211_ATTR_WIPHY_RETRY_SHORT and/or
+ *	%NL80211_ATTR_WIPHY_RETRY_LONG attributes.
+ *	The tx power at which this frame shall be transmitted can be specified
+ *	using %NL80211_ATTR_WIPHY_TX_POWER_LEVEL attribute.
  * @NL80211_CMD_FRAME_WAIT_CANCEL: When an off-channel TX was requested, this
  *	command may be used with the corresponding cookie to cancel the wait
  *	time if it is known that it is no longer necessary.
@@ -1621,7 +1631,8 @@ enum nl80211_commands {
  *      &enum nl80211_tx_power_setting for possible values.
  * @NL80211_ATTR_WIPHY_TX_POWER_LEVEL: Transmit power level in signed mBm units.
  *      This is used in association with @NL80211_ATTR_WIPHY_TX_POWER_SETTING
- *      for non-automatic settings.
+ *      for non-automatic settings. When used in @NL80211_CMD_FRAME, it
+ *	specifies the fixed power at which the frame shall be transmitted.
  *
  * @NL80211_ATTR_SUPPORT_IBSS_RSN: The device supports IBSS RSN, which mostly
  *	means support for per-station GTKs.
@@ -2270,6 +2281,12 @@ enum nl80211_commands {
  *	or bssid attribute will have higher precedence than the thresholds
  *	mentioned in this attribute while checking rssi.
  *
+ * @NL80211_ATTR_RATE_INFO: Specifies either tx rate at which a packet shall be
+ *	transmitted or rx rate at which a packet has been received. Nested
+ *	attribute containing info as possible, see &enum nl80211_rate_info.
+ *	Will be used with %NL80211_CMD_FRAME to specify the phy rate at which
+ *	the frame associated with this command shall be transmitted over the
+ *	air.
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2717,6 +2734,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SCHED_SCAN_MIN_RSSI,
 
+	NL80211_ATTR_RATE_INFO,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2930,7 +2949,9 @@ enum nl80211_he_ru_alloc {
  * enum nl80211_rate_info - bitrate information
  *
  * These attribute types are used with %NL80211_STA_INFO_TXRATE
- * when getting information about the bitrate of a station.
+ * when getting information about the bitrate of a station and with
+ * %NL80211_CMD_FRAME to specify the phy rate at which the frame shall
+ * be transmitted.
  * There are 2 attributes for bitrate, a legacy one that represents
  * a 16-bit value, and new one that represents a 32-bit value.
  * If the rate value fits into 16 bit, both attributes are reported
@@ -5278,6 +5299,10 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_SCHED_SCAN_BAND_SPECIFIC_RSSI_THOLD: The driver supports
  *	filtering scan results with band specific rssi thresholds that are
  *	specified within %NL80211_ATTR_SCHED_SCAN_MIN_RSSI.
+ * @NL80211_EXT_FEATURE_CMD_FRAME_TXRATE: The driver supports sending frames
+ *	at rate specified by userspace with %NL80211_CMD_FRAME. The tx rate
+ *	shall be specified within %NL80211_ATTR_RATE_INFO nested attribute
+ *	with %NL80211_CMD_FRAME command.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5319,6 +5344,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_CAN_REPLACE_PTK0,
 	NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER,
 	NL80211_EXT_FEATURE_SCHED_SCAN_BAND_SPECIFIC_RSSI_THOLD,
+	NL80211_EXT_FEATURE_CMD_FRAME_TXRATE,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4fc0bfc..70c19f5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -240,6 +240,27 @@ static int validate_ie_attr(const struct nlattr *attr,
 					     .len = U8_MAX },
 };
 
+static const struct nla_policy
+nl80211_rate_info_policy[NL80211_RATE_INFO_MAX + 1] = {
+	[NL80211_RATE_INFO_BITRATE] = { .type = NLA_U16 },
+	[NL80211_RATE_INFO_MCS] = { .type = NLA_U8 },
+	[NL80211_RATE_INFO_40_MHZ_WIDTH] = { .type = NLA_FLAG },
+	[NL80211_RATE_INFO_SHORT_GI] = { .type = NLA_FLAG },
+	[NL80211_RATE_INFO_BITRATE32] = { .type = NLA_U32 },
+	[NL80211_RATE_INFO_VHT_MCS] = { .type = NLA_U8 },
+	[NL80211_RATE_INFO_VHT_NSS] = { .type = NLA_U8 },
+	[NL80211_RATE_INFO_80_MHZ_WIDTH] = { .type = NLA_FLAG },
+	[NL80211_RATE_INFO_80P80_MHZ_WIDTH] = { .type = NLA_FLAG },
+	[NL80211_RATE_INFO_160_MHZ_WIDTH] = { .type = NLA_FLAG },
+	[NL80211_RATE_INFO_10_MHZ_WIDTH] = { .type = NLA_FLAG },
+	[NL80211_RATE_INFO_5_MHZ_WIDTH] = { .type = NLA_FLAG },
+	[NL80211_RATE_INFO_HE_MCS] = { .type = NLA_U8 },
+	[NL80211_RATE_INFO_HE_NSS] = { .type = NLA_U8 },
+	[NL80211_RATE_INFO_HE_GI] = { .type = NLA_U8 },
+	[NL80211_RATE_INFO_HE_DCM] = { .type = NLA_U8 },
+	[NL80211_RATE_INFO_HE_RU_ALLOC] = { .type = NLA_U8 },
+};
+
 static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_NAME] = { .type = NLA_NUL_STRING,
@@ -498,6 +519,8 @@ static int validate_ie_attr(const struct nlattr *attr,
 		.validation_data = nl80211_ftm_responder_policy,
 	},
 	[NL80211_ATTR_SCHED_SCAN_MIN_RSSI] = { .type = NLA_NESTED },
+	[NL80211_ATTR_RATE_INFO] = NLA_POLICY_NESTED(NL80211_RATE_INFO_MAX,
+						     nl80211_rate_info_policy),
 };
 
 /* policy for the key attributes */
@@ -9918,6 +9941,92 @@ static int nl80211_register_mgmt(struct sk_buff *skb, struct genl_info *info)
 			nla_len(info->attrs[NL80211_ATTR_FRAME_MATCH]));
 }
 
+static int
+nl80211_parse_rate_info(struct genl_info *info, struct rate_info *rate)
+{
+	struct nlattr *tb[NL80211_RATE_INFO_MAX + 1];
+	struct nlattr *attr;
+	int err;
+
+	attr = info->attrs[NL80211_ATTR_RATE_INFO];
+	if (!attr)
+		return -EINVAL;
+
+	err = nla_parse_nested(tb, NL80211_RATE_INFO_MAX, attr,
+			       nl80211_rate_info_policy, NULL);
+	if (err)
+		return err;
+
+	if (tb[NL80211_RATE_INFO_BITRATE] || tb[NL80211_RATE_INFO_BITRATE32]) {
+		if (tb[NL80211_RATE_INFO_MCS] ||
+		    tb[NL80211_RATE_INFO_VHT_MCS] ||
+		    tb[NL80211_RATE_INFO_HE_MCS])
+			return -EINVAL;
+	} else if (tb[NL80211_RATE_INFO_MCS]) {
+		if (tb[NL80211_RATE_INFO_VHT_MCS] ||
+		    tb[NL80211_RATE_INFO_HE_MCS])
+			return -EINVAL;
+	} else if (tb[NL80211_RATE_INFO_VHT_MCS]) {
+		if (tb[NL80211_RATE_INFO_HE_MCS])
+			return -EINVAL;
+		if (!tb[NL80211_RATE_INFO_VHT_NSS])
+			return -EINVAL;
+	} else if (tb[NL80211_RATE_INFO_HE_MCS]) {
+		if (!(tb[NL80211_RATE_INFO_HE_NSS] &&
+		      tb[NL80211_RATE_INFO_HE_GI] &&
+		      tb[NL80211_RATE_INFO_HE_DCM]))
+			return -EINVAL;
+	} else {
+		return -EINVAL;
+	}
+
+	memset(rate, 0, sizeof(struct rate_info));
+
+	if (tb[NL80211_RATE_INFO_BITRATE32]) {
+		/* Safe to truncate, as 11abg rates will fit into 16-bits */
+		rate->legacy =
+			(u16)nla_get_u32(tb[NL80211_RATE_INFO_BITRATE32]);
+	} else if (tb[NL80211_RATE_INFO_BITRATE]) {
+		rate->legacy = nla_get_u16(tb[NL80211_RATE_INFO_BITRATE]);
+	} else if (tb[NL80211_RATE_INFO_MCS]) {
+		rate->mcs = nla_get_u16(tb[NL80211_RATE_INFO_MCS]);
+		rate->flags |= RATE_INFO_FLAGS_MCS;
+	} else if (tb[NL80211_RATE_INFO_VHT_MCS]) {
+		rate->mcs = nla_get_u16(tb[NL80211_RATE_INFO_VHT_MCS]);
+		rate->nss = nla_get_u8(tb[NL80211_RATE_INFO_VHT_NSS]);
+		rate->flags |= RATE_INFO_FLAGS_VHT_MCS;
+	} else if (tb[NL80211_RATE_INFO_HE_MCS]) {
+		rate->mcs = nla_get_u16(tb[NL80211_RATE_INFO_HE_MCS]);
+		rate->nss = nla_get_u8(tb[NL80211_RATE_INFO_HE_NSS]);
+		rate->flags |= RATE_INFO_FLAGS_HE_MCS;
+	}
+
+	if (tb[NL80211_RATE_INFO_MCS] || tb[NL80211_RATE_INFO_VHT_MCS]) {
+		if (nla_get_flag(tb[NL80211_RATE_INFO_SHORT_GI]))
+			rate->flags |= RATE_INFO_FLAGS_SHORT_GI;
+	} else if (tb[NL80211_RATE_INFO_HE_MCS]) {
+		rate->he_gi = nla_get_u8(tb[NL80211_RATE_INFO_HE_GI]);
+		rate->he_dcm = nla_get_u8(tb[NL80211_RATE_INFO_HE_DCM]);
+	}
+
+	if (nla_get_flag(tb[NL80211_RATE_INFO_5_MHZ_WIDTH]))
+		rate->bw = RATE_INFO_BW_5;
+	else if (nla_get_flag(tb[NL80211_RATE_INFO_10_MHZ_WIDTH]))
+		rate->bw = RATE_INFO_BW_10;
+	else if (nla_get_flag(tb[NL80211_RATE_INFO_40_MHZ_WIDTH]))
+		rate->bw = RATE_INFO_BW_40;
+	else if (nla_get_flag(tb[NL80211_RATE_INFO_80_MHZ_WIDTH]))
+		rate->bw = RATE_INFO_BW_80;
+	else if (nla_get_flag(tb[NL80211_RATE_INFO_160_MHZ_WIDTH]))
+		rate->bw = RATE_INFO_BW_160;
+	else if (tb[NL80211_RATE_INFO_HE_MCS])
+		rate->bw = RATE_INFO_BW_HE_RU;
+	else
+		rate->bw = RATE_INFO_BW_20;
+
+	return 0;
+}
+
 static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -9955,6 +10064,11 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 		return -EOPNOTSUPP;
 	}
 
+	if (!wiphy_ext_feature_isset(&rdev->wiphy,
+				     NL80211_EXT_FEATURE_CMD_FRAME_TXRATE) &&
+	    info->attrs[NL80211_ATTR_RATE_INFO])
+		return -EINVAL;
+
 	if (info->attrs[NL80211_ATTR_DURATION]) {
 		if (!(rdev->wiphy.flags & WIPHY_FLAG_OFFCHAN_TX))
 			return -EINVAL;
@@ -10017,6 +10131,32 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
+	if (info->attrs[NL80211_ATTR_RATE_INFO]) {
+		err = nl80211_parse_rate_info(info, &params.txrate);
+		if (err)
+			return err;
+		params.filled |= MGMT_PACKET_TX_RATE;
+	}
+
+	if (info->attrs[NL80211_ATTR_WIPHY_RETRY_SHORT]) {
+		params.retry_short =
+			nla_get_u8(info->attrs[NL80211_ATTR_WIPHY_RETRY_SHORT]);
+		params.filled |= MGMT_PACKET_TX_RETRIES;
+	}
+
+	if (info->attrs[NL80211_ATTR_WIPHY_RETRY_LONG]) {
+		params.retry_long =
+			nla_get_u8(info->attrs[NL80211_ATTR_WIPHY_RETRY_LONG]);
+		params.filled |= MGMT_PACKET_TX_RETRIES;
+	}
+
+	if (info->attrs[NL80211_ATTR_WIPHY_TX_POWER_LEVEL]) {
+		int idx = NL80211_ATTR_WIPHY_TX_POWER_LEVEL;
+
+		params.tx_power = nla_get_s32(info->attrs[idx]);
+		params.filled |= MGMT_PACKET_TX_POWER;
+	}
+
 	if (!params.dont_wait_for_ack) {
 		msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 		if (!msg)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

