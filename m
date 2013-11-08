Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2674 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab3KHPmK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 10:42:10 -0500
Received: from md8338-opensuse-12-3.site (a82-161-119-167.adsl.xs4all.nl [82.161.119.167])
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id rA8FVke4026152
	for <linux-wireless@vger.kernel.org>; Fri, 8 Nov 2013 16:31:47 +0100 (CET)
	(envelope-from f.leerink@xs4all.nl)
From: Frans Leerink <f.leerink@xs4all.nl>
To: linux-wireless@vger.kernel.org
Subject: Bug report - Wrong naming of my Wireless Network card enp3s6, should have been wlp3s6
Date: Fri, 08 Nov 2013 16:31:46 +0100
Message-ID: <2774683.Pvb2zYysB7@md8338-opensuse-12-3.site> (sfid-20131108_164216_143671_A2984534)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have installed openSUSE 12.3 / KDE on my Medion Notebook
MD41300 with an INTEL Pentium 4 CPU 3.0 GHz and 1 Gb memory and 
everything works oke, including wireless.
 
I am testing openSUSE 13.1 RC2 with this older laptop. Up to now it has 
worked very well through all the releases upto openSUSE/KDE 12.3.

On the moment I test the live openSUSE/KDE 13.1 RC2 via an usb-stick. 
The system comes up nicely but the wireless network card does not work 
and generates the following lines in dmesg output:

[ 48.675564] enp3s6: resetting device...
[ 48.675587] enp3s6: uploading firmware...
[ 48.855166] prism54: request_firmware() failed for 'isl3890'
[ 48.855175] enp3s6: could not upload firmware ('isl3890')
[ 48.855179] enp3s6: islpci_reset: failure

While I followed URL:
         http://wireless.kernel.org/en/users/Drivers/p54
to activate driver p54pci, the same as I had done for all the previous 
releases.

The wireless networkcard, according to command "/sbin/lspci"
Networkcontroller: "Intersil Corporation ISL3890 [Prism GT/Prism
Duette] /ISL3886 [Prism Javelin/Prism Xbow] (rev 01)".

The kernel version is according to command uname -r :
     3.11.6-3-default

I checked on the openSUSE forum wih Larry Finger, in thread:

http://forums.opensuse.org/english/get-technical-help-here/install-boot-login/413006-please-help-enabling-p54-wireless-firmware-kernel-according-url-http-wireless-kernel-org-en-users-drivers-p54-2.html

and he noticed that my wireless get the wrong naming "enp3s6" in stead 
of  "wlp..."
He proposed a way to still test my wireless card by adding an entry, 
70-persistent-net.rules (with the mac address of my wireless card and 
wlan0 in it) to /etc/udev/rules.d/

I have added that line to /etc/udev/rules.d/70-persistent-net.rules and 
deactivated prism54 driver and activated p54pci driver (via modprobe)
and the wireless device started working correctly.

> Below the relevant entries from dmesg
> In the beginning
> [ 3.245827] Loaded prism54 driver, version 1.2

> then somewhere
> [                    ] systemd-udevd [230]:renamed network interface 
eth1 to enp3s6

> At the end 
> [561.396409] enp3s6: removing device
> [ 561.471117] Unloaded prism54 driver
> [ 737.932041] cfg80211: Calling CRDA to update world regulatory domain
> [ 738.248459] ieee80211 phy0: p54 detected a LM86 firmware
> [ 738.248470] p54: rx_mtu reduced from 3240 to 2376
> [ 738.248476] ieee80211 phy0: FW rev 2.13.25.0 - Softmac protocol 5.9
> [ 738.248483] ieee80211 phy0: cryptographic accelerator WEP:YES,
> TKIP:YES, CCMP:YES
> [ 738.359804] cfg80211: World regulatory domain updated:
> [ 738.359812] cfg80211: (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [ 738.359816] cfg80211: (2402000 KHz - 2472000 KHz @ 40000 KHz), (300
> mBi, 2000 mBm)
> [ 738.359820] cfg80211: (2457000 KHz - 2482000 KHz @ 40000 KHz), (300
> mBi, 2000 mBm)
> [ 738.359823] cfg80211: (2474000 KHz - 2494000 KHz @ 20000 KHz), (300
> mBi, 2000 mBm)
> [ 738.359826] cfg80211: (5170000 KHz - 5250000 KHz @ 40000 KHz), (300
> mBi, 2000 mBm)
> [ 738.359829] cfg80211: (5735000 KHz - 5835000 KHz @ 40000 KHz), (300
> mBi, 2000 mBm)
> [ 739.102119] ieee80211 phy0: hwaddr 00:60:b3:1e:5a:fd, MAC:isl3890
> RF:Frisbee
> [ 739.314682] ieee80211 phy0: Selected rate control algorithm
> 'minstrel_ht'
> [ 739.316966] p54pci 0000:03:06.0: is registered as 'phy0'
> [ 739.532327] systemd-udevd[2433]: renamed network interface wlan0 to
> wlp3s6
> [ 739.860509] IPv6: ADDRCONF(NETDEV_UP): wlp3s6: link is not ready
> [ 740.057475] NET: Registered protocol family 17
> [ 754.446569] wlp3s6: authenticate with bc:05:43:f2:77:b4
> [ 754.446780] wlp3s6: send auth to bc:05:43:f2:77:b4 (try 1/3)
> [ 754.451362] wlp3s6: authenticated
> [ 754.452090] wlp3s6: associate with bc:05:43:f2:77:b4 (try 1/3)
> [ 754.454695] wlp3s6: RX AssocResp from bc:05:43:f2:77:b4 (capab=0x431
> status=0 aid=2)
> [ 754.455114] wlp3s6: associated
> [ 754.455175] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s6: link becomes 
ready
> [ 754.455301] cfg80211: Calling CRDA for country: DE
> [ 754.473156] cfg80211: Regulatory domain changed to country: DE
> [ 754.473169] cfg80211: (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [ 754.473173] cfg80211: (2400000 KHz - 2483500 KHz @ 40000 KHz),
> (N/A, 2000 mBm)
> [ 754.473177] cfg80211: (5150000 KHz - 5250000 KHz @ 40000 KHz),
> (N/A, 2000 mBm)
> [ 754.473181] cfg80211: (5250000 KHz - 5350000 KHz @ 40000 KHz),
> (N/A, 2000 mBm)
> [ 754.473185] cfg80211: (5470000 KHz - 5725000 KHz @ 40000 KHz),
> (N/A, 2698 mBm)
> [ 754.473188] cfg80211: (57240000 KHz - 65880000 KHz @ 2160000 KHz),
> (N/A, 4000 mBm)
> linux:/home/linux #

The problem is now why assigned the openSUSE 13.1 RC2 live USB-stick 
initialy the  wrong naming  enp3s6    to my Wireless Network card.


Regards / Groeten,

	Frans
