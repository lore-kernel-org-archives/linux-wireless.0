Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:34302 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090AbbEaJgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 05:36:04 -0400
Received: by wgv5 with SMTP id 5so92564733wgv.1
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2015 02:36:03 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/9] staging: vt6655: use workqueue for interrupt handling
Date: Sun, 31 May 2015 10:35:24 +0100
Message-Id: <1433064928-2139-5-git-send-email-tvboxspy@gmail.com> (sfid-20150531_113610_954877_8CCB2206)
In-Reply-To: <1433064928-2139-1-git-send-email-tvboxspy@gmail.com>
References: <1433064928-2139-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce vnt_interrupt to handle interrupt and use workqueue
to queue and queue on vif.

Convert device_intr to void call vnt_interrupt_process
from vnt_interrupt_work providing vif is valid.

This removes troublesome heavy code from the interupt handler and
allows to remove atomic from other areas of driver.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      |  2 ++
 drivers/staging/vt6655/device_main.c | 36 ++++++++++++++++++++++++++----------
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index e9c4bf3..b928c2a 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -405,6 +405,8 @@ struct vnt_private {
 
 	unsigned short wBeaconInterval;
 
+	struct work_struct interrupt_work;
+
 	struct ieee80211_low_level_stats low_stats;
 };
 
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 31f4ec7..d5f090f 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -32,7 +32,6 @@
  *   device_free_info - device structure resource free function
  *   device_get_pci_info - get allocated pci io/mem resource
  *   device_print_info - print out resource
- *   device_intr - interrupt handle function
  *   device_rx_srv - rx service function
  *   device_alloc_rx_buf - rx buffer pre-allocated function
  *   device_free_tx_buf - free tx buffer function
@@ -148,7 +147,6 @@ static void vt6655_init_info(struct pci_dev *pcid,
 static void device_free_info(struct vnt_private *pDevice);
 static bool device_get_pci_info(struct vnt_private *, struct pci_dev *pcid);
 static void device_print_info(struct vnt_private *pDevice);
-static  irqreturn_t  device_intr(int irq,  void *dev_instance);
 
 #ifdef CONFIG_PM
 static int device_notify_reboot(struct notifier_block *, unsigned long event, void *ptr);
@@ -1053,27 +1051,24 @@ static void vnt_check_bb_vga(struct vnt_private *priv)
 	}
 }
 
-static  irqreturn_t  device_intr(int irq,  void *dev_instance)
+static void vnt_interrupt_process(struct vnt_private *pDevice)
 {
-	struct vnt_private *pDevice = dev_instance;
 	struct ieee80211_low_level_stats *low_stats = &pDevice->low_stats;
 	int             max_count = 0;
 	u32 mib_counter;
 	unsigned char byOrgPageSel = 0;
-	int             handled = 0;
 	unsigned long flags;
 
 	MACvReadISR(pDevice->PortOffset, &pDevice->dwIsr);
 
 	if (pDevice->dwIsr == 0)
-		return IRQ_RETVAL(handled);
+		return;
 
 	if (pDevice->dwIsr == 0xffffffff) {
 		pr_debug("dwIsr = 0xffff\n");
-		return IRQ_RETVAL(handled);
+		return;
 	}
 
-	handled = 1;
 	MACvIntDisable(pDevice->PortOffset);
 
 	spin_lock_irqsave(&pDevice->lock, flags);
@@ -1175,8 +1170,25 @@ static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 	spin_unlock_irqrestore(&pDevice->lock, flags);
 
 	MACvIntEnable(pDevice->PortOffset, IMR_MASK_VALUE);
+}
+
+static void vnt_interrupt_work(struct work_struct *work)
+{
+	struct vnt_private *priv =
+		container_of(work, struct vnt_private, interrupt_work);
+
+	if (priv->vif)
+		vnt_interrupt_process(priv);
+}
+
+static irqreturn_t vnt_interrupt(int irq,  void *arg)
+{
+	struct vnt_private *priv = arg;
 
-	return IRQ_RETVAL(handled);
+	if (priv->vif)
+		schedule_work(&priv->interrupt_work);
+
+	return IRQ_HANDLED;
 }
 
 static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
@@ -1268,7 +1280,7 @@ static int vnt_start(struct ieee80211_hw *hw)
 	if (!device_init_rings(priv))
 		return -ENOMEM;
 
-	ret = request_irq(priv->pcid->irq, &device_intr,
+	ret = request_irq(priv->pcid->irq, &vnt_interrupt,
 			  IRQF_SHARED, "vt6655", priv);
 	if (ret) {
 		dev_dbg(&priv->pcid->dev, "failed to start irq\n");
@@ -1297,6 +1309,8 @@ static void vnt_stop(struct ieee80211_hw *hw)
 
 	ieee80211_stop_queues(hw);
 
+	cancel_work_sync(&priv->interrupt_work);
+
 	MACbShutdown(priv->PortOffset);
 	MACbSoftwareReset(priv->PortOffset);
 	CARDbRadioPowerOff(priv);
@@ -1783,6 +1797,8 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 		return -ENODEV;
 	}
 
+	INIT_WORK(&priv->interrupt_work, vnt_interrupt_work);
+
 	/* do reset */
 	if (!MACbSoftwareReset(priv->PortOffset)) {
 		dev_err(&pcid->dev, ": Failed to access MAC hardware..\n");
-- 
2.1.4

