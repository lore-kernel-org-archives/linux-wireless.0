Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ADB1C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA5B420835
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:58:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="l3/ZnWos";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RrEfnm1n"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA5B420835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbeJCRp7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 13:45:59 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53380 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbeJCRp7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 13:45:59 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 51B4E60C6A; Wed,  3 Oct 2018 10:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538564286;
        bh=LwdYkgFV0/q3/3M48Grn2I1rrUxZWsc5tRQ6lGSNxt8=;
        h=From:To:Cc:Subject:Date:From;
        b=l3/ZnWosOl7I5T9TQUSXE2UDyLlUnof7ASRiOfQEOb3T+NdjAnYRPiqOVnWsI4V0l
         wkgNKZ4OPl1yEFv/K9dJIodtuv2cX7E1wFdYLKW1fgM0zuojtcmLDvWz4qbrVsXvun
         7SlFVNAZLJbS22XZSDLN32YPLLk/RjxoYz7paMXk=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2352F6081B;
        Wed,  3 Oct 2018 10:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538564283;
        bh=LwdYkgFV0/q3/3M48Grn2I1rrUxZWsc5tRQ6lGSNxt8=;
        h=From:To:Cc:Subject:Date:From;
        b=RrEfnm1nGOQhmpz4pSpf6gk01VB7kFmKuITPhBTKHLwAFIqs1zY31+NUK08nns7sS
         3PGBFxDTpyBApRqCPifzG5a8QecSTktSkqYluO8Iuu62ckuKZ8MJOrdMLhAV3r4ObX
         ZoYC6EH4TEIOu1g3v3fWZhEHkYBd1hsTKf87ZSMw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2352F6081B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH] ath10k: Fill the channel survey results for WCN3990 correctly
Date:   Wed,  3 Oct 2018 16:27:47 +0530
Message-Id: <1538564267-19863-1-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The host driver currently expects the channel info event to be
received in pairs for all the channels, i.e. the first
chan_info event for a particular channel will not have the
COMPLETE flag set and the second chan_info event for the
same channel will have the COMPLETE flag set.

The HL2.0 firmware sends only one channel info event per channel
which is scanned without the COMPLETE flag set. After sending the
chan_info_event for all the channels, the HL2.0 firmware sends a
chan_info_event with COMPLETE flag set to indicate the completion
of the channel info event.

