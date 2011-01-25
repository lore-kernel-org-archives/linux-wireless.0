Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2712 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab1AYEcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 23:32:04 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, mickflemm@gmail.com,
	Bruno Randolf <br1@einfach.org>, jirislaby@gmail.com,
	lrodriguez@atheros.com, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/2] ath5k: fix error handling in ath5k_hw_dma_stop
Date: Mon, 24 Jan 2011 23:31:43 -0500
Message-Id: <1295929904-11806-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Review spotted a problem with the error handling in ath5k_hw_dma_stop:
a successful return from ath5k_hw_stop_tx_dma will be treated as
an error, so we always bail out of the loop after processing a single
active queue.  As a result, we may not actually stop some queues during
reset.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
These two patches fix some buglets I found when reviewing some old code.

 drivers/net/wireless/ath/ath5k/dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index 0064be7..e828b98 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -838,7 +838,7 @@ int ath5k_hw_dma_stop(struct ath5k_hw *ah)
 	for (i = 0; i < qmax; i++) {
 		err = ath5k_hw_stop_tx_dma(ah, i);
 		/* -EINVAL -> queue inactive */
-		if (err != -EINVAL)
+		if (err && err != -EINVAL)
 			return err;
 	}
 
-- 
1.7.1.1


