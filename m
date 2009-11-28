Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:51921 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZK1Xr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 18:47:27 -0500
Received: by fg-out-1718.google.com with SMTP id 19so548880fgg.1
        for <linux-wireless@vger.kernel.org>; Sat, 28 Nov 2009 15:47:33 -0800 (PST)
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/5] ar9170: remove dead definitions
Cc: John W Linville <linville@tuxdriver.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 29 Nov 2009 00:51:54 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911290051.54652.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes dead infrastructure which was meant
for an out-of-tree rate control algorithm.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
low priority
---
diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index 9f94598..d95a7d4 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -109,7 +109,6 @@ struct ar9170_rxstream_mpdu_merge {
 	bool has_plcp;
 };
 
-#define AR9170_NUM_MAX_BA_RETRY	5
 #define AR9170_NUM_TID	16
 #define WME_BA_BMP_SIZE         64
 #define AR9170_NUM_MAX_AGG_LEN	(2 * WME_BA_BMP_SIZE)
@@ -143,7 +142,6 @@ struct ar9170_sta_tid {
 	u16 tid;
 	enum ar9170_tid_state state;
 	bool active;
-	u8 retry;
 };
 
 #define AR9170_QUEUE_TIMEOUT		64
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index f9d6db8..cbf59b1 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -2366,7 +2366,6 @@ static void ar9170_sta_notify(struct ieee80211_hw *hw,
 			sta_info->agg[i].state = AR9170_TID_STATE_SHUTDOWN;
 			sta_info->agg[i].active = false;
 			sta_info->agg[i].ssn = 0;
-			sta_info->agg[i].retry = 0;
 			sta_info->agg[i].tid = i;
 			INIT_LIST_HEAD(&sta_info->agg[i].list);
 			skb_queue_head_init(&sta_info->agg[i].queue);
