Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815E8C4321A
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 06:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52E7B206DD
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 06:41:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mycD0lXd";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mycD0lXd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfDZGl0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 02:41:26 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53736 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfDZGl0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 02:41:26 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A5A23608D4; Fri, 26 Apr 2019 06:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556260884;
        bh=SGBwD3fHfRtvIkwiGKLdm/PJH/KChM7C0ch4XU9or0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mycD0lXdQjyQv7jUsam2baN/90CSzhDPR1Wq3ISLWZ0/T4kWQ8MrsFAN7A6aGyi+2
         f0MeDMmsLNr+4g15iSxhj0kRVhQ+PKGDJfB5oQzZBjDBHIbD7lpPWGBTqcQt5cupll
         lhp+Hmu1GGryPXN9NCVWJJPR/Gnb1i+Qencqu2iQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1E2256076C;
        Fri, 26 Apr 2019 06:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556260884;
        bh=SGBwD3fHfRtvIkwiGKLdm/PJH/KChM7C0ch4XU9or0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mycD0lXdQjyQv7jUsam2baN/90CSzhDPR1Wq3ISLWZ0/T4kWQ8MrsFAN7A6aGyi+2
         f0MeDMmsLNr+4g15iSxhj0kRVhQ+PKGDJfB5oQzZBjDBHIbD7lpPWGBTqcQt5cupll
         lhp+Hmu1GGryPXN9NCVWJJPR/Gnb1i+Qencqu2iQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1E2256076C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, Wen Gong <wgong@codeaurora.org>
Subject: [PATCH 5/5] ath10k: enable QCA6174 hw3.2 SDIO hardware
Date:   Fri, 26 Apr 2019 09:41:11 +0300
Message-Id: <1556260871-2919-6-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556260871-2919-1-git-send-email-kvalo@codeaurora.org>
References: <1556260871-2919-1-git-send-email-kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Wen Gong <wgong@codeaurora.org>

After implementing PN replay check we can enable SDIO support on QCA6174.
Tested with client mode on all security modes, and fragmentation as well. AP
mode does not work yet.

Also tone down the warning about SDIO being not ready yet.

Tested on QCA6174 SDIO with firmware WLAN.RMH.4.4.1-00007-QCARMSWP-1. AP mode
is not working yet.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 27 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  1 +
 drivers/net/wireless/ath/ath10k/sdio.c |  2 +-
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index cfd7bb29a1ec..525a7ff87bf4 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -154,6 +154,33 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.fw_diag_ce_download = false,
 	},
 	{
+		.id = QCA6174_HW_3_2_VERSION,
+		.dev_id = QCA6174_3_2_DEVICE_ID,
+		.bus = ATH10K_BUS_SDIO,
+		.name = "qca6174 hw3.2 sdio",
+		.patch_load_addr = QCA6174_HW_3_0_PATCH_LOAD_ADDR,
+		.uart_pin = 19,
+		.otp_exe_param = 0,
+		.channel_counters_freq_hz = 88000,
+		.max_probe_resp_desc_thres = 0,
+		.cal_data_len = 0,
+		.fw = {
+			.dir = QCA6174_HW_3_0_FW_DIR,
+			.board = QCA6174_HW_3_0_BOARD_DATA_FILE,
+			.board_size = QCA6174_BOARD_DATA_SZ,
+			.board_ext_size = QCA6174_BOARD_EXT_DATA_SZ,
+		},
+		.hw_ops = &qca6174_ops,
+		.hw_clk = qca6174_clk,
+		.target_cpu_freq = 176000000,
+		.decap_align_bytes = 4,
+		.n_cipher_suites = 8,
+		.num_peers = 10,
+		.ast_skid_limit = 0x10,
+		.num_wds_entries = 0x20,
+		.uart_pin_workaround = true,
+	},
+	{
 		.id = QCA6174_HW_2_1_VERSION,
 		.dev_id = QCA6164_2_1_DEVICE_ID,
 		.bus = ATH10K_BUS_PCI,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index a92fce1bb6f0..248cfb4e53c3 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -24,6 +24,7 @@ enum ath10k_bus {
 #define QCA988X_2_0_DEVICE_ID   (0x003c)
 #define QCA6164_2_1_DEVICE_ID   (0x0041)
 #define QCA6174_2_1_DEVICE_ID   (0x003e)
+#define QCA6174_3_2_DEVICE_ID   (0x0042)
 #define QCA99X0_2_0_DEVICE_ID   (0x0040)
 #define QCA9888_2_0_DEVICE_ID	(0x0056)
 #define QCA9984_1_0_DEVICE_ID	(0x0046)
diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 30102090e282..a2c1bad67b5b 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -2059,7 +2059,7 @@ static int ath10k_sdio_probe(struct sdio_func *func,
 	}
 
 	/* TODO: remove this once SDIO support is fully implemented */
-	ath10k_warn(ar, "WARNING: ath10k SDIO support is incomplete, don't expect anything to work!\n");
+	ath10k_warn(ar, "WARNING: ath10k SDIO support is work-in-progress, problems may arise!\n");
 
 	return 0;
 
-- 
2.7.4

