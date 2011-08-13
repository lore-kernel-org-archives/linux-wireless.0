Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9177 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1HME6R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 00:58:17 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 04/11] ath9k: Remove unused argument tsf from ath9k_hw_rxprocdesc
Date: Sat, 13 Aug 2011 10:28:11 +0530
Message-ID: <1313211498-14442-4-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110813_065820_787483_2387E29F)
In-Reply-To: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/mac.c  |    2 +-
 drivers/net/wireless/ath/ath9k/mac.h  |    2 +-
 drivers/net/wireless/ath/ath9k/recv.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 0f90e15..7ddca67 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -564,7 +564,7 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 EXPORT_SYMBOL(ath9k_hw_resettxqueue);
 
 int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
-			struct ath_rx_status *rs, u64 tsf)
+			struct ath_rx_status *rs)
 {
 	struct ar5416_desc ads;
 	struct ar5416_desc *adsp = AR5416DESC(ds);
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 8e848c4..153859c 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -687,7 +687,7 @@ int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 bool ath9k_hw_releasetxqueue(struct ath_hw *ah, u32 q);
 bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q);
 int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
-			struct ath_rx_status *rs, u64 tsf);
+			struct ath_rx_status *rs);
 void ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			  u32 size, u32 flags);
 bool ath9k_hw_setrxabort(struct ath_hw *ah, bool set);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index c0c66e0..a9d8f96b 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -761,7 +761,7 @@ static struct ath_buf *ath_get_next_rx_buf(struct ath_softc *sc,
 	 * on.  All this is necessary because of our use of
 	 * a self-linked list to avoid rx overruns.
 	 */
-	ret = ath9k_hw_rxprocdesc(ah, ds, rs, 0);
+	ret = ath9k_hw_rxprocdesc(ah, ds, rs);
 	if (ret == -EINPROGRESS) {
 		struct ath_rx_status trs;
 		struct ath_buf *tbf;
@@ -787,7 +787,7 @@ static struct ath_buf *ath_get_next_rx_buf(struct ath_softc *sc,
 		 */
 
 		tds = tbf->bf_desc;
-		ret = ath9k_hw_rxprocdesc(ah, tds, &trs, 0);
+		ret = ath9k_hw_rxprocdesc(ah, tds, &trs);
 		if (ret == -EINPROGRESS)
 			return NULL;
 	}
-- 
1.7.6

