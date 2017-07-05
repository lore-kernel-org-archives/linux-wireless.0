Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arabica.frei.media ([176.9.117.169]:41023 "EHLO mail.frei.media"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751964AbdGESod (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Jul 2017 14:44:33 -0400
From: Matthias Frei <mf@frei.media>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH] ath10k: set a-mpdu reference number in ath10k (receiver)
Date: Wed, 5 Jul 2017 20:34:10 +0200
Message-Id: <B8D63297-0A88-42A3-B789-3849895CF201@frei.media> (sfid-20170705_204437_215412_F0065AA4)
Cc: linux-wireless@vger.kernel.org
To: ath10k@lists.infradead.org
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the a-mpdu reference number in ath10k to make it accessible in the receivers radiotap header. Implemented as in ath9k. 
The reference number is needed for troubleshooting and research at the receivers site (e.g. to identify mpdu's that were aggregated in an a-mpdu)

Signed-off-by: Matthias Frei <mf@frei.media>
---
 drivers/net/wireless/ath/ath10k/core.h   |  3 +++
 drivers/net/wireless/ath/ath10k/htt_rx.c | 14 +++++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index bf09151..82adf55 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -989,6 +989,9 @@ struct ath10k {
 		u32 reg_ack_cts_timeout_orig;
 	} fw_coverage;
 
+	/* AMPDU */
+	u32 ampdu_ref;
+
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
 };
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 84b6067..a4de02b 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -877,16 +877,24 @@ static void ath10k_htt_rx_h_ppdu(struct ath10k *ar,
 		status->nss = 0;
 		status->encoding = RX_ENC_LEGACY;
 		status->bw = RATE_INFO_BW_20;
-		status->flag &= ~RX_FLAG_MACTIME_END;
-		status->flag |= RX_FLAG_NO_SIGNAL_VAL;
+		status->flag &= ~(RX_FLAG_MACTIME_END | RX_FLAG_AMPDU_IS_LAST);
+		status->flag |= RX_FLAG_NO_SIGNAL_VAL | RX_FLAG_AMPDU_DETAILS | RX_FLAG_AMPDU_LAST_KNOWN;
+
+		/* set ampdu ref */
+		status->ampdu_reference = ar->ampdu_ref;
 
 		ath10k_htt_rx_h_signal(ar, status, rxd);
 		ath10k_htt_rx_h_channel(ar, status, rxd, vdev_id);
 		ath10k_htt_rx_h_rates(ar, status, rxd);
 	}
 
-	if (is_last_ppdu)
+	if (is_last_ppdu) {
 		ath10k_htt_rx_h_mactime(ar, status, rxd);
+
+		/* set ampdu last segment flag */
+		status->flag |= RX_FLAG_AMPDU_IS_LAST;
+		ar->ampdu_ref++;
+	}
 }
 
 static const char * const tid_to_ac[] = {
-- 
2.7.4
