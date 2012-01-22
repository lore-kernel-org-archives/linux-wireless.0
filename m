Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:37619 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751567Ab2AVDcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jan 2012 22:32:53 -0500
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 1/2] ipw2200: Fix order of device registration
Date: Sun, 22 Jan 2012 04:32:31 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	656813@bugs.debian.org
References: <1327201775.8004.83.camel@deadeye>
In-Reply-To: <1327201775.8004.83.camel@deadeye>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201201220432.34482.s.L-H@gmx.de> (sfid-20120122_043258_009965_B169265B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Sunday 22 January 2012, Ben Hutchings wrote:
> Currently cfg80211 fails to create a "phy80211" symlink in sysfs from
> the net device to the wiphy device.  The latter needs to be registered
> first.
> 
> Compile-tested only.
> 
> Reported-by: Cesare Leonardi <celeonar@gmail.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/net/wireless/ipw2x00/ipw2200.c |   23 ++++++++++++-----------
>  1 files changed, 12 insertions(+), 11 deletions(-)

I've tested this patch on my ipw2200 (inside an Acer TravelMate 292LMi).
While the original

[    5.525347] libipw: 802.11 data/management/control stack, git-1.1.13
[    5.525352] libipw: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[…]
[    5.787605] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmprq
[    5.787610] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[    5.787742] ipw2200 0000:02:02.0: power state changed by ACPI to D0
[    5.787749] ipw2200 0000:02:02.0: power state changed by ACPI to D0
[    5.787762] ipw2200 0000:02:02.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
[    5.787789] ipw2200: Detected Intel PRO/Wireless 2200BG Network Connection
[    6.120089] cfg80211: failed to add phy80211 symlink to netdev!
[    6.120373] ipw2200: Detected geography ZZG (13 802.11bg channels, 0 802.11a channels)
[    6.138818] udevd[252]: renamed network interface eth1 to wlan0
[…]
[    8.744754] acerhk: registered input device
[    8.744878] input: Acer hotkey driver as /devices/virtual/input/input7
[    8.747175] acerhk: forced laptop series to 290
[    8.747184] acerhk: enabling dritek keyboard extension
[    8.747704] acerhk: bios routine found at 0xc00fdf22
[    8.747706] Acer Travelmate hotkey driver v0.5.35
[…]
[   15.107990] lib80211_crypt: registered algorithm 'CCMP'
[   15.276082] Intel AES-NI instructions are not detected.
[   24.386037] wlan0: no IPv6 routers present
[wlan available]

is almost cosmetic, without any apparent ill-effects, applying that 
patch to kernel 3.2.1 (not exactly Debian's - e.g. I need acerhk/ 
dritek to disable rfkill for that card, but it should be close enough) 
results in this trace:

[    5.708938] libipw: 802.11 data/management/control stack, git-1.1.13
[    5.708942] libipw: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[…]
[    5.785178] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmprq
[    5.785184] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[    5.785323] ipw2200 0000:02:02.0: power state changed by ACPI to D0
[    5.785330] ipw2200 0000:02:02.0: power state changed by ACPI to D0
[    5.785344] ipw2200 0000:02:02.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
[    5.785370] ipw2200: Detected Intel PRO/Wireless 2200BG Network Connection
[    5.785416] ------------[ cut here ]------------
[    5.785435] WARNING: at /tmp/buildd/linux-aptosid-3.2/debian/build/source_i386_none/net/wireless/core.c:562 wiphy_register+0x45/0x38d [cfg80211]()
[    5.785440] Hardware name: TravelMate 290 \xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff
[    5.785443] Modules linked in: ipw2200(+) iTCO_wdt libipw joydev drm snd_seq snd_timer snd_seq_device iTCO_vendor_support yenta_socket snd intel_agp i2c_i801 pcmcia_rsrc cfg80211 soundcore parport_pc psmouse parport rng_core snd_page_alloc serio_raw pcspkr i2c_algo_bit intel_gtt pcmcia_core evdev irda crc_ccitt rfkill lib80211 processor container ac battery shpchp pci_hotplug button ext4 mbcache jbd2 crc16 dm_mod sd_mod sr_mod crc_t10dif cdrom ata_generic pata_acpi ata_piix libata scsi_mod firewire_ohci firewire_core crc_itu_t 8139too 8139cp mii uhci_hcd ehci_hcd usbcore usb_common [last unloaded: scsi_wait_scan]
[    5.785512] Pid: 328, comm: modprobe Not tainted 3.2-1.slh.4-aptosid-686 #1
[    5.785515] Call Trace:
[    5.785527]  [<c012eaf4>] ? warn_slowpath_common+0x7c/0x8f
[    5.785538]  [<e0ff0b3e>] ? wiphy_register+0x45/0x38d [cfg80211]
[    5.785549]  [<e0ff0b3e>] ? wiphy_register+0x45/0x38d [cfg80211]
[    5.785554]  [<c012eb22>] ? warn_slowpath_null+0x1b/0x1f
[    5.785565]  [<e0ff0b3e>] ? wiphy_register+0x45/0x38d [cfg80211]
[    5.785574]  [<c01f89d7>] ? internal_create_group+0xf5/0xff
[    5.785589]  [<e0a2de1c>] ? ipw_pci_probe+0xa9a/0xbd0 [ipw2200]
[    5.785597]  [<c01519f4>] ? arch_local_irq_save+0xf/0x14
[    5.785605]  [<c0252986>] ? pci_device_probe+0x53/0x9a
[    5.785612]  [<c02c2820>] ? driver_probe_device+0x94/0x124
[    5.785617]  [<c0252871>] ? pci_match_id+0x15/0x34
[    5.785622]  [<c02c28f0>] ? __driver_attach+0x40/0x5b
[    5.785626]  [<c02c1d81>] ? bus_for_each_dev+0x37/0x60
[    5.785631]  [<c02c25aa>] ? driver_attach+0x17/0x1a
[    5.785636]  [<c02c28b0>] ? driver_probe_device+0x124/0x124
[    5.785641]  [<c02c22c4>] ? bus_add_driver+0x92/0x1d1
[    5.785648]  [<e099d000>] ? 0xe099cfff
[    5.785652]  [<c02c2cb8>] ? driver_register+0x7d/0xd4
[    5.785661]  [<c017cd50>] ? jump_label_module_notify+0xec/0x167
[    5.785666]  [<e099d000>] ? 0xe099cfff
[    5.785670]  [<c0253017>] ? __pci_register_driver+0x32/0x87
[    5.785675]  [<e099d000>] ? 0xe099cfff
[    5.785687]  [<e099d02e>] ? ipw_init+0x2e/0x72 [ipw2200]
[    5.785693]  [<c0101173>] ? do_one_initcall+0x7d/0x132
[    5.785699]  [<c0145016>] ? __blocking_notifier_call_chain+0x47/0x4f
[    5.785705]  [<c0154a73>] ? sys_init_module+0x13a4/0x159c
[    5.785718]  [<c03a639f>] ? sysenter_do_call+0x12/0x28
[    5.785722] ---[ end trace d5a4597cc4a1d28f ]---
[    5.785724] ipw2200: failed to register wireless device
[    5.785795] ipw2200 0000:02:02.0: PCI INT A disabled
[    5.785820] ipw2200: probe of 0000:02:02.0 failed with error -5
[acerhk is loaded much later than ipw2200 through /etc/modules, so it 
 can't interfere at this stage]

I can try to give it some further checking tomorrow.

Regards
	Stefan Lippers-Hollmann
