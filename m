Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:65050 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaDBEDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2014 00:03:46 -0400
Received: by mail-pd0-f169.google.com with SMTP id fp1so10574096pdb.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2014 21:03:45 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] ath9k_htc: set IEEE80211_TX_STAT_AMPDU for acked aggregated frames
Date: Wed,  2 Apr 2014 12:03:18 +0800
Message-Id: <1396411398-4525-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20140402_060350_342472_74F54609)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Frame aggregation requires the IEEE80211_TX_STAT_AMPDU to
be set so that mac80211 can report the last_tx_rate correctly.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index e8149e3..289f3d8 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -471,8 +471,11 @@ static void ath9k_htc_tx_process(struct ath9k_htc_priv *priv,
 	if (!txok || !vif || !txs)
 		goto send_mac80211;
 
-	if (txs->ts_flags & ATH9K_HTC_TXSTAT_ACK)
+	if (txs->ts_flags & ATH9K_HTC_TXSTAT_ACK) {
 		tx_info->flags |= IEEE80211_TX_STAT_ACK;
+		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU)
+			tx_info->flags |= IEEE80211_TX_STAT_AMPDU;
+	}
 
 	if (txs->ts_flags & ATH9K_HTC_TXSTAT_FILT)
 		tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
-- 
1.7.9.5

