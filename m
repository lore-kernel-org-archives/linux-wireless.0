Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50987 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0L1I6b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 03:58:31 -0500
Received: by pwj3 with SMTP id 3so1001276pwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 00:58:31 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19737.42662.806048.662102@gargle.gargle.HOWL>
Date: Tue, 28 Dec 2010 14:28:14 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH v2 3/6] ath9k_htc: Move work cancellation outside of mutex
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

There is no need to lock the various work cancellation
calls. This will be helpful when handling FATAL events.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index dd17909..5f75f70 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1218,6 +1218,11 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	int ret = 0;
 	u8 cmd_rsp;
 
+	/* Cancel all the running timers/work .. */
+	cancel_work_sync(&priv->ps_work);
+	cancel_delayed_work_sync(&priv->ath9k_led_blink_work);
+	ath9k_led_stop_brightness(priv);
+
 	mutex_lock(&priv->mutex);
 
 	if (priv->op_flags & OP_INVALID) {
@@ -1226,11 +1231,6 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 		return;
 	}
 
-	/* Cancel all the running timers/work .. */
-	cancel_work_sync(&priv->ps_work);
-	cancel_delayed_work_sync(&priv->ath9k_led_blink_work);
-	ath9k_led_stop_brightness(priv);
-
 	ath9k_htc_ps_wakeup(priv);
 	htc_stop(priv->htc);
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
-- 
1.7.3.4

