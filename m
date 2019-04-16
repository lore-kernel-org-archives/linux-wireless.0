Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D73BC10F13
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 09:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5070D20821
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 09:28:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XFDb+VBf";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="a/vFakdF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbfDPJ2i (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 05:28:38 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41404 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728847AbfDPJ2D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 05:28:03 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 343E3613A7; Tue, 16 Apr 2019 09:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555406882;
        bh=MTMnAmP9HDvr/OdAUXr3/nZp14AOAWPije+B1qKu478=;
        h=From:To:Cc:Subject:Date:From;
        b=XFDb+VBf5RHADPqG8QLeDfeWMWmCxWaum4UclvrsYD4mgHnlGHIAPvO6DceKVGLhe
         iYqjZ2FVKfLWnqeubrykAeUf8xf0dS2LenmtDmXvii7McdjBKD00DU2SOMF4woL8Zx
         lyK+k5FVbwQbHta0+efLlCH+KhwYI7AHsFAWU+2E=
Received: from localhost.localdomain (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wgong@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 34A1460A60;
        Tue, 16 Apr 2019 09:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555406881;
        bh=MTMnAmP9HDvr/OdAUXr3/nZp14AOAWPije+B1qKu478=;
        h=From:To:Cc:Subject:Date:From;
        b=a/vFakdFxoGuoK1EDLBa2j36sSORgPaO9f5Xeq9SQPzp+/rktfYrWITTwHHtcqiNm
         CC/NbHSjQDcmaXCYJ4wt23/umtdcOZOqCumBmADBIEH+gv5bXb3KH4cVPa9IbaAHq3
         0j18n7dJ4pS/L3YXdYzqQY5VZ+8V19OSLg2HyCLs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 34A1460A60
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=wgong@codeaurora.org
From:   Wen Gong <wgong@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: add support for simulate crash on SDIO chip
Date:   Tue, 16 Apr 2019 17:27:45 +0800
Message-Id: <1555406865-21514-1-git-send-email-wgong@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The command to simulate firmware crash:
echo soft > /sys/kernel/debug/ieee80211/phy0/ath10k/simulate_fw_crash

It will send WMI_FORCE_FW_HANG_ASSERT to firmware, then it will trigger
CPU interrupt status register for SDIO chip, ath10k driver need to
configure it while enable SDIO interrupt, otherwise ath10k driver will
not get the assert error info.

After this change, it will success for simulate firmware crash.

Tested with QCA6174 SDIO with firmware
WLAN.RMH.4.4.1-00007-QCARMSWP-1.

Signed-off-by: Wen Gong <wgong@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/hw.h   | 1 +
 drivers/net/wireless/ath/ath10k/sdio.c | 8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 7131499..60521ed 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -1095,6 +1095,7 @@ struct ath10k_hw_ops {
 #define MBOX_CPU_INT_STATUS_ENABLE_ADDRESS	0x00000819
 #define MBOX_CPU_INT_STATUS_ENABLE_BIT_LSB	0
 #define MBOX_CPU_INT_STATUS_ENABLE_BIT_MASK	0x000000ff
+#define MBOX_CPU_STATUS_ENABLE_ASSERT_MASK 0x00000001
 #define MBOX_ERROR_STATUS_ENABLE_ADDRESS	0x0000081a
 #define MBOX_ERROR_STATUS_ENABLE_RX_UNDERFLOW_LSB  1
 #define MBOX_ERROR_STATUS_ENABLE_RX_UNDERFLOW_MASK 0x00000002
diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index fae56c6..78a2f3b 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -850,6 +850,8 @@ static int ath10k_sdio_mbox_proc_cpu_intr(struct ath10k *ar)
 
 out:
 	mutex_unlock(&irq_data->mtx);
+	ath10k_err(ar, "firmware crashed!\n");
+	queue_work(ar->workqueue, &ar->restart_work);
 	return ret;
 }
 
@@ -1495,8 +1497,10 @@ static int ath10k_sdio_hif_enable_intrs(struct ath10k *ar)
 	regs->int_status_en |=
 		FIELD_PREP(MBOX_INT_STATUS_ENABLE_MBOX_DATA_MASK, 1);
 
-	/* Set up the CPU Interrupt status Register */
-	regs->cpu_int_status_en = 0;
+	/* Set up the CPU Interrupt Status Register, enable CPU sourced interrupt #0
+	 * #0 is used for report assertion from target
+	 */
+	regs->cpu_int_status_en = FIELD_PREP(MBOX_CPU_STATUS_ENABLE_ASSERT_MASK, 1);
 
 	/* Set up the Error Interrupt status Register */
 	regs->err_int_status_en =
-- 
1.9.1

