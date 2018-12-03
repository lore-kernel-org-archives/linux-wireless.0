Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D374EC04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 12:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EF9120851
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 12:05:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UsRP2c+i";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZH8oduqd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7EF9120851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbeLCMFr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 07:05:47 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43632 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbeLCMFr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 07:05:47 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EA6A060913; Mon,  3 Dec 2018 12:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543838699;
        bh=Qb+M9RoKqh/ILSogfe0YCruQ0nHnTIIgryfOGXs1IbU=;
        h=From:To:Cc:Subject:Date:From;
        b=UsRP2c+iZnhhnttNEEYFlPjWfJdhUzvxRmV0NPSWFkC4kmYpv2S5G6jTWdbzWRzEU
         uYY1VID9ou8uBQpIZSfKnCDXf/fY8fv1BO3lUZoUoIXE9N07pDTX0BgfY/62TphGaK
         d2cNXkbsDOROjg+d69sdlJtraxHhOGrfG/qCKqGk=
Received: from vamsin-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: vamsin@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AE6F7601D1;
        Mon,  3 Dec 2018 12:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543838698;
        bh=Qb+M9RoKqh/ILSogfe0YCruQ0nHnTIIgryfOGXs1IbU=;
        h=From:To:Cc:Subject:Date:From;
        b=ZH8oduqdsUGwpcnJzT8NRdciUH3ruBXH8SmIVqY9WTbARNP1Xwv96U3HDM3TmuqWG
         yM5J0B5UNwvxQedvjppo1JeTSFP3IKcxg0VL1AaYGdHhQ6f+yJNFx9saqmG46iRAPv
         XiGa45gkd7X6uXS/7wgjReocEbzr9LeFlKCWS5yA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AE6F7601D1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=vamsin@codeaurora.org
From:   vamsi krishna <vamsin@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, jouni@codeaurora.org,
        vamsi krishna <vamsin@codeaurora.org>
Subject: [PATCH] nl80211/cfg80211: Add support to send tx frames at specified rate
Date:   Mon,  3 Dec 2018 17:34:06 +0530
Message-Id: <1543838646-3574-1-git-send-email-vamsin@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

NL80211_CMD_FRAME is used to send frames from userspace. Add support to
transmit the frames at a rate specified by userspace when needed.
The drivers shall indicate the support to send frames at rate specified
by userspace by setting %NL80211_EXT_FEATURE_CMD_FRAME_TXRATE flag in
wiphy capabilities. The userspace can specify the rate within
%NL80211_ATTR_RATE_INFO attribute while sending %NL80211_CMD_FRAME.

NL80211_ATTR_RATE_INFO is a nested attribute and encapsulates the
attributes defined in &enum nl80211_rate_info.

Signed-off-by: vamsi krishna <vamsin@codeaurora.org>

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c032375..dbf58c6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2629,6 +2629,11 @@ struct cfg80211_update_ft_ies_params {
  * @dont_wait_for_ack: tells the low level not to wait for an ack
  * @n_csa_offsets: length of csa_offsets array
  * @csa_offsets: array of all the csa offsets in the frame
+ * @txrate: Tx rate at which this frame shall be transmitted on-air.
+ *	txrate->legacy shall be used to determine 11abg rate only when none of
+ *	RATE_INFO_FLAGS_MCS, RATE_INFO_FLAGS_VHT_MCS and RATE_INFO_FLAGS_HE_MCS
+ *	flags in txrate->flags.
+ * @txrate_specified: Indicates whether any valid tx rate specified @txrate.
  */
 struct cfg80211_mgmt_tx_params {
 	struct ieee80211_channel *chan;
@@ -2640,6 +2645,8 @@ struct cfg80211_mgmt_tx_params {
 	bool dont_wait_for_ack;
 	int n_csa_offsets;
 	const u16 *csa_offsets;
+	struct rate_info txrate;
+	bool txrate_specified;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 0d4dd14..b731868 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -646,6 +646,11 @@
  *	%NL80211_ATTR_CSA_C_OFFSETS_TX is an array of offsets to CSA
  *	counters which will be updated to the current value. This attribute
  *	is used during CSA period.
+ *	Optionally the rate at which this frame shall be transmitted can be
+ *	specified using %NL80211_ATTR_RATE_INFO if the driver indicates the
+ *	support by setting %NL80211_EXT_FEATURE_CMD_FRAME_TXRATE feature flag.
+ *	NL80211_RATE_INFO_BITRATE* shall not be populated within
+ *	%NL80211_ATTR_RATE_INFO unless one of the 11abg rates is specified.
  * @NL80211_CMD_FRAME_WAIT_CANCEL: When an off-channel TX was requested, this
  *	command may be used with the corresponding cookie to cancel the wait
  *	time if it is known that it is no longer necessary.
@@ -2270,6 +2275,12 @@ enum nl80211_commands {
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
@@ -2717,6 +2728,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SCHED_SCAN_MIN_RSSI,
 
+	NL80211_ATTR_RATE_INFO,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2930,7 +2943,9 @@ enum nl80211_he_ru_alloc {
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
@@ -5278,6 +5293,10 @@ enum nl80211_feature_flags {
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
@@ -5319,6 +5338,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_CAN_REPLACE_PTK0,
 	NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER,
 	NL80211_EXT_FEATURE_SCHED_SCAN_BAND_SPECIFIC_RSSI_THOLD,
+	NL80211_EXT_FEATURE_CMD_FRAME_TXRATE,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4fc0bfc..9bb7b65 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -498,6 +498,7 @@ static int validate_ie_attr(const struct nlattr *attr,
 		.validation_data = nl80211_ftm_responder_policy,
 	},
 	[NL80211_ATTR_SCHED_SCAN_MIN_RSSI] = { .type = NLA_NESTED },
+	[NL80211_ATTR_RATE_INFO] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -638,6 +639,27 @@ static int validate_ie_attr(const struct nlattr *attr,
 	[NL80211_PKTPAT_OFFSET] = { .type = NLA_U32 },
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
 static int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
 				     struct cfg80211_registered_device **rdev,
 				     struct wireless_dev **wdev)
@@ -9918,6 +9940,92 @@ static int nl80211_register_mgmt(struct sk_buff *skb, struct genl_info *info)
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
@@ -9955,6 +10063,11 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
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
@@ -10017,6 +10130,15 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
+	if (info->attrs[NL80211_ATTR_RATE_INFO]) {
+		err = nl80211_parse_rate_info(info, &params.txrate);
+		if (err)
+			return err;
+		params.txrate_specified = true;
+	} else {
+		params.txrate_specified = false;
+	}
+
 	if (!params.dont_wait_for_ack) {
 		msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 		if (!msg)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

