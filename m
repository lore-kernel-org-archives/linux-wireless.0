Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:49048 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755071AbYATAPA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jan 2008 19:15:00 -0500
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 13/14] [rndis_host] blacklist known wireless RNDIS devices
To: linux-wireless@vger.kernel.org
Cc: bjd@jooz.net, dbrownell@users.sourceforge.net,
	netdev@vger.kernel.org
Date: Sun, 20 Jan 2008 02:14:55 +0200
Message-ID: <20080120001455.25718.75424.stgit@fate.lan> (sfid-20080120_001508_065633_4DCE146B)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Blacklist known wireless RNDIS devices that will be handled by
rndis_wext module.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---

 drivers/net/usb/rndis_host.c |  104 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 104 insertions(+), 0 deletions(-)

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 1ffbbb3..cd1f953 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -530,6 +530,110 @@ static const struct driver_info	rndis_info = {
 /*-------------------------------------------------------------------------*/
 
 static const struct usb_device_id	products [] = {
+/*
+ * BLACKLIST !!
+ *
+ * Blacklist RNDIS devices that are handled in separate RNDIS modules.
+ */
+
+#define	RNDIS_MASTER_INTERFACE \
+	.bInterfaceClass	= USB_CLASS_COMM, \
+	.bInterfaceSubClass	= 2 /* ACM */, \
+	.bInterfaceProtocol	= 0x0ff
+
+/* Wireless RNDIS devices, rndis_wext module */
+{
+	.match_flags	=   USB_DEVICE_ID_MATCH_INT_INFO
+			  | USB_DEVICE_ID_MATCH_DEVICE,
+	.idVendor		= 0x0411,
+	.idProduct		= 0x00bc,	/* Buffalo WLI-U2-KG125S */
+	RNDIS_MASTER_INTERFACE,
+	.driver_info		= 0,
+}, {
+	.match_flags	=   USB_DEVICE_ID_MATCH_INT_INFO
+			  | USB_DEVICE_ID_MATCH_DEVICE,
+	.idVendor		= 0x0baf,
+	.idProduct		= 0x011b,	/* U.S. Robotics USR5421 */
+	RNDIS_MASTER_INTERFACE,
+	.driver_info		= 0,
+}, {
+	.match_flags	=   USB_DEVICE_ID_MATCH_INT_INFO
+			  | USB_DEVICE_ID_MATCH_DEVICE,
+	.idVendor		= 0x050d,
+	.idProduct		= 0x011b,	/* Belkin F5D7051 */
+	RNDIS_MASTER_INTERFACE,
+	.driver_info		= 0,
+}, {
+	.match_flags	=   USB_DEVICE_ID_MATCH_INT_INFO
+			  | USB_DEVICE_ID_MATCH_DEVICE,
+	.idVendor		= 0x1799,	/* Belkin has two vendor ids */
+	.idProduct		= 0x011b,	/* Belkin F5D7051 */
+	RNDIS_MASTER_INTERFACE,
+	.driver_info		= 0,
+}, {
+	.match_flags	=   USB_DEVICE_ID_MATCH_INT_INFO
+			  | USB_DEVICE_ID_MATCH_DEVICE,
+	.idVendor		= 0x13b1,
+	.idProduct		= 0x0014,	/* Linksys WUSB54GSv2 */
+	RNDIS_MASTER_INTERFACE,
+	.driver_info		= 0,
+}, {
+	.match_flags	=   USB_DEVICE_ID_MATCH_INT_INFO
+			  | USB_DEVICE_ID_MATCH_DEVICE,
+	.idVendor		= 0x13b1,
+	.idProduct		= 0x0026,	/* Linksys WUSB54GSC */
+	RNDIS_MASTER_INTERFACE,
+	.driver_info		= 0,
+}, {
+	.match_flags	=   USB_DEVICE_ID_MATCH_INT_INFO
+			  | USB_DEVICE_ID_MATCH_DEVICE,
+	.idVendor		= 0x0b05,
+	.idProduct		= 0x1717,	/* Asus WL169gE */
+	RNDIS_MASTER_INTERFACE,
+	.driver_info		= 0,
+}, {
+	.match_flags	=   USB_DEVICE_ID_MATCH_INT_INFO
+			  | USB_DEVICE_ID_MATCH_DEVICE,
+	.idVendor		= 0x0a5c,
+	.idProduct		= 0xd11b,	/* Eminent EM4045 */
+	RNDIS_MASTER_INTERFACE,
+	.driver_info		= 0,
+}, {
+	.match_flags	=   USB_DEVICE_ID_MATCH_INT_INFO
+			  | USB_DEVICE_ID_MATCH_DEVICE,
+	.idVendor		= 0x1690,
+	.idProduct		= 0x0715,	/* BT Voyager 1055 */
+	RNDIS_MASTER_INTERFACE,
+	.driver_info		= 0,
+}, {
+	.match_flags	=   USB_DEVICE_ID_MATCH_INT_INFO
+			  | USB_DEVICE_ID_MATCH_DEVICE,
+	.idVendor		= 0x13b1,
+	.idProduct		= 0x000e,	/* Linksys WUSB54GSv1 */
+	RNDIS_MASTER_INTERFACE,
+	.driver_info		= 0,
+}, {
+	.match_flags	=   USB_DEVICE_ID_MATCH_INT_INFO
+			  | USB_DEVICE_ID_MATCH_DEVICE,
+	.idVendor		= 0x0baf,
+	.idProduct		= 0x0111,	/* U.S. Robotics USR5420 */
+	RNDIS_MASTER_INTERFACE,
+	.driver_info		= 0,
+}, {
+	.match_flags	=   USB_DEVICE_ID_MATCH_INT_INFO
+			  | USB_DEVICE_ID_MATCH_DEVICE,
+	.idVendor		= 0x0411,
+	.idProduct		= 0x004b,	/* BUFFALO WLI-USB-G54 */
+	RNDIS_MASTER_INTERFACE,
+	.driver_info		= 0,
+},
+
+/*
+ * WHITELIST!!!
+ *
+ * All other RNDIS devices that do not need special OID handling in order
+ * to work.
+ */
 {
 	/* RNDIS is MSFT's un-official variant of CDC ACM */
 	USB_INTERFACE_INFO(USB_CLASS_COMM, 2 /* ACM */, 0x0ff),

