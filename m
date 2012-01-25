Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6927 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab2AYQII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 11:08:08 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH V3 2/6] ath6kl: Fix memory leak when unloading ath6kl_sdio
Date: Wed, 25 Jan 2012 21:37:50 +0530
Message-ID: <1327507674-2561-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120125_170818_279294_57AFA589)
In-Reply-To: <1327507674-2561-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1327507674-2561-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "ath6kl: create core.c" removes wiphy_free() from
ath6kl_cfg80211_cleanup() and misses to free wiphy in
ath6kl_sdio_remove(). This patch fixes this regression.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 7bb6107..d9f5591 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1314,6 +1314,7 @@ static void ath6kl_sdio_remove(struct sdio_func *func)
 	cancel_work_sync(&ar_sdio->wr_async_work);
 
 	ath6kl_core_cleanup(ar_sdio->ar);
+	ath6kl_core_destroy(ar_sdio->ar);
 
 	kfree(ar_sdio->dma_buffer);
 	kfree(ar_sdio);
-- 
1.7.0.4

