Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:43876 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaJYTIv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:08:51 -0400
Received: by mail-wi0-f169.google.com with SMTP id q5so3340674wiv.0
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:08:50 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/31] staging: vt6655: mac80211 conversion replace suspend resume functions
Date: Sat, 25 Oct 2014 09:20:20 +0100
Message-Id: <1414225241-5480-11-git-send-email-tvboxspy@gmail.com> (sfid-20141025_210855_443215_7EA9A82A)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add vt6655_suspend and vt6655_resume

remove viawget_suspend and viawget_resume.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 104 ++++++++++++-----------------------
 1 file changed, 34 insertions(+), 70 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 054841b..b0f94a8 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -274,8 +274,6 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 
 #ifdef CONFIG_PM
 static int device_notify_reboot(struct notifier_block *, unsigned long event, void *ptr);
-static int viawget_suspend(struct pci_dev *pcid, pm_message_t state);
-static int viawget_resume(struct pci_dev *pcid);
 static struct notifier_block device_notifier = {
 	.notifier_call = device_notify_reboot,
 	.next = NULL,
@@ -3482,6 +3480,37 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 
 /*------------------------------------------------------------------*/
 
+#ifdef CONFIG_PM
+static int vt6655_suspend(struct pci_dev *pcid, pm_message_t state)
+{
+	struct vnt_private *priv = pci_get_drvdata(pcid);
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	pci_save_state(pcid);
+
+	MACbShutdown(priv->PortOffset);
+
+	pci_disable_device(pcid);
+	pci_set_power_state(pcid, pci_choose_state(pcid, state));
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
+}
+
+static int vt6655_resume(struct pci_dev *pcid)
+{
+
+	pci_set_power_state(pcid, PCI_D0);
+	pci_enable_wake(pcid, PCI_D0, 0);
+	pci_restore_state(pcid);
+
+	return 0;
+}
+#endif
+
 MODULE_DEVICE_TABLE(pci, vt6655_pci_id_table);
 
 static struct pci_driver device_driver = {
@@ -3490,8 +3519,8 @@ static struct pci_driver device_driver = {
 	.probe = vt6655_probe,
 	.remove = vt6655_remove,
 #ifdef CONFIG_PM
-	.suspend = viawget_suspend,
-	.resume = viawget_resume,
+	.suspend = vt6655_suspend,
+	.resume = vt6655_resume,
 #endif
 };
 
@@ -3532,75 +3561,10 @@ device_notify_reboot(struct notifier_block *nb, unsigned long event, void *p)
 		for_each_pci_dev(pdev) {
 			if (pci_dev_driver(pdev) == &device_driver) {
 				if (pci_get_drvdata(pdev))
-					viawget_suspend(pdev, PMSG_HIBERNATE);
+					vt6655_suspend(pdev, PMSG_HIBERNATE);
 			}
 		}
 	}
 	return NOTIFY_DONE;
 }
-
-static int
-viawget_suspend(struct pci_dev *pcid, pm_message_t state)
-{
-	int power_status;   // to silence the compiler
-
-	struct vnt_private *pDevice = pci_get_drvdata(pcid);
-	PSMgmtObject  pMgmt = pDevice->pMgmt;
-
-	netif_stop_queue(pDevice->dev);
-	spin_lock_irq(&pDevice->lock);
-	pci_save_state(pcid);
-	del_timer(&pDevice->sTimerCommand);
-	del_timer(&pMgmt->sTimerSecondCallback);
-	pDevice->cbFreeCmdQueue = CMD_Q_SIZE;
-	pDevice->uCmdDequeueIdx = 0;
-	pDevice->uCmdEnqueueIdx = 0;
-	pDevice->bCmdRunning = false;
-	MACbShutdown(pDevice->PortOffset);
-	MACvSaveContext(pDevice->PortOffset, pDevice->abyMacContext);
-	pDevice->bLinkPass = false;
-	memset(pMgmt->abyCurrBSSID, 0, 6);
-	pMgmt->eCurrState = WMAC_STATE_IDLE;
-	pci_disable_device(pcid);
-	power_status = pci_set_power_state(pcid, pci_choose_state(pcid, state));
-	spin_unlock_irq(&pDevice->lock);
-	return 0;
-}
-
-static int
-viawget_resume(struct pci_dev *pcid)
-{
-	struct vnt_private *pDevice = pci_get_drvdata(pcid);
-	PSMgmtObject  pMgmt = pDevice->pMgmt;
-	int power_status;   // to silence the compiler
-
-	power_status = pci_set_power_state(pcid, PCI_D0);
-	power_status = pci_enable_wake(pcid, PCI_D0, 0);
-	pci_restore_state(pcid);
-	if (netif_running(pDevice->dev)) {
-		spin_lock_irq(&pDevice->lock);
-		MACvRestoreContext(pDevice->PortOffset, pDevice->abyMacContext);
-		device_init_registers(pDevice);
-		if (pMgmt->sNodeDBTable[0].bActive) { // Assoc with BSS
-			pMgmt->sNodeDBTable[0].bActive = false;
-			pDevice->bLinkPass = false;
-			if (pMgmt->eCurrMode == WMAC_MODE_IBSS_STA) {
-				// In Adhoc, BSS state set back to started.
-				pMgmt->eCurrState = WMAC_STATE_STARTED;
-			} else {
-				pMgmt->eCurrMode = WMAC_MODE_STANDBY;
-				pMgmt->eCurrState = WMAC_STATE_IDLE;
-			}
-		}
-		init_timer(&pMgmt->sTimerSecondCallback);
-		init_timer(&pDevice->sTimerCommand);
-		MACvIntEnable(pDevice->PortOffset, IMR_MASK_VALUE);
-		BSSvClearBSSList((void *)pDevice, pDevice->bLinkPass);
-		bScheduleCommand((void *)pDevice, WLAN_CMD_BSSID_SCAN, NULL);
-		bScheduleCommand((void *)pDevice, WLAN_CMD_SSID, NULL);
-		spin_unlock_irq(&pDevice->lock);
-	}
-	return 0;
-}
-
 #endif
-- 
1.9.1

