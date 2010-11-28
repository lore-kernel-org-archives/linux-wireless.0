Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43658 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429Ab0K1Shz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Nov 2010 13:37:55 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH] ath9k: fix software retry counter tracking
Date: Sun, 28 Nov 2010 19:37:48 +0100
Message-Id: <1290969468-13733-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The recent tx path cleanups moved the software retry count tracking
from the ath_buf to the skb cb, however the actual counter update
referred to the wrong location, confusing block-ack window tracking.
Fix this by using the retries counter in the struct ath_frame_info.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 495432e..177a7b1 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -250,11 +250,11 @@ static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 static void ath_tx_set_retry(struct ath_softc *sc, struct ath_txq *txq,
 			     struct sk_buff *skb)
 {
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ath_frame_info *fi = get_frame_info(skb);
 	struct ieee80211_hdr *hdr;
 
 	TX_STAT_INC(txq->axq_qnum, a_retries);
-	if (tx_info->control.rates[4].count++ > 0)
+	if (fi->retries++ > 0)
 		return;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
-- 
1.7.3.2

