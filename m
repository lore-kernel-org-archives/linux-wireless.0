Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:43657 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1AUDBV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:01:21 -0500
Received: by pxi15 with SMTP id 15so217636pxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:01:21 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63187.572339.174364@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:30:35 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 10/33] ath9k_htc: Protect ampdu_action with a mutex
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

This is required when issuing commands to the firmware.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 6bd7e25..b6c8363 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1636,6 +1636,8 @@ static int ath9k_htc_ampdu_action(struct ieee80211_hw *hw,
 	struct ath9k_htc_sta *ista;
 	int ret = 0;
 
+	mutex_lock(&priv->mutex);
+
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		break;
@@ -1660,6 +1662,8 @@ static int ath9k_htc_ampdu_action(struct ieee80211_hw *hw,
 		ath_err(ath9k_hw_common(priv->ah), "Unknown AMPDU action\n");
 	}
 
+	mutex_unlock(&priv->mutex);
+
 	return ret;
 }
 
-- 
1.7.3.5

