Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtphub1.cc.ic.ac.uk ([155.198.31.79]:57688 "EHLO
        smtphub1.cc.ic.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965701AbeFOLhO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jun 2018 07:37:14 -0400
Received: from mail-ve1eur01lp0208.outbound.protection.outlook.com ([2a01:111:f400:7e01::208] helo=EUR01-VE1-obe.outbound.protection.outlook.com)
        by smtphub1.cc.ic.ac.uk with esmtps (TLSv1.2:ECDHE-RSA-AES256-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <dan.mcginn@imperial.ac.uk>)
        id 1fTmbP-0008VD-7M
        for linux-wireless@vger.kernel.org; Fri, 15 Jun 2018 12:09:11 +0100
From: "McGinn, Dan" <dan.mcginn@imperial.ac.uk>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [BUG] mac80211: Using smp_processor_id() in preemptible code: iwd
Date: Fri, 15 Jun 2018 11:09:09 +0000
Message-ID: <DB5PR06MB106451FE83810B8A129CE1E4A47C0@DB5PR06MB1064.eurprd06.prod.outlook.com> (sfid-20180615_133718_270290_EB030DCF)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, I'm newly trying out Intel iwd daemon but I experience regular kernel e=
rrors in 4.17, although WPA2-PSK connection remains stable.  These errors d=
on't seem to be experienced with wpa_supplicant.  The errors reliably appea=
r around the following events:
netdev_unicast_notify()
netdev_control_port_frame_event()
netdev_set_rekey_offload()
netdev_set_gtk()

@Denkenz in IRC helpfully suggests Johannes could follow the finger of susp=
icion to this commit:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D911806491425d79107cadddbde11b42bbdfe38c8

dmesg:
    BUG: using smp_processor_id() in preemptible [00000000] code: iwd/517
    caller is __ieee80211_subif_start_xmit+0x144/0x210 [mac80211]
    CPU: 9 PID: 517 Comm: iwd Tainted: P           O      4.17.0-1-custom #=
1
    Hardware name: BIOS 05/14/2018
    Call Trace:
    dump_stack+0x5c/0x80
    check_preemption_disabled.cold.0+0x46/0x51
    __ieee80211_subif_start_xmit+0x144/0x210 [mac80211]
    ieee80211_tx_control_port+0x116/0x140 [mac80211]
    nl80211_tx_control_port+0x13c/0x270 [cfg80211]
    genl_family_rcv_msg+0x1c4/0x3a0
    ? _raw_spin_lock_irqsave+0x25/0x50
    ? _raw_spin_unlock_irqrestore+0x20/0x40
    ? ep_poll_callback+0x212/0x290
    genl_rcv_msg+0x47/0x90
    ? __kmalloc_node_track_caller+0x210/0x2b0
    ? genl_family_rcv_msg+0x3a0/0x3a0
    netlink_rcv_skb+0x4c/0x120
    genl_rcv+0x24/0x40
    netlink_unicast+0x196/0x240
    netlink_sendmsg+0x1fd/0x3c0
    sock_sendmsg+0x33/0x40
    __sys_sendto+0xee/0x160
    ? do_epoll_wait+0xb0/0xd0
    __x64_sys_sendto+0x24/0x30
    do_syscall_64+0x5b/0x170
    entry_SYSCALL_64_after_hwframe+0x44/0xa9
    RIP: 0033:0x7f94f41c98cd
    RSP: 002b:00007ffd224eab48 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
    RAX: ffffffffffffffda RBX: 0000557648053250 RCX: 00007f94f41c98cd
    RDX: 0000000000000098 RSI: 00005576480615e0 RDI: 0000000000000006
    RBP: 0000557648062560 R08: 0000000000000000 R09: 0000000000000000
    R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd224eabb0
    R13: 00007ffd224eabac R14: 0000000000000000 R15: 0000000000000000

Kernel: 4.17 mainline with iwlwifi patched for recent Intel9560/Killer1552 =
hardware VID/PIDs:
https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/backport-iwlwifi.gi=
t/commit/?id=3Da3ef483ec5002b7af5a2ad04cb7a77366cd23b9f
uCode: iwlwifi-9000-pu-b0-jf-b0-38

Tried iwd with both 0.2tag and master with same result.

Appears minor, but please let me know if more info is required tracking thi=
s down.=
