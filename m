Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:39338 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbZDIF4h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 01:56:37 -0400
Received: by bwz17 with SMTP id 17so420364bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 08 Apr 2009 22:56:35 -0700 (PDT)
To: reinette.chatre@intel.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: iwl3945 regression: WARNING: at net/wireless/core.c:291
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 09 Apr 2009 08:56:33 +0300
Message-ID: <87ljqamktq.fsf@litku.valot.fi> (sfid-20090409_075641_657031_2D7F021C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Reinette,

I updated to latest wireless-testing and iwl3945 didn't load. I'm using
Lenovo x60s with 32 bit kernel and debian unstable.

The error message:

[   17.484147] ------------[ cut here ]------------
[   17.489314] WARNING: at net/wireless/core.c:291 wiphy_register+0xa7/0x1bf [cfg80211]()
[   17.494687] Hardware name: 1703Y1F
[   17.499921] Modules linked in: snd_seq snd_timer iwl3945(+) snd_seq_device iwlcore pcmcia(+) thinkpad_acpi snd rfkill mac80211 btusb soundcore video backlight yenta_socket rsrc_nonstatic lib80211 bluetooth snd_page_alloc processor battery ac output pcmcia_core rng_core psmouse pcspkr cfg80211 evdev i2c_i801 nvram button ext3 jbd mbcache sha256_generic aes_i586 aes_generic cbc dm_crypt dm_mirror dm_region_hash dm_log dm_snapshot dm_mod sd_mod ata_generic ata_piix uhci_hcd libata scsi_mod sdhci_pci sdhci mmc_core led_class e1000e ide_pci_generic ide_core ehci_hcd usbcore thermal fan
[   17.529567] Pid: 1924, comm: modprobe Not tainted 2.6.30-rc1 #152
[   17.535677] Call Trace:
[   17.541699]  [<c0123415>] warn_slowpath+0x71/0xa8
[   17.547679]  [<c011beb8>] ? enqueue_task_fair+0x131/0x17f
[   17.553539]  [<c01100e7>] ? native_smp_send_reschedule+0x45/0x47
[   17.559499]  [<c011a114>] ? resched_task+0x5d/0x60
[   17.565318]  [<f898438e>] wiphy_register+0xa7/0x1bf [cfg80211]
[   17.571152]  [<f85c6271>] ieee80211_register_hw+0xd8/0x354 [mac80211]
[   17.577000]  [<f871018f>] ? iwl_enable_interrupts+0xca/0xd2 [iwlcore]
[   17.582789]  [<f876b4ac>] iwl3945_pci_probe+0xa9b/0xbb7 [iwl3945]
[   17.588529]  [<c01e70b4>] local_pci_probe+0xe/0x10
[   17.594313]  [<c01e7ad1>] pci_device_probe+0x43/0x66
[   17.600163]  [<c0246e45>] driver_probe_device+0x80/0x10c
[   17.606094]  [<c0246f14>] __driver_attach+0x43/0x5f
[   17.612075]  [<c0246884>] bus_for_each_dev+0x3d/0x67
[   17.617988]  [<c0246d17>] driver_attach+0x14/0x16
[   17.623902]  [<c0246ed1>] ? __driver_attach+0x0/0x5f
[   17.629781]  [<c02462d2>] bus_add_driver+0xd2/0x1e9
[   17.635605]  [<c0247131>] driver_register+0x8b/0xe8
[   17.641438]  [<c01e7df3>] __pci_register_driver+0x38/0x91
[   17.647263]  [<f86c9048>] iwl3945_init+0x48/0x65 [iwl3945]
[   17.653060]  [<c0101137>] do_one_initcall+0x4a/0x10c
[   17.658825]  [<f86c9000>] ? iwl3945_init+0x0/0x65 [iwl3945]
[   17.664628]  [<c0136a52>] ? __blocking_notifier_call_chain+0x40/0x4c
[   17.670478]  [<c0143946>] sys_init_module+0x87/0x186
[   17.676382]  [<c0102948>] sysenter_do_call+0x12/0x26
[   17.682219] ---[ end trace 6325ce0ce8671ee8 ]---
[   17.687950] iwl3945 0000:03:00.0: Failed to register hw (error -22)
[   17.693817] iwl3945 0000:03:00.0: PCI INT A disabled
[   17.699462] iwl3945: probe of 0000:03:00.0 failed with error -22

And the warning from code:

	if (WARN_ON(wiphy->max_scan_ssids < 1))
		return -EINVAL;

It should be easy to fix, I just don't have time to send a patch right
now.

-- 
Kalle Valo
