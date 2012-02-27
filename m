Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tqs.de ([62.157.136.18]:34510 "EHLO mail2.tqs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab2B0Kjp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 05:39:45 -0500
Subject: [PATCH] Staging: rtl8712: Change double device ID back to original
	value
To: linville@example.com
From: Martin Krause <martin.krause@tqs.de>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Date: Mon, 27 Feb 2012 11:29:56 +0100
Message-ID: <20120227102857.21246.43090.stgit@localhost.localdomain> (sfid-20120227_113948_799691_3BE2FE4A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the rtl8712 staging driver the 0bda:8172 usb device id exists two times.
It seems that this was an error when integrating the original Realtek
driver into the kernel. This patch changes the double device id back to the
value used in the last Realtek driver
(rtl8712_8188_8191_8192SU_usb_linux_v2.6.6.0.20110401).

Signed-off-by: Martin Krause <martin.krause@tqs.de>
---
I tested this patch on a powerpc board (p2020 based) with a WIFIHU Radicom 
wireless module with a RTL8191SU chip on it (usb device id 0bda:8192).

 drivers/staging/rtl8712/usb_intf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index 9bade18..bb247ce 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -104,7 +104,7 @@ static struct usb_device_id rtl871x_usb_id_tbl[] = {
 
 /* RTL8191SU */
 	/* Realtek */
-	{USB_DEVICE(0x0BDA, 0x8172)},
+	{USB_DEVICE(0x0BDA, 0x8192)},
 	/* Amigo */
 	{USB_DEVICE(0x0EB0, 0x9061)},
 	/* ASUS/EKB */

