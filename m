Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708E9C282C2
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 12:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C9102073D
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 12:14:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UjD2deek";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gykOVkqZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbfBFMOt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 07:14:49 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39998 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfBFMOt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 07:14:49 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AA2E760734; Wed,  6 Feb 2019 12:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549455287;
        bh=jKHLUWej1jhrFHTuQQbmpD6oqL01OWgNwKfbcgX2jZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UjD2deek/XIHBAHsq8JFjxxFuEbKD1iHi3F5NWTuLKcA6MyRs5ITeEMEjEeTsSl1U
         eiNElY1GKpqk4RZBfxg2vJlY+aX7XZIkQVj437rJpbO9/F7OCUdNGjl2T/NZ4mRpHc
         C1S/AwqWQwTKjd+1IxL/H5w43C98acs1GF1Yv2kA=
Received: from govinds-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: govinds@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BB461608EA;
        Wed,  6 Feb 2019 12:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549455286;
        bh=jKHLUWej1jhrFHTuQQbmpD6oqL01OWgNwKfbcgX2jZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gykOVkqZ34qWgol22QQ3i5fot5X+/Tv8gxMVVwS0tZjVocpxSXYqsZoncTDAWoSQy
         u7UORN83ZOhfU/re1dOv+CXMPWMGhe6C0gyqAUIkDG086DFispO/it1/+RTMA/cP5h
         aQzsb13MBoCTt6HqJ5kLejUoDywK3ibrRq2BQQyE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BB461608EA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=govinds@codeaurora.org
From:   Govind Singh <govinds@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v3 1/3] ath10k: Enable bus layer suspend/resume for WCN3990
Date:   Wed,  6 Feb 2019 17:44:31 +0530
Message-Id: <20190206121433.11606-2-govinds@codeaurora.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190206121433.11606-1-govinds@codeaurora.org>
References: <20190206121433.11606-1-govinds@codeaurora.org>
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
index dad7e1ce79c0..60e0f46cfdd9 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -30,6 +30,7 @@
 
 #define ATH10K_SNOC_RX_POST_RETRY_MS 50
 #define CE_POLL_PIPE 4
+#define ATH10K_SNOC_WAKE_IRQ 2
 
 static char *const ce_name[] = {
 	"WLAN_CE_0",
@@ -1041,6 +1042,46 @@ static int ath10k_snoc_hif_power_up(struct ath10k *ar)
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
@@ -1054,6 +1095,10 @@ static const struct ath10k_hif_ops ath10k_snoc_hif_ops = {
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

