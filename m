Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:47147 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751671AbeBBKhz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Feb 2018 05:37:55 -0500
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        stable@vger.kernel.org
Subject: [PATCH] ath9k: Protect queue draining by rcu_read_lock()
Date: Fri,  2 Feb 2018 11:36:45 +0100
Message-Id: <20180202103645.12215-1-toke@toke.dk> (sfid-20180202_113759_661422_E25FFE92)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When ath9k was switched over to use the mac80211 intermediate queues,
node cleanup now drains the mac80211 queues. However, this call path is
not protected by rcu_read_lock() as it was previously entirely internal
to the driver which uses its own locking.

This leads to a possible rcu_dereference() without holding
rcu_read_lock(); but only if a station is cleaned up while having
packets queued on the TXQ. Fix this by adding the rcu_read_lock() to the
caller in ath9k.

Fixes: 50f08edf9809 ("ath9k: Switch to using mac80211 intermediate software queues.")
Cc: stable@vger.kernel.org
Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 396bf05c6bf6..d8b041f48ca8 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2892,6 +2892,8 @@ void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 	struct ath_txq *txq;
 	int tidno;
 
+	rcu_read_lock();
+
 	for (tidno = 0; tidno < IEEE80211_NUM_TIDS; tidno++) {
 		tid = ath_node_to_tid(an, tidno);
 		txq = tid->txq;
@@ -2909,6 +2911,8 @@ void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 		if (!an->sta)
 			break; /* just one multicast ath_atx_tid */
 	}
+
+	rcu_read_unlock();
 }
 
 #ifdef CONFIG_ATH9K_TX99
-- 
2.16.0
