Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34367 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab1BUCTW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Feb 2011 21:19:22 -0500
Received: by mail-gx0-f174.google.com with SMTP id 8so301676gxk.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 18:19:21 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19809.52124.186919.920232@gargle.gargle.HOWL>
Date: Mon, 21 Feb 2011 07:49:08 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 11/23] ath9k_htc: Protect ampdu_action with a mutex
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

This is required when issuing commands to the firmware.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 9620f45..04cb243 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1639,6 +1639,8 @@ static int ath9k_htc_ampdu_action(struct ieee80211_hw *hw,
 	struct ath9k_htc_sta *ista;
 	int ret = 0;
 
+	mutex_lock(&priv->mutex);
+
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		break;
@@ -1663,6 +1665,8 @@ static int ath9k_htc_ampdu_action(struct ieee80211_hw *hw,
 		ath_err(ath9k_hw_common(priv->ah), "Unknown AMPDU action\n");
 	}
 
+	mutex_unlock(&priv->mutex);
+
 	return ret;
 }
 
-- 
1.7.4.1

