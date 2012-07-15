Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40169 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab2GORxq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jul 2012 13:53:46 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v3 06/12] ath9k/ath9k_htc: fix txop limit handling
Date: Sun, 15 Jul 2012 19:53:34 +0200
Message-Id: <1342374820-92409-6-git-send-email-nbd@openwrt.org> (sfid-20120715_195349_010808_010F7EF5)
In-Reply-To: <1342374820-92409-5-git-send-email-nbd@openwrt.org>
References: <1342374820-92409-1-git-send-email-nbd@openwrt.org>
 <1342374820-92409-2-git-send-email-nbd@openwrt.org>
 <1342374820-92409-3-git-send-email-nbd@openwrt.org>
 <1342374820-92409-4-git-send-email-nbd@openwrt.org>
 <1342374820-92409-5-git-send-email-nbd@openwrt.org>
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
index cb9a8c9..d74b4b6 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1388,7 +1388,7 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw,
 	qi.tqi_aifs = params->aifs;
 	qi.tqi_cwmin = params->cw_min;
 	qi.tqi_cwmax = params->cw_max;
-	qi.tqi_burstTime = params->txop;
+	qi.tqi_burstTime = params->txop * 32;
 
 	ath_dbg(common, CONFIG,
 		"Configure tx [queue/halq] [%d/%d], aifs: %d, cw_min: %d, cw_max: %d, txop: %d\n",
-- 
1.7.7.5 (Apple Git-26)

