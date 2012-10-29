Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59734 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759701Ab2J2RUJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 13:20:09 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so2103360bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Oct 2012 10:20:07 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Albert Pool <albertpool@solcon.nl>
Subject: Re: Unknown Realtek USB device
Date: Mon, 29 Oct 2012 18:20:02 +0100
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org, devel@linuxdriverproject.org
References: <508EB140.5010102@solcon.nl>
In-Reply-To: <508EB140.5010102@solcon.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210291820.03101.chunkeey@googlemail.com> (sfid-20121029_182036_603039_E9FB5B18)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, October 29, 2012 05:39:28 PM Albert Pool wrote:
> Can any of you help me identify the Realtek chip in this device so that the USB ID can be added to the right driver?
> It's a 802.11n USB nano dongle from ISY. I only have the dongle for short time, so I may not be able to test it
> myself if it takes some time. usb-devices and lsusb -v output is attached.

Is it a ISY IWL 2000 device? Then it could be supported by rtl8192cu:

<http://forum.ubuntuusers.de/topic/isy-iwl-2000-n150-standard-wird-nicht-erkannt/#post-4641162>

Note:
you'll have to have to correct firmware in place as well. Either
you have to install a realtek firmware package (rtlwifi) for your
distro... Or download it manually (filename: rtlwifi/rtl8192cufw.bin
<http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git>)
and put it into the correct place (/lib/firmware/(rtlwifi))

Regards,
	Chr
---
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
index 9970c2b..d4338fd 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -297,6 +297,7 @@ static struct usb_device_id rtl8192c_usb_ids[] = {
 	/*=== Customer ID ===*/
 	/****** 8188CU ********/
 	{RTL_USB_DEVICE(0x050d, 0x1102, rtl92cu_hal_cfg)}, /*Belkin - Edimax*/
+	{RTL_USB_DEVICE(0x050d, 0x11f2, rtl92cu_hal_cfg)}, /*Belkin - Edimax*/
 	{RTL_USB_DEVICE(0x06f8, 0xe033, rtl92cu_hal_cfg)}, /*Hercules - Edimax*/
 	{RTL_USB_DEVICE(0x07b8, 0x8188, rtl92cu_hal_cfg)}, /*Abocom - Abocom*/
 	{RTL_USB_DEVICE(0x07b8, 0x8189, rtl92cu_hal_cfg)}, /*Funai - Abocom*/
