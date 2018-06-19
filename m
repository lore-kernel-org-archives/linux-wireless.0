Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:36417 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937124AbeFSCdM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 22:33:12 -0400
Received: by mail-ot0-f175.google.com with SMTP id c15-v6so20867084otl.3
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2018 19:33:12 -0700 (PDT)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Subject: Kernel Oops in ieee80211_subif_start_xmit
Message-ID: <737b0716-78d3-5a4c-1bda-008ff84f9b63@gmail.com> (sfid-20180619_043317_315469_A2CC14C7)
Date: Mon, 18 Jun 2018 21:33:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Some Arch Linux users are reporting a kernel oops when using iwd on 4.17 
inside the control port bits.  It seems to be pre-emption related since 
I've never seen this in all my testing.  Any pointers as to what might 
be causing this?

[ 5069.567760] Call Trace:
[ 5069.567765]  dump_stack+0x5c/0x80
[ 5069.567769]  check_preemption_disabled.cold.0+0x46/0x51
[ 5069.567778]  __ieee80211_subif_start_xmit+0x144/0x210 [mac80211]
[ 5069.567786]  ieee80211_tx_control_port+0x116/0x140 [mac80211]
[ 5069.567806]  nl80211_tx_control_port+0x13c/0x270 [cfg80211]
[ 5069.567809]  genl_family_rcv_msg+0x1c4/0x3a0
[ 5069.567811]  genl_rcv_msg+0x47/0x90
[ 5069.567814]  ? __kmalloc_node_track_caller+0x210/0x2b0
[ 5069.567815]  ? genl_family_rcv_msg+0x3a0/0x3a0
[ 5069.567816]  netlink_rcv_skb+0x4c/0x120
[ 5069.567818]  genl_rcv+0x24/0x40
[ 5069.567819]  netlink_unicast+0x196/0x240
[ 5069.567821]  netlink_sendmsg+0x1fd/0x3c0
[ 5069.567823]  sock_sendmsg+0x33/0x40
[ 5069.567825]  __sys_sendto+0xee/0x160
[ 5069.567826]  ? __sys_recvmsg+0x54/0xa0
[ 5069.567829]  ? do_epoll_wait+0xb0/0xd0
[ 5069.567830]  __x64_sys_sendto+0x24/0x30
[ 5069.567832]  do_syscall_64+0x5b/0x170
[ 5069.567834]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
