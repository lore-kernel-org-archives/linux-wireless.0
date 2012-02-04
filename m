Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53391 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab2BDRUG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Feb 2012 12:20:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1RtjHP-0004jm-Dv
	for linux-wireless@vger.kernel.org; Sat, 04 Feb 2012 18:20:03 +0100
Received: from 88-97-16-53.dsl.zen.co.uk ([88.97.16.53])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 04 Feb 2012 18:20:03 +0100
Received: from frank by 88-97-16-53.dsl.zen.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 04 Feb 2012 18:20:03 +0100
To: linux-wireless@vger.kernel.org
From: "Frank A. Kingswood" <frank@kingswood-consulting.co.uk>
Subject: Kernel panic with brcm4313 (kernel 3.2.2)
Date: Sat, 04 Feb 2012 17:02:03 +0000
Message-ID: <jgjoab$l54$1@dough.gmane.org> (sfid-20120204_182012_063274_4A08C8E6)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On a new (Samsung 305U1A) laptop with BRCM4313 wireless I have not been 
able to use the wireless at all, although occasionally a flicker of life
can be seen in it.

"iwconfig scan" usually fails to report more than one access point. 
Disabling the local AP makes it show up a different one, suggesting it
is actually able to see it but somewhere fails to pass the data along.

Fiddling with NetworkManager produces this kernel panic:

------------[ cut here ]------------
WARNING: at net/wireless/mlme.c:309 cfg80211_send_auth_timeout+0x6d/0xd0 
[cfg80211]()
Hardware name: 305U1A
Modules linked in: powernow_k8 mperf cpufreq_powersave cpufreq_userspace 
cpufreq_stats cpufreq_conservative xt_recent nf_conntrack_ipv4 
nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp iptable_filter ip_tables 
x_tables fuse arc4 brcmsmac mac80211 brcmutil cfg80211 crc8 cordic loop 
snd_hda_codec_realtek snd_hda_codec_hdmi radeon ttm drm_kms_helper 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss uvcvideo snd_mixer_oss 
drm i2c_piix4 snd_pcm agpgart i2c_algo_bit cfbcopyarea cfbimgblt video 
cfbfillrect snd_timer snd_page_alloc battery processor button ac 
thermal_sys sd_mod ahci libahci libata scsi_mod
Pid: 132, comm: kworker/u:4 Not tainted 3.2.2 #9
Call Trace:
[<ffffffff8103af0b>] ? warn_slowpath_common+0x7b/0xc0
[<ffffffffa02a0d3d>] ? cfg80211_send_auth_timeout+0x6d/0xd0 [cfg80211]
[<ffffffff8105b4fd>] ? sched_clock_cpu+0x5d/0xe0
[<ffffffffa02c0301>] ? ieee80211_probe_auth_done+0x101/0x110 [mac80211]
[<ffffffffa02c35a6>] ? ieee80211_work_work+0x4d6/0x1300 [mac80211]
[<ffffffffa02c30d0>] ? free_work+0x10/0x10 [mac80211]
[<ffffffff8104fb88>] ? process_one_work+0xf8/0x370
[<ffffffff8104ec8f>] ? cwq_activate_first_delayed+0x2f/0x90
[<ffffffff8105079d>] ? worker_thread+0x14d/0x320
[<ffffffff81050650>] ? manage_workers.isra.31+0x1f0/0x1f0
[<ffffffff8105587e>] ? kthread+0x7e/0x90
[<ffffffff813b25f4>] ? kernel_thread_helper+0x4/0x10
[<ffffffff81055800>] ? kthread_worker_fn+0x180/0x180
[<ffffffff813b25f0>] ? gs_change+0xb/0xb
---[ end trace eacbed78fae113fa ]---


The WiFi card:
03:00.0 Network controller [0280]: Broadcom Corporation BCM4313 
802.11b/g/n Wireless LAN Controller [14e4:4727] (rev 01)
	Subsystem: Wistron NeWeb Corp. Device [185f:051a]
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at fea00000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: brcmsmac


Kernel: 3.2.2
CONFIG_WLAN=y
CONFIG_BRCMUTIL=m
CONFIG_BRCMSMAC=m
# CONFIG_BRCMDBG is not set

Full .config at http://pastebin.com/TqhTJpBS

I know support for 4313 is still very new, and am willing to test out 
development kernels if that helps.

Frank

