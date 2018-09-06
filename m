Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:11635 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725885AbeIFGwP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 02:52:15 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: Yue Haibing <yuehaibing@huawei.com>, <ath10k@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH] ath10k: snoc: remove set but not used variable 'ar_snoc'
Date: Thu, 6 Sep 2018 02:29:25 +0000
Message-ID: <1536200965-121172-1-git-send-email-yuehaibing@huawei.com> (sfid-20180906_041920_554158_C4CF5F42)
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yue Haibing <yuehaibing@huawei.com>

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/ath/ath10k/snoc.c: In function 'ath10k_snoc_tx_pipe_cleanup':
drivers/net/wireless/ath/ath10k/snoc.c:681:22: warning:
 variable 'ar_snoc' set but not used [-Wunused-but-set-variable]

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index fa1843a..2d6ae00 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -678,13 +678,11 @@ static void ath10k_snoc_tx_pipe_cleanup(struct ath10k_snoc_pipe *snoc_pipe)
 {
 	struct ath10k_ce_pipe *ce_pipe;
 	struct ath10k_ce_ring *ce_ring;
-	struct ath10k_snoc *ar_snoc;
 	struct sk_buff *skb;
 	struct ath10k *ar;
 	int i;
 
 	ar = snoc_pipe->hif_ce_state;
-	ar_snoc = ath10k_snoc_priv(ar);
 	ce_pipe = snoc_pipe->ce_hdl;
 	ce_ring = ce_pipe->src_ring;
