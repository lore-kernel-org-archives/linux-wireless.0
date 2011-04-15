Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53419 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149Ab1DOWES (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 18:04:18 -0400
Message-ID: <4DA8C0DD.8090003@lwfinger.net>
Date: Fri, 15 Apr 2011 17:04:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Strange build error with new driver on 2.6.39-rc3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When building a new driver on kernel 2.6.39-rc3 when using a 32-bit system, I 
get the following error:

   MODPOST 511 modules
FATAL: drivers/net/wireless/rtlwifi/rtl8192se/rtl8192se: sizeof(struct 
usb_device_id)=20 is not a modulo of the size of section __mod_usb_device_table=168.
Fix definition of struct usb_device_id in mod_devicetable.h

This error is strange in that this device is PCI based and contains no mention 
of usb_device_id. There is a USB-based driver in the rtlwifi tree, but there is 
also another PCI driver and it does not get this error.

Thanks,

Larry
