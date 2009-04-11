Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:39405 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbZDKXz6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Apr 2009 19:55:58 -0400
Received: by fxm2 with SMTP id 2so1580173fxm.37
        for <linux-wireless@vger.kernel.org>; Sat, 11 Apr 2009 16:55:55 -0700 (PDT)
Subject: Re: attempt to scan fails (device busy) if essid/ssid was changed
 recently
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1239449651.17031.42.camel@johannes.local>
References: <1239062401.4705.23.camel@maxim-laptop>
	 (sfid-20090407_020013_939126_90578556)  <1239092296.22453.1.camel@johannes.local>
	 <1239108689.15015.3.camel@maxim-laptop>
	 (sfid-20090407_145137_740898_8D0C40FD)  <1239109001.22453.40.camel@johannes.local>
	 <1239109497.15015.12.camel@maxim-laptop>
	 (sfid-20090407_150534_375314_4DA28551)  <1239110010.22453.41.camel@johannes.local>
	 <1239110412.15015.23.camel@maxim-laptop>
	 (sfid-20090407_152021_060436_AEF9110F)  <1239110860.4084.0.camel@johannes.local>
	 <1239112310.15015.25.camel@maxim-laptop>
	 <1239135878.17958.11.camel@maxim-laptop>
	 (sfid-20090407_222443_633750_085B264D)  <1239136637.7475.57.camel@johannes.local>
	 <1239395434.13792.3.camel@maxim-laptop>
	 (sfid-20090410_223110_294055_69850902)  <1239449651.17031.42.camel@johannes.local>
Content-Type: text/plain
Date: Sun, 12 Apr 2009 02:55:52 +0300
Message-Id: <1239494152.8136.8.camel@maxim-laptop> (sfid-20090412_015602_635112_B9167DC4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-04-11 at 13:34 +0200, Johannes Berg wrote:
> On Fri, 2009-04-10 at 23:30 +0300, Maxim Levitsky wrote:
> 
> > It is.
> > 
> > I have just compiled iwlwifi.git tree, and same message is there:
> > 
> > 
> > 
> > > [ 1666.298390] ------------[ cut here ]------------
> > > [ 1666.298395] WARNING: at /home/maxim/software/kernel/linux-2.6/net/wireless/core.h:79 nl80211_send_wiphy+0x8bd/0xa20 [cfg80211]()
> > > [ 1666.298399] Hardware name: Aspire 5720     
> 
> > > [ 1666.298473] Pid: 13164, comm: wpa_supplicant Tainted: P           2.6.29-wl #19
> > > [ 1666.298477] Call Trace:
> > > [ 1666.298490]  [<ffffffff80241320>] warn_slowpath+0xd0/0x130
> > > [ 1666.298504]  [<ffffffffa00f9ac6>] ? nl80211_get_wiphy+0x56/0xd0 [cfg80211]
> > > [ 1666.298512]  [<ffffffff802a8263>] ? __alloc_pages_internal+0xe3/0x4f0
> > > [ 1666.298525]  [<ffffffffa00f965d>] nl80211_send_wiphy+0x8bd/0xa20 [cfg80211]
> 
> Then your stacktrace is crap -- please apply the patch I just sent you.

You mean "[PATCH] cfg80211: convert mutex assert to macro"

With the patch:

> 
> [   59.405096] Call Trace:
> [   59.405106]  [<ffffffff80241320>] warn_slowpath+0xd0/0x130
> [   59.405117]  [<ffffffffa010ea86>] ? nl80211_get_wiphy+0x56/0xd0 [cfg80211]
> [   59.405122]  [<ffffffff802a8263>] ? __alloc_pages_internal+0xe3/0x4f0
> [   59.405128]  [<ffffffff804ade47>] ? netdev_run_todo+0x57/0x260
> [   59.405137]  [<ffffffffa010e76c>] nl80211_send_wiphy+0xa0c/0xa20 [cfg80211]
> [   59.405141]  [<ffffffff802a86ee>] ? __get_free_pages+0x1e/0x60
> [   59.405147]  [<ffffffff804a59ae>] ? __alloc_skb+0x6e/0x140
> [   59.405156]  [<ffffffffa010eaa4>] nl80211_get_wiphy+0x74/0xd0 [cfg80211]
> [   59.405161]  [<ffffffff804c5986>] genl_rcv_msg+0x1b6/0x1f0
> [   59.405166]  [<ffffffff804c57d0>] ? genl_rcv_msg+0x0/0x1f0
> [   59.405171]  [<ffffffff804c4839>] netlink_rcv_skb+0x89/0xb0
> [   59.405174]  [<ffffffff804c57b7>] genl_rcv+0x27/0x40
> [   59.405179]  [<ffffffff804c4234>] netlink_unicast+0x2c4/0x2e0
> [   59.405183]  [<ffffffff804a59ae>] ? __alloc_skb+0x6e/0x140
> [   59.405187]  [<ffffffff804c4464>] netlink_sendmsg+0x214/0x310
> [   59.405191]  [<ffffffff8049ceb7>] sock_sendmsg+0x127/0x140
> [   59.405198]  [<ffffffff80258c20>] ? autoremove_wake_function+0x0/0x40
> [   59.405204]  [<ffffffff802a1c62>] ? unlock_page+0x22/0x30
> [   59.405209]  [<ffffffff802b7349>] ? __do_fault+0x1e9/0x4a0
> [   59.405213]  [<ffffffff8049dd17>] ? move_addr_to_kernel+0x57/0x60
> [   59.405217]  [<ffffffff804a6e7c>] ? verify_iovec+0x3c/0xd0
> [   59.405221]  [<ffffffff8049d059>] sys_sendmsg+0x189/0x320
> [   59.405225]  [<ffffffff8049bf71>] ? sock_ioctl+0x81/0x270
> [   59.405229]  [<ffffffff802dfd21>] ? vfs_ioctl+0x31/0xa0
> [   59.405233]  [<ffffffff802dfe18>] ? do_vfs_ioctl+0x88/0x580
> [   59.405238]  [<ffffffff802d20c9>] ? __fput+0x169/0x1e0
> [   59.405242]  [<ffffffff802e03a9>] ? sys_ioctl+0x99/0xa0
> [   59.405246]  [<ffffffff8020c5db>] system_call_fastpath+0x16/0x1b

Same backtrace it seems.
Everything works, so I guess that this one if false alarm.

> 
> > On top of that I need to note that NM doesn't show signal strenghts
> > correctly.
> > Instead it shows 100% for all AP except the current active one.
> 
> Separate thing -- don't hide it in this thread. I'll not even think
> about looking at it here.
Ok, fine. Just note that this does seem to be kernel issue.

The wpa_supplicant constructs scan results when it uses wext,
but it just dumps what it receives over netlink to NM, when it uses
nl80211. Thus kernel doesn't send what it expects. But enough, I start a
separate thread on wpa_supplicant mailing list. They know about this
better.


Maxim Levitsky

