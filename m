Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36212 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880Ab3HET4b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 15:56:31 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 08/12] ath9k: fix clearing expired A-MPDU subframes in tx completion
Date: Mon,  5 Aug 2013 21:56:19 +0200
Message-Id: <1375732583-39001-8-git-send-email-nbd@openwrt.org> (sfid-20130805_220908_816879_F5763A68)
In-Reply-To: <1375732583-39001-1-git-send-email-nbd@openwrt.org>
References: <1375732583-39001-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the tid aggregation state has been marked as inactive, free
completed tx packets immediately. When a new aggregation session has not
been initialized yet, the BAW checks do not recognize it as expired.

Might fix potential stalls in setting up a new aggregation session.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index e4d3723..2cd8268 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -520,7 +520,8 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		tx_info = IEEE80211_SKB_CB(skb);
 		fi = get_frame_info(skb);
 
-		if (!BAW_WITHIN(tid->seq_start, tid->baw_size, seqno)) {
+		if (!BAW_WITHIN(tid->seq_start, tid->baw_size, seqno) ||
+		    !tid->active) {
 			/*
 			 * Outside of the current BlockAck window,
 			 * maybe part of a previous session
-- 
1.8.0.2

