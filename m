Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:53264 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbaG3R2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2014 13:28:48 -0400
Message-ID: <53D92B47.3000305@broadcom.com> (sfid-20140730_192851_722440_5EB174F0)
Date: Wed, 30 Jul 2014 19:28:39 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?ANDR=C9_SI?= <andre_cte2010@hotmail.com>
CC: brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Bug Driver Broadcom
References: <BLU180-W14370D921EDB121FE8EC149DF90@phx.gbl> <BLU180-W146AAC9DB0BDA5C16DED8B9DF90@phx.gbl>,<53D90FCA.9030603@broadcom.com> <BLU180-W3796F15428964196877C529DF90@phx.gbl>
In-Reply-To: <BLU180-W3796F15428964196877C529DF90@phx.gbl>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/30/14 19:15, ANDRÉ SI wrote:
>
>  > Date: Wed, 30 Jul 2014 17:31:22 +0200
>  > From: arend@broadcom.com
>  > To: andre_cte2010@hotmail.com
>  > CC: brcm80211-dev-list@broadcom.com; linux-wireless@vger.kernel.org
>  > Subject: Re: Bug Driver Broadcom
>  >
>  > On 07/30/14 16:59, ANDRÉ SI wrote:
>  > >
>  > > Good Day,
>  > > I have a laptop with a Broadcom wireless card:
>  > > 02:00.0 Network controller: Broadcom Corporation BCM43225 802.11b/g/n
>  > > (rev 01)
>  > > and PCI ID 14e4:4357.
>  > > I have Linux installed and the chipset just don't identifies wireless
>  > > network in channel 12 and 13,
>  > > I live in Brazil, wireless networks at channel 12 and 13 are permitted
>  > > here, how can i solve this problem ?
>  > > I have searched solutions on the internet but none work.
>  >
>  > As far as I know the brcmsmac driver has a custom regulatory domain,
>  > which allows those channels although it is not allowed to initiate
>  > radiation on them. Without any kernel log I can only guess. Can you
>  > provide a kernel log and output of 'iw list' command?
>  >
>  > Regards,
>
> Follow attached the kernel log and output of 'iw list'
> Regards

Looking at the kernel long I see you are using the hybrid wl driver. 
This driver is not what we (brcm80211-dev-list) are supporting. Despite 
that and the surprising fact that Brazil is part of the EU, it seems 
channels 12 and 13 are enabled.

Could you try the brcmsmac driver instead?

Regards,
Arend

--8<----------------------------------------------------------------------

[   19.411278] cfg80211: Calling CRDA to update world regulatory domain
[   19.423164] lib80211: common routines for IEEE802.11 drivers
[   19.423169] lib80211_crypt: registered algorithm 'NULL'
[   19.426873] wl: module license 'MIXED/Proprietary' taints kernel.
[   19.426881] Disabling lock debugging due to kernel taint
[   19.429979] wl: module verification failed: signature and/or 
required key missing - tainting kernel
[   19.435174] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[   19.435190] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   19.435192] [drm] Driver supports precise vblank timestamp query.
[   19.436069] vgaarb: device changed decodes: 
PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   19.470386] INFO @wl_cfg80211_attach : Registered CFG80211 phy
[   19.475463] lib80211_crypt: registered algorithm 'TKIP'
[   19.520515] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work 
properly. Using workaround
[   19.523578] wlan0: Broadcom BCM4357 802.11 Hybrid Wireless Controller 
6.30.223.141 (r415941)
[   19.539730] fbcon: inteldrmfb (fb0) is primary device
[   19.624382] acer_wmi: Acer Laptop ACPI-WMI Extras
[   19.624395] acer_wmi: Function bitmap for Communication Button: 0x1
[   19.624517] acer_wmi: Brightness must be controlled by acpi video driver
[   19.625147] input: Acer WMI hotkeys as /devices/virtual/input/input15
[   19.625425] input: Acer BMA150 accelerometer as 
/devices/virtual/input/input16
[   19.881256] cfg80211: World regulatory domain updated:
[   19.881257] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[   19.881258] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[   19.881259] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[   19.881260] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 
mBi, 2000 mBm)
[   19.881261] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[   19.881262] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[   19.881275] cfg80211: Calling CRDA for country: EU
[   19.884189] cfg80211: Regulatory domain changed to country: EU
[   19.884190] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[   19.884192] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), 
(N/A, 2000 mBm)
[   19.884193] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), 
(N/A, 2000 mBm)
[   19.884194] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), 
(N/A, 2000 mBm)
[   19.884194] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), 
(N/A, 2700 mBm)
