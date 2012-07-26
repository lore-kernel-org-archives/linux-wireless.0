Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout2.ltindia.com ([125.18.18.171]:57511 "EHLO
	mailout2.ltindia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2GZNN5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 09:13:57 -0400
From: Mridula Prakash <Mridula.Prakash@lnties.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: wl1271 driver problem
Date: Thu, 26 Jul 2012 13:13:33 +0000
Message-ID: <B0824BA06BBF0C4AA3F9BE696B46CC8C060AFCA0@POCITMSEXMB01.LntUniverse.com> (sfid-20120726_151401_762638_09EAA722)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm having some issues getting my [newly designed] board to run with wl12xx (wl1271 on SDIO). My kernel is 2.6.28 and I'm using a compat-wireless-3.5rc5 tar file.
Note: I am using the "wl1271-nvs.bin" firmware file for the wifi chip.

Here what I see when I boot:
The wl1271 driver has been loaded and the #ifconfig -a gives me a wlan0 interface. wpa_supplicant works fine when the wlan0 is up.
But bringing the wlan0 interface down and trying to run the wpa_supplicant causes problem and I see the below in the dmesg log.

wl12xx: down
wl12xx: ERROR timeout waiting for the hardware to complete initialization
wl12xx: ERROR timeout waiting for the hardware to complete initialization
wl12xx: ERROR timeout waiting for the hardware to complete initialization
wl12xx: ERROR firmware boot failed despite 3 retries

I have to bring the interface up and down very often as per my system requirements. Please suggest a solution/any idea for the above at the earliest.
To add to this I put some debugs into my kernel and I see the below log:

[  223.710000] lpc313x_mmc lpc313x_mmc.0: data FIFO error (status=00008010)
[  223.720000] wl1271_sdio mmc0:0001:2: sdio write failed (-5)
Previously, I was suing the TI's WiLink_rel05 driver source for the same chip and there was no problem encountered with the LPC drivers.

Any help on the above will be greatly appreciated.

Thanks and Regards
Mridula Prakash

Larsen & Toubro Limited

www.larsentoubro.com

This Email may contain confidential or privileged information for the intended recipient (s). If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.
