Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD3BC282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:34:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A1412147A
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548696889;
	bh=2U1Jmyvg5esE/OB0zNbOG5RLUk4Tvyt9Ul0P74IyvK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=j2JpPZFNvG0MJZkeazLcBLIGxPk9pczZdIzgkRGuxyOnx1cMSAb25KV9GB7tFSJwa
	 8LKwPg5sLmd47NLRO+UJSO8TcaUFUQ7zbIOhEJnQfk9x+/VZ7MN7nimgqxs+05CIwB
	 yyWFYlgII4Yb1vxmPW1MCxzSDymzSZNeYhRm/dEs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbfA1Pzm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:55:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729958AbfA1Pzl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 10:55:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A333621741;
        Mon, 28 Jan 2019 15:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548690940;
        bh=2U1Jmyvg5esE/OB0zNbOG5RLUk4Tvyt9Ul0P74IyvK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uHqEMGxzhdRquSsdD/vv/gJXp+Y9mTucvTC12O9BxbnX0S+wDg1tBfYkmL8Diz0Bh
         x8zFnvyJeDDrdFJPc/ZHECuxOP3BcXT8lEjmpPp3hZGhH7MN3YM8hPdbwWusdbRDJS
         3koVNGjsVsJlZAwmPsdJyyjZbvtKcOJRenV+E1Gw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Karthikeyan Periyasamy <periyasa@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 241/304] ath10k: fix kernel panic due to use after free
Date:   Mon, 28 Jan 2019 10:42:38 -0500
Message-Id: <20190128154341.47195-241-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128154341.47195-1-sashal@kernel.org>
References: <20190128154341.47195-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Karthikeyan Periyasamy <periyasa@codeaurora.org>

[ Upstream commit 553a7cca769d551f1317186760631487c47e23bf ]

This issue arise in a race condition between ath10k_sta_state() and
ath10k_htt_fetch_peer_stats(), explained in below scenario

Steps:
1. In ath10k_sta_state(), arsta->tx_stats get deallocated before peer deletion
   when the station moves from IEEE80211_STA_NONE to IEEE80211_STA_NOTEXIST
   state.
2. Meanwhile ath10k receive HTT_T2H_MSG_TYPE_PEER_STATS message.
   In ath10k_htt_fetch_peer_stats(), arsta->tx_stats get accessed after
   the peer validation check.

Since arsta->tx_stats get freed before the peer deletion [1].
ath10k_htt_fetch_peer_stats() ended up in "use after free" situation.

Fixed this issue by moving the arsta->tx_stats free handling after the
peer deletion. so that ath10k_htt_fetch_peer_stats() will not end up in
"use after free" situation.

Kernel Panic:

Unable to handle kernel NULL pointer dereference at virtual address 00000286
pgd = d8754000
[00000286] *pgd=00000000
Internal error: Oops: 5 [#1] PREEMPT SMP ARM
...
CPU: 0 PID: 6245 Comm: hostapd Not tainted
task: dc44cac0 ti: d4a38000 task.ti: d4a38000
PC is at kmem_cache_alloc+0x7c/0x114
LR is at ath10k_sta_state+0x190/0xd58 [ath10k_core]
pc : [<c02bdc50>]    lr : [<bf916b78>]    psr: 20000013
sp : d4a39b88  ip : 00000000  fp : 00000001
r10: 00000000  r9 : 1d3bc000  r8 : 00000dc0
r7 : 000080d0  r6 : d4a38000  r5 : dd401b00  r4 : 00000286
r3 : 00000000  r2 : d4a39ba0  r1 : 000080d0  r0 : dd401b00
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 10c5787d  Table: 5a75406a  DAC: 00000015
Process hostapd (pid: 6245, stack limit = 0xd4a38238)
Stack: (0xd4a39b88 to 0xd4a3a000)
...
[<c02bdc50>] (kmem_cache_alloc) from [<bf916b78>] (ath10k_sta_state+0x190/0xd58 [ath10k_core])
[<bf916b78>] (ath10k_sta_state [ath10k_core]) from [<bf870d4c>] (sta_info_insert_rcu+0x418/0x61c [mac80211])
[<bf870d4c>] (sta_info_insert_rcu [mac80211]) from [<bf88634c>] (ieee80211_add_station+0xf0/0x134 [mac80211])
[<bf88634c>] (ieee80211_add_station [mac80211]) from [<bf83f3c4>] (nl80211_new_station+0x330/0x36c [cfg80211])
[<bf83f3c4>] (nl80211_new_station [cfg80211]) from [<bf6c4040>] (extack_doit+0x2c/0x74 [compat])
[<bf6c4040>] (extack_doit [compat]) from [<c05c285c>] (genl_rcv_msg+0x274/0x30c)
[<c05c285c>] (genl_rcv_msg) from [<c05c1d98>] (netlink_rcv_skb+0x58/0xac)
[<c05c1d98>] (netlink_rcv_skb) from [<c05c25d4>] (genl_rcv+0x20/0x34)
[<c05c25d4>] (genl_rcv) from [<c05c1750>] (netlink_unicast+0x11c/0x204)
[<c05c1750>] (netlink_unicast) from [<c05c1be0>] (netlink_sendmsg+0x30c/0x370)
[<c05c1be0>] (netlink_sendmsg) from [<c0587e90>] (sock_sendmsg+0x70/0x84)
[<c0587e90>] (sock_sendmsg) from [<c058970c>] (___sys_sendmsg.part.3+0x188/0x228)
[<c058970c>] (___sys_sendmsg.part.3) from [<c058a594>] (__sys_sendmsg+0x4c/0x70)
[<c058a594>] (__sys_sendmsg) from [<c0208c80>] (ret_fast_syscall+0x0/0x44)
Code: ebfffec1 e1a04000 ea00001b e5953014 (e7940003)
ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0, skipped old beacon

Hardware tested: QCA9984
Firmware tested: 10.4-3.6.0.1-00004

Fixes: a904417fc ("ath10k: add extended per sta tx statistics support")
Signed-off-by: Karthikeyan Periyasamy <periyasa@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b4764fee4751..6436dc229be5 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6387,11 +6387,6 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			   "mac vdev %d peer delete %pM sta %pK (sta gone)\n",
 			   arvif->vdev_id, sta->addr, sta);
 
-		if (ath10k_debug_is_extd_tx_stats_enabled(ar)) {
-			kfree(arsta->tx_stats);
-			arsta->tx_stats = NULL;
-		}
-
 		if (sta->tdls) {
 			ret = ath10k_mac_tdls_peer_update(ar, arvif->vdev_id,
 							  sta,
@@ -6431,6 +6426,11 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		}
 		spin_unlock_bh(&ar->data_lock);
 
+		if (ath10k_debug_is_extd_tx_stats_enabled(ar)) {
+			kfree(arsta->tx_stats);
+			arsta->tx_stats = NULL;
+		}
+
 		for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
 			ath10k_mac_txq_unref(ar, sta->txq[i]);
 
-- 
2.19.1

