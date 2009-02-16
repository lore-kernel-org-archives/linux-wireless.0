Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:51150 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZBPFdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 00:33:12 -0500
Received: by ewy14 with SMTP id 14so1761834ewy.13
        for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 21:33:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <63d38a500902152114o7b3c0f91j571a1e1d62e31d24@mail.gmail.com>
References: <63d38a500902152114o7b3c0f91j571a1e1d62e31d24@mail.gmail.com>
Date: Mon, 16 Feb 2009 06:33:10 +0100
Message-ID: <63d38a500902152133y264b783cl76800ed3efa46dd4@mail.gmail.com> (sfid-20090216_063323_245399_91D02D8C)
Subject: rtl8187 not handling my usb card
From: =?ISO-8859-2?Q?Viktor_Ilija=B9i=E6?= <viktor.ilijasic@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all.

Sorry if I'm not posting this properly, my first time here.

I have what might be a bug to report:

My Realtek 8187 USB wifi card is not being handled by rtl8187 module.

I am using Ubuntu 8.10, and module from Jan 29th that is (presumably)
supplied by Ubuntu package linux-backports-modules-
intrepid is not handling the card, as well as the one I built myself
from (git?) sources, dated Feb 15th.

I can properly load the module rtl8187 (both already mentioned
versions), but when I insert the USB card, nothing happens. See logs
at the bottom.

To properly load two versions I had to correspondingly rename
mac80211.ko and cfg80211.ko, since there were errors reported (unknown
symbols, unable to load, etc). Since I can properly load the modules,
dependencies are not the problem. Unless there is some other *.ko that
I need to rename?

The card is AirLive WL1600USB, PCI/USB ID 1b75:8187,
url: http://www.airlive.com/product/product_3.jsp?pdid=PD1223473034861

I somehow have the feeling that the PCI/USB ID of this card is
unrecognized by the module (if the module even recognizes hardware
only by it's ID), since this is rather obscure ID (google only returns
2 results for that ID). I'm no expert, I might be wrong.

I'd like to get it working with native drivers if possible. Didn't try
ndiswrapper yet, and I'd rather if that were not my only option.

If any more info is needed, please, feel free to ask.

$ tail /var/log/syslog
Feb 16 05:55:36 CH4 kernel: [ 1389.137978] usbcore: deregistering
interface driver rtl8187
Feb 16 05:55:41 CH4 kernel: [ 1394.294357] usbcore: registered new
interface driver rtl8187
Feb 16 05:55:45 CH4 kernel: [ 1397.480159] usb 4-3: new high speed USB
device using ehci_hcd and address 4
Feb 16 05:55:45 CH4 kernel: [ 1397.678395] usb 4-3: configuration #1
chosen from 1 choice

$ lsusb
Bus 004 Device 004: ID 1b75:8187
Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

$ uname -a
Linux CH4 2.6.27-11-generic #1 SMP Thu Jan 29 19:24:39 UTC 2009 i686 GNU/Linux

modinfo for the self-built Feb 15th version:
$ modinfo rtl8187
filename:
/lib/modules/2.6.27-11-generic/updates/drivers/net/wireless/rtl818x/rtl8187.ko
license:        GPL
description:    RTL8187/RTL8187B USB wireless driver
author:         Larry Finger <Larry.Finger@lwfinger.net>
author:         Hin-Tak Leung <htl10@users.sourceforge.net>
author:         Herton Ronaldo Krzesinski <herton@mandriva.com.br>
author:         Andrea Merello <andreamrl@tiscali.it>
author:         Michael Wu <flamingice@sourmilk.net>
srcversion:     545837A60AA95978807201A
alias:          usb:v13D1pABE6d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DF6p0028d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DF6p000Dd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v03F0pCA02d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0846p4260d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0846p6A00d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0846p6100d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp8198d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp8197d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp8189d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp8187d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050Dp705Ed*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0B05p171Dd*dc*dsc*dp*ic*isc*ip*
depends:        mac80211,eeprom_93cx6,cfg80211,usbcore
vermagic:       2.6.27-11-generic SMP mod_unload modversions 586

$ dmesg
[ 3536.706004] usbcore: deregistering interface driver rtl8187
[ 3540.582591] usbcore: registered new interface driver rtl8187
[ 3545.160202] usb 4-4: new high speed USB device using ehci_hcd and address 5
[ 3545.326673] usb 4-4: configuration #1 chosen from 1 choice
[ 3556.715311] usb 4-4: USB disconnect, address 5
[ 3558.944148] usb 4-3: new high speed USB device using ehci_hcd and address 6
[ 3559.110562] usb 4-3: configuration #1 chosen from 1 choice


Thanks for the hard work and your help.

Viktor

--
Don't let people drive you crazy when you know it's in walking distance.
