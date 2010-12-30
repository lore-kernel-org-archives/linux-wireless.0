Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:60311 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206Ab0L3GsL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Dec 2010 01:48:11 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 29 Dec 2010 22:47:54 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
Subject: [PATCH] Revert "ath9k: Parse DTIM period from mac80211"
Date: Thu, 30 Dec 2010 12:18:01 +0530
Message-ID: <1293691681-3574-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

This reverts commit 0ce3bcfc84900a64347b0fe1140229bd81314008.

Event though with the above commit we obtain the configured DTIM period
from the AP rather than always hardcoding it to '1', this seems to cause
problems under the following scenarios:
* Preventing association with broken AP's
* Adds latency in roaming
So its better to always use the safe value of '1' for dtim period

Cc: Jouni Malinen <Jouni.Malinen@Atheros.com>
Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    3 +--
 drivers/net/wireless/ath/ath9k/init.c         |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 0f6be35..e0a9c83 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -714,8 +714,7 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 		IEEE80211_HW_HAS_RATE_CONTROL |
 		IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_SUPPORTS_PS |
-		IEEE80211_HW_PS_NULLFUNC_STACK |
-		IEEE80211_HW_NEED_DTIM_PERIOD;
+		IEEE80211_HW_PS_NULLFUNC_STACK;
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index b0e5e71..498c3a4 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -647,8 +647,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_PS_NULLFUNC_STACK |
 		IEEE80211_HW_SPECTRUM_MGMT |
-		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
-		IEEE80211_HW_NEED_DTIM_PERIOD;
+		IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
 		 hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
-- 
1.7.0.4

