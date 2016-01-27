Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8120 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbcA0J6t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 04:58:49 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 10/12] ath10k: include irq related functions in ahb
Date: Wed, 27 Jan 2016 15:24:31 +0530
Message-ID: <1453888473-2879-11-git-send-email-rmani@qti.qualcomm.com> (sfid-20160127_105858_808549_B93E27E3)
In-Reply-To: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
References: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add irq related functions to register,handle,release,disable interrupt.

qca4019 supports msi interrupt, but it has the problem. Until the issue
gets sorted out, only legacy interrupt model is enabled and used.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ahb.c | 44 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/ahb.h |  2 ++
 2 files changed, 46 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index 2305078..29d0b6c 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -458,6 +458,50 @@ static void ath10k_ahb_halt_chip(struct ath10k *ar)
 	ath10k_dbg(ar, ATH10K_DBG_AHB, "core %d reset done\n", core_id);
 }
 
+static irqreturn_t ath10k_ahb_interrupt_handler(int irq, void *arg)
+{
+	struct ath10k *ar = arg;
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+
+	if (!ath10k_pci_irq_pending(ar))
+		return IRQ_NONE;
+
+	ath10k_pci_disable_and_clear_legacy_irq(ar);
+	tasklet_schedule(&ar_pci->intr_tq);
+
+	return IRQ_HANDLED;
+}
+
+static int ath10k_ahb_request_irq_legacy(struct ath10k *ar)
+{
+	struct ath10k_ahb *ar_ahb = ath10k_ahb_priv(ar);
+	int ret;
+
+	ret = request_irq(ar_ahb->irq,
+			  ath10k_ahb_interrupt_handler,
+			  IRQF_SHARED, "ath10k_ahb", ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to request legacy irq %d: %d\n",
+			    ar_ahb->irq, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void ath10k_ahb_release_irq_legacy(struct ath10k *ar)
+{
+	struct ath10k_ahb *ar_ahb = ath10k_ahb_priv(ar);
+
+	free_irq(ar_ahb->irq, ar);
+}
+
+static void ath10k_ahb_irq_disable(struct ath10k *ar)
+{
+	ath10k_ce_disable_interrupts(ar);
+	ath10k_pci_disable_and_clear_legacy_irq(ar);
+}
+
 static int ath10k_ahb_probe(struct platform_device *pdev)
 {
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/ahb.h b/drivers/net/wireless/ath/ath10k/ahb.h
index 4761eeb..97c40e4 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.h
+++ b/drivers/net/wireless/ath/ath10k/ahb.h
@@ -26,6 +26,8 @@ struct ath10k_ahb {
 	void __iomem *gcc_mem;
 	void __iomem *tcsr_mem;
 
+	int irq;
+
 	struct clk *cmd_clk;
 	struct clk *ref_clk;
 	struct clk *rtc_clk;
-- 
1.8.1.2

