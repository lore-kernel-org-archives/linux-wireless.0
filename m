Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0073.outbound.protection.outlook.com ([104.47.42.73]:15232
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751071AbdHONG4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2017 09:06:56 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 2/9] qtnfmac: switch to napi_gro_receive
Date: Tue, 15 Aug 2017 16:06:32 +0300
Message-Id: <20170815130638.31718-3-sergey.matyukevich.os@quantenna.com> (sfid-20170815_150706_233743_82E0CBD9)
In-Reply-To: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
References: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use napi_gro_receive() rather than netif_receive_skb() in qtnfmac driver.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index ae8acc1bf291..08b35dc30bc8 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -762,7 +762,7 @@ static int qtnf_rx_poll(struct napi_struct *napi, int budget)
 				ndev->stats.rx_bytes += skb->len;
 
 				skb->protocol = eth_type_trans(skb, ndev);
-				netif_receive_skb(skb);
+				napi_gro_receive(napi, skb);
 			} else {
 				pr_debug("drop untagged skb\n");
 				bus->mux_dev.stats.rx_dropped++;
-- 
2.11.0
