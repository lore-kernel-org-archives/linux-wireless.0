Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.nanl.de ([217.115.11.12]:56772 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758616Ab3BGOfA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 09:35:00 -0500
Received: from mail-ie0-f169.google.com (mail-ie0-f169.google.com [209.85.223.169])
	by mail.nanl.de (Postfix) with ESMTPSA id CE90A45E50
	for <linux-wireless@vger.kernel.org>; Thu,  7 Feb 2013 14:33:38 +0000 (UTC)
Received: by mail-ie0-f169.google.com with SMTP id 13so3626846iea.0
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2013 06:34:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130206151313.GB373@markyou.marvell.com>
References: <20130103075440.GA20523@markyou.marvell.com> <CAOiHx=kpV8TScc4gQRZUBwUDAEL-j+uoNg3eodKi8WwmAHYg=w@mail.gmail.com>
 <20130206151313.GB373@markyou.marvell.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Thu, 7 Feb 2013 15:34:32 +0100
Message-ID: <CAOiHx=n_ZdSUmR8EgHNSqb8FeO+2iOA=iU8L5VdVy7GFsZqeOA@mail.gmail.com> (sfid-20130207_153508_804442_1AD9E6EE)
Subject: Re: [PATCH 5/5] mwl8k: bump firmware API to 3
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 February 2013 16:13, Yogesh Ashok Powar <yogeshp@marvell.com> wrote:
> Hi Jonas,
>
> We have already mailed the API-3 firmware to Ben Hutching for adding
> it to linux-firmware.git.
>
> Meanwhile please get the new AP firmware from
> https://github.com/yogeshpowar/mwl8k_ap_firmware

Thanks, with it I can get AP mode to work on both a 2.4 GHz single
band and a dual band card, but a 5 GHz single band card craps out when
bringing up the interface (see the oops at the end).

I haven't looked to deeply into what's happening, and I haven't made
sure yet the problem isn't caused by any OpenWrt modifications (which
is using compat-wirless 2013-01-07). I'll take a closer look tomorrow.

Regards
Jonas


P.S: The oops:
[  665.669993] Unable to handle kernel NULL pointer dereference at
virtual address 00000016
[  665.678194] pgd = c6d58000
[  665.680941] [00000016] *pgd=06f8a831, *pte=00000000, *ppte=00000000
[  665.687303] Internal error: Oops: 17 [#1]
[  665.691326] Modules linked in: nf_nat_irc nf_nat_ftp
nf_conntrack_irc nf_conntrack_ftp ipt_MASQUERADE iptable_nat nf_nat
pppoe xt_conntrack xt_CT xt_NOTRACK iptable_raw xt_state
nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack pppox ipt_REJECT
xt_TCPMSS ipt_LOG xt_comment xt_multiport xt_mac xt_limit
iptable_mangle iptable_filter ip_tables xt_tcpudp x_tables ppp_async
ppp_generic slhc mwl8k(O) mac80211(O) crc_ccitt cfg80211(O) compat(O)
arc4 aes_generic crypto_algapi
[  665.732940] CPU: 0    Tainted: G           O  (3.3.8 #52)
[  665.738387] PC is at cfg80211_chandef_usable+0x7c/0x1bc [cfg80211]
[  665.744611] LR is at cfg80211_chandef_usable+0x20/0x1bc [cfg80211]
(...)
[  666.116373] Backtrace:
[  666.118866] [<bf0368dc>] (cfg80211_chandef_usable+0x0/0x1bc
[cfg80211]) from [<bf025e64>] (nl80211_leave_mesh+0x244/0x264
[cfg80211])
[  666.130919]  r7:c6d12100 r6:0000143c r5:c0611c48 r4:c0611b98
[  666.136668] [<bf025d84>] (nl80211_leave_mesh+0x164/0x264
[cfg80211]) from [<bf02634c>] (nl80211_remain_on_channel+0x2a0/0x358
[cfg80211])
[  666.149074]  r7:c6d12000 r6:c6d12000 r5:c6f4f368 r4:00000003
[  666.154814] [<bf0262ec>] (nl80211_remain_on_channel+0x240/0x358
[cfg80211]) from [<bf02ddb0>] (nl80211_set_wiphy+0x264/0x560
[cfg80211])
[  666.167150] [<bf02db4c>] (nl80211_set_wiphy+0x0/0x560 [cfg80211])
from [<c01f94e0>] (genl_rcv_msg+0x1b8/0x1f8)
[  666.177205] [<c01f9328>] (genl_rcv_msg+0x0/0x1f8) from [<c01f89a0>]
(netlink_rcv_skb+0x58/0xb4)
[  666.185949] [<c01f8948>] (netlink_rcv_skb+0x0/0xb4) from
[<c01f931c>] (genl_rcv+0x20/0x2c)
[  666.194251]  r6:c6f70780 r5:0000002c r4:c6f70780 r3:00000001
[  666.199973] [<c01f92fc>] (genl_rcv+0x0/0x2c) from [<c01f8418>]
(netlink_unicast+0x154/0x1f4)
[  666.208449]  r4:c785ea00 r3:c01f92fc
[  666.212057] [<c01f82c4>] (netlink_unicast+0x0/0x1f4) from
[<c01f8790>] (netlink_sendmsg+0x230/0x2b0)
[  666.221240] [<c01f8560>] (netlink_sendmsg+0x0/0x2b0) from
[<c01cccf8>] (sock_sendmsg+0x90/0xa4)
[  666.229986] [<c01ccc68>] (sock_sendmsg+0x0/0xa4) from [<c01cdcb0>]
(__sys_sendmsg+0x290/0x298)
[  666.238637]  r9:00000000 r8:c0611ec8 r6:0000002c r5:c0610000 r4:c0611f64
[  666.245411] [<c01cda20>] (__sys_sendmsg+0x0/0x298) from
[<c01cf52c>] (sys_sendmsg+0x44/0x6c)
[  666.253897] [<c01cf4e8>] (sys_sendmsg+0x0/0x6c) from [<c00090a0>]
(ret_fast_syscall+0x0/0x2c)

Full stack at <http://pastebin.com/v0tYysE9>
