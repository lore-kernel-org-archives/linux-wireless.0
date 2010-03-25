Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56807.mail.re3.yahoo.com ([66.196.97.81]:39589 "HELO
	web56807.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752275Ab0CYQ0l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 12:26:41 -0400
Message-ID: <733969.9491.qm@web56807.mail.re3.yahoo.com>
Date: Thu, 25 Mar 2010 09:20:00 -0700 (PDT)
From: Golden <goldenstranger@yahoo.com>
Subject: firmware_loading_store: vmap() failed, broken firmware with kernles .27 - .30 
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent compat-wireless releases break firmware loading under slightly older kernels. The bug occurs as tested by me with 2.6.27 and 2.6.30, it does not appear on kernels 2.6.31 and up.

The error log from zd1211rw:

usbcore: registered new interface driver zd1211rw
usb 5-1: firmware: requesting zd1211/zd1211b_ub
compat_firmware 5-1: firmware_loading_store: vmap() failed
usb 5-1: Could not load firmware file zd1211/zd1211b_ub. Error number -2
zd1211rw 5-1:1.0: couldn't load firmware. Error number -2

The error log from b43:

Broadcom 43xx driver loaded [ Features: PMNLS, Firmware-ID: FW13 ]
b43 ssb0:0: firmware: requesting b43/ucode5.fw
compat_firmware ssb0:0: firmware_loading_store: vmap() failed
b43 ssb0:0: firmware: requesting b43-open/ucode5.fw
compat_firmware ssb0:0: firmware_loading_store: unexpected value (0)
b43-phy0 ERROR: Firmware file "b43/ucode5.fw" not found
b43-phy0 ERROR: Firmware file "b43-open/ucode5.fw" not found
b43-phy0 ERROR: You must go to http://wireless.kernel.org/en/users/Drivers/b43#devicefirmware and download the correct firmware for this driver version. Please carefully read all instructions on this website.

To be noted, that compat-wireless releases from December 2009 work fine as well as the kernel's default drivers, every other release from January till now /March/ breaks the firmware loading process, thus the drivers.

If I missed any relevant information, please let me know. 


      
