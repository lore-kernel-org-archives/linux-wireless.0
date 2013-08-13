Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41186 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756294Ab3HMKdi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 06:33:38 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 5/5] ath9k: reset buffer stale flag in ath_tx_get_tid_subframe
Date: Tue, 13 Aug 2013 12:33:30 +0200
Message-Id: <1376390010-81819-5-git-send-email-nbd@openwrt.org> (sfid-20130813_123341_322115_DA071B85)
In-Reply-To: <1376390010-81819-1-git-send-email-nbd@openwrt.org>
References: <1376390010-81819-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If that flag stays set for a buffer that already ran through the tx path
once, it might cause issues in tx completion processing. Better clear it
early to ensure that this does not happen

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index cb06c1c..7223e30 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -888,6 +888,8 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
 		bf = fi->bf;
 		if (!fi->bf)
 			bf = ath_tx_setup_buffer(sc, txq, tid, skb);
+		else
+			bf->bf_state.stale = false;
 
 		if (!bf) {
 			__skb_unlink(skb, *q);
-- 
1.8.0.2

