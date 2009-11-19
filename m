Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55497 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbZKSNnE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 08:43:04 -0500
Received: by bwz27 with SMTP id 27so2348454bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 19 Nov 2009 05:43:08 -0800 (PST)
Subject: Re: mac80211 breaks suspend to disk
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1258579261.30511.84.camel@johannes.local>
References: <1258568836.4512.13.camel@maxim-laptop>
	 <20091118202802.GE2911@tuxdriver.com>
	 <1258576749.8018.7.camel@maxim-laptop>
	 <1258578199.30511.80.camel@johannes.local>
	 <1258579170.4525.2.camel@maxim-laptop>
	 <1258579261.30511.84.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Nov 2009 15:43:03 +0200
Message-ID: <1258638183.5063.4.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-11-18 at 22:21 +0100, Johannes Berg wrote: 
> On Wed, 2009-11-18 at 23:19 +0200, Maxim Levitsky wrote:
> 
> > > Then again, we drop RX frames while local->suspended is true, and I
> > > guess we don't really care about missing a few more frames when we're
> > > just waking up, so it should be OK to keep suspended == true while doing
> > > the startup.
> > > 
> > > EXCEPT drivers are going to start using ieee80211_queue_work() already
> > > then from the callbacks, which we must allow.
> > > 
> > > So ... maybe this?
> > 
> > 
> > This will likely fix this problem.
> > I will run my suspend/resume loop for a while and let you know if it
> > works.
> 
> Thanks. I'll take another look at the code to see if there's another
> code path that could now end in warnings, but I don't think so.
> 
> I suppose you could reduce your AP's beacon interval to make it more
> likely to trigger.
> 
> johannes


This problem definitely is fixed.

One more finding from the hibernate loop though:

