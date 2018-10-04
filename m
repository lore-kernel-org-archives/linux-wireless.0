Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC1BCC64EBC
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 13:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77B792084D
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 13:08:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UazaXJ1l";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UazaXJ1l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77B792084D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbeJDUCC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 16:02:02 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38264 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727367AbeJDUCB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 16:02:01 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D0C8260242; Thu,  4 Oct 2018 13:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538658527;
        bh=elvIYXb0Ig7CBTG46e+W1sKl0PbAiqg2jZV18rnPRZI=;
        h=From:To:Cc:Subject:Date:From;
        b=UazaXJ1lPdYYB59HhzVSh4MOVbfkZrYSMP5VcojcEtZWtbG6EhkaStGUNieLDqxKX
         DxPRhrSLMImi/8+7YBxVJv69gkfaQme3t67FpIZapFcGXdwBocd39XZRv3eZiDy+OC
         m2juB1wSCBqWeoO6KAE7Q+sRh3UqMQ1VnOoC4e6U=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A0A0F60BE3;
        Thu,  4 Oct 2018 13:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538658527;
        bh=elvIYXb0Ig7CBTG46e+W1sKl0PbAiqg2jZV18rnPRZI=;
        h=From:To:Cc:Subject:Date:From;
        b=UazaXJ1lPdYYB59HhzVSh4MOVbfkZrYSMP5VcojcEtZWtbG6EhkaStGUNieLDqxKX
         DxPRhrSLMImi/8+7YBxVJv69gkfaQme3t67FpIZapFcGXdwBocd39XZRv3eZiDy+OC
         m2juB1wSCBqWeoO6KAE7Q+sRh3UqMQ1VnOoC4e6U=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A0A0F60BE3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH] ath10k: Add support for WCN3990 firmware crash recovery
Date:   Thu,  4 Oct 2018 18:38:32 +0530
Message-Id: <1538658512-31867-1-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Surabhi Vishnoi <svishnoi@codeaurora.org>

Whenever the WCN3990 firmware becomes unavailable,
the host driver receives a FW down indication, post
which all the direct hardware register access should
be avoided, in order to prevent improper behavior in
the host driver.

Set the crash_flush flag when the host driver receives
a FW_DOWN_IND via qmi, in order to stop the untimely
hardware register access. Also handle the case, where
we need to do core register only for the first FW_READY
indication, which is when we initialize the host driver.
All the subsequent FW_READY indication will be received
in subsystem recovery case and we only need to do the
restart work. The state of driver is maintained using
flags to distinguish between first and subsequent FW_READY
indication received.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c |  3 +++
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/snoc.c | 39 +++++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath10k/snoc.h |  7 ++++++
 4 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 9aa72da..9d0b351 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2184,6 +2184,8 @@ static void ath10k_core_restart(struct work_struct *work)
 	if (ret)
 		ath10k_warn(ar, "failed to send firmware crash dump via devcoredump: %d",
 			    ret);
+
+	complete(&ar->driver_recovery);
 }
 
 static void ath10k_core_set_coverage_class_work(struct work_struct *work)
@@ -3047,6 +3049,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 	init_completion(&ar->scan.completed);
 	init_completion(&ar->scan.on_channel);
 	init_completion(&ar->target_suspend);
+	init_completion(&ar->driver_recovery);
 	init_completion(&ar->wow.wakeup_completed);
 
 	init_completion(&ar->install_key_done);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index f66b46b..1376fc5 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -962,6 +962,7 @@ struct ath10k {
 	} hif;
 
 	struct completion target_suspend;
+	struct completion driver_recovery;
 
 	const struct ath10k_hw_regs *regs;
 	const struct ath10k_hw_ce_regs *hw_ce_regs;
diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index bdffc4e..178840a 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -918,7 +918,9 @@ static void ath10k_snoc_buffer_cleanup(struct ath10k *ar)
 
 static void ath10k_snoc_hif_stop(struct ath10k *ar)
 {
-	ath10k_snoc_irq_disable(ar);
+	if (!test_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags))
+		ath10k_snoc_irq_disable(ar);
+
 	napi_synchronize(&ar->napi);
 	napi_disable(&ar->napi);
 	ath10k_snoc_buffer_cleanup(ar);
