Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43972 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbdFVBZC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 21:25:02 -0400
From: miaoqing@codeaurora.org
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        sssa@qti.qualcomm.com, giulio.genovese@gmail.com,
        Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 2/3] ath9k: avoid potential freezing
Date: Thu, 22 Jun 2017 09:24:28 +0800
Message-Id: <1498094669-6510-2-git-send-email-miaoqing@codeaurora.org> (sfid-20170622_032505_679436_94C54975)
In-Reply-To: <1498094669-6510-1-git-send-email-miaoqing@codeaurora.org>
References: <1498094669-6510-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

In the worst case, ath9k_rng_stop() may take 10s to stop rng kthread.
The time is too long for users, use wait_event_interruptible_timeout()
instead of msleep_interruptible(), wakup immediately once
kthread_should_stop() is true.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/rng.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireless/ath/ath9k/rng.c
index 73f46fb..f9d3d6e 100644
--- a/drivers/net/wireless/ath/ath9k/rng.c
+++ b/drivers/net/wireless/ath/ath9k/rng.c
@@ -24,6 +24,8 @@
 #define ATH9K_RNG_BUF_SIZE	320
 #define ATH9K_RNG_ENTROPY(x)	(((x) * 8 * 10) >> 5) /* quality: 10/32 */
 
+static DECLARE_WAIT_QUEUE_HEAD(rng_queue);
+
 static int ath9k_rng_data_read(struct ath_softc *sc, u32 *buf, u32 buf_size)
 {
 	int i, j;
@@ -85,7 +87,9 @@ static int ath9k_rng_kthread(void *data)
 						 ATH9K_RNG_BUF_SIZE);
 		if (unlikely(!bytes_read)) {
 			delay = ath9k_rng_delay_get(++fail_stats);
-			msleep_interruptible(delay);
+			wait_event_interruptible_timeout(rng_queue,
+							 kthread_should_stop(),
+							 msecs_to_jiffies(delay));
 			continue;
 		}
 
-- 
1.9.1
