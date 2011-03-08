Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53777 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376Ab1CHVpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 16:45:49 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: me@bobcopeland.com, mickflemm@gmail.com,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath5k: restrict AR5K_TX_QUEUE_ID_DATA_MAX to reflect the [0,3] range
Date: Tue,  8 Mar 2011 16:36:00 -0500
Message-Id: <1299620160-27837-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This just matches reality...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
...or am I missing something?

 drivers/net/wireless/ath/ath5k/ath5k.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 0ee54eb..8a06dbd 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -513,7 +513,7 @@ enum ath5k_tx_queue_id {
 	AR5K_TX_QUEUE_ID_NOQCU_DATA	= 0,
 	AR5K_TX_QUEUE_ID_NOQCU_BEACON	= 1,
 	AR5K_TX_QUEUE_ID_DATA_MIN	= 0, /*IEEE80211_TX_QUEUE_DATA0*/
-	AR5K_TX_QUEUE_ID_DATA_MAX	= 4, /*IEEE80211_TX_QUEUE_DATA4*/
+	AR5K_TX_QUEUE_ID_DATA_MAX	= 3, /*IEEE80211_TX_QUEUE_DATA3*/
 	AR5K_TX_QUEUE_ID_DATA_SVP	= 5, /*IEEE80211_TX_QUEUE_SVP - Spectralink Voice Protocol*/
 	AR5K_TX_QUEUE_ID_CAB		= 6, /*IEEE80211_TX_QUEUE_AFTER_BEACON*/
 	AR5K_TX_QUEUE_ID_BEACON		= 7, /*IEEE80211_TX_QUEUE_BEACON*/
-- 
1.7.4

