Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0078.outbound.protection.outlook.com ([104.47.33.78]:11264
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751468AbdJOUxr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 15 Oct 2017 16:53:47 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 1/5] qtnfmac: modify full Tx queue error reporting
Date: Sun, 15 Oct 2017 23:53:23 +0300
Message-Id: <20171015205327.9966-2-sergey.matyukevich.os@quantenna.com> (sfid-20171015_225419_328356_8AD83E19)
In-Reply-To: <20171015205327.9966-1-sergey.matyukevich.os@quantenna.com>
References: <20171015205327.9966-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Under heavy load it is normal that h/w Tx queue is almost full all the time
and reclaim should be done before transmitting next packet. Warning still
should be reported as well as s/w Tx queues should be stopped in the
case when reclaim failed.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index 502e72b7cdcc..a8f2c46f3a25 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -643,11 +643,11 @@ static int qtnf_tx_queue_ready(struct qtnf_pcie_bus_priv *priv)
 {
 	if (!CIRC_SPACE(priv->tx_bd_w_index, priv->tx_bd_r_index,
 			priv->tx_bd_num)) {
-		pr_err_ratelimited("reclaim full Tx queue\n");
 		qtnf_pcie_data_tx_reclaim(priv);
 
 		if (!CIRC_SPACE(priv->tx_bd_w_index, priv->tx_bd_r_index,
 				priv->tx_bd_num)) {
+			pr_warn_ratelimited("reclaim full Tx queue\n");
 			priv->tx_full_count++;
 			return 0;
 		}
-- 
2.11.0
