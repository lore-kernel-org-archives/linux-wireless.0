Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:24730 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288Ab0BRL2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:20 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH 12/22] wl1271: wakeup chip in op_conf_tx()
Date: Thu, 18 Feb 2010 13:25:47 +0200
Message-Id: <1266492357-462-13-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

elp_wakeup() was missing in op_conf_tx() which caused wakeup problems in
power save. I forgot to add this part when porting the patch from wl1251.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index c7f5191..9de7df7 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1738,11 +1738,15 @@ static int wl1271_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 conf tx %d", queue);
 
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out;
+
 	ret = wl1271_acx_ac_cfg(wl, wl1271_tx_get_queue(queue),
 				params->cw_min, params->cw_max,
 				params->aifs, params->txop);
 	if (ret < 0)
-		goto out;
+		goto out_sleep;
 
 	ret = wl1271_acx_tid_cfg(wl, wl1271_tx_get_queue(queue),
 				 CONF_CHANNEL_TYPE_EDCF,
@@ -1750,7 +1754,10 @@ static int wl1271_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
 				 CONF_PS_SCHEME_LEGACY_PSPOLL,
 				 CONF_ACK_POLICY_LEGACY, 0, 0);
 	if (ret < 0)
-		goto out;
+		goto out_sleep;
+
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
 
 out:
 	mutex_unlock(&wl->mutex);
-- 
1.6.3.3

