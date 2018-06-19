Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:38909 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966534AbeFSPj4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 11:39:56 -0400
Received: by mail-ot0-f196.google.com with SMTP id p95-v6so158176ota.5
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2018 08:39:56 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH] mac80211: Fix oops in ieee80211_tx_control_port
Date: Tue, 19 Jun 2018 10:39:50 -0500
Message-Id: <20180619153950.28903-1-denkenz@gmail.com> (sfid-20180619_174004_371689_B903070F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On pre-emption enabled kernels the following oops was being seen due to
missing local_bh_disable/local_bh_enable calls.  mac80211 assumes that
pre-emption is disabled in the data path.

[ 5365.229756] Call Trace:
[ 5365.229762]  dump_stack+0x5c/0x80
[ 5365.229766]  check_preemption_disabled.cold.0+0x46/0x51
[ 5365.229779]  __ieee80211_subif_start_xmit+0x144/0x210 [mac80211]
[ 5365.229790]  ieee80211_tx_control_port+0x116/0x140 [mac80211]
[ 5365.229806]  nl80211_tx_control_port+0x13c/0x270 [cfg80211]
[ 5365.229810]  genl_family_rcv_msg+0x1c4/0x3a0
[ 5365.229814]  ? nlmon_xmit+0x3c/0x50 [nlmon]
[ 5365.229816]  ? dev_hard_start_xmit+0xa5/0x240
[ 5365.229817]  genl_rcv_msg+0x47/0x90
[ 5365.229818]  ? genl_family_rcv_msg+0x3a0/0x3a0
[ 5365.229820]  netlink_rcv_skb+0x4c/0x120
[ 5365.229821]  genl_rcv+0x24/0x40
[ 5365.229822]  netlink_unicast+0x196/0x240
[ 5365.229824]  netlink_sendmsg+0x1fd/0x3c0
[ 5365.229826]  sock_sendmsg+0x33/0x40
[ 5365.229827]  __sys_sendto+0xee/0x160
[ 5365.229830]  ? __se_sys_epoll_ctl+0x34d/0xe80
[ 5365.229831]  ? do_epoll_wait+0xb0/0xd0
[ 5365.229832]  __x64_sys_sendto+0x24/0x30
[ 5365.229835]  do_syscall_64+0x5b/0x170
[ 5365.229836]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 net/mac80211/tx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5b93bde248fd..6a79d564de35 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4850,7 +4850,9 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	skb_reset_network_header(skb);
 	skb_reset_mac_header(skb);
 
+	local_bh_disable();
 	__ieee80211_subif_start_xmit(skb, skb->dev, flags);
+	local_bh_enable();
 
 	return 0;
 }
-- 
2.13.5
