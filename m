Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44870 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750822AbeAPKyV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 05:54:21 -0500
Subject: [PATCH] ath10k: fix recently introduced checkpatch warnings
From: Kalle Valo <kvalo@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 16 Jan 2018 12:54:17 +0200
Message-ID: <151610005703.17030.17977783056615638055.stgit@potku.adurom.net> (sfid-20180116_115425_137311_9490492C)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Checkpatch found these issues:

drivers/net/wireless/ath/ath10k/ce.h:324: Please use a blank line after function/struct/union/enum declarations
drivers/net/wireless/ath/ath10k/core.c:1321: Please don't use multiple blank lines
drivers/net/wireless/ath/ath10k/htt.h:1859: Please use a blank line after function/struct/union/enum declarations

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/ce.h   |    1 +
 drivers/net/wireless/ath/ath10k/core.c |    1 -
 drivers/net/wireless/ath/ath10k/htt.h  |    1 +
 3 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 06ac2eb70bf5..2c3c8f5e90ea 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -321,6 +321,7 @@ struct ath10k_ce_ops {
 			      dma_addr_t buffer, u32 nbytes,
 			      u32 transfer_id, u32 flags);
 };
+
 static inline u32 ath10k_ce_base_address(struct ath10k *ar, unsigned int ce_id)
 {
 	return CE0_BASE_ADDRESS + (CE1_BASE_ADDRESS - CE0_BASE_ADDRESS) * ce_id;
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c60d91328b5f..b0fdc1023619 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1318,7 +1318,6 @@ static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
 			goto out;
 		}
 
-
 		len -= ie_len;
 		data += ie_len;
 	}
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 360c71b106d7..8cc2a8b278e4 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1856,6 +1856,7 @@ struct ath10k_htt_rx_ops {
 	void* (*htt_get_vaddr_ring)(struct ath10k_htt *htt);
 	void (*htt_reset_paddrs_ring)(struct ath10k_htt *htt, int idx);
 };
+
 #define RX_HTT_HDR_STATUS_LEN 64
 
 /* This structure layout is programmed via rx ring setup
