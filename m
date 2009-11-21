Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp6.freeserve.com ([193.252.22.190]:4924 "EHLO
	smtp6.freeserve.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbZKUAOT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 19:14:19 -0500
Date: Sat, 21 Nov 2009 00:15:12 +0000
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: William Bourque <william.bourque@polymtl.ca>,
	wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de
Subject: Re: Fatal DMA error problem with netbook and BCM4312
Message-ID: <20091121001512.02326eda@boulder.homenet>
In-Reply-To: <4B06F685.1020405@lwfinger.net>
References: <4AFA09C8.4060602@gmail.com>
	<200911131216.43704.mb@bu3sch.de>
	<4AFD83CA.2050508@lwfinger.net>
	<200911131836.26857.mb@bu3sch.de>
	<4AFD9E20.3060501@gmail.com>
	<4AFDD1C9.4050402@lwfinger.net>
	<4AFDF68C.4040804@polymtl.ca>
	<4AFE1E5F.9040009@lwfinger.net>
	<4AFEFC2C.5030704@polymtl.ca>
	<4B068ED9.5070107@lwfinger.net>
	<20091120195834.334d8bc0@boulder.homenet>
	<4B06F685.1020405@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 20 Nov 2009 14:05:25 -0600
Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 11/20/2009 01:58 PM, Chris Vine wrote:
> > On Fri, 20 Nov 2009 06:43:05 -0600
> > Larry Finger <Larry.Finger@lwfinger.net> wrote:
> >> One last check. I would appreciate receiving answers to the
> >> following questions. These questions apply to anyone else with
> >> this problem.
> >>
> >> Does the pm_qos patch help your "fatal DMA error" problem,
> >> particularly when booted from power-off?
> >>
> >> If you warm-boot after loading the wl driver, does the patch make
> >> any difference?
> > 
> > What's the date/time of the last patch you posted for this and what
> > kernel does it apply to?
> 
> Friday 11/13 ar 22:38 CET. The link is at
> https://lists.berlios.de/pipermail/bcm43xx-dev/2009-November/006338.html.
> 
> The patch is written for wireless-testing, but it should apply on
> mainline kernels as well.

OK.  I have applied the patch to mainline kernel 2.6.32-rc8.

COLD BOOT

On a cold boot, the patch gives rise to a very substantial improvement.
Without it, with the processor acpi module loaded, often just bringing
up the interface would cause the DMA errors, and if that didn't do it
then running 'iwlist scan' a few times always would.  At that point the
wireless device required a cold boot to get it working again.

With the patch applied and with the processor acpi module loaded it
works well for a period - I can bring up the interface, associate with
my wireless router and do some web browsing. However if I gave it a
stress test by rsyncing a large directory (actually all my
mozilla/firefox caches) then after a while, say 1 minute of full speed
throughput, I got the kernel warning at the end of this post. Shortly
after this the DMA errors arose, all throughput ceased and shortly
afterwards I got a complete kernel lock-up.  (I couldn't ssh in or nor
did anything appear in the logs.) I was not able to capture the text of
the DMA errors but they followed the usual pattern.

This is pretty well the same effect as not applying the patch and
blacklisting the processor module: I reported a few weeks ago that
blacklisting that module solves the DMA problem for me, but further
testing showed that to be wrong - I got kernel warnings (sorry I didn't
save them) followed by the usual DMA errors following sometimes by a
kernel lock-up.

WARM BOOT FROM KERNEL WITH WL MODULE INSTALLED

The patched kernel makes no change on a warm boot in the sense that if I
warm boot after initialising the wireless device with the wl module
then the b43 module appears to work correctly, both with and without
the patch applied.

On the same stress test as mentioned above, I have not been able to
induce the DMA errors nor kernel warnings.  It resolutely refuses to do
anything except work correctly.

KERNEL WARNING

The kernel warning I induced on a cold boot was as follows:

WARNING: at drivers/net/wireless/b43/dma.c:1151
b43_dma_handle_txstatus+0x55/0x420 [b43]()
Hardware name: 20021,2959
Modules linked in: arc4 ecb b43 ssb mmc_core pcmcia mac80211 cfg80211
led_class pcmcia_core i915 drm_kms_helper drm i2c_algo_bit snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss sco bnep rfcomm l2cap crc16 nfsd exportfs nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables xt_helper xt_conntrack xt_state x_tables nf_conntrack_irc nf_conntrack_ftp nf_conntrack parport_pc parport fuse snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm uvcvideo rtc_cmos btusb bluetooth rtc_core intel_agp rfkill snd_timer battery ac videodev rtc_lib video processor thermal usbhid tg3 psmouse v4l1_compat snd wmi thermal_sys agpgart button output hwmon i2c_i801 evdev libphy soundcore sg serio_raw snd_page_alloc
Pid: 4412, comm: irq/17-b43 Not tainted 2.6.32-rc8 #1
Call Trace:
 [<f8dd4c95>] ? b43_dma_handle_txstatus+0x55/0x420 [b43]
 [<c10328fc>] warn_slowpath_common+0x7c/0xa0
 [<f8dd4c95>] ? b43_dma_handle_txstatus+0x55/0x420 [b43]
 [<c1032935>] warn_slowpath_null+0x15/0x20
 [<f8dd4c95>] b43_dma_handle_txstatus+0x55/0x420 [b43]
 [<c10265e1>] ? __dequeue_entity+0x21/0x40
 [<c1028ee9>] ? finish_task_switch+0x39/0x80
 [<f8dceb7e>] b43_handle_txstatus+0x6e/0x80 [b43]
 [<f8dbcdbb>] b43_do_interrupt_thread+0x21b/0x910 [b43]
 [<c102a34f>] ? try_to_wake_up+0x8f/0x210
 [<f8dbd518>] b43_interrupt_thread_handler+0x18/0x30 [b43]
 [<c1068580>] irq_thread+0xc0/0x1a0
 [<c10684c0>] ? irq_thread+0x0/0x1a0
 [<c104ac24>] kthread+0x74/0x80
 [<c104abb0>] ? kthread+0x0/0x80
 [<c100384f>] kernel_thread_helper+0x7/0x38
---[ end trace 778fc6df7aca6d14 ]---
------------[ cut here ]------------
WARNING: at drivers/net/wireless/b43/dma.c:1154
b43_dma_handle_txstatus+0x6e/0x420 [b43]()
Hardware name: 20021,2959
Modules linked in: arc4 ecb b43 ssb mmc_core pcmcia mac80211 cfg80211
led_class pcmcia_core i915 drm_kms_helper drm i2c_algo_bit snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss sco bnep rfcomm l2cap crc16 nfsd exportfs nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables xt_helper xt_conntrack xt_state x_tables nf_conntrack_irc nf_conntrack_ftp nf_conntrack parport_pc parport fuse snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm uvcvideo rtc_cmos btusb bluetooth rtc_core intel_agp rfkill snd_timer battery ac videodev rtc_lib video processor thermal usbhid tg3 psmouse v4l1_compat snd wmi thermal_sys agpgart button output hwmon i2c_i801 evdev libphy soundcore sg serio_raw snd_page_alloc
Pid: 4412, comm: irq/17-b43 Tainted: G        W  2.6.32-rc8 #1
Call Trace:
 [<f8dd4cae>] ? b43_dma_handle_txstatus+0x6e/0x420 [b43]
 [<c10328fc>] warn_slowpath_common+0x7c/0xa0
 [<f8dd4cae>] ? b43_dma_handle_txstatus+0x6e/0x420 [b43]
 [<c1032935>] warn_slowpath_null+0x15/0x20
 [<f8dd4cae>] b43_dma_handle_txstatus+0x6e/0x420 [b43]
 [<c10265e1>] ? __dequeue_entity+0x21/0x40
 [<c1028ee9>] ? finish_task_switch+0x39/0x80
 [<f8dceb7e>] b43_handle_txstatus+0x6e/0x80 [b43]
 [<f8dbcdbb>] b43_do_interrupt_thread+0x21b/0x910 [b43]
 [<c102a34f>] ? try_to_wake_up+0x8f/0x210
 [<f8dbd518>] b43_interrupt_thread_handler+0x18/0x30 [b43]
 [<c1068580>] irq_thread+0xc0/0x1a0
 [<c10684c0>] ? irq_thread+0x0/0x1a0
 [<c104ac24>] kthread+0x74/0x80
 [<c104abb0>] ? kthread+0x0/0x80
 [<c100384f>] kernel_thread_helper+0x7/0x38
---[ end trace 778fc6df7aca6d15 ]---

Chris



