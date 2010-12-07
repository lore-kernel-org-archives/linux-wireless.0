Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55378 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab0LGLCW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 06:02:22 -0500
Received: by mail-pv0-f174.google.com with SMTP id 4so2051658pva.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 03:02:22 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19710.5154.542990.136949@gargle.gargle.HOWL>
Date: Tue, 7 Dec 2010 16:31:54 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] ath9k_htc: Add support for handling TX power configuration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 8266ce1..5eb23f1 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1412,6 +1412,7 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 		}
 
 	}
+
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
 		if (conf->flags & IEEE80211_CONF_PS) {
 			ath9k_htc_setpower(priv, ATH9K_PM_NETWORK_SLEEP);
@@ -1423,6 +1424,11 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
+	if (changed & IEEE80211_CONF_CHANGE_POWER) {
+		priv->txpowlimit = 2 * conf->power_level;
+		ath_update_txpow(priv);
+	}
+
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
 		if (conf->flags & IEEE80211_CONF_MONITOR) {
 			if (ath9k_htc_add_monitor_interface(priv))
-- 
1.7.3.2

