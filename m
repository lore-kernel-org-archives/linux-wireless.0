Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:58896 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756765AbXHRUNw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Aug 2007 16:13:52 -0400
Message-ID: <46C752FE.4030706@lwfinger.net>
Date: Sat, 18 Aug 2007 15:13:50 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: fix software decryption with b43legacy
References: <1187346385.23489.157.camel@johannes.berg>	 <46C5CC0D.2040609@lwfinger.net> <1187384230.6090.7.camel@johannes.berg>	 <46C612E8.4020604@lwfinger.net> <1187387215.6090.13.camel@johannes.berg>	 <46C64777.1000602@lwfinger.net> <1187453173.6090.33.camel@johannes.berg>
In-Reply-To: <1187453173.6090.33.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have added the lists to this message.

I got b43legacy up and running with the software decryption modifications. It started OK with 
WPA-PSK TKIP encryption, but soon thereafter, I got this message:

eth1: No ProbeResp from current AP 00:1a:70:46:ba:b1 - assume out of range

I don't know why this happened. I didn't move away from the AP, or do anything that should have 
caused loss of a probe response; however, immediately after that, I got this GPF:

general protection fault: 0000 [1] SMP
CPU 0
Modules linked in: nfs af_packet snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device vboxdrv
cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table
thermal processor button battery ac nls_utf8 ntfs loop dm_mod nfsd exportfs lockd nfs_acl
auth_rpcgss sunrpc snd_hda_intel rc80211_simple snd_pcm snd_timer ohci_hcd snd ohci1394 ehci_hcd
ieee1394 soundcore b43legacy sdhci usbcore mmc_core mac80211 cfg80211 ide_cd cdrom forcedeth
snd_page_alloc i2c_nforce2 ssb ext3 mbcache jbd sg edd fan sata_nv libata amd74xx sd_mod scsi_mod
ide_disk ide_core
Pid: 2087, comm: b43legacy Not tainted 2.6.23-rc3-Ldev-gf5a42059-dirty #13
RIP: 0010:[<ffffffff803fe191>]  [<ffffffff803fe191>] __mutex_unlock_slowpath+0x6b/0x13a
RSP: 0018:ffff810056bd9b30  EFLAGS: 00010016
RAX: 0000000000007b64 RBX: ffff81005825e978 RCX: 0000000000000003
RDX: ffff810037f3d080 RSI: 0000000000000008 RDI: 6b6b6b6b6b6b6ba3
RBP: ffff810056bd9b50 R08: 0000000000000000 R09: ffff81005825e978
R10: ffff810056bd9b80 R11: ffff810037f3d080 R12: 6b6b6b6b6b6b6ba3
R13: 0000000000000246 R14: 6b6b6b6b6b6b6bab R15: ffff8100580564c0
FS:  00002b4afda060b0(0000) GS:ffffffff80539000(0000) knlGS:00000000f479eb90
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000f4e88bd0 CR3: 0000000057aa2000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process b43legacy (pid: 2087, threadinfo ffff810056bd8000, task ffff810037f3d080)
Stack:  ffff81005825e978 ffff81005825c2f0 ffff8100580564c0 ffff81005825c2f0
  ffff810056bd9b60 ffffffff803fe269 ffff810056bd9b80 ffffffff8814d704
  ffff81005825c2f0 ffff810058056640 ffff810056bd9bb0 ffffffff8813cd4f
Call Trace:
  [<ffffffff803fe269>] mutex_unlock+0x9/0xb
  [<ffffffff8814d704>] :mac80211:ieee80211_key_free+0x33/0x37
  [<ffffffff8813cd4f>] :mac80211:sta_info_free+0x92/0xae
  [<ffffffff881427dc>] :mac80211:ieee80211_associated+0x100/0x1ec
  [<ffffffff88143646>] :mac80211:ieee80211_sta_work+0x0/0x182e

The rest of the call trace is available if needed. The crash occurred when ieee80211_key_free was
trying to unlock the mutex key_idx. I added printk's to dump the pointer to sdata at the point where 
that mutex is initialized and where the key is freed. The mutex that errs was inited.

Note: For this run, I did not have a set_key callback routine defined. I also tried it with a 
callback routine that immediately returns -ENOSPC. It didn't make any difference.

Please let me know what further debug info you need.

Larry


