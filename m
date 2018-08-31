Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43950 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727614AbeHaTL0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 15:11:26 -0400
From: Igor Stoppa <igor.stoppa@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: igor.stoppa@gmail.com, Igor Stoppa <igor.stoppa@huawei.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Michal Kazior <michal.kazior@tieto.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless: remove unnecessary unlikely()
Date: Fri, 31 Aug 2018 18:03:00 +0300
Message-Id: <20180831150300.2702-1-igor.stoppa@huawei.com> (sfid-20180831_170450_059364_05E9C7DB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both WARN_ON() and WARN_ON_ONCE() already contain unlikely().

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Christian Lamparter <chunkeey@googlemail.com>
Cc: Michal Kazior <michal.kazior@tieto.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c      | 4 ++--
 drivers/net/wireless/ath/carl9170/tx.c        | 4 ++--
 drivers/net/wireless/broadcom/b43/dma.c       | 2 +-
 drivers/net/wireless/broadcom/b43legacy/dma.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 4d1cd90d6d27..1455007f3eb8 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1176,11 +1176,11 @@ static void ath10k_htt_rx_h_undecap_raw(struct ath10k *ar,
 	 */
 
 	/* This probably shouldn't happen but warn just in case */
-	if (unlikely(WARN_ON_ONCE(!is_first)))
+	if (WARN_ON_ONCE(!is_first))
 		return;
 
 	/* This probably shouldn't happen but warn just in case */
-	if (unlikely(WARN_ON_ONCE(!(is_first && is_last))))
+	if (WARN_ON_ONCE(!(is_first && is_last)))
 		return;
 
 	skb_trim(msdu, msdu->len - FCS_LEN);
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 0cb5b58925dc..8c75651ede6c 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -246,8 +246,8 @@ static void carl9170_release_dev_space(struct ar9170 *ar, struct sk_buff *skb)
 	 *    of available memory blocks, so the number can
 	 *    never execeed the mem_blocks count.
 	 */
-	if (unlikely(WARN_ON_ONCE(cookie == 0) ||
-	    WARN_ON_ONCE(cookie > ar->fw.mem_blocks)))
+	if (WARN_ON_ONCE(cookie == 0) ||
+	    WARN_ON_ONCE(cookie > ar->fw.mem_blocks))
 		return;
 
 	atomic_add(DIV_ROUND_UP(skb->len, ar->fw.mem_block_size),
diff --git a/drivers/net/wireless/broadcom/b43/dma.c b/drivers/net/wireless/broadcom/b43/dma.c
index 6b0e1ec346cb..d113bd997f4b 100644
--- a/drivers/net/wireless/broadcom/b43/dma.c
+++ b/drivers/net/wireless/broadcom/b43/dma.c
@@ -1432,7 +1432,7 @@ int b43_dma_tx(struct b43_wldev *dev, struct sk_buff *skb)
 		goto out;
 	}
 
-	if (unlikely(WARN_ON(free_slots(ring) < TX_SLOTS_PER_FRAME))) {
+	if (WARN_ON(free_slots(ring) < TX_SLOTS_PER_FRAME)) {
 		/* If we get here, we have a real error with the queue
 		 * full, but queues not stopped. */
 		b43err(dev->wl, "DMA queue overflow\n");
diff --git a/drivers/net/wireless/broadcom/b43legacy/dma.c b/drivers/net/wireless/broadcom/b43legacy/dma.c
index 2f0c64cef65f..1b1da7d83652 100644
--- a/drivers/net/wireless/broadcom/b43legacy/dma.c
+++ b/drivers/net/wireless/broadcom/b43legacy/dma.c
@@ -1149,7 +1149,7 @@ int b43legacy_dma_tx(struct b43legacy_wldev *dev,
 		return -ENOSPC;
 	}
 
-	if (unlikely(WARN_ON(free_slots(ring) < SLOTS_PER_PACKET))) {
+	if (WARN_ON(free_slots(ring) < SLOTS_PER_PACKET)) {
 		/* If we get here, we have a real error with the queue
 		 * full, but queues not stopped. */
 		b43legacyerr(dev->wl, "DMA queue overflow\n");
-- 
2.17.1