@@ -927,10 +929,14 @@ static void ath10k_snoc_hif_stop(struct ath10k *ar)
 
 static int ath10k_snoc_hif_start(struct ath10k *ar)
 {
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
+
 	napi_enable(&ar->napi);
 	ath10k_snoc_irq_enable(ar);
 	ath10k_snoc_rx_post(ar);
 
+	clear_bit(ATH10K_SNOC_FLAG_RECOVERY, &ar_snoc->flags);
+
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif start\n");
 
 	return 0;
@@ -994,7 +1000,8 @@ static int ath10k_snoc_wlan_enable(struct ath10k *ar)
 
 static void ath10k_snoc_wlan_disable(struct ath10k *ar)
 {
-	ath10k_qmi_wlan_disable(ar);
+	if (!test_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags))
+		ath10k_qmi_wlan_disable(ar);
 }
 
 static void ath10k_snoc_hif_power_down(struct ath10k *ar)
@@ -1091,6 +1098,11 @@ static int ath10k_snoc_napi_poll(struct napi_struct *ctx, int budget)
 	struct ath10k *ar = container_of(ctx, struct ath10k, napi);
 	int done = 0;
 
+	if (test_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags)) {
+		napi_complete(ctx);
+		return done;
+	}
+
 	ath10k_ce_per_engine_service_any(ar);
 	done = ath10k_htt_txrx_compl_task(ar, budget);
 
@@ -1187,17 +1199,29 @@ int ath10k_snoc_fw_indication(struct ath10k *ar, u64 type)
 	struct ath10k_bus_params bus_params;
 	int ret;
 
+	if (test_bit(ATH10K_SNOC_FLAG_UNREGISTERING, &ar_snoc->flags))
+		return 0;
+
 	bus_params.chip_id = ar_snoc->target_info.soc_version;
 
 	switch (type) {
 	case ATH10K_QMI_EVENT_FW_READY_IND:
+		if (test_bit(ATH10K_SNOC_FLAG_REGISTERED, &ar_snoc->flags)) {
+			queue_work(ar->workqueue, &ar->restart_work);
+			break;
+		}
+
 		ret = ath10k_core_register(ar, &bus_params);
 		if (ret) {
-			ath10k_err(ar, "failed to register driver core: %d\n",
+			ath10k_err(ar, "Failed to register driver core: %d\n",
 				   ret);
+			return ret;
 		}
+		set_bit(ATH10K_SNOC_FLAG_REGISTERED, &ar_snoc->flags);
 		break;
 	case ATH10K_QMI_EVENT_FW_DOWN_IND:
+		set_bit(ATH10K_SNOC_FLAG_RECOVERY, &ar_snoc->flags);
+		set_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
 		break;
 	default:
 		ath10k_err(ar, "invalid fw indication: %llx\n", type);
@@ -1631,8 +1655,17 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
 static int ath10k_snoc_remove(struct platform_device *pdev)
 {
 	struct ath10k *ar = platform_get_drvdata(pdev);
+	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
 
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc remove\n");
+
+	reinit_completion(&ar->driver_recovery);
+
+	if (test_bit(ATH10K_SNOC_FLAG_RECOVERY, &ar_snoc->flags))
+		wait_for_completion_timeout(&ar->driver_recovery, 3 * HZ);
+
+	set_bit(ATH10K_SNOC_FLAG_UNREGISTERING, &ar_snoc->flags);
+
 	ath10k_core_unregister(ar);
 	ath10k_hw_power_off(ar);
 	ath10k_snoc_free_irq(ar);
diff --git a/drivers/net/wireless/ath/ath10k/snoc.h b/drivers/net/wireless/ath/ath10k/snoc.h
index e1d2d66..3a44e30 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.h
+++ b/drivers/net/wireless/ath/ath10k/snoc.h
@@ -70,6 +70,12 @@ struct ath10k_wcn3990_clk_info {
 	bool required;
 };
 
+enum ath10k_snoc_flags {
+	ATH10K_SNOC_FLAG_REGISTERED,
+	ATH10K_SNOC_FLAG_UNREGISTERING,
+	ATH10K_SNOC_FLAG_RECOVERY,
+};
+
 struct ath10k_snoc {
 	struct platform_device *dev;
 	struct ath10k *ar;
@@ -84,6 +90,7 @@ struct ath10k_snoc {
 	struct ath10k_wcn3990_vreg_info *vreg;
 	struct ath10k_wcn3990_clk_info *clk;
 	struct ath10k_qmi *qmi;
+	unsigned long int flags;
 };
 
 static inline struct ath10k_snoc *ath10k_snoc_priv(struct ath10k *ar)
-- 
2.7.4

