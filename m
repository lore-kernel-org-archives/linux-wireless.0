Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:54905 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaKAJry (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2014 05:47:54 -0400
Received: by mail-ie0-f180.google.com with SMTP id y20so2783025ier.11
        for <linux-wireless@vger.kernel.org>; Sat, 01 Nov 2014 02:47:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1414804501.1032.1.camel@gmail.com>
References: <1414804501.1032.1.camel@gmail.com>
Date: Sat, 1 Nov 2014 10:47:53 +0100
Message-ID: <CACna6ryQqZf9yDtJbcUx2VQ-bMqXa7dPX__cHi1JqgsAkg8W9Q@mail.gmail.com> (sfid-20141101_104828_041401_E8FA4289)
Subject: Re: BCM43228 wireless card broken in kernel update [b43]
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Duncan de Wet <duncandewet@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

First of all, your e-mail thread suggests a regression in b43 after
kernel update. This is impossible, as 3.17 is the first kernel with
b43 support for BCM43227/BCM43228/BCM43131. First thing unclear about
your report.

On 1 November 2014 02:15, Duncan de Wet <duncandewet@gmail.com> wrote:
> After the kernel update to 3.17.1-1-ARCH, I can view a list of wireless
> networks but not connect to any. Both GNOME network manager and wicd-gtk
> say "Connecting..." then without an error message change to "Not
> Connected".
>
> Here is the dmesg output that occurs when trying to connect to a
> wireless network, with my router hardware address redacted:
>
> [ 1363.980448] wlp4s0: authenticate with [redacted]
> [ 1364.066378] wlp4s0: send auth to [redacted] (try 1/3)
> [ 1364.068641] wlp4s0: authenticated
> [ 1364.069358] wlp4s0: associate with [redacted] (try 1/3)
> [ 1364.073798] wlp4s0: RX AssocResp from [redacted] (capab=0x411
> status=0 aid=2)
> [ 1364.073869] wlp4s0: associated
> [ 1364.073927] IPv6: ADDRCONF(NETDEV_CHANGE): wlp4s0: link becomes ready
> [ 1364.074029] cfg80211: Calling CRDA to update world regulatory domain
> [ 1369.624786] wlp4s0: deauthenticating from [redacted] by local choice
> (Reason: 3=DEAUTH_LEAVING)

This could be some problem with the driver (I'm still not sure *which*
driver), I guess running wpa_supplicant with -dd could tell us more.


> Here is the exact model of the card, and other information from lspci if
> it is helpful:
>
> 04:00.0 Network controller [0280]: Broadcom Corporation BCM43228
> 802.11a/b/g/n [14e4:4359]
>         Subsystem: Broadcom Corporation Device [14e4:0607]
>         Flags: bus master, fast devsel, latency 0, IRQ 17
>         Memory at f2500000 (64-bit, non-prefetchable) [size=16K]
>         Capabilities: [40] Power Management version 3
>         Capabilities: [58] Vendor Specific Information: Len=78 <?>
>         Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
>         Capabilities: [d0] Express Endpoint, MSI 00
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [13c] Virtual Channel
>         Capabilities: [160] Device Serial Number [redacted]
>         Capabilities: [16c] Power Budgeting <?>
>         Kernel driver in use: bcma-pci-bridge
>         Kernel modules: bcma, wl
>
> I do not know why "wl" is listed as an available module because I
> uninstalled broadcom-wl already.

It doesn't seem you really uninstalled it. AFAIK otherwise "lspci"
wouldn't have idea about "wl".


> I am using the b43 driver, along with b43-firmware from Arch Linux AUR,
> but broadcom-wl does not work either (same issue where I can view
> networks but not connect). Everything worked before I updated my kernel.

Broadcom's "wl" uses cfg80211 API. There could be some cfg80211 change
in 3.17 that caused a regression for your setup, not sure how likely
is that.


> It also may be interesting that on startup, I get this dmesg output:
>
> Broadcom BCM4359 802.11 Hybrid Wireless Controller 6.30.223.248
> (r487574)

So you didn't uninstall Broadcom's wl. More over, you still load this module!


> however my card is BCM43228 not BCM4359.

Broadcom's "wl" has broken chipset reporting. It treats PCI ID as a
chipset which is obviously not correct.
