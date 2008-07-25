Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:47993 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYGYRIM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2008 13:08:12 -0400
Received: by rv-out-0506.google.com with SMTP id k40so3506217rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2008 10:08:11 -0700 (PDT)
Message-ID: <c68f135e0807251008i77d4a097g82bdffdc296dc607@mail.gmail.com> (sfid-20080725_190818_541388_BDCA55D5)
Date: Fri, 25 Jul 2008 19:08:11 +0200
From: "Andrea Merello" <andrea.merello@gmail.com>
Reply-To: andrea.merello@gmail.com
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Rtl8187 PATCH add usb ID for asus wireless link
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch from Davide Cavalca adds a usb ID for an rtl8187L device.

---
 drivers/net/wireless/Kconfig       |    1 +
 drivers/net/wireless/rtl8187_dev.c |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 91fc2c7..4c7ff61 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -649,6 +649,7 @@ config RTL8187
          Trendnet TEW-424UB
          ASUS P5B Deluxe
          Toshiba Satellite Pro series of laptops
+         Asus Wireless Link

          Thanks to Realtek for their support!

diff --git a/drivers/net/wireless/rtl8187_dev.c
b/drivers/net/wireless/rtl8187_dev.c
index d3067b1..046f700 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -31,6 +31,8 @@ MODULE_DESCRIPTION("RTL8187/RTL8187B USB wireless driver");
 MODULE_LICENSE("GPL");

 static struct usb_device_id rtl8187_table[] __devinitdata = {
+       /* Asus */
+       {USB_DEVICE(0x0b05, 0x171d), .driver_info = DEVICE_RTL8187},
        /* Realtek */
        {USB_DEVICE(0x0bda, 0x8187), .driver_info = DEVICE_RTL8187},
        {USB_DEVICE(0x0bda, 0x8189), .driver_info = DEVICE_RTL8187B},
--
1.5.6.2
