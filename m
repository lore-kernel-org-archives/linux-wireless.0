Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 152F1C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 08:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A671120827
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 08:55:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QTMHkzkU";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ceEZXM9Z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A671120827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbeKISer (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 13:34:47 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54010 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727603AbeKISer (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 13:34:47 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3DD14601D1; Fri,  9 Nov 2018 08:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541753711;
        bh=676vyYyAgpIn+80c/InIR75e6CP8rh3XYL1Y5p93gS8=;
        h=From:To:Cc:Subject:Date:From;
        b=QTMHkzkUWYFZM9pq8By+oFePCkIfbWmnDMS5uceF13rbxV7Hv2EIRpjpq5dX97R07
         J6nkMCPrInxEwuuENCGxE0jMAuXM+dWdUAjkevBr4KWl7xD/ZiU3w6fdZmRPq8nfOf
         /Ij8AfORJAT5IrTo/Zb6Pk9NnbDkFrj6hsHTbhzw=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: periyasa@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 28A326019D;
        Fri,  9 Nov 2018 08:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541753710;
        bh=676vyYyAgpIn+80c/InIR75e6CP8rh3XYL1Y5p93gS8=;
        h=From:To:Cc:Subject:Date:From;
        b=ceEZXM9ZsqC8qvQ9qIcLCI/1YylasBXPOejJDr6HGD+g91M0mkPJGaUfusL3K31y1
         LAGVeLa2qYbOMjtZwc3iLIM7cthNAXyO8Y8IWLfUX/et98QftfbMIR8hNANCFXjB1B
         1Y7PgT0B1KvbG/5VQruMLt7MjnRFOYPBSpM5plWA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 28A326019D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=periyasa@codeaurora.org
From:   Karthikeyan Periyasamy <periyasa@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Karthikeyan Periyasamy <periyasa@codeaurora.org>
Subject: [PATCH] ath10k: Fix kernel panic due to use after free
Date:   Fri,  9 Nov 2018 14:24:06 +0530
Message-Id: <1541753646-11533-1-git-send-email-periyasa@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

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
---
 drivers/net/wireless/ath/ath10k/mac.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c5130fa..fbf4ff0 100644
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
1.9.1

