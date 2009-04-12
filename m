Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:65414 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbZDLWoB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Apr 2009 18:44:01 -0400
Received: by bwz17 with SMTP id 17so1823447bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 12 Apr 2009 15:43:59 -0700 (PDT)
Subject: A warning in latest -git 2.6.30-rc1
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
Content-Type: text/plain
Date: Mon, 13 Apr 2009 01:43:56 +0300
Message-Id: <1239576236.3814.2.camel@maxim-laptop> (sfid-20090413_004409_281211_D9E014F3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have just noticed this, seems to be harmless, everything works fine:


> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250121] ------------[ cut here ]------------
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250128] WARNING: at /home/maxim/software/kernel/linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c:496 iwl3945_mac_set_key+0x7e5/0x7f0 [iwl3945]()
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250134] Hardware name: Aspire 5720     
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250137] no space for a new keyModules linked in: uhci_hcd af_packet nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc cpufreq_powersave cpufreq_conservative cpufreq_userspace acpi_cpufreq coretemp uvcvideo videodev v4l1_compat v4l2_compat_ioctl32 sbp2 joydev iwl3945 iwlcore psmouse snd_hda_codec_realtek rfkill ehci_hcd tg3 snd_hda_intel snd_hda_codec iTCO_wdt mac80211 nvidia(P) ohci1394 ricoh_mmc sdhci_pci sdhci evdev serio_raw libphy snd_hwdep iTCO_vendor_support usbcore snd_pcm snd_timer snd_page_alloc ext3 jbd mbcache fuse
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250208] Pid: 8, comm: events/0 Tainted: P        W  2.6.30-rc1-vanilla #5
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250212] Call Trace:
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250224]  [<ffffffff802463f0>] warn_slowpath+0xd0/0x130
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250233]  [<ffffffff802c8bdf>] ? __slab_alloc+0xbf/0x760
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250241]  [<ffffffff802e60d1>] ? alloc_inode+0x51/0x60
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250247]  [<ffffffff802e3a1f>] ? __d_lookup+0xcf/0x150
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250255]  [<ffffffff8035988c>] ? security_inode_alloc+0x1c/0x20
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250262]  [<ffffffff802e5fbe>] ? inode_init_always+0x12e/0x1f0
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250277]  [<ffffffffa09dc100>] ? iwl3945_mac_set_key+0x0/0x7f0 [iwl3945]
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250284]  [<ffffffff8035a416>] ? security_d_instantiate+0x16/0x30
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250291]  [<ffffffff802e2d45>] ? d_instantiate+0x45/0x50
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250313]  [<ffffffffa09b97bd>] ? iwl_scan_cancel_timeout+0x2d/0xb0 [iwlcore]
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250328]  [<ffffffffa09dc8e5>] iwl3945_mac_set_key+0x7e5/0x7f0 [iwl3945]
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250357]  [<ffffffffa08d72fc>] __ieee80211_key_todo+0x16c/0x330 [mac80211]
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250383]  [<ffffffffa08d7630>] ? key_todo+0x0/0x10 [mac80211]
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250408]  [<ffffffffa08d7615>] ieee80211_key_todo+0x15/0x30 [mac80211]
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250433]  [<ffffffffa08d7639>] key_todo+0x9/0x10 [mac80211]
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250441]  [<ffffffff80259713>] worker_thread+0x1a3/0x2a0
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250448]  [<ffffffff8025e290>] ? autoremove_wake_function+0x0/0x40
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250455]  [<ffffffff80259570>] ? worker_thread+0x0/0x2a0
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250461]  [<ffffffff80259570>] ? worker_thread+0x0/0x2a0
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250467]  [<ffffffff8025dd96>] kthread+0x56/0x90
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250475]  [<ffffffff8020ceea>] child_rip+0xa/0x20
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250481]  [<ffffffff8025dd40>] ? kthread+0x0/0x90
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250487]  [<ffffffff8020cee0>] ? child_rip+0x0/0x20
> Apr 13 00:35:22 maxim-laptop kernel: [ 3495.250492] ---[ end trace a941121475b47e49 ]---
> 
Happens often, usually after resume from disk. I have WPA2 network.


This is vanilla kernel commit b0cbc861a3c05e634520b049b5cc27ad6febb51f

Best regards,
	Maxim Levitsky

