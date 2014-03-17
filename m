Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zhbdzmsp-mail13.bluewin.ch ([195.186.99.121]:53506 "EHLO
	zhbdzmsp-mail13.bluewin.ch" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750706AbaCQSto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 14:49:44 -0400
Message-ID: <5327421C.2040603@weiss.ch> (sfid-20140317_194949_917940_0CD2CAE6)
Date: Mon, 17 Mar 2014 19:42:36 +0100
From: Rolf Anderegg <rolf.anderegg@weiss.ch>
Reply-To: <rolf.anderegg@weiss.ch>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
Subject: ath5k: SIOCGIWFREQ ioctl EINVAL
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was lately required to move to a newer kernel (3.12.10-rt15) on an Intel Atom
setup. All is working fine, including the wireless module (ath5k) acting as an
access point on my bridge, using hostapd:

:~$ lspci
...
03:00.0 Ethernet controller: Qualcomm Atheros AR5212/AR5213 Wireless Network
Adapter (rev 01)
	Subsystem: D-Link System Inc AirPlus DWL-G520 Wireless PCI Adapter (rev. B)
	Flags: bus master, fast Back2Back, medium devsel, latency 168, IRQ 20
	Memory at d0000000 (32-bit, non-prefetchable) [size=64K]
	Kernel driver in use: ath5k
	Kernel modules: ath5k
...
:~$ iwconfig ath0
ath0      IEEE 802.11bg  Mode:Master  Tx-Power=27 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:on

:~$ iwlist ath0 f
ath0      11 channels in total; available frequencies :
          Channel 01 : 2.412 GHz
          Channel 02 : 2.417 GHz
          Channel 03 : 2.422 GHz
          Channel 04 : 2.427 GHz
          Channel 05 : 2.432 GHz
          Channel 06 : 2.437 GHz
          Channel 07 : 2.442 GHz
          Channel 08 : 2.447 GHz
          Channel 09 : 2.452 GHz
          Channel 10 : 2.457 GHz
          Channel 11 : 2.462 GHz


However, as can be seen above I am now unable to read the current
channel/frequency info within iwlist, iwconfig or any other tool; ioctl on
SIOCGIWFREQ seems to fail with EINVAL (Invalid argument):

:~$ strace iwconfig ath0
...
ioctl(3, SIOCGIWFREQ, 0xbfc8f41c)       = -1 EINVAL (Invalid argument)
...

I also have a a USB wireless stick (based on AR9271, using module ath9k_htc) at
hand, also working fine in same setup, but no chance to read SIOCGIWFREQ.
Why could this be? Has anything changed in the atheros wireless section
regarding this?
Thanks in advance,

Rolf Anderegg
