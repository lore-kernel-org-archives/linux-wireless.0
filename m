Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:4315 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756869Ab3KODLH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 22:11:07 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.13 6/6] mwifiex: fix issues in driver unload path for USB chipsets
Date: Thu, 14 Nov 2013 19:10:42 -0800
Message-ID: <1384485042-7083-6-git-send-email-bzhao@marvell.com> (sfid-20131115_041112_303914_6A487907)
In-Reply-To: <1384485042-7083-1-git-send-email-bzhao@marvell.com>
References: <1384485042-7083-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ujjal Roy <royujjal@gmail.com>

1) After driver load failure, clear 'card->adapter' instead of
card pointer so that card specific cleanup is performed later
when user unloads the driver.

2) Clear usb_card pointer in disconnect handler to avoid invalid
memory access when user unloads the driver after removing the
card.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/usb.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 1c70b8d..edf5b7a 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -350,7 +350,6 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 
 	card->udev = udev;
 	card->intf = intf;
-	usb_card = card;
 
 	pr_debug("info: bcdUSB=%#x Device Class=%#x SubClass=%#x Protocol=%#x\n",
 		 udev->descriptor.bcdUSB, udev->descriptor.bDeviceClass,
@@ -525,25 +524,28 @@ static int mwifiex_usb_resume(struct usb_interface *intf)
 static void mwifiex_usb_disconnect(struct usb_interface *intf)
 {
 	struct usb_card_rec *card = usb_get_intfdata(intf);
-	struct mwifiex_adapter *adapter;
 
-	if (!card || !card->adapter) {
-		pr_err("%s: card or card->adapter is NULL\n", __func__);
+	if (!card) {
+		pr_err("%s: card is NULL\n", __func__);
 		return;
 	}
 
-	adapter = card->adapter;
-	if (!adapter->priv_num)
-		return;
-
 	mwifiex_usb_free(card);
 
-	dev_dbg(adapter->dev, "%s: removing card\n", __func__);
-	mwifiex_remove_card(adapter, &add_remove_card_sem);
+	if (card->adapter) {
+		struct mwifiex_adapter *adapter = card->adapter;
+
+		if (!adapter->priv_num)
+			return;
+
+		dev_dbg(adapter->dev, "%s: removing card\n", __func__);
+		mwifiex_remove_card(adapter, &add_remove_card_sem);
+	}
 
 	usb_set_intfdata(intf, NULL);
 	usb_put_dev(interface_to_usbdev(intf));
 	kfree(card);
+	usb_card = NULL;
 
 	return;
 }
@@ -754,6 +756,7 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	card->adapter = adapter;
 	adapter->dev = &card->udev->dev;
 	strcpy(adapter->fw_name, USB8797_DEFAULT_FW_NAME);
+	usb_card = card;
 
 	return 0;
 }
@@ -762,7 +765,7 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 {
 	struct usb_card_rec *card = (struct usb_card_rec *)adapter->card;
 
-	usb_set_intfdata(card->intf, NULL);
+	card->adapter = NULL;
 }
 
 static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
@@ -1004,7 +1007,7 @@ static void mwifiex_usb_cleanup_module(void)
 	if (!down_interruptible(&add_remove_card_sem))
 		up(&add_remove_card_sem);
 
-	if (usb_card) {
+	if (usb_card && usb_card->adapter) {
 		struct mwifiex_adapter *adapter = usb_card->adapter;
 		int i;
 
-- 
1.8.2.3

