Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:10402 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYFPDYn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2008 23:24:43 -0400
Received: by rv-out-0506.google.com with SMTP id k40so3371603rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 15 Jun 2008 20:24:43 -0700 (PDT)
Message-ID: <eaf2efa20806152024i510ea7auc9aba61b68598ec0@mail.gmail.com> (sfid-20080616_093321_892415_4CA57010)
Date: Mon, 16 Jun 2008 12:24:42 +0900
From: "Mark Roberts" <mroberts1839@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Problem with master mode on BCM4318
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Ubuntu 8.04 with BCM4318 wireless PCI card here.

I want to set up this machine as a wireless access point, but I cannot
get the BCM4318 to go into master mode.

I've followed the directions on linuxwireless.org, downloaded
compat-wireless-2008-06-15, extracted, built, installed, and loaded.
There are a few warnings, but nothing that looks fatal. I try to set
the mode of the card, but I still cannot get it into master mode.

Observations:

(1) When I reboot the machine, b43 is no longer loaded as before. Now,
I must explicitly "sudo modprobe b43".

(2) Trying to get the card into master mode gives the same error as
before I tried to build new drivers:

      "sudo iwconfig wlan0 mode master"

      Error for wireless request "Set Mode" (8B06) :
          SET failed on device wlan0 ; Invalid argument.

(3) uname -a

      Linux Fonebone 2.6.24-18-generic #1 SMP Wed May 28 20:27:26 UTC
2008 i686 GNU/Linux

(4) lspci -vvn | grep 43 -A7

04:05.0 0280: 14e4:4318 (rev 02)
    Subsystem: 1154:0355
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
    Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 64
    Interrupt: pin A routed to IRQ 22
    Region 0: Memory at fbefe000 (32-bit, non-prefetchable) [size=8K]

(5) dmesg

[  449.628695] ssb: Sonics Silicon Backplane found on PCI device 0000:04:05.0
[  449.641734] b43-phy0: Broadcom 4318 WLAN found
[  449.709352] phy0: Selected rate control algorithm 'pid'
[  449.772516] Broadcom 43xx driver loaded [ Features: PMLR, Firmware-ID: FW13 ]
[  449.806925] Broadcom 43xx-legacy driver loaded [ Features: PID,
Firmware-ID: FW10 ]
[  449.877452] input: b43-phy0 as /devices/virtual/input/input7
[  450.159814] b43-phy0: Loading firmware version 351.126 (2006-07-29 05:54:02)
[  450.159824] b43-phy0 warning: You are using an old firmware image.
Support for old firmware will be removed in July 2008.
[  450.159829] b43-phy0 warning: You must go to
http://linuxwireless.org/en/users/Drivers/b43#devicefirmware and
download the latest firmware (version 4).
[  450.277178] Registered led device: b43-phy0::tx
[  450.277400] Registered led device: b43-phy0::rx
[  450.277594] Registered led device: b43-phy0::radio
[  450.325171] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  451.110364] wlan0: Initial auth_alg=0
[  451.110372] wlan0: authenticate with AP 00:11:24:07:bd:99
[  451.111793] wlan0: RX authentication from 00:11:24:07:bd:99 (alg=0
transaction=2 status=0)
[  451.111798] wlan0: authenticated
[  451.111802] wlan0: associate with AP 00:11:24:07:bd:99
[  451.114075] wlan0: RX AssocResp from 00:11:24:07:bd:99 (capab=0x11
status=0 aid=3)
[  451.114080] wlan0: associated
[  451.114092] wlan0: CTS protection enabled (BSSID=00:11:24:07:bd:99)
[  451.115708] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  461.142858] wlan0: no IPv6 routers present
[ 1554.356732] b43-phy1: Broadcom 4318 WLAN found
[ 1554.425693] phy1: Selected rate control algorithm 'pid'
[ 1554.426209] Broadcom 43xx driver loaded [ Features: PMLR, Firmware-ID: FW13 ]
[ 1554.490956] input: b43-phy1 as /devices/virtual/input/input8
[ 1554.711506] b43-phy1: Loading firmware version 410.2160 (2007-05-26 15:32:10)
[ 1554.828855] Registered led device: b43-phy1::tx
[ 1554.829079] Registered led device: b43-phy1::rx
[ 1554.829245] Registered led device: b43-phy1::radio
[ 1554.876862] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 1555.662068] wlan0: Initial auth_alg=0
[ 1555.662077] wlan0: authenticate with AP 00:11:24:07:bd:99
[ 1555.663504] wlan0: RX authentication from 00:11:24:07:bd:99 (alg=0
transaction=2 status=0)
[ 1555.663510] wlan0: authenticated
[ 1555.663513] wlan0: associate with AP 00:11:24:07:bd:99
[ 1555.665748] wlan0: RX AssocResp from 00:11:24:07:bd:99 (capab=0x11
status=0 aid=3)
[ 1555.665753] wlan0: associated
[ 1555.665764] wlan0: CTS protection enabled (BSSID=00:11:24:07:bd:99)
[ 1555.667407] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 1565.690514] wlan0: no IPv6 routers present

I noticed the warning in the dmesg output about having old firmware
and I've followed the instructions on the web site to install it, but
it seems to make no difference. I still see the warning.

I assume that I'm doing something wrong, but I cannot tell. To be
honest, I don't find the documentation on linuxwireless.org to be very
clear or well-presented. It seems to be written primarily for
developers, not end-users as the site advertises.

At this point, I'm stuck. Any suggestions?

M