The firmware does not indicate this behavior with any service bitmap
and hence a new firmware feature flag is used to handle the modified
parsing of the channel info events, in the host driver, for the
firmware which sends single channel info event per scanned channel.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Co-developed-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c    |   1 +
 drivers/net/wireless/ath/ath10k/core.h    |   3 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |   3 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  10 +++
 drivers/net/wireless/ath/ath10k/wmi.c     | 130 +++++++++++++++++++++---------
 drivers/net/wireless/ath/ath10k/wmi.h     |  12 +++
 6 files changed, 122 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 203f309..218b44f 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -594,6 +594,7 @@ static const char *const ath10k_core_fw_feature_str[] = {
 	[ATH10K_FW_FEATURE_NO_PS] = "no-ps",
 	[ATH10K_FW_FEATURE_MGMT_TX_BY_REF] = "mgmt-tx-by-reference",
 	[ATH10K_FW_FEATURE_NON_BMI] = "non-bmi",
+	[ATH10K_FW_FEATURE_SINGLE_CHAN_INFO_PER_CHANNEL] = "single-chan-info-per-channel",
 };
 
 static unsigned int ath10k_core_get_fw_feature_str(char *buf,
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index c76af34..3c34560 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -760,6 +760,9 @@ enum ath10k_fw_features {
 	/* Firmware load is done externally, not by bmi */
 	ATH10K_FW_FEATURE_NON_BMI = 19,
 
+	/* Firmware sends only one chan_info event per channel */
+	ATH10K_FW_FEATURE_SINGLE_CHAN_INFO_PER_CHANNEL = 20,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index df8f673..442184d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -824,6 +824,9 @@ static int ath10k_wmi_tlv_op_pull_ch_info_ev(struct ath10k *ar,
 	arg->noise_floor = ev->noise_floor;
 	arg->rx_clear_count = ev->rx_clear_count;
 	arg->cycle_count = ev->cycle_count;
+	if (test_bit(ATH10K_FW_FEATURE_SINGLE_CHAN_INFO_PER_CHANNEL,
+		     ar->running_fw->fw_file.fw_features))
+		arg->mac_clk_mhz = ev->mac_clk_mhz;
 
 	kfree(tb);
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 8014fc8..b529955 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1582,6 +1582,16 @@ struct ath10k_mgmt_tx_pkt_addr {
 
 #define WMI_TLV_FLAG_MGMT_BUNDLE_TX_COMPL	BIT(9)
 
+struct chan_info_params {
+	u32 err_code;
+	u32 freq;
+	u32 cmd_flags;
+	u32 noise_floor;
+	u32 rx_clear_count;
+	u32 cycle_count;
+	u32 mac_clk_mhz;
+};
+
 struct wmi_tlv_mgmt_tx_compl_ev {
 	__le32 desc_id;
 	__le32 status;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 8f62a85..37607fa 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2580,60 +2580,71 @@ static int ath10k_wmi_10_4_op_pull_ch_info_ev(struct ath10k *ar,
 	return 0;
 }
 
-void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
+/*
+ * Handle the channel info event for firmware which only sends one
+ * chan_info event per scanned channel.
+ */
+static void ath10k_wmi_event_chan_info_unpaired(struct ath10k *ar,
+						struct chan_info_params *params)
 {
-	struct wmi_ch_info_ev_arg arg = {};
 	struct survey_info *survey;
-	u32 err_code, freq, cmd_flags, noise_floor, rx_clear_count, cycle_count;
-	int idx, ret;
+	u64 clock_freq;
+	int idx;
 
-	ret = ath10k_wmi_pull_ch_info(ar, skb, &arg);
-	if (ret) {
-		ath10k_warn(ar, "failed to parse chan info event: %d\n", ret);
+	if (params->cmd_flags & WMI_CHAN_INFO_FLAG_COMPLETE) {
+		ath10k_dbg(ar, ATH10K_DBG_WMI, "chan info report completed\n");
 		return;
 	}
 
-	err_code = __le32_to_cpu(arg.err_code);
-	freq = __le32_to_cpu(arg.freq);
-	cmd_flags = __le32_to_cpu(arg.cmd_flags);
-	noise_floor = __le32_to_cpu(arg.noise_floor);
-	rx_clear_count = __le32_to_cpu(arg.rx_clear_count);
-	cycle_count = __le32_to_cpu(arg.cycle_count);
+	idx = freq_to_idx(ar, params->freq);
+	if (idx >= ARRAY_SIZE(ar->survey)) {
+		ath10k_warn(ar, "chan info: invalid frequency %d (idx %d out of bounds)\n",
+			    params->freq, idx);
+		return;
+	}
 
-	ath10k_dbg(ar, ATH10K_DBG_WMI,
-		   "chan info err_code %d freq %d cmd_flags %d noise_floor %d rx_clear_count %d cycle_count %d\n",
-		   err_code, freq, cmd_flags, noise_floor, rx_clear_count,
-		   cycle_count);
+	survey = &ar->survey[idx];
 
-	spin_lock_bh(&ar->data_lock);
+	if (!params->mac_clk_mhz || !survey)
+		return;
 
-	switch (ar->scan.state) {
-	case ATH10K_SCAN_IDLE:
-	case ATH10K_SCAN_STARTING:
-		ath10k_warn(ar, "received chan info event without a scan request, ignoring\n");
-		goto exit;
-	case ATH10K_SCAN_RUNNING:
-	case ATH10K_SCAN_ABORTING:
-		break;
-	}
+	clock_freq = params->mac_clk_mhz * 1000;
+	memset(survey, 0, sizeof(*survey));
 
-	idx = freq_to_idx(ar, freq);
+	survey->noise = params->noise_floor;
+	survey->time = params->cycle_count / clock_freq;
+	survey->time_busy = params->rx_clear_count / clock_freq;
+	survey->filled |= SURVEY_INFO_NOISE_DBM | SURVEY_INFO_TIME |
+			  SURVEY_INFO_TIME_BUSY;
+}
+
+/*
+ * Handle the channel info event for firmware which sends chan_info
+ * event in pairs(start and stop events) for every scanned channel.
+ */
+static void ath10k_wmi_event_chan_info_paired(struct ath10k *ar,
+					      struct chan_info_params *params)
+{
+	struct survey_info *survey;
+	int idx;
+
+	idx = freq_to_idx(ar, params->freq);
 	if (idx >= ARRAY_SIZE(ar->survey)) {
 		ath10k_warn(ar, "chan info: invalid frequency %d (idx %d out of bounds)\n",
-			    freq, idx);
-		goto exit;
+			    params->freq, idx);
+		return;
 	}
 
-	if (cmd_flags & WMI_CHAN_INFO_FLAG_COMPLETE) {
+	if (params->cmd_flags & WMI_CHAN_INFO_FLAG_COMPLETE) {
 		if (ar->ch_info_can_report_survey) {
 			survey = &ar->survey[idx];
-			survey->noise = noise_floor;
+			survey->noise = params->noise_floor;
 			survey->filled = SURVEY_INFO_NOISE_DBM;
 
 			ath10k_hw_fill_survey_time(ar,
 						   survey,
-						   cycle_count,
-						   rx_clear_count,
+						   params->cycle_count,
+						   params->rx_clear_count,
 						   ar->survey_last_cycle_count,
 						   ar->survey_last_rx_clear_count);
 		}
@@ -2643,11 +2654,56 @@ void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
 		ar->ch_info_can_report_survey = true;
 	}
 
-	if (!(cmd_flags & WMI_CHAN_INFO_FLAG_PRE_COMPLETE)) {
-		ar->survey_last_rx_clear_count = rx_clear_count;
-		ar->survey_last_cycle_count = cycle_count;
+	if (!(params->cmd_flags & WMI_CHAN_INFO_FLAG_PRE_COMPLETE)) {
+		ar->survey_last_rx_clear_count = params->rx_clear_count;
+		ar->survey_last_cycle_count = params->cycle_count;
+	}
+}
+
+void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
+{
+	struct chan_info_params ch_info_param;
+	struct wmi_ch_info_ev_arg arg = {};
+	int ret;
+
+	ret = ath10k_wmi_pull_ch_info(ar, skb, &arg);
+	if (ret) {
+		ath10k_warn(ar, "failed to parse chan info event: %d\n", ret);
+		return;
+	}
+
+	ch_info_param.err_code = __le32_to_cpu(arg.err_code);
+	ch_info_param.freq = __le32_to_cpu(arg.freq);
+	ch_info_param.cmd_flags = __le32_to_cpu(arg.cmd_flags);
+	ch_info_param.noise_floor = __le32_to_cpu(arg.noise_floor);
+	ch_info_param.rx_clear_count = __le32_to_cpu(arg.rx_clear_count);
+	ch_info_param.cycle_count = __le32_to_cpu(arg.cycle_count);
+	ch_info_param.mac_clk_mhz = __le32_to_cpu(arg.mac_clk_mhz);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "chan info err_code %d freq %d cmd_flags %d noise_floor %d rx_clear_count %d cycle_count %d\n",
+		   ch_info_param.err_code, ch_info_param.freq, ch_info_param.cmd_flags,
+		   ch_info_param.noise_floor, ch_info_param.rx_clear_count,
+		   ch_info_param.cycle_count);
+
+	spin_lock_bh(&ar->data_lock);
+
+	switch (ar->scan.state) {
+	case ATH10K_SCAN_IDLE:
+	case ATH10K_SCAN_STARTING:
+		ath10k_warn(ar, "received chan info event without a scan request, ignoring\n");
+		goto exit;
+	case ATH10K_SCAN_RUNNING:
+	case ATH10K_SCAN_ABORTING:
+		break;
 	}
 
+	if (test_bit(ATH10K_FW_FEATURE_SINGLE_CHAN_INFO_PER_CHANNEL,
+		     ar->running_fw->fw_file.fw_features))
+		ath10k_wmi_event_chan_info_unpaired(ar, &ch_info_param);
+	else
+		ath10k_wmi_event_chan_info_paired(ar, &ch_info_param);
+
 exit:
 	spin_unlock_bh(&ar->data_lock);
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 1287687..e8e471e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6441,6 +6441,14 @@ struct wmi_chan_info_event {
 	__le32 noise_floor;
 	__le32 rx_clear_count;
 	__le32 cycle_count;
+	__le32 chan_tx_pwr_range;
+	__le32 chan_tx_pwr_tp;
+	__le32 rx_frame_count;
+	__le32 my_bss_rx_cycle_count;
+	__le32 rx_11b_mode_data_duration;
+	__le32 tx_frame_cnt;
+	__le32 mac_clk_mhz;
+
 } __packed;
 
 struct wmi_10_4_chan_info_event {
@@ -6675,6 +6683,10 @@ struct wmi_ch_info_ev_arg {
 	__le32 chan_tx_pwr_range;
 	__le32 chan_tx_pwr_tp;
 	__le32 rx_frame_count;
+	__le32 my_bss_rx_cycle_count;
+	__le32 rx_11b_mode_data_duration;
+	__le32 tx_frame_cnt;
+	__le32 mac_clk_mhz;
 };
 
 /* From 10.4 firmware, not sure all have the same values. */
-- 
2.7.4

