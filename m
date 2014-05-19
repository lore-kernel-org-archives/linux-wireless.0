Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:64759 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbaESWC1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 18:02:27 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH] ath9k_htc: fix build with disabled debug
Date: Tue, 20 May 2014 00:02:03 +0200
Message-Id: <1400536923-14597-1-git-send-email-linux@rempel-privat.de> (sfid-20140520_000234_846193_FC1AF2CF)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/net/wireless/ath/ath9k/htc_drv_txrx.o
drivers/net/wireless/ath/ath9k/htc_drv_txrx.c: In function ‘ath9k_rx_prepare’:
drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:1006:2: warning: passing argument 2 of ‘ath9k_htc_err_stat_rx’ from incompatible pointer type [enabled by default]
  ath9k_htc_err_stat_rx(priv, &rx_stats);
  ^
In file included from drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:17:0:
drivers/net/wireless/ath/ath9k/htc.h:380:20: note: expected ‘struct ath_htc_rx_status *’ but argument is of type ‘struct ath_rx_status *’
 static inline void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 04d2f4f..ca801a0 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -378,7 +378,7 @@ void ath9k_htc_get_et_stats(struct ieee80211_hw *hw,
 #define TX_QSTAT_INC(c) do { } while (0)
 
 static inline void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
-					 struct ath_htc_rx_status *rxs)
+					 struct ath_rx_status *rs);
 {
 }
 
-- 
1.9.1

