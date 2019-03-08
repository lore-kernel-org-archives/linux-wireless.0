Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A23CCC43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 11:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B64A20684
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 11:26:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="G5+MSPhc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HLLD3R05"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfCHL0R (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 06:26:17 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39792 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfCHL0R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 06:26:17 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AE3096044E; Fri,  8 Mar 2019 11:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552044375;
        bh=YCNFAnzFzyW65UY8uuOijnL6zUe7bftiF7DSyzA3QW8=;
        h=From:To:Cc:Subject:Date:From;
        b=G5+MSPhcu5rXPvYy+Eu3FUhjI+h+9QHBZmocSMRR5rJYtqjOT9uGVbq2Dp3bNfXUu
         9Sm7NoKLR9VrZ3hk4XqVKlkzxKXkhg/LFUw6Eqje3nooCNwSMIgcl1GyLl2FzEiwop
         yq5NhkNAF7GqpGO9Cg5B9qoYESiwOEAAy1UpdNUo=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B7E996029B;
        Fri,  8 Mar 2019 11:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552044374;
        bh=YCNFAnzFzyW65UY8uuOijnL6zUe7bftiF7DSyzA3QW8=;
        h=From:To:Cc:Subject:Date:From;
        b=HLLD3R05MT8pLliB3zLoHGyIQ/c9pOSD75y8dytGiIt5Ax6Kk4y7v8JetyQVeMgUm
         fZNGkfa8OHRvf8YINg6sY0ybSVWK3f0jt1P2XWvSNKRklNVkcWS3w4h7qQJ3fctTRa
         hge0AkAX5AaR8+8hggdnCPgWnFeTu6eoSLNcCwkc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B7E996029B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH] ath10k: Fix channel info parsing for non tlv target
Date:   Fri,  8 Mar 2019 16:56:06 +0530
Message-Id: <1552044366-9186-1-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The tlv targets such as WCN3990 send more data in
the chan info event, which is not sent by the non tlv
targets. There is a minimum size check in the wmi event for
non-tlv targets and hence we cannot update the common
channel info structure.

If the common channel info structure is updated, the
size check for chan info event for non-tlv targets
will fail and return -EPROTO and we see the below
error messages

   ath10k_pci 0000:01:00.0: failed to parse chan info event: -71

Add tlv specific channel info structure and restore the
original size of the common channel info structure to
mitigate this issue.

Tested HW: WCN3990
	   QCA9887
Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1
	   10.2.4-1.0-00037

Fixes: 13104929d2ec ("ath10k: fill the channel survey results for WCN3990 correctly")
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 16 ++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |  8 --------
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 582fb11..a826acb 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -810,7 +810,7 @@ static int ath10k_wmi_tlv_op_pull_ch_info_ev(struct ath10k *ar,
 					     struct wmi_ch_info_ev_arg *arg)
 {
 	const void **tb;
-	const struct wmi_chan_info_event *ev;
+	const struct wmi_tlv_chan_info_event *ev;
 	int ret;
 
 	tb = ath10k_wmi_tlv_parse_alloc(ar, skb->data, skb->len, GFP_ATOMIC);
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 65e6aa5..4bdd655 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1607,6 +1607,22 @@ struct chan_info_params {
 
 #define WMI_TLV_FLAG_MGMT_BUNDLE_TX_COMPL	BIT(9)
 
+struct wmi_tlv_chan_info_event {
+	__le32 err_code;
+	__le32 freq;
+	__le32 cmd_flags;
+	__le32 noise_floor;
+	__le32 rx_clear_count;
+	__le32 cycle_count;
+	__le32 chan_tx_pwr_range;
+	__le32 chan_tx_pwr_tp;
+	__le32 rx_frame_count;
+	__le32 my_bss_rx_cycle_count;
+	__le32 rx_11b_mode_data_duration;
+	__le32 tx_frame_cnt;
+	__le32 mac_clk_mhz;
+} __packed;
+
 struct wmi_tlv_mgmt_tx_compl_ev {
 	__le32 desc_id;
 	__le32 status;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index e1c40bb..d188a2c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6523,14 +6523,6 @@ struct wmi_chan_info_event {
 	__le32 noise_floor;
 	__le32 rx_clear_count;
 	__le32 cycle_count;
-	__le32 chan_tx_pwr_range;
-	__le32 chan_tx_pwr_tp;
-	__le32 rx_frame_count;
-	__le32 my_bss_rx_cycle_count;
-	__le32 rx_11b_mode_data_duration;
-	__le32 tx_frame_cnt;
-	__le32 mac_clk_mhz;
-
 } __packed;
 
 struct wmi_10_4_chan_info_event {
-- 
2.7.4

