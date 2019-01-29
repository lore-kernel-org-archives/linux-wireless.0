Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F40C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 12:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4C0920880
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 12:03:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YjttFiz1";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="S2kYS+2R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbfA2MDw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 07:03:52 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:45544 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729519AbfA2MDv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 07:03:51 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8A4A860A98; Tue, 29 Jan 2019 12:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548763429;
        bh=W/GOHItXMtfX4SolfW4Ot/Z2TrM1V7BcEfVBq2ad95Y=;
        h=From:To:Cc:Subject:Date:From;
        b=YjttFiz11rdPxegzGzTRcKfFv+ztyxGCKDTMH5Qer9EldbxTI7gbnkXg1ANh861WD
         DgqULzOCyZlhOgjAgQspT2kVKgit4apjuhUoxf/3P81Ndh60S3lK1g4aMnfFOAKNqF
         E7JlmVlh9V/P3KBZRsFJDsUyLyfHXzmaiWQm2gQs=
Received: from localhost.localdomain (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wgong@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 482DF6095E;
        Tue, 29 Jan 2019 12:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548763428;
        bh=W/GOHItXMtfX4SolfW4Ot/Z2TrM1V7BcEfVBq2ad95Y=;
        h=From:To:Cc:Subject:Date:From;
        b=S2kYS+2R8aH1t/ok3maVhevp3qucHUpA+WRRARMmd0dnRQc4wvQ8Acu2T42s1fWa5
         8W4yIe5DdmcfyMOS9Nzt//d/7I2tRlWSaWTJ6IUXfIIBcTcMciuw2aQsFhfW89bKe2
         IYR4umgGyEiJWdWWwenUp3X2KUqHuPT4YrICTkyI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 482DF6095E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=wgong@codeaurora.org
From:   Wen Gong <wgong@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: Change swap mail box check after htc ready
Date:   Tue, 29 Jan 2019 20:03:12 +0800
Message-Id: <1548763392-3378-1-git-send-email-wgong@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The swap box flag of firmware is not set before htc ready, then it
will not set swap box flag in ath10k driver, and it will let swap
box setting not same between firmware and ath10k driver, then it
will trigger firmware assert failure.

Check the flag and set swap box after htc ready will fix the firmware
assert failure.

Tested with QCA6174 SDIO with firmware
WLAN.RMH.4.4.1-00005-QCARMSWP-1.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c |  6 ++++++
 drivers/net/wireless/ath/ath10k/hif.h  |  9 ++++++++
 drivers/net/wireless/ath/ath10k/sdio.c | 38 ++++++++++++++++++++--------------
 3 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 22cbe9a..55fa521 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2534,6 +2534,12 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 		goto err_hif_stop;
 	}
 
+	status = ath10k_hif_swap_mailbox(ar);
+	if (status) {
+		ath10k_err(ar, "failed to swap mailbox: %d\n", status);
+		goto err_hif_stop;
+	}
+
 	if (mode == ATH10K_FIRMWARE_MODE_NORMAL) {
 		status = ath10k_htt_connect(&ar->htt);
 		if (status) {
diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index 1a59ea0..5f7f1e0 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -59,6 +59,8 @@ struct ath10k_hif_ops {
 	 */
 	void (*stop)(struct ath10k *ar);
 
+	int (*swap_mailbox)(struct ath10k *ar);
+
 	int (*map_service_to_pipe)(struct ath10k *ar, u16 service_id,
 				   u8 *ul_pipe, u8 *dl_pipe);
 
@@ -139,6 +141,13 @@ static inline void ath10k_hif_stop(struct ath10k *ar)
 	return ar->hif.ops->stop(ar);
 }
 
+static inline int ath10k_hif_swap_mailbox(struct ath10k *ar)
+{
+	if (ar->hif.ops->swap_mailbox)
+		return ar->hif.ops->swap_mailbox(ar);
+	return 0;
+}
+
 static inline int ath10k_hif_map_service_to_pipe(struct ath10k *ar,
 						 u16 service_id,
 						 u8 *ul_pipe, u8 *dl_pipe)
diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 983ecfe..334a147 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -1615,12 +1615,33 @@ static int ath10k_sdio_hif_diag_write_mem(struct ath10k *ar, u32 address,
 	return 0;
 }
 
+static int ath10k_sdio_hif_swap_mailbox(struct ath10k *ar)
+{
+	struct ath10k_sdio *ar_sdio = ath10k_sdio_priv(ar);
+	u32 addr, val;
+	int ret = 0;
+
+	addr = host_interest_item_address(HI_ITEM(hi_acs_flags));
+
+	ret = ath10k_sdio_hif_diag_read32(ar, addr, &val);
+	if (ret) {
+		ath10k_warn(ar, "unable to read hi_acs_flags : %d\n", ret);
+		return ret;
+	}
+
+	if (val & HI_ACS_FLAGS_SDIO_SWAP_MAILBOX_FW_ACK) {
+		ath10k_dbg(ar, ATH10K_DBG_SDIO,
+			   "sdio mailbox swap service enabled\n");
+		ar_sdio->swap_mbox = true;
+	}
+	return 0;
+}
+
 /* HIF start/stop */
 
 static int ath10k_sdio_hif_start(struct ath10k *ar)
 {
 	struct ath10k_sdio *ar_sdio = ath10k_sdio_priv(ar);
-	u32 addr, val;
 	int ret;
 
 	/* Sleep 20 ms before HIF interrupts are disabled.
@@ -1654,20 +1675,6 @@ static int ath10k_sdio_hif_start(struct ath10k *ar)
 	if (ret)
 		ath10k_warn(ar, "failed to enable sdio interrupts: %d\n", ret);
 
-	addr = host_interest_item_address(HI_ITEM(hi_acs_flags));
-
-	ret = ath10k_sdio_hif_diag_read32(ar, addr, &val);
-	if (ret) {
-		ath10k_warn(ar, "unable to read hi_acs_flags address: %d\n", ret);
-		return ret;
-	}
-
-	if (val & HI_ACS_FLAGS_SDIO_SWAP_MAILBOX_FW_ACK) {
-		ath10k_dbg(ar, ATH10K_DBG_SDIO,
-			   "sdio mailbox swap service enabled\n");
-		ar_sdio->swap_mbox = true;
-	}
-
 	/* Enable sleep and then disable it again */
 	ret = ath10k_sdio_hif_set_mbox_sleep(ar, true);
 	if (ret)
@@ -1898,6 +1905,7 @@ static void ath10k_sdio_hif_send_complete_check(struct ath10k *ar,
 	.exchange_bmi_msg	= ath10k_sdio_bmi_exchange_msg,
 	.start			= ath10k_sdio_hif_start,
 	.stop			= ath10k_sdio_hif_stop,
+	.swap_mailbox		= ath10k_sdio_hif_swap_mailbox,
 	.map_service_to_pipe	= ath10k_sdio_hif_map_service_to_pipe,
 	.get_default_pipe	= ath10k_sdio_hif_get_default_pipe,
 	.send_complete_check	= ath10k_sdio_hif_send_complete_check,
-- 
1.9.1

