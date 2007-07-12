Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.238]:3520 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbXGLTjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2007 15:39:47 -0400
Received: by wr-out-0506.google.com with SMTP id i30so194498wra
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jul 2007 12:39:46 -0700 (PDT)
Message-ID: <a63ecaf0707121239h51479d54m5e45174640e8c114@mail.gmail.com>
Date: Thu, 12 Jul 2007 16:39:45 -0300
From: "Sushi Sensei" <sinestado@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Master mode on rtl8187
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have compiled the kernel 2.6.22.1 with git2 patch. This patch add:

[PATCH] Add rtl8187 wireless driver
[PATCH] rtl8187: add header blocks and indicate origin of magic values
[PATCH] Add 93cx6 eeprom library
[PATCH] eeprom_93cx6: shorten pulse timing to match spec
[PATCH] eeprom_93cx6: Add comment for 1us delay after pulse

I have a wifi usb dongle ENUWI-G2 from Encore. From /var/log/messages:

Jul 12 16:28:16 emiliano kernel: usb 1-5: new high speed USB device
using ehci_hcd and address 2
Jul 12 16:28:16 emiliano kernel: usb 1-5: Product: RTL8187_Wireless_LAN_Adapter
Jul 12 16:28:16 emiliano kernel: usb 1-5: Manufacturer:
Manufacturer_Realtek_RTL8187_
Jul 12 16:28:16 emiliano kernel: usb 1-5: SerialNumber: 0018E91A9333
Jul 12 16:28:16 emiliano kernel: usb 1-5: configuration #1 chosen from 1 choice
Jul 12 16:28:16 emiliano kernel: phy0: hwaddr 00:18:e7:1a:xx:xx,
rtl8187 V1 + rtl8225z2
Jul 12 16:28:16 emiliano kernel: usbcore: registered new interface
driver rtl8187

In mode Managed, Ad-hoc and Monitor seems to work fine but, after
apply the rtl8187-enable-mastermode.patch (
http://www.spinics.net/lists/linux-wireless/msg03079.html ) and try to
put the enuwi in master mode I have this error:


# iwconfig wlan0 mode master
Error for wireless request "Set Mode" (8B06) :
    SET failed on device wlan0 ; Invalid argument.


Sombody have some experience in master mode for this chipset?

------------------------------------------------------
--- Timeo Danaos et dona ferentes ---
------------------------------------------------------
