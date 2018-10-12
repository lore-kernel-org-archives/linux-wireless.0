Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13565C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 09:49:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 875AB2075B
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 09:49:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gQVGofdg";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gQVGofdg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 875AB2075B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbeJLRVW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 13:21:22 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59312 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727808AbeJLRVW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 13:21:22 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A4ACD60AD8; Fri, 12 Oct 2018 09:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539337785;
        bh=2MqALgetTAkw4UJEjOiE/NyIA+i59WNWFYofGUX8qY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQVGofdgbiSzwUtUBIQcur2aSQnKtKNV++dIPy9qUI9kaINT8wha3FQZo3CEqz4HZ
         5YzZlyunsQQZtE0C4VS7CCtY79wFWO/PTP5SFm1mLT4xZ+ZvqgwhgOJyfialt/CcdJ
         1cF+rYapLOzfRpkKzZFiZATreve+u2xq6N/PTns0=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E82AF60791;
        Fri, 12 Oct 2018 09:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539337785;
        bh=2MqALgetTAkw4UJEjOiE/NyIA+i59WNWFYofGUX8qY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQVGofdgbiSzwUtUBIQcur2aSQnKtKNV++dIPy9qUI9kaINT8wha3FQZo3CEqz4HZ
         5YzZlyunsQQZtE0C4VS7CCtY79wFWO/PTP5SFm1mLT4xZ+ZvqgwhgOJyfialt/CcdJ
         1cF+rYapLOzfRpkKzZFiZATreve+u2xq6N/PTns0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E82AF60791
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v2 1/3] ath10k: Enable bus layer suspend/resume for WCN3990
Date:   Fri, 12 Oct 2018 15:19:36 +0530
Message-Id: <20181012094938.14734-2-govinds@codeaurora.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181012094938.14734-1-govinds@codeaurora.org>
References: <20181012094938.14734-1-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Register snoc bus layer suspend/resume PM ops and configure
the wakeup source(CE2) for the device.

Testing:
    Tested on WCN3990 HW.
    Tested FW: WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 45 ++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index bdef3d00f3f4..3f935c5ce8a8 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -30,6 +30,7 @@
 
 #define ATH10K_SNOC_RX_POST_RETRY_MS 50
 #define CE_POLL_PIPE 4
+#define ATH10K_SNOC_WAKE_IRQ 2
 
 static char *const ce_name[] = {
 	"WLAN_CE_0",
@@ -1025,6 +1026,46 @@ static int ath10k_snoc_hif_power_up(struct ath10k *ar)
 	return ret;
 }
 
+#ifdef CONFIG_PM
+static int ath10k_snoc_hif_suspend(struct ath10k *ar)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	int ret;
+
+	if (!device_may_wakeup(ar->dev))
+		return -EPERM;
+
+	ret = enable_irq_wake(ar_snoc->ce_irqs[ATH10K_SNOC_WAKE_IRQ].irq_line);
+	if (ret) {
+		ath10k_err(ar, "failed to enable wakeup irq :%d\n", ret);
+		return ret;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc device suspended\n");
+
+	return ret;
+}
+
+static int ath10k_snoc_hif_resume(struct ath10k *ar)
+{
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+	int ret;
+
+	if (!device_may_wakeup(ar->dev))
+		return -EPERM;
+
+	ret = disable_irq_wake(ar_snoc->ce_irqs[ATH10K_SNOC_WAKE_IRQ].irq_line);
+	if (ret) {
+		ath10k_err(ar, "failed to disable wakeup irq: %d\n", ret);
+		return ret;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc device resumed\n");
+
+	return ret;
+}
+#endif
+
 static const struct ath10k_hif_ops ath10k_snoc_hif_ops = {
 	.read32		= ath10k_snoc_read32,
 	.write32	= ath10k_snoc_write32,
@@ -1038,6 +1079,10 @@ static const struct ath10k_hif_ops ath10k_snoc_hif_ops = {
 	.send_complete_check	= ath10k_snoc_hif_send_complete_check,
 	.get_free_queue_number	= ath10k_snoc_hif_get_free_queue_number,
 	.get_target_info	= ath10k_snoc_hif_get_target_info,
+#ifdef CONFIG_PM
+	.suspend                = ath10k_snoc_hif_suspend,
+	.resume                 = ath10k_snoc_hif_resume,
+#endif
 };
 
 static const struct ath10k_bus_ops ath10k_snoc_bus_ops = {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

