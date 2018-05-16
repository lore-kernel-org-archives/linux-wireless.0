Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:7675 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752292AbeEPK5M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 06:57:12 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: <kvalo@qca.qualcomm.com>, <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] ath10k: Remove useless test before clk_disable_unprepare
Date: Wed, 16 May 2018 18:54:54 +0800
Message-ID: <20180516105454.30212-1-yuehaibing@huawei.com> (sfid-20180516_125719_389401_7F498EFD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

clk_disable_unprepare() already checks that the clock pointer is valid.
No need to test it before calling it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/ath10k/ahb.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index 35d1049..fa39fff 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -180,14 +180,11 @@ static void ath10k_ahb_clock_disable(struct ath10k *ar)
 {
 	struct ath10k_ahb *ar_ahb = ath10k_ahb_priv(ar);
 
-	if (!IS_ERR_OR_NULL(ar_ahb->cmd_clk))
-		clk_disable_unprepare(ar_ahb->cmd_clk);
+	clk_disable_unprepare(ar_ahb->cmd_clk);
 
-	if (!IS_ERR_OR_NULL(ar_ahb->ref_clk))
-		clk_disable_unprepare(ar_ahb->ref_clk);
+	clk_disable_unprepare(ar_ahb->ref_clk);
 
-	if (!IS_ERR_OR_NULL(ar_ahb->rtc_clk))
-		clk_disable_unprepare(ar_ahb->rtc_clk);
+	clk_disable_unprepare(ar_ahb->rtc_clk);
 }
 
 static int ath10k_ahb_rst_ctrl_init(struct ath10k *ar)
-- 
2.7.0
