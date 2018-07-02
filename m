Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59832 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934015AbeGBKKZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jul 2018 06:10:25 -0400
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
Subject: [PATCH] mac80211: add stations tied to AP_VLANs during hw reconfig
Date: Mon,  2 Jul 2018 15:40:14 +0530
Message-Id: <1530526214-25086-1-git-send-email-mpubbise@codeaurora.org> (sfid-20180702_121029_751871_4827DE38)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As part of hw reconfig, only stations linked to AP interfaces are added
back to the driver ignoring those which are tied to AP_VLAN interfaces.

It is true that there could be stations tied to the AP_VLAN interface while
serving 4addr clients or when using AP_VLAN for VLAN operations; we should
be adding these stations back to the driver as part of hw reconfig, failing
to do so can cause functional issues.

In the case of ath10k driver, the following errors were observed.

ath10k_pci : failed to install key for non-existent peer XX:XX:XX:XX:XX:XX
Workqueue: events_freezable ieee80211_restart_work [mac80211]
(unwind_backtrace) from (show_stack+0x10/0x14)
(show_stack) (dump_stack+0x80/0xa0)
(dump_stack) (warn_slowpath_common+0x68/0x8c)
(warn_slowpath_common) (warn_slowpath_null+0x18/0x20)
(warn_slowpath_null) (ieee80211_enable_keys+0x88/0x154 [mac80211])
(ieee80211_enable_keys) (ieee80211_reconfig+0xc90/0x19c8 [mac80211])
(ieee80211_reconfig]) (ieee80211_restart_work+0x8c/0xa0 [mac80211])
(ieee80211_restart_work) (process_one_work+0x284/0x488)
(process_one_work) (worker_thread+0x228/0x360)
(worker_thread) (kthread+0xd8/0xec)
(kthread) (ret_from_fork+0x14/0x24)

Also while bringing down the AP VAP, WARN_ONs and errors related to peer
removal were observed.

ath10k_pci : failed to clear all peer wep keys for vdev 0: -2
ath10k_pci : failed to disassociate station: 8c:fd:f0:0a:8c:f5 vdev 0: -2
(unwind_backtrace) (show_stack+0x10/0x14)
(show_stack) (dump_stack+0x80/0xa0)
(dump_stack) (warn_slowpath_common+0x68/0x8c)
(warn_slowpath_common) (warn_slowpath_null+0x18/0x20)
(warn_slowpath_null) (sta_set_sinfo+0xb98/0xc9c [mac80211])
(sta_set_sinfo [mac80211]) (__sta_info_flush+0xf0/0x134 [mac80211])
(__sta_info_flush [mac80211]) (ieee80211_stop_ap+0xe8/0x390 [mac80211])
(ieee80211_stop_ap [mac80211]) (__cfg80211_stop_ap+0xe0/0x3dc [cfg80211])
(__cfg80211_stop_ap [cfg80211]) (cfg80211_stop_ap+0x30/0x44 [cfg80211])
(cfg80211_stop_ap [cfg80211]) (genl_rcv_msg+0x274/0x30c)
(genl_rcv_msg) (netlink_rcv_skb+0x58/0xac)
(netlink_rcv_skb) (genl_rcv+0x20/0x34)
(genl_rcv) (netlink_unicast+0x11c/0x204)
(netlink_unicast) (netlink_sendmsg+0x30c/0x370)
(netlink_sendmsg) (sock_sendmsg+0x70/0x84)
(sock_sendmsg) (___sys_sendmsg.part.3+0x188/0x228)
(___sys_sendmsg.part.3) (__sys_sendmsg+0x4c/0x70)
(__sys_sendmsg) (ret_fast_syscall+0x0/0x44)

These issues got fixed by adding the stations which are
tied to AP_VLANs back to the driver.

Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
---
 net/mac80211/util.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3e68132..88efda7 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2140,7 +2140,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		if (!sta->uploaded)
 			continue;
 
-		if (sta->sdata->vif.type != NL80211_IFTYPE_AP)
+		if (sta->sdata->vif.type != NL80211_IFTYPE_AP &&
+		    sta->sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
 			continue;
 
 		for (state = IEEE80211_STA_NOTEXIST;
-- 
2.7.4
