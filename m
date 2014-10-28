Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:15119 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaJ1N5i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 09:57:38 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 01/16] brcmfmac: Add wowl support for USB devices.
Date: Tue, 28 Oct 2014 14:56:04 +0100
Message-ID: <1414504579-12562-2-git-send-email-arend@broadcom.com> (sfid-20141028_145741_987486_0E6E459C)
In-Reply-To: <1414504579-12562-1-git-send-email-arend@broadcom.com>
References: <1414504579-12562-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

This patch adds wowl support for USB bus devices. This feature
requires FW which has support for wowl built in.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c | 49 +++++++++++++++++++++------
 1 file changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index dc13591..e533000 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -93,6 +93,8 @@ struct brcmf_usbdev_info {
 	u8 ifnum;
 
 	struct urb *bulk_urb; /* used for FW download */
+
+	bool wowl_enabled;
 };
 
 static void brcmf_usb_rx_refill(struct brcmf_usbdev_info *devinfo,
@@ -600,6 +602,16 @@ static int brcmf_usb_up(struct device *dev)
 	return 0;
 }
 
+static void brcmf_cancel_all_urbs(struct brcmf_usbdev_info *devinfo)
+{
+	if (devinfo->ctl_urb)
+		usb_kill_urb(devinfo->ctl_urb);
+	if (devinfo->bulk_urb)
+		usb_kill_urb(devinfo->bulk_urb);
+	brcmf_usb_free_q(&devinfo->tx_postq, true);
+	brcmf_usb_free_q(&devinfo->rx_postq, true);
+}
+
 static void brcmf_usb_down(struct device *dev)
 {
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(dev);
@@ -613,14 +625,7 @@ static void brcmf_usb_down(struct device *dev)
 
 	brcmf_usb_state_change(devinfo, BRCMFMAC_USB_STATE_DOWN);
 
-	if (devinfo->ctl_urb)
-		usb_kill_urb(devinfo->ctl_urb);
-
-	if (devinfo->bulk_urb)
-		usb_kill_urb(devinfo->bulk_urb);
-	brcmf_usb_free_q(&devinfo->tx_postq, true);
-
-	brcmf_usb_free_q(&devinfo->rx_postq, true);
+	brcmf_cancel_all_urbs(devinfo);
 }
 
 static void
@@ -1094,11 +1099,24 @@ error:
 	return NULL;
 }
 
+static void brcmf_usb_wowl_config(struct device *dev, bool enabled)
+{
+	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(dev);
+
+	brcmf_dbg(USB, "Configuring WOWL, enabled=%d\n", enabled);
+	devinfo->wowl_enabled = enabled;
+	if (enabled)
+		device_set_wakeup_enable(devinfo->dev, true);
+	else
+		device_set_wakeup_enable(devinfo->dev, false);
+}
+
 static struct brcmf_bus_ops brcmf_usb_bus_ops = {
 	.txdata = brcmf_usb_tx,
 	.stop = brcmf_usb_down,
 	.txctl = brcmf_usb_tx_ctlpkt,
 	.rxctl = brcmf_usb_rx_ctlpkt,
+	.wowl_config = brcmf_usb_wowl_config,
 };
 
 static int brcmf_usb_bus_setup(struct brcmf_usbdev_info *devinfo)
@@ -1186,6 +1204,9 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 	bus->ops = &brcmf_usb_bus_ops;
 	bus->proto_type = BRCMF_PROTO_BCDC;
 	bus->always_use_fws_queue = true;
+#ifdef CONFIG_PM
+	bus->wowl_supported = true;
+#endif
 
 	if (!brcmf_usb_dlneeded(devinfo)) {
 		ret = brcmf_usb_bus_setup(devinfo);
@@ -1339,7 +1360,10 @@ static int brcmf_usb_suspend(struct usb_interface *intf, pm_message_t state)
 
 	brcmf_dbg(USB, "Enter\n");
 	devinfo->bus_pub.state = BRCMFMAC_USB_STATE_SLEEP;
-	brcmf_detach(&usb->dev);
+	if (devinfo->wowl_enabled)
+		brcmf_cancel_all_urbs(devinfo);
+	else
+		brcmf_detach(&usb->dev);
 	return 0;
 }
 
@@ -1352,7 +1376,12 @@ static int brcmf_usb_resume(struct usb_interface *intf)
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(&usb->dev);
 
 	brcmf_dbg(USB, "Enter\n");
-	return brcmf_usb_bus_setup(devinfo);
+	if (!devinfo->wowl_enabled)
+		return brcmf_usb_bus_setup(devinfo);
+
+	devinfo->bus_pub.state = BRCMFMAC_USB_STATE_UP;
+	brcmf_usb_rx_fill_all(devinfo);
+	return 0;
 }
 
 static int brcmf_usb_reset_resume(struct usb_interface *intf)
-- 
1.9.1

