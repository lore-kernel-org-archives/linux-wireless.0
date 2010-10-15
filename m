Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51535 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab0JOWEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 18:04:14 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] ath9k:  Properly initialize ath_common->cc_lock.
Date: Fri, 15 Oct 2010 15:04:09 -0700
Message-Id: <1287180249-18647-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Otherwise, lockdep splats, at the least:

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
Pid: 2240, comm: ip Not tainted 2.6.36-rc8-wl+ #32
Call Trace:
 [<c075d940>] ? printk+0xf/0x17
 [<c045507a>] register_lock_class+0x5a/0x29e
 [<c0455be2>] ? mark_lock+0x1e/0x1de
 [<c0456af5>] __lock_acquire+0xa2/0xb8c
 [<c0455be2>] ? mark_lock+0x1e/0x1de
 [<c0457639>] lock_acquire+0x5a/0x78
 [<f8c5115b>] ? ath9k_config+0x274/0x3d8 [ath9k]
 [<c075f602>] _raw_spin_lock_irqsave+0x2f/0x3f
 [<f8c5115b>] ? ath9k_config+0x274/0x3d8 [ath9k]
 [<f8c5115b>] ath9k_config+0x274/0x3d8 [ath9k]
 [<f8c0ba2e>] ieee80211_hw_config+0x11b/0x125 [mac80211]
 [<f8c17edf>] ieee80211_do_open+0x3c5/0x466 [mac80211]
 [<f8c171d6>] ? ieee80211_check_concurrent_iface+0x21/0x13a [mac80211]
 [<f8c17fdb>] ieee80211_open+0x5b/0x5e [mac80211]
 [<c06ce76b>] __dev_open+0x80/0xae
 [<c06cc99b>] __dev_change_flags+0xa0/0x115
 [<c06ce6bf>] dev_change_flags+0x13/0x3f
 [<c06d7e78>] do_setlink+0x23a/0x51b
 [<c0455037>] ? register_lock_class+0x17/0x29e
 [<c06d847c>] rtnl_newlink+0x269/0x431
 [<c06d8291>] ? rtnl_newlink+0x7e/0x431
 [<c0455be2>] ? mark_lock+0x1e/0x1de
 [<c0455de9>] ? mark_held_locks+0x47/0x5f
 [<c075ebcf>] ? __mutex_lock_common+0x2bb/0x2d6
 [<c0456045>] ? trace_hardirqs_on_caller+0x104/0x125
 [<c075ebe0>] ? __mutex_lock_common+0x2cc/0x2d6
 [<c06d8213>] ? rtnl_newlink+0x0/0x431
 [<c06d79e2>] rtnetlink_rcv_msg+0x182/0x198
 [<c06d7860>] ? rtnetlink_rcv_msg+0x0/0x198
 [<c06e503c>] netlink_rcv_skb+0x30/0x77
 [<c06d7859>] rtnetlink_rcv+0x1b/0x22
 [<c06e4e77>] netlink_unicast+0xbe/0x119
 [<c06e5a15>] netlink_sendmsg+0x234/0x24c
 [<c06bf93a>] __sock_sendmsg+0x51/0x5a
 [<c06bfba4>] sock_sendmsg+0x93/0xa7
 [<c04968cf>] ? might_fault+0x47/0x81
 [<c0496904>] ? might_fault+0x7c/0x81
 [<c06c7904>] ? copy_from_user+0x8/0xa
 [<c06c7c2d>] ? verify_iovec+0x3e/0x6d
 [<c06bfd8c>] sys_sendmsg+0x149/0x193
 [<c0455037>] ? register_lock_class+0x17/0x29e
 [<c0455be2>] ? mark_lock+0x1e/0x1de
 [<c0498d7a>] ? __do_fault+0x1fc/0x3a5
 [<c048690a>] ? unlock_page+0x40/0x43
 [<c0498ef7>] ? __do_fault+0x379/0x3a5
 [<c04576dd>] ? lock_release_non_nested+0x86/0x1d8
 [<c04968cf>] ? might_fault+0x47/0x81
 [<c04968cf>] ? might_fault+0x47/0x81
 [<c06c148b>] sys_socketcall+0x15e/0x1a5
 [<c0402f1c>] sysenter_do_call+0x12/0x38

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
v1 -> v2:  Updated commit message to show lockdep splat.

:100644 100644 a4c5ed4... fdc25f9... M	drivers/net/wireless/ath/ath9k/init.c
 drivers/net/wireless/ath/ath9k/init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index a4c5ed4..fdc25f9 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -577,6 +577,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	common->hw = sc->hw;
 	common->priv = sc;
 	common->debug_mask = ath9k_debug;
+	spin_lock_init(&common->cc_lock);
 
 	spin_lock_init(&sc->wiphy_lock);
 	spin_lock_init(&sc->sc_resetlock);
-- 
1.7.2.2

