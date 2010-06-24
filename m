Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58806 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843Ab0FXPPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 11:15:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtl8180: mark rtl8180_beacon_work static
Date: Thu, 24 Jun 2010 11:09:23 -0400
Message-Id: <1277392163-8530-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl818x/rtl8180_dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
index 515817d..4270502 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -671,7 +671,7 @@ static u64 rtl8180_get_tsf(struct ieee80211_hw *dev)
 	       (u64)(rtl818x_ioread32(priv, &priv->map->TSFT[1])) << 32;
 }
 
-void rtl8180_beacon_work(struct work_struct *work)
+static void rtl8180_beacon_work(struct work_struct *work)
 {
 	struct rtl8180_vif *vif_priv =
 		container_of(work, struct rtl8180_vif, beacon_work.work);
-- 
1.7.0.1

