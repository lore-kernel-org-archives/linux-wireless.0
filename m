Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51561 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbaCAUQw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:16:52 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 04/23] ath9k_htc: use ath_beacon_conf.enable_beacon
Date: Sat,  1 Mar 2014 21:15:47 +0100
Message-Id: <1393704966-13985-5-git-send-email-linux@rempel-privat.de> (sfid-20140301_211656_398850_52A606AF)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

to reduce difference between ath9k and ath9k_htc

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc.h            | 1 -
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 4 ++--
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   | 4 ++--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 69022b0..d5a1088 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -439,7 +439,6 @@ static inline void ath9k_htc_stop_btcoex(struct ath9k_htc_priv *priv)
 
 #define OP_INVALID		   BIT(0)
 #define OP_SCANNING		   BIT(1)
-#define OP_ENABLE_BEACON           BIT(2)
 #define OP_BT_PRIORITY_DETECTED    BIT(3)
 #define OP_BT_SCAN                 BIT(4)
 #define OP_ANI_RUNNING             BIT(5)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 09ad141..4540eac 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -199,7 +199,7 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
 		} while (nexttbtt < tsftu);
 	}
 
-	if (test_bit(OP_ENABLE_BEACON, &priv->op_flags))
+	if (bss_conf->enable_beacon)
 		imask |= ATH9K_INT_SWBA;
 
 	ath_dbg(common, CONFIG,
@@ -247,7 +247,7 @@ static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
 	else
 		priv->ah->config.sw_beacon_response_time = MIN_SWBA_RESPONSE;
 
-	if (test_bit(OP_ENABLE_BEACON, &priv->op_flags))
+	if (bss_conf->enable_beacon)
 		imask |= ATH9K_INT_SWBA;
 
 	ath_dbg(common, CONFIG,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 90dad41..40733d0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1529,7 +1529,7 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 		ath_dbg(common, CONFIG, "Beacon enabled for BSS: %pM\n",
 			bss_conf->bssid);
 		ath9k_htc_set_tsfadjust(priv, vif);
-		set_bit(OP_ENABLE_BEACON, &priv->op_flags);
+		priv->cur_beacon_conf.enable_beacon = 1;
 		ath9k_htc_beacon_config(priv, vif);
 	}
 
@@ -1543,7 +1543,7 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 			ath_dbg(common, CONFIG,
 				"Beacon disabled for BSS: %pM\n",
 				bss_conf->bssid);
-			clear_bit(OP_ENABLE_BEACON, &priv->op_flags);
+			priv->cur_beacon_conf.enable_beacon = 0;
 			ath9k_htc_beacon_config(priv, vif);
 		}
 	}
-- 
1.9.0

