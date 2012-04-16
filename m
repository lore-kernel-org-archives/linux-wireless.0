Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:40474 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750923Ab2DPGrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 02:47:10 -0400
Received: by lagz14 with SMTP id z14so3514779lag.28
        for <linux-wireless@vger.kernel.org>; Sun, 15 Apr 2012 23:47:07 -0700 (PDT)
Message-ID: <1334558825.4209.8.camel@cumari> (sfid-20120416_084714_499033_4F483E83)
Subject: Re: Splat in latest wireless-testing (3.4.0-rc2+)
From: Luciano Coelho <coelho@ti.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 16 Apr 2012 09:47:05 +0300
In-Reply-To: <4F870095.90207@candelatech.com>
References: <4F870095.90207@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

On Thu, 2012-04-12 at 09:19 -0700, Ben Greear wrote: 
> I have a few patches applied, but likely nothing that affects
> this particular bit of code.
> 
> ------------[ cut here ]------------
> WARNING: at /home/greearb/git/linux.wireless-testing/net/mac80211/iface.c:171 ieee80211_check_queues+0x)
> Hardware name: To Be Filled By O.E.M.
> Modules linked in: 8021q garp stp llc fuse macvlan pktgen w83627ehf hwmon_vid nfs lockd fscache auth_rp]
> Pid: 2500, comm: hostapd Not tainted 3.4.0-rc2-wl+ #9
> Call Trace:
>   [<c04273e4>] warn_slowpath_common+0x65/0x7a
>   [<f89e814e>] ? ieee80211_check_queues+0xab/0xe8 [mac80211]
>   [<c0427408>] warn_slowpath_null+0xf/0x13
>   [<f89e814e>] ieee80211_check_queues+0xab/0xe8 [mac80211]
>   [<f89e8a5e>] ieee80211_do_open+0x2b9/0x509 [mac80211]
>   [<f89e8d04>] ieee80211_open+0x56/0x60 [mac80211]
>   [<c0719ff2>] __dev_open+0x80/0xae
>   [<c07181a7>] __dev_change_flags+0xa1/0x116
>   [<c0719f46>] dev_change_flags+0x13/0x3f
>   [<c07647ea>] devinet_ioctl+0x220/0x4ac
>   [<c05987d6>] ? copy_to_user+0x2f/0x105
>   [<c0765ba1>] inet_ioctl+0x82/0x9b
>   [<c070b5b6>] sock_ioctl+0x1c5/0x1e7
>   [<c070b3f1>] ? kernel_sendmsg+0x37/0x37
>   [<c04cc572>] do_vfs_ioctl+0x460/0x49f
>   [<c04c7e44>] ? path_put+0x15/0x18
>   [<c04cc5f2>] sys_ioctl+0x41/0x61
>   [<c07bd118>] sysenter_do_call+0x12/0x28
> ---[ end trace dd414f1907cc9857 ]---

This patch I sent last week should fix your problem:

http://www.spinics.net/lists/linux-wireless/msg88226.html

-- 
Cheers,
Luca.

