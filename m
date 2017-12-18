Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.codigosur.net ([109.69.10.39]:45780 "EHLO
        mail.codigosur.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757719AbdLRCwR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Dec 2017 21:52:17 -0500
Received: from authenticated-user (mail.codigosur.net [109.69.10.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.codigosur.net (Postfix) with ESMTPSA id 07FD66D20F6A
        for <linux-wireless@vger.kernel.org>; Mon, 18 Dec 2017 02:44:13 +0000 (UTC)
From: Gui Iribarren <gui@altermundi.net>
Subject: oops on cloned-mac 802.11s stations
To: linux-wireless@vger.kernel.org
Message-ID: <39d50d91-ac83-611d-6709-021757686206@altermundi.net> (sfid-20171218_035222_838601_77D93FC5)
Date: Mon, 18 Dec 2017 03:44:12 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Steps to reproduce:
join a 802.11s mesh with a nodeA, and then join the same 802.11s mesh
with another nodeB, so that both nodes MAC addresses are exactly the
same (i.e. nodeB is "cloning" nodeA MAC)

Expected result:
nodeA and nodeB coexist in a conflicting state, silently
(not saying that this is a desired scenario, of course; just came across
this while testing radios that accidentally had the same (fake) address.
the warning might ring a bell to someone, so reporting it here just for
the record)

What actually happens:
both on nodeA and nodeB, the log is flooded with these warnings:

[  957.948794] ------------[ cut here ]------------
[  957.953651] WARNING: CPU: 0 PID: 2874 at
backports-2017-11-01/net/mac80211/sta_info.c:456
sta_info_insert_rcu+0xa8/0x654 [mac80211]
[  957.965646] Modules linked in: pppoe ppp_async ath9k pppox
ppp_generic nf_conntrack_ipv6 iptable_nat ipt_REJECT ipt_MASQUERADE
ebtable_nat ebtable_filter ebtable_broute ath9k_common xt_time xt_tcpudp
xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_conntrack
xt_comment xt_TCPMSS xt_REDIRECT xt_LOG slhc nf_reject_ipv4
nf_nat_redirect nf_nat_masquerade_ipv4 nf_conntrack_ipv4 nf_nat_ipv4
nf_nat nf_log_ipv4 nf_defrag_ipv6 nf_defrag_ipv4 nf_conntrack_rtcache
nf_conntrack macvlan mac80211 iptable_mangle iptable_filter ip_tables
ebtables ebt_vlan ebt_stp ebt_redirect ebt_pkttype ebt_mark_m ebt_mark
ebt_limit ebt_ip6 ebt_among ebt_802_3 crc_ccitt br_netfilter ath9k_hw
ath batman_adv libcrc32c cfg80211 compat ip6t_REJECT nf_reject_ipv6
nf_log_ipv6 nf_log_common ip6table_mangle ip6table_filter ip6_tables
x_tables dummy ip6_tunnel tunnel6 tun ehci_platform ehci_hcd
gpio_button_hotplug usbcore nls_base usb_common crc16 crc32c_generic
crypto_hash
[  958.050885] CPU: 0 PID: 2874 Comm: kworker/u2:1 Tainted: G        W
    4.9.67 #0
[  958.058727] Workqueue: phy1 ieee80211_ibss_leave [mac80211]
[  958.064394] Stack : 86eec818 00000088 80470000 800a9684 87da269c
80461247 80413b58 00000b3a
[  958.072938]         80413ac4 873d3b84 80460000 800d8d3c 80470000
800a9684 80419374 80460000
[  958.081483]         00000003 873d3b84 80460000 80094ee0 80470000
873d3bbc 00000000 802228f8
[  958.090019]         804737d0 80222800 87693a04 87fa4d00 87fa4c00
70687931 00000000 00000000
[  958.098563]         00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[  958.107109]         ...
[  958.109601] Call Trace:
[  958.112098] [<8006b2e8>] show_stack+0x54/0x88
[  958.116530] [<8007ff60>] __warn+0xe4/0x118
[  958.120697] [<80080028>] warn_slowpath_null+0x1c/0x34
[  958.125919] [<87684f3c>] sta_info_insert_rcu+0xa8/0x654 [mac80211]
[  958.132306] [<876cd328>] mesh_pathtbl_unregister+0xc64/0xcf4 [mac80211]
[  958.139083] ---[ end trace cca096df034d04e6 ]---
