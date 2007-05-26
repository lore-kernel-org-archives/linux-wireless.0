Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:44650
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbXEZFC6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2007 01:02:58 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: BUG: at net/mac80211/ieee80211.c:1280 ieee80211_tx()
Date: Sat, 26 May 2007 07:02:56 +0200
Cc: "Will Dyson" <will.dyson@gmail.com>, linux-wireless@vger.kernel.org
References: <8e6f94720705251637o71a13d71w70199a3057048592@mail.gmail.com>
In-Reply-To: <8e6f94720705251637o71a13d71w70199a3057048592@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200705260702.56851.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 26 May 2007 01:37, Will Dyson wrote:
> Hi all,
> 
> First, the good news: bcm43xx-mac80211 in wireless-dev now works about
> as well for me as the old driver. Similar connection reliability,
> upload speed and download speed. Woo!

Whoo, nice. :)
/me pours a bottle of beer to everybody on the list.

> But I've got ton's of these in my log:
> 
>  BUG: at net/mac80211/ieee80211.c:1280 ieee80211_tx()

Hm, probably mac80211 bug. Not sure. I didn't look at the code, yet.

>  Call Trace:
>   [<ffffffff805866a3>] ieee80211_master_start_xmit+0x5f3/0x680
>   [<ffffffff804d447d>] dev_hard_start_xmit+0x26d/0x2d0
>   [<ffffffff804e4781>] __qdisc_run+0xd1/0x260
>   [<ffffffff804d6a87>] dev_queue_xmit+0x1a7/0x370
>   [<ffffffff8058a45b>] ieee80211_subif_start_xmit+0x34b/0x590
>   [<ffffffff804ce3a7>] kfree_skb+0x17/0x30
>   [<ffffffff804d447d>] dev_hard_start_xmit+0x26d/0x2d0
>   [<ffffffff804e4781>] __qdisc_run+0xd1/0x260
>   [<ffffffff804d6a87>] dev_queue_xmit+0x1a7/0x370
>   [<ffffffff804f9bef>] ip_output+0x19f/0x340
>   [<ffffffff804f9069>] ip_queue_xmit+0x219/0x430
>   [<ffffffff80295fe0>] __pollwait+0x0/0x110
>   [<ffffffff8050a82e>] tcp_transmit_skb+0x40e/0x7c0
>   [<ffffffff8022ce00>] default_wake_function+0x0/0x10
>   [<ffffffff8050c4bb>] __tcp_push_pending_frames+0x11b/0x940
>   [<ffffffff8059c6a8>] csum_partial_copy_from_user+0x88/0x120
>   [<ffffffff80500b66>] tcp_sendmsg+0x876/0xc80
>   [<ffffffff8022ce0d>] default_wake_function+0xd/0x10
>   [<ffffffff8022ba37>] __wake_up_common+0x47/0x70
>   [<ffffffff8051e795>] inet_sendmsg+0x45/0x80
>   [<ffffffff804c7161>] sock_aio_write+0x101/0x110
>   [<ffffffff80286071>] do_sync_write+0xf1/0x130
>   [<ffffffff80246f80>] autoremove_wake_function+0x0/0x40
>   [<ffffffff8023688e>] current_fs_time+0x3e/0x40
>   [<ffffffff80286999>] vfs_write+0x159/0x170
>   [<ffffffff80286fa0>] sys_write+0x50/0x90
>   [<ffffffff8020a1ae>] system_call+0x7e/0x83
> 
> Kernel: wireless-dev latest from git
> Arch: x86-64
> 
> My boot log is attached for full hardware information.
> 
