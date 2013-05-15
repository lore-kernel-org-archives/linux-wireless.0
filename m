Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40908 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754581Ab3EONOA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 09:14:00 -0400
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id AB89A8EE0DD
	for <linux-wireless@vger.kernel.org>; Wed, 15 May 2013 06:13:59 -0700 (PDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
	by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JWfPj5VLZae6 for <linux-wireless@vger.kernel.org>;
	Wed, 15 May 2013 06:13:59 -0700 (PDT)
Received: from [10.10.178.236] (unknown [159.125.79.200])
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 44D9A8EE0A9
	for <linux-wireless@vger.kernel.org>; Wed, 15 May 2013 06:13:59 -0700 (PDT)
Message-ID: <1368623636.19370.26.camel@dabdike> (sfid-20130515_151407_577721_27B1A107)
Subject: warning in mac80211 from iwlwifi queuing work during suspend
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: linux-wireless@vger.kernel.org
Date: Wed, 15 May 2013 09:13:56 -0400
Content-Type: text/plain; charset="ISO-8859-15"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I got this message on resume

---
[24856.578799] ------------[ cut here ]------------
[24856.578849] WARNING: at /home/abuild/rpmbuild/BUILD/kernel-desktop-3.9.1/linux-3.9/net/mac80211/util.c:599 ieee80211_can_queue_work.isra.7+0x2d/0x40 [mac80211]()
[24856.578851] Hardware name: 4286CTO
[24856.578852] queueing ieee80211 work while going to suspend
[24856.578917] Modules linked in: cpufreq_stats fuse tun af_packet rfcomm bnep sha256_generic cbc dm_crypt dm_mod mperf coretemp crc32_pclmul crc32c_intel ghash_clmulni_intel cryptd arc4 iwldvm mac80211 snd_hda_codec_hdmi snd_hda_codec_conexant iTCO_wdt iTCO_vendor_support kvm_intel kvm microcode snd_hda_intel snd_hda_codec joydev snd_hwdep pcspkr snd_pcm_oss i2c_i801 snd_pcm uvcvideo btusb sg thinkpad_acpi videobuf2_core videodev videobuf2_vmalloc bluetooth snd_seq videobuf2_memops lpc_ich mfd_core iwlwifi sdhci_pci sdhci snd_seq_device mmc_core cfg80211 e1000e rfkill snd_mixer_oss snd_timer ptp snd_page_alloc pps_core mei wmi snd battery tpm_tis tpm tpm_bios ac soundcore edd autofs4 i915 drm_kms_helper drm i2c_algo_bit video button scsi_dh_hp_sw scsi_dh_alua scsi_dh_emc scsi_dh_rdac scsi_dh fan processor thermal thermal_sys
[24856.578921] Pid: 0, comm: swapper/0 Not tainted 3.9.1-7.gb6484b6-desktop #1
[24856.578921] Call Trace:
[24856.578933]  [<ffffffff81004728>] dump_trace+0x88/0x300
[24856.578938]  [<ffffffff815cafba>] dump_stack+0x69/0x6f
[24856.578945]  [<ffffffff810461c9>] warn_slowpath_common+0x79/0xc0
[24856.578948]  [<ffffffff810462c5>] warn_slowpath_fmt+0x45/0x50
[24856.578960]  [<ffffffffa06053dd>] ieee80211_can_queue_work.isra.7+0x2d/0x40 [mac80211]
[24856.579004]  [<ffffffffa0605487>] ieee80211_queue_work+0x27/0x60 [mac80211]
[24856.579029]  [<ffffffff8105615c>] call_timer_fn+0x2c/0x170
[24856.579033]  [<ffffffff810564c5>] run_timer_softirq+0x225/0x2d0
[24856.579037]  [<ffffffff8104e60e>] __do_softirq+0xde/0x280
[24856.579040]  [<ffffffff8104e905>] irq_exit+0x95/0xa0
[24856.579043]  [<ffffffff810264e8>] smp_apic_timer_interrupt+0x68/0xa0
[24856.579047]  [<ffffffff815df9dd>] apic_timer_interrupt+0x6d/0x80
[24856.579051] ---[ end trace 53ff81b324167a8a ]---
----

Kernel is 

Linux version 3.9.1-7.gb6484b6-desktop (geeko@buildhost) (gcc version 4.7.2 20130108 [gcc-4_7-branch revision 195012] (SUSE Linux) ) #1 SMP PREEMPT Wed May 8 15:02:04 UTC 2013 (b6484b6)

and the wireless stack is 

jejb@dabdike> lsmod|grep iwl
iwldvm                253990  0 
mac80211              678341  1 iwldvm
iwlwifi               118000  1 iwldvm
cfg80211              579562  3 iwldvm,mac80211,iwlwifi


James


