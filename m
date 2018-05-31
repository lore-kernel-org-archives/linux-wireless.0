Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:55397 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S932622AbeEaC0b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 22:26:31 -0400
From: Wei Yongjun <weiyongjun1@huawei.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        Govind Singh <govinds@codeaurora.org>
CC: Wei Yongjun <weiyongjun1@huawei.com>, <ath10k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] ath10k: make some functions static
Date: Thu, 31 May 2018 02:33:14 +0000
Message-ID: <1527733994-149212-1-git-send-email-weiyongjun1@huawei.com> (sfid-20180531_042708_111494_2A482A1C)
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes the following sparse warnings:

drivers/net/wireless/ath/ath10k/snoc.c:823:5: warning:
 symbol 'ath10k_snoc_get_ce_id_from_irq' was not declared. Should it be static?
drivers/net/wireless/ath/ath10k/snoc.c:871:6: warning:
 symbol 'ath10k_snoc_init_napi' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 47a4d2a..c82bc6f 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -820,7 +820,7 @@ static int ath10k_snoc_hif_power_up(struct ath10k *ar)
 	.write32	= ath10k_snoc_write32,
 };
 
-int ath10k_snoc_get_ce_id_from_irq(struct ath10k *ar, int irq)
+static int ath10k_snoc_get_ce_id_from_irq(struct ath10k *ar, int irq)
 {
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
 	int i;
@@ -868,7 +868,7 @@ static int ath10k_snoc_napi_poll(struct napi_struct *ctx, int budget)
 	return done;
 }
 
-void ath10k_snoc_init_napi(struct ath10k *ar)
+static void ath10k_snoc_init_napi(struct ath10k *ar)
 {
 	netif_napi_add(&ar->napi_dev, &ar->napi, ath10k_snoc_napi_poll,
 		       ATH10K_NAPI_BUDGET);
