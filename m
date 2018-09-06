Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728039AbeIFNyP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:54:15 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 17/42] mt76x0: set max fragments size
Date: Thu,  6 Sep 2018 11:18:33 +0200
Message-Id: <1536225538-16454-18-git-send-email-sgruszka@redhat.com> (sfid-20180906_111952_089304_362BFAAF)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Set maximum number of tx fragments according to usb controller
features

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 33730c93c63f..cd7cdf3d9731 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -722,6 +722,12 @@ int mt76x0_register_device(struct mt76x0_dev *dev)
 	if (ret)
 		return ret;
 
+	/* check hw sg support in order to enable AMSDU */
+	if (mt76u_check_sg(&dev->mt76))
+		hw->max_tx_fragments = MT_SG_MAX_SIZE;
+	else
+		hw->max_tx_fragments = 1;
+
 	mt76x0_init_debugfs(dev);
 
 	return 0;
-- 
2.7.5
