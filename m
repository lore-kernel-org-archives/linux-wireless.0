Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gretel.risen.be ([78.46.99.137]:37100 "EHLO gretel.risen.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab2EWXyd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 19:54:33 -0400
Message-ID: <4FBD7772.6070305@aquazul.com> (sfid-20120524_015438_043789_885A4814)
Date: Thu, 24 May 2012 01:49:06 +0200
From: Mourad De Clerck <bugs-wireless@aquazul.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Larry Finger <Larry.Finger@lwfinger.net>
Subject: firmware loading fails for b43 using linux 3.4?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm probably missing something obvious, but when going from 3.3 to 3.4 
the b43 driver throws up an error, saying it can't find the firmware - 
but it really _is_ there.


Here's the error:

b43-phy0 ERROR: Firmware file "b43/ucode16_mimo.fw" not found
b43-phy0 ERROR: Firmware file "b43-open/ucode16_mimo.fw" not found
b43-phy0 ERROR: You must go to 
http://wireless.kernel.org/en/users/Drivers/b43#devicefirmware and 
download the correct firmware for this driver version. Please carefully 
read all instructions on this website.


Here's the firmware it claims doesn't exist:

$ sha1sum /lib/firmware/b43/ucode16_mimo.fw
825a4bc63e3a96bb20fd8551add947435d47ad46  /lib/firmware/b43/ucode16_mimo.fw

This is from Debian's firmware-b43-installer package, version 1:015-14.


The network card in question:

02:00.0 Network controller [0280]: Broadcom Corporation BCM4322 
802.11a/b/g/n Wireless LAN Controller [14e4:432b] (rev 01)


The only obvious change is 6b6fa5868eec26bdc6a83543cebb8cf832a2645a by 
Larry Finger. I don't know if it matters, but b43 is statically compiled 
in the kernel.

Am I missing something?

Thanks,

-- Mourad DC
