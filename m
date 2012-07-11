Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49707 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756593Ab2GKR70 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 13:59:26 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 06/12] ath9k/ath9k_htc: fix txop limit handling
Date: Wed, 11 Jul 2012 19:59:09 +0200
Message-Id: <1342029555-31618-6-git-send-email-nbd@openwrt.org> (sfid-20120711_195930_896224_6B1627E2)
In-Reply-To: <1342029555-31618-5-git-send-email-nbd@openwrt.org>
References: <1342029555-31618-1-git-send-email-nbd@openwrt.org>
 <1342029555-31618-2-git-send-email-nbd@openwrt.org>
 <1342029555-31618-3-git-send-email-nbd@openwrt.org>
 <1342029555-31618-4-git-send-email-nbd@openwrt.org>
 <1342029555-31618-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In all those years apparently nobody noticed that the txop limit programmed
into the chip was off by a factor of 32 (!), probably because the VI and VO
queues aren't used that much aside from mgmt frames on VO.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    2 +-
 drivers/net/wireless/ath/ath9k/main.c         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 374c32e..fe2bfff 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1351,7 +1351,7 @@ static int ath9k_htc_conf_tx(struct ieee80211_hw *hw,
 	qi.tqi_aifs = params->aifs;
 	qi.tqi_cwmin = params->cw_min;
 	qi.tqi_cwmax = params->cw_max;
-	qi.tqi_burstTime = params->txop;
+	qi.tqi_burstTime = params->txop * 32;
 
 	qnum = get_hw_qnum(queue, priv->hwq_map);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 49f293a..6f0be0d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1377,7 +1377,7 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw,
 	qi.tqi_aifs = params->aifs;
 	qi.tqi_cwmin = params->cw_min;
 	qi.tqi_cwmax = params->cw_max;
-	qi.tqi_burstTime = params->txop;
+	qi.tqi_burstTime = params->txop * 32;
 
 	ath_dbg(common, CONFIG,
 		"Configure tx [queue/halq] [%d/%d], aifs: %d, cw_min: %d, cw_max: %d, txop: %d\n",
-- 
1.7.3.2

