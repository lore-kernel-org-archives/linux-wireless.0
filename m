Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:32366 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab0JRGHn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 02:07:43 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 17 Oct 2010 23:07:33 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	<j@w1.fi>, <Senthilkumar.Balasubramanian@Atheros.com>,
	<Vasanth.Thiagarajan@Atheros.com>, <nbd@openwrt.org>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: Remove the median function in rate control
Date: Mon, 18 Oct 2010 11:37:17 +0530
Message-ID: <1287382037-5104-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

With the current rate control selection method the median function is
nowhere used, so remove it.

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index abebf24..c0c6e6f 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -392,25 +392,6 @@ static const struct ath_rate_table *hw_rate_table[ATH9K_MODE_MAX] = {
 static int ath_rc_get_rateindex(const struct ath_rate_table *rate_table,
 				struct ieee80211_tx_rate *rate);
 
-static inline int8_t median(int8_t a, int8_t b, int8_t c)
-{
-	if (a >= b) {
-		if (b >= c)
-			return b;
-		else if (a > c)
-			return c;
-		else
-			return a;
-	} else {
-		if (a >= c)
-			return a;
-		else if (b >= c)
-			return c;
-		else
-			return b;
-	}
-}
-
 static void ath_rc_sort_validrates(const struct ath_rate_table *rate_table,
 				   struct ath_rate_priv *ath_rc_priv)
 {
-- 
1.7.0.4

