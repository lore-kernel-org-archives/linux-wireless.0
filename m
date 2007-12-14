Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:19630 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757072AbXLNJtG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2007 04:49:06 -0500
From: Bruno Randolf <bruno@thinktube.com>
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 1/1] ath5k: avoid zero rates
Date: Fri, 14 Dec 2007 18:48:57 +0900
Message-Id: <1197625737-26207-1-git-send-email-bruno@thinktube.com> (sfid-20071214_094911_490618_E57682C8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

setting up tx descriptors with a rate of zero will put the HW into a mode where
it continously sends noise on the channel, thus blocking the whole channel.
since it is important to avoid this situation, add a WARN_ON in these cases,
even if we hope to never get bad rates from the rate control module.

Changes-licensed-under: ISC
Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---
 drivers/net/wireless/ath5k/hw.c |   40 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 83fd241..6181066 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -3476,9 +3476,20 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 
 	/*
 	 * Validate input
+	 * - Zero retries don't make sense.
+	 * - A zero rate will put the HW into a mode where it continously sends
+	 *   noise on the channel, so it is important to avoid this.
 	 */
-	if (tx_tries0 == 0)
+	if (unlikely(tx_tries0 == 0)) {
+		ATH5K_ERR(ah->ah_sc, "zero retries\n");
+		WARN_ON(1);
 		return -EINVAL;
+	}
+	if (unlikely(tx_rate0 == 0)) {
+		ATH5K_ERR(ah->ah_sc, "zero rate\n");
+		WARN_ON(1);
+		return -EINVAL;
+	}
 
 	/* Clear status descriptor */
 	memset(desc->ds_hw, 0, sizeof(struct ath5k_hw_tx_status));
@@ -3595,9 +3606,20 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 
 	/*
 	 * Validate input
+	 * - Zero retries don't make sense.
+	 * - A zero rate will put the HW into a mode where it continously sends
+	 *   noise on the channel, so it is important to avoid this.
 	 */
-	if (tx_tries0 == 0)
+	if (unlikely(tx_tries0 == 0)) {
+		ATH5K_ERR(ah->ah_sc, "zero retries\n");
+		WARN_ON(1);
 		return -EINVAL;
+	}
+	if (unlikely(tx_rate0 == 0)) {
+		ATH5K_ERR(ah->ah_sc, "zero rate\n");
+		WARN_ON(1);
+		return -EINVAL;
+	}
 
 	/* Clear status descriptor */
 	memset(tx_status, 0, sizeof(struct ath5k_hw_tx_status));
@@ -3686,6 +3708,20 @@ ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 {
 	struct ath5k_hw_4w_tx_desc *tx_desc;
 
+	/*
+	 * Rates can be 0 as long as the retry count is 0 too.
+	 * A zero rate and nonzero retry count will put the HW into a mode where
+	 * it continously sends noise on the channel, so it is important to
+	 * avoid this.
+	 */
+	if (unlikely((tx_rate1 == 0 && tx_tries1 != 0) ||
+		     (tx_rate2 == 0 && tx_tries2 != 0) ||
+		     (tx_rate3 == 0 && tx_tries3 != 0))) {
+		ATH5K_ERR(ah->ah_sc, "zero rate\n");
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
 	if (ah->ah_version == AR5K_AR5212) {
 		tx_desc = (struct ath5k_hw_4w_tx_desc *)&desc->ds_ctl0;
 
-- 
1.5.3.4

