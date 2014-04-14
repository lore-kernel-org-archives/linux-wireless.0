Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9143 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755761AbaDNWdD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 18:33:03 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 6/7] mwifiex: use USB core's soft_unbind option
Date: Mon, 14 Apr 2014 15:32:54 -0700
Message-ID: <1397514775-4777-6-git-send-email-bzhao@marvell.com> (sfid-20140415_003309_466233_95553AAE)
In-Reply-To: <1397514775-4777-1-git-send-email-bzhao@marvell.com>
References: <1397514775-4777-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This option allows driver to finish pending operations in
disconnect handler by not killing URBs after usb_deregister
call.

We will get rid of global pointer 'usb_card' by moving code
from cleanup_module() to disconnect(). This will help to match
with our handling for SDIO and PCIe interfaces.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/usb.c | 60 ++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index edbe4af..db6377f 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -22,9 +22,9 @@
 
 #define USB_VERSION	"1.0"
 
+static u8 user_rmmod;
 static struct mwifiex_if_ops usb_ops;
 static struct semaphore add_remove_card_sem;
-static struct usb_card_rec *usb_card;
 
 static struct usb_device_id mwifiex_usb_table[] = {
 	/* 8797 */
@@ -532,28 +532,43 @@ static int mwifiex_usb_resume(struct usb_interface *intf)
 static void mwifiex_usb_disconnect(struct usb_interface *intf)
 {
 	struct usb_card_rec *card = usb_get_intfdata(intf);
+	struct mwifiex_adapter *adapter;
 
-	if (!card) {
-		pr_err("%s: card is NULL\n", __func__);
+	if (!card || !card->adapter) {
+		pr_err("%s: card or card->adapter is NULL\n", __func__);
 		return;
 	}
 
-	mwifiex_usb_free(card);
+	adapter = card->adapter;
+	if (!adapter->priv_num)
+		return;
 
-	if (card->adapter) {
-		struct mwifiex_adapter *adapter = card->adapter;
+	/* In case driver is removed when asynchronous FW downloading is
+	 * in progress
+	 */
+	wait_for_completion(&adapter->fw_load);
 
-		if (!adapter->priv_num)
-			return;
+	if (user_rmmod) {
+#ifdef CONFIG_PM
+		if (adapter->is_suspended)
+			mwifiex_usb_resume(intf);
+#endif
+
+		mwifiex_deauthenticate_all(adapter);
 
-		dev_dbg(adapter->dev, "%s: removing card\n", __func__);
-		mwifiex_remove_card(adapter, &add_remove_card_sem);
+		mwifiex_init_shutdown_fw(mwifiex_get_priv(adapter,
+							  MWIFIEX_BSS_ROLE_ANY),
+					 MWIFIEX_FUNC_SHUTDOWN);
 	}
 
+	mwifiex_usb_free(card);
+
+	dev_dbg(adapter->dev, "%s: removing card\n", __func__);
+	mwifiex_remove_card(adapter, &add_remove_card_sem);
+
 	usb_set_intfdata(intf, NULL);
 	usb_put_dev(interface_to_usbdev(intf));
 	kfree(card);
-	usb_card = NULL;
 
 	return;
 }
@@ -565,6 +580,7 @@ static struct usb_driver mwifiex_usb_driver = {
 	.id_table = mwifiex_usb_table,
 	.suspend = mwifiex_usb_suspend,
 	.resume = mwifiex_usb_resume,
+	.soft_unbind = 1,
 };
 
 static int mwifiex_usb_tx_init(struct mwifiex_adapter *adapter)
@@ -762,7 +778,6 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 
 	card->adapter = adapter;
 	adapter->dev = &card->udev->dev;
-	usb_card = card;
 
 	switch (le16_to_cpu(card->udev->descriptor.idProduct)) {
 	case USB8897_PID_1:
@@ -1025,25 +1040,8 @@ static void mwifiex_usb_cleanup_module(void)
 	if (!down_interruptible(&add_remove_card_sem))
 		up(&add_remove_card_sem);
 
-	if (usb_card && usb_card->adapter) {
-		struct mwifiex_adapter *adapter = usb_card->adapter;
-
-		/* In case driver is removed when asynchronous FW downloading is
-		 * in progress
-		 */
-		wait_for_completion(&adapter->fw_load);
-
-#ifdef CONFIG_PM
-		if (adapter->is_suspended)
-			mwifiex_usb_resume(usb_card->intf);
-#endif
-
-		mwifiex_deauthenticate_all(adapter);
-
-		mwifiex_init_shutdown_fw(mwifiex_get_priv(adapter,
-							  MWIFIEX_BSS_ROLE_ANY),
-					 MWIFIEX_FUNC_SHUTDOWN);
-	}
+	/* set the flag as user is removing this module */
+	user_rmmod = 1;
 
 	usb_deregister(&mwifiex_usb_driver);
 }
-- 
1.8.2.3

