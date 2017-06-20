Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52348 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752665AbdFTBOB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 21:14:01 -0400
From: miaoqing@codeaurora.org
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        sssa@qti.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH 1/2] ath9k: fix tx99 use after free
Date: Tue, 20 Jun 2017 09:13:39 +0800
Message-Id: <1497921220-12940-1-git-send-email-miaoqing@codeaurora.org> (sfid-20170620_031405_221565_04A0AA0D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

One scenario that could lead to UAF is two threads writing
simultaneously to the "tx99" debug file. One of them would
set the "start" value to true and follow to ath9k_tx99_init().
Inside the function it would set the sc->tx99_state to true
after allocating sc->tx99skb. Then, the other thread would
execute write_file_tx99() and call ath9k_tx99_deinit().
sc->tx99_state would be freed. After that, the first thread
would continue inside ath9k_tx99_init() and call
r = ath9k_tx99_send(sc, sc->tx99_skb, &txctl);
that would make use of the freed sc->tx99_skb memory.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/tx99.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/tx99.c b/drivers/net/wireless/ath/ath9k/tx99.c
index a866cbd..49ed1af 100644
--- a/drivers/net/wireless/ath/ath9k/tx99.c
+++ b/drivers/net/wireless/ath/ath9k/tx99.c
@@ -189,22 +189,27 @@ static ssize_t write_file_tx99(struct file *file, const char __user *user_buf,
 	if (strtobool(buf, &start))
 		return -EINVAL;
 
+	mutex_lock(&sc->mutex);
+
 	if (start == sc->tx99_state) {
 		if (!start)
-			return count;
+			goto out;
 		ath_dbg(common, XMIT, "Resetting TX99\n");
 		ath9k_tx99_deinit(sc);
 	}
 
 	if (!start) {
 		ath9k_tx99_deinit(sc);
-		return count;
+		goto out;
 	}
 
 	r = ath9k_tx99_init(sc);
-	if (r)
+	if (r) {
+		mutex_unlock(&sc->mutex);
 		return r;
-
+	}
+out:
+	mutex_unlock(&sc->mutex);
 	return count;
 }
 
-- 
1.9.1
