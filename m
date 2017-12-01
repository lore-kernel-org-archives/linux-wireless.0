Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:45094 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752793AbdLAPxN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 10:53:13 -0500
From: Christian Lamparter <chunkeey@gmail.com>
To: mbizon@freebox.fr
Cc: akolli@codeaurora.org, akolli@qti.qualcomm.com,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH 2/2] ath10k: add per peer tx stats support for 10.2.4
Date: Fri, 01 Dec 2017 16:53:10 +0100
Message-ID: <6519868.NEUq8DTjxK@debian64> (sfid-20171201_165326_275775_7B5D97BB)
In-Reply-To: <1512140710.38490.81.camel@sakura.staff.proxad.net>
References: <1512046701-14435-1-git-send-email-akolli@qti.qualcomm.com> <7792e2fb2c546d8745c65e48945f2535@codeaurora.org> <1512140710.38490.81.camel@sakura.staff.proxad.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, December 1, 2017 4:05:10 PM CET Maxime Bizon wrote:
> 
> On Fri, 2017-12-01 at 19:18 +0530, akolli@codeaurora.org wrote:
> 
> > Hope CONFIG_MAC80211_DEBUGFS is enabled in your build.
> 
> it wasn't and IMHO it's confusing because tx rate is filled by the other
> drivers without it.
> 
> I now have the following warning:
> 
> [   96.174967] ------------[ cut here ]------------
> [   96.179640] WARNING: CPU: 0 PID: 609 at net/wireless/util.c:1254 cfg80211_calculate_bitrate+0x174/0x220
> [   96.189538] invalid rate bw=1, mcs=9, nss=2
> [   96.219736] CPU: 0 PID: 609 Comm: hostapd Not tainted 4.14.3-00381-gec9756b0f64d #28
> [   96.227910] Hardware name: Marvell Kirkwood (Flattened Device Tree)
> [   96.235450] [<80010124>] (unwind_backtrace) from [<8000d9ec>] (show_stack+0x10/0x14)
> [   96.247180] [<8000d9ec>] (show_stack) from [<8002016c>] (__warn+0xdc/0xf8)
> [   96.254243] [<8002016c>] (__warn) from [<800201bc>] (warn_slowpath_fmt+0x34/0x44)
> [   96.262016] [<800201bc>] (warn_slowpath_fmt) from [<8064dfdc>] (cfg80211_calculate_bitrate+0x174/0x220)
> [   96.272652] [<8064dfdc>] (cfg80211_calculate_bitrate) from [<806692d4>] (nl80211_put_sta_rate+0x44/0x1dc)
> [   96.282509] [<806692d4>] (nl80211_put_sta_rate) from [<8066001c>] (nl80211_send_station+0x388/0xaf0)
> [   96.292261] [<8066001c>] (nl80211_send_station) from [<8066082c>] (nl80211_get_station+0xa8/0xec)
> [   96.304166] [<8066082c>] (nl80211_get_station) from [<80509c20>] (genl_rcv_msg+0x2dc/0x34c)
> [   96.313324] [<80509c20>] (genl_rcv_msg) from [<8050890c>] (netlink_rcv_skb+0x84/0xdc)
> [   96.321880] [<8050890c>] (netlink_rcv_skb) from [<805093c0>] (genl_rcv+0x20/0x34)
> [   96.329668] [<805093c0>] (genl_rcv) from [<80508188>] (netlink_unicast+0x12c/0x1e0)
> [   96.338408] [<80508188>] (netlink_unicast) from [<805085d8>] (netlink_sendmsg+0x2e0/0x304)
> [   96.350736] [<805085d8>] (netlink_sendmsg) from [<804b5f9c>] (sock_sendmsg+0x14/0x24)
> [   96.358656] [<804b5f9c>] (sock_sendmsg) from [<804b66e8>] (___sys_sendmsg+0x1c8/0x20c)
> [   96.367093] [<804b66e8>] (___sys_sendmsg) from [<804b739c>] (__sys_sendmsg+0x40/0x64)
> [   96.375276] [<804b739c>] (__sys_sendmsg) from [<8000a3e0>] (ret_fast_syscall+0x0/0x44)
> [   96.383455] ---[ end trace da8257d6a850e91a ]---
> 
Look for:

"[PATCH] ath10k: fix recent bandwidth conversion bug"
