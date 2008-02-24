Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp02.uc3m.es ([163.117.176.132]:41415 "EHLO smtp02.uc3m.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbYBXWDF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2008 17:03:05 -0500
From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Message-Id: <200802242157.m1OLvS429023@inv.it.uc3m.es> (sfid-20080224_220312_353058_4025F8DA)
Subject: ADM8211
To: linux-wireless@vger.kernel.org
Date: Sun, 24 Feb 2008 22:57:28 +0100 (MET)
CC: flamingice@sourmilk.net
Reply-To: ptb@inv.it.uc3m.es
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


What's support like for the old broadcom pci ADM8211 card these days?

  0000:00:0b.0 Network controller: Linksys ADMtek ADM8211 802.11b
  Wireless Interface (rev 11)
  Subsystem: Standard Microsystems Corp [SMC]: Unknown device 2602
  Flags: medium devsel, IRQ 19
  I/O ports at 9400 [size=256]
  Memory at ed101000 (32-bit, non-prefetchable) [size=1K]
  Expansion ROM at 30100000 [disabled] [size=128K]
  Capabilities: [c0] Power Management version 2

This produces zilch on my 64 bit athlon running kern 2.6.22.10 in 64
bit mode with the latest wireles-compat stack:

  [590632.616943] ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 19 (level, low) -> IRQ 19
  [590632.640345] 0000:00:0b.0 (adm8211): Channel range: 1 - 13
  [590632.640463] 0000:00:0b.0 (adm8211): RFtype=1 BBPtype=1 Specific BBP=0 Transceiver=0
  [590632.640535] WARNING: at /usr/local/src/compat-wireless-2.6/net/wireless/core.c:267 wiphy_register()
  [590632.665337]
  [590632.665338] Call Trace:
  [590632.676634]  [<ffffffff880ed566>] :cfg80211:wiphy_register+0x126/0x150
  [590632.694525]  [<ffffffff881d9040>] :adm8211:adm8211_eeprom_register_write+0x0/0x60
  [590632.715011]  [<ffffffff881a44f9>] :mac80211:ieee80211_register_hw+0x29/0x3c0
  [590632.734315]  [<ffffffff881dcdf9>] :adm8211:adm8211_probe+0x339/0x500
  [590632.751704]  [<ffffffff802d1f30>] sysfs_make_dirent+0x30/0x50
  [590632.769234]  [<ffffffff803245c0>] pci_call_probe+0x10/0x20
  [590632.784307]  [<ffffffff8032462d>] __pci_device_probe+0x5d/0x70
  [590632.800321]  [<ffffffff80324670>] pci_device_probe+0x30/0x60
  [590632.815867]  [<ffffffff8037f074>] really_probe+0x94/0x130
  [590632.830710]  [<ffffffff8037f17b>] driver_probe_device+0x4b/0x70
  [590632.846955]  [<ffffffff8037f30b>] __driver_attach+0xbb/0xf0
  [590632.862266]  [<ffffffff8037f250>] __driver_attach+0x0/0xf0
  [590632.877319]  [<ffffffff8037f250>] __driver_attach+0x0/0xf0
  [590632.892400]  [<ffffffff8037e0ba>] bus_for_each_dev+0x5a/0x80
  [590632.907946]  [<ffffffff8037e88c>] bus_add_driver+0x7c/0x120
  [590632.923256]  [<ffffffff80324a3d>] __pci_register_driver+0x5d/0xa0
  [590632.939971]  [<ffffffff8024ed26>] sys_init_module+0xf6/0x170
  [590632.955491]  [<ffffffff8020a0be>] system_call+0x7e/0x83
  [590632.970435]
  [590632.974797] 0000:00:0b.0 (adm8211): Cannot register device
  [590632.990001] ACPI: PCI interrupt for device 0000:00:0b.0 disabled
  [590633.006636] adm8211: probe of 0000:00:0b.0 failed with error -22
  [590633.028461] usbcore: registered new interface driver zd1211rw
  [590633.050754] usbcore: registered new interface driver rtl8187

The warning is

       if (!have_band) {
               WARN_ON(1);
               return -EINVAL;
                                               }
Which appears to come from

    wiphy->bands[band] == NULL

for band = 0 to IEEE80211_NUM_BANDS - 1. I'd guess it got nothing by
reading some registers.

Any clues?

Peter

