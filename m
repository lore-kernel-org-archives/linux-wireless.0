Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:53985 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbaFYUP0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:15:26 -0400
Received: by mail-wi0-f175.google.com with SMTP id r20so8602287wiv.2
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:15:24 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/17] staging: vt6656: mac80211 conversion: add vnt_init to bScheduleCommand
Date: Wed, 25 Jun 2014 21:14:27 +0100
Message-Id: <1403727278-6666-7-git-send-email-tvboxspy@gmail.com> (sfid-20140625_221545_667519_C7F25C2E)
In-Reply-To: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
References: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

start driver by linking vnt_init to vt6656_probe use bScheduleCommand
to schedule new command WLAN_CMD_INIT_MAC80211

vResetCommandTimer is now used to initiate command timer.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   |  2 ++
 drivers/staging/vt6656/main_usb.c | 10 +++++++++-
 drivers/staging/vt6656/wcmd.c     | 19 +++++++++++++++++--
 drivers/staging/vt6656/wcmd.h     |  2 ++
 4 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 46d7704..46584c7 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -397,6 +397,7 @@ struct vnt_private {
 	/* mac80211 */
 	struct ieee80211_hw *hw;
 	struct ieee80211_vif *vif;
+	u8 mac_hw;
 	/* netdev */
 	struct usb_device *usb;
 	struct net_device *dev;
@@ -744,5 +745,6 @@ struct vnt_private {
 
 int device_alloc_frag_buf(struct vnt_private *, PSDeFragControlBlock pDeF);
 void vnt_configure_filter(struct vnt_private *);
+int vnt_init(struct vnt_private *priv);
 
 #endif
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 663ea0c..ee63390 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1383,6 +1383,8 @@ int vnt_init(struct vnt_private *priv)
 	if (ieee80211_register_hw(priv->hw))
 		return -ENODEV;
 
+	priv->mac_hw = true;
+
 	return 0;
 }
 
@@ -1443,6 +1445,11 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	usb_device_reset(priv);
 
+	MP_CLEAR_FLAG(priv, fMP_DISCONNECTED);
+	vResetCommandTimer(priv);
+
+	bScheduleCommand(priv, WLAN_CMD_INIT_MAC80211, NULL);
+
 	return 0;
 
 err_nomem:
@@ -1458,7 +1465,8 @@ static void vt6656_disconnect(struct usb_interface *intf)
 	if (!priv)
 		return;
 
-	ieee80211_unregister_hw(priv->hw);
+	if (priv->mac_hw)
+		ieee80211_unregister_hw(priv->hw);
 
 	usb_set_intfdata(intf, NULL);
 	usb_put_dev(interface_to_usbdev(intf));
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 4c37908..85adc1c 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -287,7 +287,20 @@ void vRunCommand(struct work_struct *work)
 		return;
 
 	switch (pDevice->eCommandState) {
+	case WLAN_CMD_INIT_MAC80211_START:
+		if (pDevice->mac_hw)
+			break;
+
+		dev_info(&pDevice->usb->dev, "Starting mac80211\n");
+
+		if (vnt_init(pDevice)) {
+			/* If fail all ends TODO retry */
+			dev_err(&pDevice->usb->dev, "failed to start\n");
+			ieee80211_free_hw(pDevice->hw);
+			return;
+		}
 
+		break;
 	case WLAN_CMD_SCAN_START:
 
 		pDevice->byReAssocCount = 0;
@@ -915,6 +928,10 @@ static int s_bCommandComplete(struct vnt_private *pDevice)
 		pDevice->cbFreeCmdQueue++;
 		pDevice->bCmdRunning = true;
 		switch (pDevice->eCommand) {
+		case WLAN_CMD_INIT_MAC80211:
+			pDevice->eCommandState = WLAN_CMD_INIT_MAC80211_START;
+			break;
+
 		case WLAN_CMD_BSSID_SCAN:
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"eCommandState= WLAN_CMD_BSSID_SCAN\n");
 			pDevice->eCommandState = WLAN_CMD_SCAN_START;
@@ -1083,8 +1100,6 @@ static int s_bClearBSSID_SCAN(struct vnt_private *pDevice)
 //mike add:reset command timer
 void vResetCommandTimer(struct vnt_private *pDevice)
 {
-	cancel_delayed_work_sync(&pDevice->run_command_work);
-
 	pDevice->cbFreeCmdQueue = CMD_Q_SIZE;
 	pDevice->uCmdDequeueIdx = 0;
 	pDevice->uCmdEnqueueIdx = 0;
diff --git a/drivers/staging/vt6656/wcmd.h b/drivers/staging/vt6656/wcmd.h
index 7365721..894eea1 100644
--- a/drivers/staging/vt6656/wcmd.h
+++ b/drivers/staging/vt6656/wcmd.h
@@ -37,6 +37,7 @@
 
 // Command code
 typedef enum tagCMD_CODE {
+    WLAN_CMD_INIT_MAC80211,
     WLAN_CMD_BSSID_SCAN,
     WLAN_CMD_SSID,
     WLAN_CMD_DISASSOCIATE,
@@ -78,6 +79,7 @@ typedef struct tagCMD_ITEM {
 
 // Command state
 typedef enum tagCMD_STATE {
+    WLAN_CMD_INIT_MAC80211_START,
     WLAN_CMD_SCAN_START,
     WLAN_CMD_SCAN_END,
     WLAN_CMD_DISASSOCIATE_START,
-- 
1.9.1

