Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36242 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728096AbeIFNyt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:54:49 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 30/42] mt76x0: alloc mcu buffers first in mt76x0_mcu_cmd_init
Date: Thu,  6 Sep 2018 11:18:46 +0200
Message-Id: <1536225538-16454-31-git-send-email-sgruszka@redhat.com> (sfid-20180906_112022_514840_38F53A1F)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

swap mt76u_mcu_init_rx and mt76x0_mcu_function_select in
mt76x0_mcu_cmd_init routine in order to allocate mcu buffers
first and then send mcu commands

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
index 0a0deaf1c65d..7be2835f3b4f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
@@ -387,9 +387,11 @@ int mt76x0_mcu_init(struct mt76x0_dev *dev)
 
 int mt76x0_mcu_cmd_init(struct mt76x0_dev *dev)
 {
-	int ret = mt76x0_mcu_function_select(dev, Q_SELECT, 1);
+	int ret;
+
+	ret = mt76u_mcu_init_rx(&dev->mt76);
 	if (ret)
 		return ret;
 
-	return mt76u_mcu_init_rx(&dev->mt76);
+	return mt76x0_mcu_function_select(dev, Q_SELECT, 1);
 }
-- 
2.7.5
