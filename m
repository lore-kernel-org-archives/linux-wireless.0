Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36222 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728375AbeIFNyj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:54:39 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 26/42] mt76x0: trim rx skb to proper length
Date: Thu,  6 Sep 2018 11:18:42 +0200
Message-Id: <1536225538-16454-27-git-send-email-sgruszka@redhat.com> (sfid-20180906_112014_416002_B37C78DC)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to truncate skb to proper length. This fix below message:

wlan0: associating with AP with corrupt beacon and probe response

Fixes: 9d87d9fad47e ("mt76x0: unify tx/rx datapath with mt76x2u driver")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 8fdc246964b9..f55734a922aa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -236,6 +236,7 @@ u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
 
 	mt76x02_remove_hdr_pad(skb, pad_len);
 
+	pskb_trim(skb, len);
 	status->chains = BIT(0);
 	rssi = mt76x0_phy_get_rssi(dev, rxwi);
 	status->chain_signal[0] = status->signal = rssi;
-- 
2.7.5
