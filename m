Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49581 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334Ab2GLPET (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 11:04:19 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2 06/12] ath9k/ath9k_htc: fix txop limit handling
Date: Thu, 12 Jul 2012 17:04:05 +0200
Message-Id: <1342105451-42297-6-git-send-email-nbd@openwrt.org> (sfid-20120712_170446_616360_70BBD113)
In-Reply-To: <1342105451-42297-5-git-send-email-nbd@openwrt.org>
References: <1342105451-42297-1-git-send-email-nbd@openwrt.org>
 <1342105451-42297-2-git-send-email-nbd@openwrt.org>
 <1342105451-42297-3-git-send-email-nbd@openwrt.org>
 <1342105451-42297-4-git-send-email-nbd@openwrt.org>
 <1342105451-42297-5-git-send-email-nbd@openwrt.org>
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
index 724f415..aac213b 100644
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

