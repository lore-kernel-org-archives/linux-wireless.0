Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51746 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932450AbcCRJzJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 05:55:09 -0400
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH] ath9k: fix rng high cpu load
Date: Fri, 18 Mar 2016 17:54:56 +0800
Message-Id: <1458294896-7502-1-git-send-email-miaoqing@codeaurora.org> (sfid-20160318_105517_596944_C87330DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

If no valid ADC randomness output, ath9k rng will continuously
reading ADC, which will cause high CPU load. So increase the
delay to wait for ADC ready.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=114261
Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/rng.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/rng.c b/drivers/net/wireless/ath/ath9k/rng.c
index c9cb2aa..d38e50f 100644
--- a/drivers/net/wireless/ath/ath9k/rng.c
+++ b/drivers/net/wireless/ath/ath9k/rng.c
@@ -55,11 +55,26 @@ static int ath9k_rng_data_read(struct ath_softc *sc, u32 *buf, u32 buf_size)
 	return j << 2;
 }
 
+static u32 ath9k_rng_delay_get(u32 fail_stats)
+{
+	u32 delay;
+
+	if (fail_stats < 100)
+		delay = 10;
+	else if (fail_stats < 105)
+		delay = 1000;
+	else
+		delay = 10000;
+
+	return delay;
+}
+
 static int ath9k_rng_kthread(void *data)
 {
 	int bytes_read;
 	struct ath_softc *sc = data;
 	u32 *rng_buf;
+	u32 delay, fail_stats = 0;
 
 	rng_buf = kmalloc_array(ATH9K_RNG_BUF_SIZE, sizeof(u32), GFP_KERNEL);
 	if (!rng_buf)
@@ -69,10 +84,13 @@ static int ath9k_rng_kthread(void *data)
 		bytes_read = ath9k_rng_data_read(sc, rng_buf,
 						 ATH9K_RNG_BUF_SIZE);
 		if (unlikely(!bytes_read)) {
-			msleep_interruptible(10);
+			delay = ath9k_rng_delay_get(++fail_stats);
+			msleep_interruptible(delay);
 			continue;
 		}
 
+		fail_stats = 0;
+
 		/* sleep until entropy bits under write_wakeup_threshold */
 		add_hwgenerator_randomness((void *)rng_buf, bytes_read,
 					   ATH9K_RNG_ENTROPY(bytes_read));
-- 
1.9.1