Nov 19 12:25:49 maxim-laptop NetworkManager: <info>  (wlan0): deactivating device (reason: 37).
Nov 19 12:25:49 maxim-laptop NetworkManager: <info>  (wlan0): canceled DHCP transaction, dhcp client pid 6130
Nov 19 12:25:49 maxim-laptop kernel: [  239.925841] wlan0: disassociating from 00:1b:9e:d8:77:02 by local choice (reason=3)
Nov 19 12:25:49 maxim-laptop kernel: [  239.940401] phy0: Removed STA 00:1b:9e:d8:77:02
Nov 19 12:25:49 maxim-laptop kernel: [  239.982746] phy0: Destroyed STA 00:1b:9e:d8:77:02
Nov 19 12:25:49 maxim-laptop NetworkManager: <WARN>  check_one_route(): (wlan0) error -34 returned from rtnl_route_del(): Sucess#012
Nov 19 12:25:49 maxim-laptop NetworkManager: <info>  (wlan0): cleaning up...
Nov 19 12:25:49 maxim-laptop NetworkManager: <info>  (wlan0): taking down device.
Nov 19 12:25:49 maxim-laptop avahi-daemon[1626]: Withdrawing address record for 10.1.0.2 on wlan0.
Nov 19 12:25:49 maxim-laptop avahi-daemon[1626]: Leaving mDNS multicast group on interface wlan0.IPv4 with address 10.1.0.2.
Nov 19 12:25:49 maxim-laptop kernel: [  239.998665] wlan0: deauthenticating from 00:1b:9e:d8:77:02 by local choice (reason=3)
Nov 19 12:25:49 maxim-laptop kernel: [  240.072664] phy0: device now idle
Nov 19 12:25:49 maxim-laptop kernel: [  240.105115] ------------[ cut here ]------------
Nov 19 12:25:49 maxim-laptop avahi-daemon[1626]: Interface wlan0.IPv4 no longer relevant for mDNS.
Nov 19 12:25:49 maxim-laptop kernel: [  240.120021] WARNING: at /home/maxim/software/kernel/linux-2.6/net/wireless/core.c:618 wdev_cleanup_work+0xe9/0x110 [cfg80211]()
Nov 19 12:25:49 maxim-laptop kernel: [  240.145103] hpet1: lost 1 rtc interrupts
Nov 19 12:25:49 maxim-laptop kernel: [  240.150333] Hardware name: Aspire 5720     
Nov 19 12:25:49 maxim-laptop kernel: [  240.150337] Modules linked in: af_packet usb_storage nfsd exportfs iwl3945 usb_libusual snd_hda_codec_
realtek nfs cpufreq_powersave uvcvideo snd_hda_intel iwlcore videodev lockd cpufreq_conservative snd_hda_codec mac80211 v4l1_compat nfs_acl cpufreq_userspace acpi_cpufreq v4
l2_compat_ioctl32 snd_hwdep coretemp auth_rpcgss uhci_hcd joydev tg3 cfg80211 ohci1394 ehci_hcd snd_pcm sbp2 sunrpc usbcore psmouse libphy evdev rfkill snd_page_alloc video 
nvidia(P) ieee1394 output lirc_ene0100 serio_raw fuse lzo lzo_decompress lzo_compress
Nov 19 12:25:49 maxim-laptop kernel: [  240.150385] Pid: 9, comm: events/0 Tainted: P           2.6.32-rc7-wl #185
Nov 19 12:25:49 maxim-laptop kernel: [  240.150388] Call Trace:
Nov 19 12:25:49 maxim-laptop kernel: [  240.150401]  [<ffffffff81043a98>] warn_slowpath_common+0x78/0xb0
Nov 19 12:25:49 maxim-laptop kernel: [  240.150405]  [<ffffffff81043adf>] warn_slowpath_null+0xf/0x20
Nov 19 12:25:49 maxim-laptop kernel: [  240.150416]  [<ffffffffa0b866a9>] wdev_cleanup_work+0xe9/0x110 [cfg80211]
Nov 19 12:25:49 maxim-laptop kernel: [  240.150424]  [<ffffffffa0b865c0>] ? wdev_cleanup_work+0x0/0x110 [cfg80211]
Nov 19 12:25:49 maxim-laptop kernel: [  240.150428]  [<ffffffff81056eb6>] worker_thread+0x1f6/0x360
Nov 19 12:25:49 maxim-laptop kernel: [  240.150431]  [<ffffffff81056e64>] ? worker_thread+0x1a4/0x360
Nov 19 12:25:49 maxim-laptop kernel: [  240.150436]  [<ffffffff8105b9f0>] ? autoremove_wake_function+0x0/0x40
Nov 19 12:25:49 maxim-laptop kernel: [  240.150441]  [<ffffffff8106d0ad>] ? trace_hardirqs_on+0xd/0x10
Nov 19 12:25:49 maxim-laptop kernel: [  240.150445]  [<ffffffff81056cc0>] ? worker_thread+0x0/0x360
Nov 19 12:25:49 maxim-laptop kernel: [  240.150449]  [<ffffffff8105b73e>] kthread+0x8e/0xa0
Nov 19 12:25:49 maxim-laptop kernel: [  240.150453]  [<ffffffff8100cf5a>] child_rip+0xa/0x20
Nov 19 12:25:49 maxim-laptop kernel: [  240.150457]  [<ffffffff8100c8c0>] ? restore_args+0x0/0x30
Nov 19 12:25:49 maxim-laptop kernel: [  240.150461]  [<ffffffff8105b6b0>] ? kthread+0x0/0xa0
Nov 19 12:25:49 maxim-laptop kernel: [  240.150464]  [<ffffffff8100cf50>] ? child_rip+0x0/0x20
Nov 19 12:25:49 maxim-laptop kernel: [  240.150466] ---[ end trace ea0fcbca6d09945c ]---
Nov 19 12:25:50 maxim-laptop kernel: [  240.833019] PM: Marking nosave pages: 0000000000001000 - 0000000000006000
Nov 19 12:25:50 maxim-laptop kernel: [  240.833402] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
Nov 19 12:25:50 maxim-laptop kernel: [  240.833782] PM: Marking nosave pages: 000000007fcfd000 - 000000007fd08000
Nov 19 12:25:50 maxim-laptop kernel: [  240.834159] PM: Marking nosave pages: 000000007fd52000 - 000000007fd55000
Nov 19 12:25:50 maxim-laptop kernel: [  240.834531] PM: Marking nosave pages: 000000007fdbb000 - 000000007fdbf000
Nov 19 12:25:50 maxim-laptop kernel: [  240.834904] PM: Basic memory bitmaps created
Nov 19 12:26:57 maxim-laptop kernel: [  240.835140] PM: Syncing filesystems ... done.
Nov 19 12:26:57 maxim-laptop kernel: [  241.022693] Freezing user space processes ... (elapsed 0.00 seconds) done.


Other that that, I got few freezes, this time with no feedback whatsoever, blank screen, thus very likely something different.
Might be nvidia proprietary driver fault too.


Best regards,
	Maxim Levitsky



