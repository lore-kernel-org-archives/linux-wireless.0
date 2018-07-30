Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:37747 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbeG3Jyy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 05:54:54 -0400
Received: from book (unknown [185.12.128.225])
        by mail.strongswan.org (Postfix) with ESMTPSA id 797A9404D9
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jul 2018 10:12:44 +0200 (CEST)
Message-ID: <6f044fff274867c90038e673c9291279ae1a1121.camel@strongswan.org> (sfid-20180730_102106_294215_89B15D82)
Subject: ath10k SWBA overrun / tx credit starvation
From: Martin Willi <martin@strongswan.org>
To: linux-wireless@vger.kernel.org
Date: Mon, 30 Jul 2018 10:12:28 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

We are experiencing some issues when running ath10k in AP mode.
Unfortunately, I didn't manage to reproduce the issue in the lab, but
in the field we see it roughly once a day on one out of fifty devices.

The symptoms are the logged "SWBA overruns" followed by a kernel
WARNING when removing a station (see below), followed by many more
"SWBA overruns". It seems that the firmware and kernel get out of sync
about the associated stations. The module does not recover, but the
whole networking stack gets very sluggish, probably due to a lock held
for many seconds. Bringing down the affected network interface takes
some extra seconds, but then allows recovering from that issue.

We are running 4.14-stable, and tried many firmware versions, including
 10.2.4.70-2, 10.2.4-1.0-00040, 10.2.4.70.61-2, 10.2.4.70.67 and
firmware-2-ct-full-community-20, but the issue remains. Hardware is
QCA9882 on a WLE600VX.

I stumbled over a some years old discussion at [1] about tx credit
starvation. Is this still the same issue we are seeing? Given that the
mentioned newer firmware versions did not help here, is there anything
else we can try?

Thanks!
Martin

[1] https://lists.infradead.org/pipermail/ath10k/2015-June/005340.html

---

15:27:39 ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0, skipped old beacon
15:27:39 ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0, skipped old beacon
15:27:39 ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0, skipped old beacon
15:27:39 ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0, skipped old beacon
15:27:40 ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0, skipped old beacon
15:27:40 ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0, skipped old beacon
15:27:41 ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0, skipped old beacon
15:27:41 ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0, skipped old beacon
15:27:40 ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0, skipped old beacon
15:27:40 ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0, skipped old beacon
15:27:44 ------------[ cut here ]------------
15:27:44 WARNING: CPU: 0 PID: 150 at net/mac80211/sta_info.c:976 __sta_info_destroy_part2+0x170/0x174
15:27:44 Modules linked in: xt_comment xt_cluster xt_u32 esp4 xfrm6_mode_tunnel xfrm4_mode_tunnel ebtable_filter ebtables bridge stp llc xt_policy xt_connmark xt_mark xt_set ip_set_hash_ipport ip_set_hash_netnet ip_set iptable_mangle nfnet
15:27:44 CPU: 0 PID: 150 Comm: hostapd Not tainted 4.14.55 #2
15:27:44 Hardware name: Marvell Armada 380/385 (Device Tree)
15:27:44 [<c010fd20>] (unwind_backtrace) from [<c010b9bc>] (show_stack+0x10/0x14)
15:27:44 [<c010b9bc>] (show_stack) from [<c0653fa8>] (dump_stack+0x88/0x9c)
15:27:44 [<c0653fa8>] (dump_stack) from [<c012f110>] (__warn+0xe8/0x100)
15:27:44 [<c012f110>] (__warn) from [<c012f1d8>] (warn_slowpath_null+0x20/0x28)
15:27:44 [<c012f1d8>] (warn_slowpath_null) from [<c060b6e0>] (__sta_info_destroy_part2+0x170/0x174)
15:27:44 [<c060b6e0>] (__sta_info_destroy_part2) from [<c060b704>] (__sta_info_destroy+0x20/0x28)
15:27:44 [<c060b704>] (__sta_info_destroy) from [<c060b77c>] (sta_info_destroy_addr_bss+0x2c/0x44)
15:27:44 [<c060b77c>] (sta_info_destroy_addr_bss) from [<c05ec1f4>] (nl80211_del_station+0xc8/0x100)
15:27:44 [<c05ec1f4>] (nl80211_del_station) from [<c050d050>] (genl_rcv_msg+0x2f8/0x3c8)
15:27:44 [<c050d050>] (genl_rcv_msg) from [<c050c190>] (netlink_rcv_skb+0xac/0x104)
15:27:44 [<c050c190>] (netlink_rcv_skb) from [<c050cd48>] (genl_rcv+0x24/0x34)
15:27:44 [<c050cd48>] (genl_rcv) from [<c050b954>] (netlink_unicast+0x184/0x21c)
15:27:44 [<c050b954>] (netlink_unicast) from [<c050bdec>] (netlink_sendmsg+0x334/0x374)
15:27:44 [<c050bdec>] (netlink_sendmsg) from [<c04bc128>] (sock_sendmsg+0x14/0x24)
15:27:44 [<c04bc128>] (sock_sendmsg) from [<c04bc660>] (___sys_sendmsg+0x214/0x228)
15:27:44 [<c04bc660>] (___sys_sendmsg) from [<c04bd4a0>] (__sys_sendmsg+0x40/0x6c)
15:27:44 [<c04bd4a0>] (__sys_sendmsg) from [<c0107ae0>] (ret_fast_syscall+0x0/0x54)
15:27:44 ---[ end trace 036b835c84274321 ]---
15:27:44 ath10k_warn: 41 callbacks suppressed
15:27:44 ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0, skipped old beacon
15:27:44 ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0, skipped old beacon
15:27:44 ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0, skipped old beacon
15:27:44 ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0, skipped old beacon
15:27:45 ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0, skipped old beacon
