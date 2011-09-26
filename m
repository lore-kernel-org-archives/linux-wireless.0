Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50892 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab1IZJnd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 05:43:33 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k: optimize tx status update
Date: Mon, 26 Sep 2011 15:12:01 +0530
Message-ID: <1317030121-3902-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110926_114336_513142_2BB3ACAF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The recent changes of ath_tx_rc_status makes it to be called
only for the first frame of aggregation or if there is a
single subframe and for all normal frames. And also for all
aggregated frames IEEE80211_TX_STAT_AMPDU will be set. This
patch removes the unnecessary checks and make the ampdu_[ack]_len
to be filled on both aggregation and normal frames.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c   |   11 -----------
 drivers/net/wireless/ath/ath9k/xmit.c |    5 ++---
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 4f13018..81c48fb 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1354,20 +1354,9 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	if (!priv_sta || !ieee80211_is_data(fc))
 		return;
 
-	/* This packet was aggregated but doesn't carry status info */
-	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) &&
-	    !(tx_info->flags & IEEE80211_TX_STAT_AMPDU))
-		return;
-
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

