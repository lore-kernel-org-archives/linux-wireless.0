Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59190 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbZKMSPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 13:15:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: m.sujith@gmail.com, mcgrof@gmail.com,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: remove warnings related to signed/unsigned type mismatch
Date: Fri, 13 Nov 2009 13:12:59 -0500
Message-Id: <1258135979-6569-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/net/wireless/ath/ath9k/recv.o
drivers/net/wireless/ath/ath9k/recv.c: In function `ath_rx_prepare':
drivers/net/wireless/ath/ath9k/recv.c:208: warning: comparison is always true due to limited range of data type
drivers/net/wireless/ath/ath9k/recv.c:220: warning: comparison is always false due to limited range of data type

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
The code has moved in wireless-testing, but AFAICT the issue is still
there (even if my other compiler doesn't complain about it).

 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath/ath9k/recv.c  |    2 --
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 1d59f10..9c07e1c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -293,7 +293,7 @@ struct ath_tx_control {
 
 #define ATH_RSSI_LPF_LEN 		10
 #define RSSI_LPF_THRESHOLD		-20
-#define ATH9K_RSSI_BAD			0x80
+#define ATH9K_RSSI_BAD			-128
 #define ATH_RSSI_EP_MULTIPLIER     (1<<7)
 #define ATH_EP_MUL(x, mul)         ((x) * (mul))
 #define ATH_RSSI_IN(x)             (ATH_EP_MUL((x), ATH_RSSI_EP_MULTIPLIER))
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ec0abf8..e2e8126 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -217,8 +217,6 @@ static int ath_rx_prepare(struct sk_buff *skb, struct ath_desc *ds,
 					ATH_RSSI_EP_MULTIPLIER);
 	if (ds->ds_rxstat.rs_rssi < 0)
 		ds->ds_rxstat.rs_rssi = 0;
-	else if (ds->ds_rxstat.rs_rssi > 127)
-		ds->ds_rxstat.rs_rssi = 127;
 
 	/* Update Beacon RSSI, this is used by ANI. */
 	if (ieee80211_is_beacon(fc))
-- 
1.6.2.5

