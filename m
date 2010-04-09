Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:38083 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755590Ab0DITYI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 15:24:08 -0400
Subject: Re: Warning in ath9k after update from 2.6.33.1 to 2.6.33.2
From: Pavel Roskin <proski@gnu.org>
To: Thomas =?ISO-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: linux-wireless@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
In-Reply-To: <4BBF6206.2070103@archlinux.org>
References: <4BBF6206.2070103@archlinux.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Apr 2010 15:24:02 -0400
Message-Id: <1270841042.23853.20.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-04-09 at 19:21 +0200, Thomas Bächler wrote:
> Since I upgraded from 2.6.33.1 to .2, I get the following warning
> sometimes, related to wireless:
> 
> ------------[ cut here ]------------
> WARNING: at kernel/softirq.c:143 local_bh_enable_ip+0x82/0xb0()
> Hardware name: TECRA A11
...
>  [<ffffffff8135d42f>] _raw_spin_unlock_bh+0x1f/0x30
>  [<ffffffffa04018ed>] ath_tx_node_cleanup+0x19d/0x1c0 [ath9k]
>  [<ffffffffa03fc607>] ath9k_sta_notify+0x57/0xb0 [ath9k]

Indeed, the patch between 2.6.32.1 and 2.6.32.2 replaces spin_lock with
spin_lock_bh and spin_unlock with spin_unlock_bh.  The exact commit is
0524bcfa80f1fffb4e1fe18a0a28900869a58a7c by Ming Lei.

It's the unlock that gives the warning.  Line 143 in kernel/softirq.c
is:

WARN_ON_ONCE(in_irq() || irqs_disabled());

As I understand, the warning would be emitted when softirqs are enabled
while hardirqs are disabled.  Hardirqs have a higher priority, so it
would create a priority inversion.

>  [<ffffffffa039bbc4>] __sta_info_unlink+0x174/0x220 [mac80211]
>  [<ffffffffa039bca8>] sta_info_unlink+0x38/0x60 [mac80211]
>  [<ffffffffa03a2639>] ieee80211_set_disassoc+0x1e9/0x290 [mac80211]
>  [<ffffffffa03a2e89>] ieee80211_mgd_deauth+0x159/0x160 [mac80211]
>  [<ffffffff8104d700>] ? default_wake_function+0x0/0x10
>  [<ffffffffa03a9b69>] ieee80211_deauth+0x19/0x20 [mac80211]
>  [<ffffffffa02426de>] __cfg80211_mlme_deauth+0xee/0x130 [cfg80211]
>  [<ffffffff8135baad>] ? __mutex_lock_slowpath+0x26d/0x370
>  [<ffffffffa0246839>] __cfg80211_disconnect+0x159/0x1d0 [cfg80211]
>  [<ffffffffa0248f9c>] cfg80211_wext_siwmlme+0x8c/0xa0 [cfg80211]
>  [<ffffffff8133e6b7>] ioctl_standard_iw_point+0x207/0x3a0
>  [<ffffffffa0248f10>] ? cfg80211_wext_siwmlme+0x0/0xa0 [cfg80211]
>  [<ffffffff8133e850>] ? ioctl_standard_call+0x0/0xd0
>  [<ffffffff8133e8e9>] ioctl_standard_call+0x99/0xd0
>  [<ffffffff812b2660>] ? __dev_get_by_name+0xa0/0xc0
>  [<ffffffff8133dce7>] wext_ioctl_dispatch+0x1f7/0x210
>  [<ffffffff8133f330>] ? ioctl_private_call+0x0/0xa0
>  [<ffffffff8133de91>] wext_handle_ioctl+0x41/0x90
>  [<ffffffff812b8299>] dev_ioctl+0x679/0x850
>  [<ffffffff812a0522>] sock_ioctl+0xe2/0x290
>  [<ffffffff812a369d>] ? sys_recvfrom+0x13d/0x160
>  [<ffffffff811324c8>] vfs_ioctl+0x38/0xd0
>  [<ffffffff81132670>] do_vfs_ioctl+0x80/0x560
>  [<ffffffff81132bd1>] sys_ioctl+0x81/0xa0
>  [<ffffffff8100b1f9>] ? do_device_not_available+0x9/0x10
>  [<ffffffff81009fc2>] system_call_fastpath+0x16/0x1b
> ---[ end trace 8dbf12cb72787a6d ]---

This looks like a call initiated by userspace through wireless
extensions.  I don't see where hardirqs are disabled.

A simple fix would be to use spin_lock_irqsave/spin_unlock_irqrestore,
but I would prefer to understand what is going on.

It's a regression in stable series, so it should be taken very
seriously.

-- 
Regards,
Pavel Roskin
