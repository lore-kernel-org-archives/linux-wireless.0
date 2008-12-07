Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:13994 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbYLGTds (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 14:33:48 -0500
Received: by nf-out-0910.google.com with SMTP id d3so391116nfc.21
        for <linux-wireless@vger.kernel.org>; Sun, 07 Dec 2008 11:33:46 -0800 (PST)
Subject: Very big upload speed regression on iwl3945
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: ipw3945-devel@lists.sourceforge.net
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Sun, 07 Dec 2008 21:33:42 +0200
Message-Id: <1228678422.20100.17.camel@maxim-laptop> (sfid-20081207_203359_248355_C4D9C701)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have spent whole day on this, but I am close.
you, Walter Francis, were completely right that there is huge speed
regression between 2.6.25 and 2.6.26, take look at the results:

I am talking now about transfer speeds between router and iwl3945, so
download speed is more or less the same on 2.6.26 and .25, it dropped
from 2.4 Mb/s to 2.0 Mb/s, still a regression, but upload speed dropped
from 3.0 (!) Mb/s to just 1.2 Mb/s maximum.

Note, that I observed sharp drops in speed on both .26 and .25, after a
while.

on 2.6.25 speeds drops drasticly from 3.0 Mb/s /2.4 Mb/s to 1.0 Mb/s ,
150 Kb/s (not typo)

on 2.6.26, upload speed changes a lot, and it is usually at 600~800
Kb/s, but download speeds also drops to 150 kb/s.
Those drops happen at same time (both upload and download).


Bisect results:


17eed249539a7b756ca65a5cb0940abc48ef553b  <- bad (1)

6002f266b3e7f0acc2d5158cddbed41730b02e82  <- doesn't load (2)

8318d78a44d49ac1edf2bdec7299de3617c4232e  <- doesn't load (3)
<cfg80211 APIfor channels/bitrates, mac80211 and driver conversion>

10b6b80145cc93887dd8aab99bfffa375e9add31 <- good (predicted) (4)




(4) is the last good revision, then next revision (3) makes the driver
show a backtrace, and fail.

(2) still doesn't load

(1) loads and have low transfer speeds.

Currently I search for commit between (1) and (2) that fixed loading
issue, then I will try to backport it, to find the exact commit.



the backtrace:

Dec  6 15:55:47 maxim-laptop kernel: [   16.374773]  [ext3:warn_on_slowpath+0x5f/0xc20] warn_on_slowpath+0x5f/0x90
Dec  6 15:55:47 maxim-laptop kernel: [   16.374781]  [acpi_cpufreq:kmem_cache_alloc+0x6d/0x530] ? kmem_cache_alloc+0x6d/0xb0
Dec  6 15:55:47 maxim-laptop kernel: [   16.374785]  [wiphy_register+0x14f/0x170] wiphy_register+0x14f/0x170
Dec  6 15:55:47 maxim-laptop kernel: [   16.374788]  [iwl3945:ieee80211_register_hw+0x2d/0x330] ieee80211_register_hw+0x2d/0x2c0
Dec  6 15:55:47 maxim-laptop kernel: [   16.374799]  [iwl3945:iwl3945_pci_probe+0xd0c/0x1690] :iwl3945:iwl3945_pci_probe+0xd0c/0x1690
Dec  6 15:55:47 maxim-laptop kernel: [   16.374803]  [find_inode+0x53/0x90] ? find_inode+0x53/0x90
Dec  6 15:55:47 maxim-laptop kernel: [   16.374807]  [sysfs_ilookup_test+0x0/0x20] ? sysfs_ilookup_test+0x0/0x20
Dec  6 15:55:47 maxim-laptop kernel: [   16.374810]  [ext3:iput+0x4a/0x750] ? iput+0x4a/0x90
Dec  6 15:55:47 maxim-laptop kernel: [   16.374814]  [sysfs_find_dirent+0x2d/0x40] ? sysfs_find_dirent+0x2d/0x40
Dec  6 15:55:47 maxim-laptop kernel: [   16.374819]  [snd_pcm:_spin_lock+0x16/0x80] ? _spin_lock+0x16/0x40
Dec  6 15:55:47 maxim-laptop kernel: [   16.374822]  [snd_pcm:_spin_unlock+0x10/0x100] ? _spin_unlock+0x10/0x40
Dec  6 15:55:47 maxim-laptop kernel: [   16.374826]  [pci_device_probe+0x7c/0xa0] pci_device_probe+0x7c/0xa0
Dec  6 15:55:47 maxim-laptop kernel: [   16.374833]  [driver_probe_device+0xa2/0x1e0] driver_probe_device+0xa2/0x1e0
Dec  6 15:55:47 maxim-laptop kernel: [   16.374836]  [__driver_attach+0x0/0xb0] ? __driver_attach+0x0/0xb0
Dec  6 15:55:47 maxim-laptop kernel: [   16.374839]  [__driver_attach+0xab/0xb0] __driver_attach+0xab/0xb0
Dec  6 15:55:47 maxim-laptop kernel: [   16.374843]  [bus_for_each_dev+0x6b/0xa0] bus_for_each_dev+0x6b/0xa0
Dec  6 15:55:47 maxim-laptop kernel: [   16.374846]  [acpi_cpufreq:kmem_cache_alloc+0x6d/0x530] ? kmem_cache_alloc+0x6d/0xb0
Dec  6 15:55:47 maxim-laptop kernel: [   16.374850]  [usbcore:driver_attach+0x1c/0x3d0] driver_attach+0x1c/0x20
Dec  6 15:55:47 maxim-laptop kernel: [   16.374853]  [bus_add_driver+0x1f8/0x270] bus_add_driver+0x1f8/0x270
Dec  6 15:55:47 maxim-laptop kernel: [   16.374857]  [usbcore:driver_register+0x47/0x120] driver_register+0x47/0x120
Dec  6 15:55:47 maxim-laptop kernel: [   16.374860]  [tg3:__pci_register_driver+0x5a/0x2b0] __pci_register_driver+0x5a/0xa0
Dec  6 15:55:47 maxim-laptop kernel: [   16.374867]  [iwl3945:init_module+0x3f/0xb5000] :iwl3945:iwl3945_init+0x3f/0x93
Dec  6 15:55:47 maxim-laptop kernel: [   16.374871]  [sys_init_module+0x154/0x1e90] sys_init_module+0x154/0x1e90
Dec  6 15:55:47 maxim-laptop kernel: [   16.374876]  [snd_hda_intel:_spin_unlock_irqrestore+0x12/0xc0] ? _spin_unlock_irqrestore+0x12/0x40
Dec  6 15:55:47 maxim-laptop kernel: [   16.374881]  [<ffffffff804be4b0>] ? ieee80211_rx_irqsafe+0x0/0x80
Dec  6 15:55:47 maxim-laptop kernel: [   16.374887]  [system_call_after_swapgs+0x7b/0x80] system_call_after_swapgs+0x7b/0x80
Dec  6 15:55:47 maxim-laptop kernel: [   16.374890] 
Dec  6 15:55:47 maxim-laptop kernel: [   16.374892] ---[ end trace 4e9e244a59472c97 ]---
Dec  6 15:55:47 maxim-laptop kernel: [   16.374894] iwl3945: Failed to register network device (error -22)


Bes

