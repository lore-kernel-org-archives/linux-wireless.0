Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:62458 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbaCAURR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:17:17 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 11/23] ath9k|ath9k_htc: move IEEE80211_MS_TO_TU to common
Date: Sat,  1 Mar 2014 21:15:54 +0100
Message-Id: <1393704966-13985-12-git-send-email-linux@rempel-privat.de> (sfid-20140301_214709_271894_8389E089)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  | 1 -
 drivers/net/wireless/ath/ath9k/common.h | 2 ++
 drivers/net/wireless/ath/ath9k/htc.h    | 1 -
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index aa4f144..44d7449 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -403,7 +403,6 @@ void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
 #define	ATH_BCBUF               	8
 #define ATH_DEFAULT_BINTVAL     	100 /* TU */
 #define ATH_DEFAULT_BMISS_LIMIT 	10
-#define IEEE80211_MS_TO_TU(x)           (((x) * 1000) / 1024)
 
 #define TSF_TO_TU(_h,_l) \
 	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 26aafb3..8deed82 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -44,6 +44,8 @@
 #define ATH_EP_RND(x, mul) 						\
 	(((x) + ((mul)/2)) / (mul))
 
+#define IEEE80211_MS_TO_TU(x)   (((x) * 1000) / 1024)
+
 struct ath_beacon_config {
 	int beacon_interval;
 	u16 dtim_period;
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 124dfed..dab1f0c 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -39,7 +39,6 @@
 #define ATH_RESTART_CALINTERVAL   1200000 /* 20 minutes */
 
 #define ATH_DEFAULT_BMISS_LIMIT 10
-#define IEEE80211_MS_TO_TU(x)   (((x) * 1000) / 1024)
 #define TSF_TO_TU(_h, _l) \
 	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
 
-- 
1.9.0

