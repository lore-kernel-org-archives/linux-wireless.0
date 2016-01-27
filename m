Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64218 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbcA0J5B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 04:57:01 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 03/12] ath10k: pull reusable code from pci probe and remove for ahb
Date: Wed, 27 Jan 2016 15:24:24 +0530
Message-ID: <1453888473-2879-4-git-send-email-rmani@qti.qualcomm.com> (sfid-20160127_105721_477068_397F3ECB)
In-Reply-To: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
References: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of the code present in ath10k_pci_{probe|remove} are reusable
in ahb case too. To avoid code duplication, move reusable code to
new functions. Later, those new functions can be called from ahb
module's probe and exit functions.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 64 +++++++++++++++++++++++------------
 drivers/net/wireless/ath/ath10k/pci.h |  2 ++
 2 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index c5f6604..6ef878c 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3009,6 +3009,37 @@ static bool ath10k_pci_chip_is_supported(u32 dev_id, u32 chip_id)
 	return false;
 }
 
+int ath10k_pci_setup_resource(struct ath10k *ar)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	int ret;
+
+	spin_lock_init(&ar_pci->ce_lock);
+	spin_lock_init(&ar_pci->ps_lock);
+
+	setup_timer(&ar_pci->rx_post_retry, ath10k_pci_rx_replenish_retry,
+		    (unsigned long)ar);
+
+	if (QCA_REV_6174(ar))
+		ath10k_pci_override_ce_config(ar);
+
+	ret = ath10k_pci_alloc_pipes(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to allocate copy engine pipes: %d\n",
+			   ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+void ath10k_pci_release_resource(struct ath10k *ar)
+{
+	ath10k_pci_kill_tasklet(ar);
+	ath10k_pci_ce_deinit(ar);
+	ath10k_pci_free_pipes(ar);
+}
+
 static const struct ath10k_bus_ops ath10k_pci_bus_ops = {
 	.read32		= ath10k_bus_pci_read32,
 	.write32	= ath10k_bus_pci_write32,
@@ -3072,34 +3103,25 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	ar->id.subsystem_vendor = pdev->subsystem_vendor;
 	ar->id.subsystem_device = pdev->subsystem_device;
 
-	spin_lock_init(&ar_pci->ce_lock);
-	spin_lock_init(&ar_pci->ps_lock);
-
-	setup_timer(&ar_pci->rx_post_retry, ath10k_pci_rx_replenish_retry,
-		    (unsigned long)ar);
 	setup_timer(&ar_pci->ps_timer, ath10k_pci_ps_timer,
 		    (unsigned long)ar);
 
-	ret = ath10k_pci_claim(ar);
+	ret = ath10k_pci_setup_resource(ar);
 	if (ret) {
-		ath10k_err(ar, "failed to claim device: %d\n", ret);
+		ath10k_err(ar, "failed to setup resource: %d\n", ret);
 		goto err_core_destroy;
 	}
 
-	if (QCA_REV_6174(ar))
-		ath10k_pci_override_ce_config(ar);
-
-	ret = ath10k_pci_alloc_pipes(ar);
+	ret = ath10k_pci_claim(ar);
 	if (ret) {
-		ath10k_err(ar, "failed to allocate copy engine pipes: %d\n",
-			   ret);
-		goto err_sleep;
+		ath10k_err(ar, "failed to claim device: %d\n", ret);
+		goto err_free_pipes;
 	}
 
 	ret = ath10k_pci_force_wake(ar);
 	if (ret) {
 		ath10k_warn(ar, "failed to wake up device : %d\n", ret);
-		goto err_free_pipes;
+		goto err_sleep;
 	}
 
 	ath10k_pci_ce_deinit(ar);
@@ -3108,7 +3130,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	ret = ath10k_pci_init_irq(ar);
 	if (ret) {
 		ath10k_err(ar, "failed to init irqs: %d\n", ret);
-		goto err_free_pipes;
+		goto err_sleep;
 	}
 
 	ath10k_info(ar, "pci irq %s interrupts %d irq_mode %d reset_mode %d\n",
@@ -3154,13 +3176,13 @@ err_free_irq:
 err_deinit_irq:
 	ath10k_pci_deinit_irq(ar);
 
-err_free_pipes:
-	ath10k_pci_free_pipes(ar);
-
 err_sleep:
 	ath10k_pci_sleep_sync(ar);
 	ath10k_pci_release(ar);
 
+err_free_pipes:
+	ath10k_pci_free_pipes(ar);
+
 err_core_destroy:
 	ath10k_core_destroy(ar);
 
@@ -3184,10 +3206,8 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
 
 	ath10k_core_unregister(ar);
 	ath10k_pci_free_irq(ar);
-	ath10k_pci_kill_tasklet(ar);
 	ath10k_pci_deinit_irq(ar);
-	ath10k_pci_ce_deinit(ar);
-	ath10k_pci_free_pipes(ar);
+	ath10k_pci_release_resource(ar);
 	ath10k_pci_sleep_sync(ar);
 	ath10k_pci_release(ar);
 	ath10k_core_destroy(ar);
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 41f3fac..fcfdbca 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -292,6 +292,8 @@ void ath10k_pci_enable_legacy_irq(struct ath10k *ar);
 bool ath10k_pci_irq_pending(struct ath10k *ar);
 void ath10k_pci_disable_and_clear_legacy_irq(struct ath10k *ar);
 int ath10k_pci_wait_for_target_init(struct ath10k *ar);
+int ath10k_pci_setup_resource(struct ath10k *ar);
+void ath10k_pci_release_resource(struct ath10k *ar);
 
 /* QCA6174 is known to have Tx/Rx issues when SOC_WAKE register is poked too
  * frequently. To avoid this put SoC to sleep after a very conservative grace
-- 
1.8.1.2

