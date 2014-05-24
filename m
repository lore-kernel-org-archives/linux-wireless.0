Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:35084 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaEXNiD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2014 09:38:03 -0400
Received: by mail-we0-f180.google.com with SMTP id t61so6055547wes.39
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2014 06:38:01 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/14] staging: vt6656: Convert remaining locks to spin_lock_irqsave.
Date: Sat, 24 May 2014 14:36:57 +0100
Message-Id: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com> (sfid-20140524_153811_861932_7BF2967C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert all remaining locks to spin_lock_irqsave and
spin_unlock_irqrestore

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/dpc.c   |  5 +++--
 drivers/staging/vt6656/int.c   |  5 +++--
 drivers/staging/vt6656/iwctl.c | 17 ++++++++++++-----
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 286e735..c0ec5b3 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -863,13 +863,14 @@ void RXvWorkItem(struct work_struct *work)
 		container_of(work, struct vnt_private, read_work_item);
 	int status;
 	struct vnt_rcb *rcb = NULL;
+	unsigned long flags;
 
 	if (priv->Flags & fMP_DISCONNECTED)
 		return;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Rx Polling Thread\n");
 
-	spin_lock_irq(&priv->lock);
+	spin_lock_irqsave(&priv->lock, flags);
 
 	while ((priv->Flags & fMP_POST_READS) && MP_IS_READY(priv) &&
 			(priv->NumRecvFreeList != 0)) {
@@ -884,7 +885,7 @@ void RXvWorkItem(struct work_struct *work)
 
 	priv->bIsRxWorkItemQueued = false;
 
-	spin_unlock_irq(&priv->lock);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 void RXvFreeRCB(struct vnt_rcb *rcb, int re_alloc_skb)
diff --git a/drivers/staging/vt6656/int.c b/drivers/staging/vt6656/int.c
index cca56b2..f2a5225 100644
--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -65,15 +65,16 @@ static int msglevel = MSG_LEVEL_INFO; /* MSG_LEVEL_DEBUG */
 -*/
 void INTvWorkItem(struct vnt_private *pDevice)
 {
+	unsigned long flags;
 	int ntStatus;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Interrupt Polling Thread\n");
 
-	spin_lock_irq(&pDevice->lock);
+	spin_lock_irqsave(&pDevice->lock, flags);
 
 	ntStatus = PIPEnsInterruptRead(pDevice);
 
-	spin_unlock_irq(&pDevice->lock);
+	spin_unlock_irqrestore(&pDevice->lock, flags);
 }
 
 void INTnsProcessData(struct vnt_private *priv)
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 3edeb2f..e7b7ca5 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -91,6 +91,7 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 	struct iw_scan_req *req = (struct iw_scan_req *)extra;
 	u8 abyScanSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
 	PWLAN_IE_SSID pItemSSID = NULL;
+	unsigned long flags;
 
 	if (!(pDevice->flags & DEVICE_FLAGS_OPENED))
 		return -EINVAL;
@@ -115,7 +116,7 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 		return 0;
 	}
 
-	spin_lock_irq(&pDevice->lock);
+	spin_lock_irqsave(&pDevice->lock, flags);
 
 	BSSvClearBSSList((void *)pDevice, pDevice->bLinkPass);
 
@@ -136,7 +137,8 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 			PRINT_K("SIOCSIWSCAN:[desired_ssid=%s,len=%d]\n", ((PWLAN_IE_SSID)abyScanSSID)->abySSID,
 				((PWLAN_IE_SSID)abyScanSSID)->len);
 			bScheduleCommand((void *)pDevice, WLAN_CMD_BSSID_SCAN, abyScanSSID);
-			spin_unlock_irq(&pDevice->lock);
+
+			spin_unlock_irqrestore(&pDevice->lock, flags);
 
 			return 0;
 		} else if (req->scan_type == IW_SCAN_TYPE_PASSIVE) { // passive scan
@@ -148,7 +150,8 @@ int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 
 	pMgmt->eScanType = WMAC_SCAN_PASSIVE;
 	bScheduleCommand((void *)pDevice, WLAN_CMD_BSSID_SCAN, NULL);
-	spin_unlock_irq(&pDevice->lock);
+
+	spin_unlock_irqrestore(&pDevice->lock, flags);
 
 	return 0;
 }
@@ -375,6 +378,7 @@ int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 	struct vnt_private *pDevice = netdev_priv(dev);
 	__u32 *wmode = &wrqu->mode;
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
+	unsigned long flags;
 	int rc = 0;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWMODE\n");
@@ -415,10 +419,13 @@ int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 	if (pDevice->bCommit) {
 		if (pMgmt->eConfigMode == WMAC_CONFIG_AP) {
 			netif_stop_queue(pDevice->dev);
-			spin_lock_irq(&pDevice->lock);
+
+			spin_lock_irqsave(&pDevice->lock, flags);
+
 			bScheduleCommand((void *) pDevice,
 				WLAN_CMD_RUN_AP, NULL);
-			spin_unlock_irq(&pDevice->lock);
+
+			spin_unlock_irqrestore(&pDevice->lock, flags);
 		} else {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 				"Commit the settings\n");
-- 
1.9.1

