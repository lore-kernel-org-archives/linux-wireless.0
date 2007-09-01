Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:17799 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbXIAEez (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:34:55 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 41E30618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:34:55 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 07/35] Don't use shift on numeric constants in  usb_control_msg() arguments
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:34:54 -0400
Message-ID: <20070901043454.2498.43997.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't know the meaning of 0x0a02 and 0x0902 in at76_get_hw_cfg() and
at76_get_hw_cfg_intersil() respectively, so don't pretend that we do.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 55e82cd..8994b70 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -599,7 +599,7 @@ static inline int at76_get_hw_cfg(struct usb_device *udev,
 {
 	return usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x33,
 			       USB_TYPE_VENDOR | USB_DIR_IN |
-			       USB_RECIP_INTERFACE, ((0x0a << 8) | 0x02), 0,
+			       USB_RECIP_INTERFACE, 0x0a02, 0,
 			       buf, buf_size, USB_CTRL_GET_TIMEOUT);
 }
 
@@ -609,7 +609,7 @@ static inline int at76_get_hw_cfg_intersil(struct usb_device *udev,
 {
 	return usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x33,
 			       USB_TYPE_VENDOR | USB_DIR_IN |
-			       USB_RECIP_INTERFACE, ((0x09 << 8) | 0x02), 0,
+			       USB_RECIP_INTERFACE, 0x0902, 0,
 			       buf, buf_size, USB_CTRL_GET_TIMEOUT);
 }
 
