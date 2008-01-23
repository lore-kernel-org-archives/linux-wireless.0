Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout08.sul.t-online.de ([194.25.134.20]:46596 "EHLO
	mailout08.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135AbYAWUKE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 15:10:04 -0500
Message-ID: <4797994C.1090900@t-online.de> (sfid-20080123_201022_822504_CA5A1BC7)
Date: Wed, 23 Jan 2008 20:45:16 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com, dhazelton@enter.net
Subject: 2.6.24-rc8: iwl3945 gets stuck
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks,

I've got some problem with iwl3945: If I run

	xset dpms force off

for the local display while some network traffic is running, then
the iwl3945 gets stuck. Syslog says:

Jan 23 19:29:41 daffy kernel: iwl3945: Microcode SW error detected.  Restarting 0x2000008.
Jan 23 19:29:43 daffy kernel: iwl3945: Can't stop Rx DMA.

The same happens if the Xserver runs into the configured timeout.
If the network is idle, then there is no such problem, as it seems.
If the Xserver is not running, and if the console runs into dpms,
then iwl3945 seems to stay alive, too, but to be sure I would need
some command similar to the xset shown above.

If the net is stuck (and if I am lucky), then I can rmmod iwl3945 and
load it again, but sometimes I have to reboot.

The machine is a Dell laptop xps m1330 running 64bit kernel 2.6.24-rc8.
Encryption is wpa/psk. iwl3945 is loaded without any special options.
At boot time there were no unusual call traces or something like this.

The configured XWindow driver is "nv", but I could reproduce this with
NVidia's proprietary "nvidia" driver, too. The vga device is a "nVidia
Corporation GeForce 8400M GS".

I would be glad to help to track this down.


Regards

Harri


