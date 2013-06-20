Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:42768 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab3FTIaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jun 2013 04:30:09 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 3.9/3.10] ath9k_htc: Handle IDLE state transition properly
Date: Thu, 20 Jun 2013 13:57:07 +0530
Message-Id: <1371716827-3720-1-git-send-email-sujith@msujith.org> (sfid-20130620_103016_166188_0FFE296D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Make sure that a chip reset is done when IDLE is turned
off - this fixes authentication timeouts.

Cc: stable@vger.kernel.org
Reported-by: Ignacy Gawedzki <i@lri.fr>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index eaa94fe..fba6ea7 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1183,7 +1183,7 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 		mutex_lock(&priv->htc_pm_lock);
 
 		priv->ps_idle = !!(conf->flags & IEEE80211_CONF_IDLE);
-		if (priv->ps_idle)
+		if (!priv->ps_idle)
 			chip_reset = true;
 
 		mutex_unlock(&priv->htc_pm_lock);
-- 
1.8.3.1

