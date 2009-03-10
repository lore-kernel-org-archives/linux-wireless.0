Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:57287 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbZCJXjL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 19:39:11 -0400
Received: by bwz26 with SMTP id 26so1754290bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 16:39:08 -0700 (PDT)
Subject: Thanks for TX power patch
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 01:39:04 +0200
Message-Id: <1236728344.26432.26.camel@maxim-laptop> (sfid-20090311_003916_231518_C2C4143F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


First, big thanks to Nick Kossifidis
Finally I get a decent speed out of my aspire one
iwconfig output specifies 54M/s.

Still transfer speeds are at 2.4~2.5M/s, while I could achieve 2.9~3.0
Mb/s on my iwl3945. Probably ANI support with fix that, or maybe just
that is the device maximum, for example due to noise at hardware paths,
not a perfect amplifier, etc... I need to test this in windows.

Also, ath5k issues many resets to the device, which results in transfer
stalls for few seconds, so effective speed is much lower.
But these are minor solvable problems, and thus thanks again.


So in summary your patch works fine.

But I noticed that few (or one) bugs crept into ath5k while I didn't
update it.

Latest version of wireless-testing that doesn't produce any
oopses/problems with suspend to disk, etc : master-2009-02-24


I now downloaded the 'compat-wireless-2009-03-10', and installed on the
above tree (I usually just install and use a wireless-testing tree, but
this time I was lazy, so I just installed compat-wireless package)


With or without (tested both) latest Nick's patches, it fails very badly
with suspend to disk.

After a suspend to disk, NM can't scan - iwlist scan says : device is
busy

(Btw I got same behavior with my iwl3945 - I disabled its hardware scan
to fix this temporally)


If I unload/reload the ath5k, it seems to work. but at next suspend to
disk, once  system hung, other time it showed many panic, in something
related to page allocator (one even was in page_alloc_pages or so)


Next time I just reloaded the ath5k, and got this in dmesg:



> [  125.144098] wlan0: no IPv6 routers present
> [  133.952101] __ratelimit: 52 callbacks suppressed
> [  133.952118] ath5k phy0: (ath5k_chan_set:1049): (2412 MHz) -> (2412 MHz)
> [  134.016143] ath5k phy0: (ath5k_chan_set:1049): (2412 MHz) -> (2417 MHz)
> [  134.016158] ath5k phy0: (ath5k_reset:2745): resetting
> [  134.016309] ath5k phy0: (ath5k_txq_cleanup:1530): beacon queue 0
> [  134.016453] ath5k phy0: (ath5k_txq_cleanup:1539): txq [0] 2479ed00, link (null)
> [  134.016493] rx queue 2479e0e0, link e479e0c0
> [  134.043236] ath5k phy0: (ath5k_rx_start:1582): cachelsz 64 rxbufsize 2560
> [  134.108204] ath5k phy0: (ath5k_chan_set:1049): (2417 MHz) -> (2422 MHz)
> [  134.108224] ath5k phy0: (ath5k_reset:2745): resetting
> [  134.108378] ath5k phy0: (ath5k_txq_cleanup:1530): beacon queue 0
> [  134.108526] ath5k phy0: (ath5k_txq_cleanup:1539): txq [0] 2479ed20, link (null)
> [  134.108575] rx queue 2479e100, link e479e0e0
> [  134.196477] rx queue 2479e100, link e479e0e0
> [  134.284343] rx queue 2479e100, link e479e0e0
> [  134.380353] rx queue 2479e140, link e479e120
> [  134.480370] rx queue 2479e1a0, link e479e180
> [  134.573328] rx queue 2479e1a0, link e479e180
> [  134.665381] rx queue 2479e1a0, link e479e180
> [  134.757380] rx queue 2479e1a0, link e479e180
> [  134.849377] rx queue 2479e1c0, link e479e1a0
> [  134.941818] rx queue 2479e1e0, link e479e1c0
> [  141.462491] BUG: unable to handle kernel paging request at 1fc6c2e4
> [  141.462522] IP: [<c02503f2>] rb_next+0x22/0x50
> [  141.462554] *pdpt = 000000002c965001 *pde = 0000000000000000 
> [  141.462579] Oops: 0000 [#1] PREEMPT SMP 
> [  141.462601] last sysfs file: /sys/devices/platform/coretemp.0/temp1_input
> [  141.462617] Modules linked in: ath5k mac80211 cfg80211 af_packet i915 drm ipv6 acpi_cpufreq cpufreq_stats cpufreq_userspace cpufreq_conservative cpufreq_powersave coretemp acpiphp snd_hda_codec_realtek snd_hda_intel snd_hda_codec acer_wmi joydev uvcvideo snd_hwdep rfkill videodev v4l1_compat snd_pcm_oss rtc_cmos serio_raw psmouse snd_mixer_oss pcspkr rtc_core rtc_lib intel_agp evdev snd_pcm iTCO_wdt iTCO_vendor_support agpgart snd_timer snd_page_alloc ext3 jbd mbcache ata_piix ehci_hcd uhci_hcd libata usbcore fuse [last unloaded: cfg80211]
> [  141.462842] 
> [  141.462859] Pid: 4525, comm: update-notifier Not tainted (2.6.29-rc6-wl-led #14) AOA150
> [  141.462879] EIP: 0060:[<c02503f2>] EFLAGS: 00010202 CPU: 0
> [  141.462899] EIP is at rb_next+0x22/0x50
> [  141.462914] EAX: 1fc6c2dc EBX: ec94a048 ECX: ec94a6c8 EDX: 1fc6c2dc
> [  141.462930] ESI: ecac1700 EDI: ec94a6c8 EBP: ec98bed4 ESP: ec98bed0
> [  141.462946]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [  141.462964] Process update-notifier (pid: 4525, ti=ec98a000 task=f6402940 task.ti=ec98a000)
> [  141.462979] Stack:
> [  141.462989]  eca77620 ec98bf6c f874883a ec94a6c0 c01b57a4 bfbafedc ec98bf60 00000804
> [  141.463029]  00000000 00000000 0015e409 c01c0070 ec98bf94 ecac1700 00000000 00000000
> [  141.463072]  00000000 f6b17800 f29d4478 00000000 00001000 00000008 00000000 492f942e
> [  141.463117] Call Trace:
> [  141.463139]  [<f874883a>] ? ext3_readdir+0x50a/0x700 [ext3]
> [  141.463194]  [<c01b57a4>] ? cp_new_stat64+0xe4/0x100
> [  141.463219]  [<c01c0070>] ? filldir64+0x0/0xf0
> [  141.463242]  [<c01b5c52>] ? sys_fstat64+0x22/0x30
> [  141.463277]  [<c01c03a0>] ? vfs_readdir+0x90/0xb0
> [  141.463299]  [<c01c0070>] ? filldir64+0x0/0xf0
> [  141.463319]  [<c01c0429>] ? sys_getdents64+0x69/0xb0
> [  141.463339]  [<c010342d>] ? sysenter_do_call+0x12/0x21
> [  141.463363] Code: 90 90 90 90 90 90 90 90 90 55 89 c1 89 e5 31 d2 53 8b 18 89 d8 83 e0 fc 39 c1 74 18 8b 41 04 85 c0 75 08 eb 18 8d 74 26 00 89 d0 <8b> 50 08 85 d2 75 f7 89 c2 89 d0 5b c9 c3 8b 1a 89 d1 89 da 83 
> [  141.463611] EIP: [<c02503f2>] rb_next+0x22/0x50 SS:ESP 0068:ec98bed0
> [  141.463648] ---[ end trace ab9ecd084d01dbb6 ]---
> [  173.948145] __ratelimit: 46 callbacks suppressed
> [  173.948163] ath5k phy0: (ath5k_chan_set:1049): (2412 MHz) -> (2412 MHz)
> [  174.012091] ath5k phy0: (ath5k_chan_set:1049): (2412 MHz) -> (2417 MHz)
> [  174.012108] ath5k phy0: (ath5k_reset:2745): resetting
> [  174.012258] ath5k phy0: (ath5k_txq_cleanup:1530): beacon queue 0
> [  174.012402] ath5k phy0: (ath5k_txq_cleanup:1539): txq [0] 2479ef40, link (null)
> [  174.012442] rx queue 2479e060, link e479e040
> [  174.041089] ath5k phy0: (ath5k_rx_start:1582): cachelsz 64 rxbufsize 2560
> [  174.104165] ath5k phy0: (ath5k_chan_set:1049): (2417 MHz) -> (2422 MHz)
> [  174.104182] ath5k phy0: (ath5k_reset:2745): resetting
> [  174.104332] ath5k phy0: (ath5k_txq_cleanup:1530): beacon queue 0
> [  174.104476] ath5k phy0: (ath5k_txq_cleanup:1539): txq [0] 2479ef60, link (null)
> 


So thanks again,
	Best regards,
		Maxim Levitsky

