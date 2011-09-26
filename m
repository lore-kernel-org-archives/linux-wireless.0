Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55639 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab1IZQSt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 12:18:49 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k: Remove unnecessary AMPDU check at tx status
Date: Mon, 26 Sep 2011 21:48:39 +0530
Message-ID: <1317053919-11006-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110926_181852_359237_343EF442)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fill the ampdu_[ack]_len for both aggregation and normal frames.
So that we could avoid unnecesary conditional at tx status.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c   |    6 ------
 drivers/net/wireless/ath/ath9k/xmit.c |    5 ++---
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 4f13018..8448281 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1362,12 +1362,6 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	if (tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED)
 		return;
 
-	if (!(tx_info->flags & IEEE80211_TX_STAT_AMPDU)) {
-		tx_info->status.ampdu_ack_len =
-			(tx_info->flags & IEEE80211_TX_STAT_ACK ? 1 : 0);
-		tx_info->status.ampdu_len = 1;
-	}
-
 	if (!(tx_info->flags & IEEE80211_TX_STAT_ACK))
 		tx_status = 1;
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index fa3dcfd..f5d4764 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2043,10 +2043,9 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 		tx_info->flags |= IEEE80211_TX_STAT_AMPDU;
 
 		BUG_ON(nbad > nframes);
-
-		tx_info->status.ampdu_len = nframes;
-		tx_info->status.ampdu_ack_len = nframes - nbad;
 	}
+	tx_info->status.ampdu_len = nframes;
+	tx_info->status.ampdu_ack_len = nframes - nbad;
 
 	if ((ts->ts_status & ATH9K_TXERR_FILT) == 0 &&
 	    (tx_info->flags & IEEE80211_TX_CTL_NO_ACK) == 0) {
-- 
1.7.6.4

