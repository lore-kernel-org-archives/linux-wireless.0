Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:35758 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755274Ab3HWXvc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 19:51:32 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/3] mwifiex: fix driver unload problem for usb chipsets
Date: Fri, 23 Aug 2013 16:48:21 -0700
Message-ID: <1377301703-8853-1-git-send-email-bzhao@marvell.com> (sfid-20130824_015135_899382_1130B52A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

We have usb_deregister() call in our rmmod routine. deauth,
shutdown etc. commands will be sent to FW later when bus
driver calls disconnect handler.

This mechanism works fine with SDIO and PCIe interfaces, but
there is an issue with USB.

USB bus driver returns all URBs submitted for receiving data
and command response immediately after usb_deregister() with
failure status. Hence we don't send deauth, shutdown etc.
command to firmware.

The problem is fixed by moving code from disconnect handler to
rmmod routine for USB interface.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/usb.c | 50 +++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index fca98b5..2472d4b 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -24,9 +24,9 @@
 
 static const char usbdriver_name[] = "usb8797";
 
-static u8 user_rmmod;
 static struct mwifiex_if_ops usb_ops;
 static struct semaphore add_remove_card_sem;
+static struct usb_card_rec *usb_card;
 
 static struct usb_device_id mwifiex_usb_table[] = {
 	{USB_DEVICE(USB8797_VID, USB8797_PID_1)},
@@ -350,6 +350,7 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 
 	card->udev = udev;
 	card->intf = intf;
+	usb_card = card;
 
 	pr_debug("info: bcdUSB=%#x Device Class=%#x SubClass=%#x Protocol=%#x\n",
 		 udev->descriptor.bcdUSB, udev->descriptor.bDeviceClass,
@@ -532,7 +533,6 @@ static void mwifiex_usb_disconnect(struct usb_interface *intf)
 {
 	struct usb_card_rec *card = usb_get_intfdata(intf);
 	struct mwifiex_adapter *adapter;
-	int i;
 
 	if (!card || !card->adapter) {
 		pr_err("%s: card or card->adapter is NULL\n", __func__);
@@ -543,27 +543,6 @@ static void mwifiex_usb_disconnect(struct usb_interface *intf)
 	if (!adapter->priv_num)
 		return;
 
-	/* In case driver is removed when asynchronous FW downloading is
-	 * in progress
-	 */
-	wait_for_completion(&adapter->fw_load);
-
-	if (user_rmmod) {
-#ifdef CONFIG_PM
-		if (adapter->is_suspended)
-			mwifiex_usb_resume(intf);
-#endif
-		for (i = 0; i < adapter->priv_num; i++)
-			if ((GET_BSS_ROLE(adapter->priv[i]) ==
-			     MWIFIEX_BSS_ROLE_STA) &&
-			    adapter->priv[i]->media_connected)
-				mwifiex_deauthenticate(adapter->priv[i], NULL);
-
-		mwifiex_init_shutdown_fw(mwifiex_get_priv(adapter,
-							  MWIFIEX_BSS_ROLE_ANY),
-					 MWIFIEX_FUNC_SHUTDOWN);
-	}
-
 	mwifiex_usb_free(card);
 
 	dev_dbg(adapter->dev, "%s: removing card\n", __func__);
@@ -1032,8 +1011,29 @@ static void mwifiex_usb_cleanup_module(void)
 	if (!down_interruptible(&add_remove_card_sem))
 		up(&add_remove_card_sem);
 
-	/* set the flag as user is removing this module */
-	user_rmmod = 1;
+	if (usb_card) {
+		struct mwifiex_adapter *adapter = usb_card->adapter;
+		int i;
+
+		/* In case driver is removed when asynchronous FW downloading is
+		 * in progress
+		 */
+		wait_for_completion(&adapter->fw_load);
+
+#ifdef CONFIG_PM
+		if (adapter->is_suspended)
+			mwifiex_usb_resume(usb_card->intf);
+#endif
+		for (i = 0; i < adapter->priv_num; i++)
+			if ((GET_BSS_ROLE(adapter->priv[i]) ==
+			     MWIFIEX_BSS_ROLE_STA) &&
+			    adapter->priv[i]->media_connected)
+				mwifiex_deauthenticate(adapter->priv[i], NULL);
+
+		mwifiex_init_shutdown_fw(mwifiex_get_priv(adapter,
+							  MWIFIEX_BSS_ROLE_ANY),
+					 MWIFIEX_FUNC_SHUTDOWN);
+	}
 
 	usb_deregister(&mwifiex_usb_driver);
 }
-- 
1.8.2.3

