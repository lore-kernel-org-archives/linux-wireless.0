Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36208 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab3HET4b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 15:56:31 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 09/12] ath9k: always clear ps filter bit on new assoc
Date: Mon,  5 Aug 2013 21:56:20 +0200
Message-Id: <1375732583-39001-9-git-send-email-nbd@openwrt.org> (sfid-20130805_215637_373988_733C876D)
In-Reply-To: <1375732583-39001-1-git-send-email-nbd@openwrt.org>
References: <1375732583-39001-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise in some cases, EAPOL frames might be filtered during the
initial handshake, causing delays and assoc failures.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 2cd8268..11202ea 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2665,6 +2665,7 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 	for (acno = 0, ac = &an->ac[acno];
 	     acno < IEEE80211_NUM_ACS; acno++, ac++) {
 		ac->sched    = false;
+		ac->clear_ps_filter = true;
 		ac->txq = sc->tx.txq_map[acno];
 		INIT_LIST_HEAD(&ac->tid_q);
 	}
-- 
1.8.0.2

