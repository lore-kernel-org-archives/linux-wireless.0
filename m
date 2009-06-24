Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21430 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbZFXNfY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 09:35:24 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2009 06:35:27 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Fix leak in tx descriptor
Date: Wed, 24 Jun 2009 18:58:47 +0530
Message-ID: <1245850127-4880-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we reclaim the tx desc, we always assume that the
last desc is a holding desc, which is not true, and skip it.
If the tx queue is drained during channel change, internal
reset and etc, the last descriptor may not be the holding
descriptor and we fail to reclaim them. This results in the
following two issues.

1. Tx stuck - We drop all the frames coming from upper layer
due to shortage in tx desc.

2. Crash - If we fail to reclaim a tx descriptor, we miss to
update the tx BA window with the seq number of the frame
associated to that desc, which, at some point, result in
the following crash due to an assert failure in ath_tx_addto_baw().

This patch fixes these two issues.

 kernel BUG at ../drivers/net/wireless/ath/ath9k/xmit.c:180!
[155064.304164] invalid opcode: 0000 [#1] SMP
 Call Trace:
  [<fbc6d83b>] ? ath9k_tx+0xeb/0x160 [ath9k]
  [<fbbc9591>]  ipv6? __ieee80211_tx+0x41/0x120 [mac80211]
  [<fbbcb5ae>] ?  aes_i586ieee80211_master_start_xmit+0x28e/0x560 [mac80211]
  [<c037e501>]  aes_generic? _spin_lock_irqsave+0x31/0x40
  [<c02f347b>] ? dev_hard_start_xmit+0x16b/0x1c0
  [<c03058b5>] ? __qdisc_run+0x1b5/0x200
  [<fbbcda5a>] ?  af_packetieee80211_select_queue+0xa/0x100 [mac80211]
  [<c02f53b7>] ?  i915dev_queue_xmit+0x2e7/0x3f0
  [<fbbc9b49>] ? ieee80211_subif_start_xmit+0x369/0x7a0 [mac80211]
  [<c031bc35>] ? ip_output+0x55/0xb0
  [<c02e0188>] ? show_memcpy_count+0x18/0x60
  [<c02eb186>] ? __kfree_skb+0x36/0x90
  [<c02f2202>] ?  binfmt_miscdev_queue_xmit_nit+0xd2/0x110
  [<c02f347b>] ? dev_hard_start_xmit+0x16b/0x1c0
  [<c03058b5>] ? __qdisc_run+0x1b5/0x200
  [<c033bca7>] ?  scoarp_create+0x57/0x2a0
  [<c02f53b7>] ?  bridgedev_queue_xmit+0x2e7/0x3f0
  [<c03034a0>] ? eth_header+0x0/0xc0
  [<c033b95f>]  stp? arp_xmit+0x5f/0x70
  [<c033bf4f>] ? arp_send+0x5f/0x70
  [<c033c8f5>]  bnep? arp_solicit+0x105/0x210
  [<c02fa5aa>] ? neigh_timer_handler+0x19a/0x390
  [<c013bf88>] ? run_timer_softirq+0x138/0x210
  [<c02fa410>] ?  ppdevneigh_timer_handler+0x0/0x390
  [<c02fa410>] ? neigh_timer_handler+0x0/0x390

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index c140f81..5de9878 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -347,7 +347,14 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		}
 
 		if (bf_next == NULL) {
-			INIT_LIST_HEAD(&bf_head);
+			/*
+			 * Make sure the last desc is reclaimed if it
+			 * not a holding desc.
+			 */
+			if (!bf_last->bf_stale)
+				list_move_tail(&bf->list, &bf_head);
+			else
+				INIT_LIST_HEAD(&bf_head);
 		} else {
 			ASSERT(!list_empty(bf_q));
 			list_move_tail(&bf->list, &bf_head);
-- 
1.5.5.1

