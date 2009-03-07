Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:52844 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbZCGRmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2009 12:42:07 -0500
Received: by yx-out-2324.google.com with SMTP id 8so585490yxm.1
        for <linux-wireless@vger.kernel.org>; Sat, 07 Mar 2009 09:42:04 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 7 Mar 2009 12:42:04 -0500
Message-ID: <960a51b60903070942q31d4d5e2n835f2c642cd19d70@mail.gmail.com> (sfid-20090307_184212_490737_AFAB68F6)
Subject: Intermittent wlan operation ( b43-phy0 ERROR: PHY transmission
	error).
From: Tom Cada <thomas.cada@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all.

I have a HP notebook with a Broadcom wireless adapter. The output of
lspci -vv is:

03:00.0 Network controller: Broadcom Corporation BCM4312 802.11a/b/g (rev 02)
	Subsystem: Hewlett-Packard Company Device 1370
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at b6000000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: b43-pci-bridge
	Kernel modules: ssb, wl

 I am using Ubuntu 8.10 64 bit SMP  with the kernel 2.6.27-11-generic.

I am running into the problem where the wireless stops transferring
data while still maintaining the connection. I get the following from
dmesg.

[ 7462.509663] PM: Finishing wakeup.
[ 7462.509664] Restarting tasks ... done.
[ 7463.541721] eth0: no link during initialization.
[ 7463.542855] ADDRCONF(NETDEV_UP): eth0: link is not ready
[ 7463.562080] input: b43-phy0 as /devices/virtual/input/input16
[ 7465.244085] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
[ 7465.379272] Registered led device: b43-phy0::tx
[ 7465.379320] Registered led device: b43-phy0::rx
[ 7465.379348] Registered led device: b43-phy0::radio
[ 7465.379437] b43-phy0 ERROR: PHY transmission error
[ 7465.400668] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 7465.413169] wlan0: authenticate with AP 00:17:9a:23:21:1a
[ 7465.413231] wlan0: authenticate with AP 00:17:9a:23:21:1a
[ 7465.613088] wlan0: authenticate with AP 00:17:9a:23:21:1a
[ 7465.813025] wlan0: authenticate with AP 00:17:9a:23:21:1a
[ 7466.013134] wlan0: authentication with AP 00:17:9a:23:21:1a timed out
[ 7492.844302] wlan0: authenticate with AP 00:19:e0:7a:10:a0
[ 7492.845896] wlan0: authenticated
[ 7492.845912] wlan0: associate with AP 00:19:e0:7a:10:a0
[ 7492.848140] wlan0: RX AssocResp from 00:19:e0:7a:10:a0 (capab=0x431
status=0 aid=7)
[ 7492.848154] wlan0: associated
[ 7492.849829] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 7492.851048] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 7705.804798] b43-phy0 ERROR: PHY transmission error
[ 7705.804835] b43-phy0 ERROR: PHY transmission error
[ 7705.804857] b43-phy0 ERROR: PHY transmission error
[ 7705.804878] b43-phy0 ERROR: PHY transmission error
[ 7705.804899] b43-phy0 ERROR: PHY transmission error
[ 7705.804920] b43-phy0 ERROR: PHY transmission error
[ 7705.804941] b43-phy0 ERROR: PHY transmission error
[ 7705.804961] b43-phy0 ERROR: PHY transmission error
[ 7705.804982] b43-phy0 ERROR: PHY transmission error
[ 7705.805003] b43-phy0 ERROR: PHY transmission error
[ 7706.055190] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
[ 7706.190480] Registered led device: b43-phy0::tx
[ 7706.190541] Registered led device: b43-phy0::rx
[ 7706.190599] Registered led device: b43-phy0::radio
tom@speedy:~$

When I get this series of b43-phy0 errors, data transfer stops and I
have to re-start the network.

I googled the error and found your web site which recommends upgrading
the drivers.

I did as suggested, and found eventually that I was already running
the suggested drivers as it appears that the Ubuntu upgrade to the
kernel also upgraded the b43 drivers.

I went so far as to download the broadcom-wl-4.150.10.5.3 drivers
thinking that a more recent version would have addressed the problem.
However, I found out I couldn't install them with the error:

 $ ../../b43-fwcutter-011/b43-fwcutter -w /lib/firmware wl_apsta_mimo.o
Sorry, the input file is either wrong or not supported by b43-fwcutter.
This file has an unknown MD5sum b84bc801b9b8f39069c252f533655af8.

At this point, I am stymied.

Any help or suggestions would be most welcome.

Thanks... Tom.
