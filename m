Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36902 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726151AbeIFONO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 10:13:14 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] mt76: fix return value of mt76x02_wait_for_mac
Date: Thu,  6 Sep 2018 11:38:34 +0200
Message-Id: <1536226714-17201-1-git-send-email-sgruszka@redhat.com> (sfid-20180906_113840_702576_B1CA994B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to return bool value in mt76x02_wait_for_mac.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 2735a6dd7df3 ("mt76: unify wait_for_mac")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 1a5da35702e6..a8bb3fede8d5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -165,7 +165,7 @@ static inline bool mt76x02_wait_for_mac(struct mt76_dev *dev)
 
 	for (i = 0; i < 500; i++) {
 		if (test_bit(MT76_REMOVED, &dev->state))
-			return -EIO;
+			return false;
 
 		switch (dev->bus->rr(dev, MAC_CSR0)) {
 		case 0:
-- 
2.7.5
