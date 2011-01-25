Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab1AYNPT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 08:15:19 -0500
Date: Tue, 25 Jan 2011 14:15:12 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	Sujith <m.sujith@gmail.com>, stable@kernel.org
Subject: [PATCH] ath9k_htc: fix race conditions when stop device
Message-ID: <20110125131459.GA2529@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do not kill any scheduled tasklets when stopping device, that may
cause usage of resources after free. Disable interrupts, kill tasklets
and then works in correct order.

Cc: stable@kernel.org
Tested-by: Sujith <m.sujith@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    3 ---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   21 +++++++++++++++------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 8e04586..a7bc26d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -142,9 +142,6 @@ static void ath9k_deinit_priv(struct ath9k_htc_priv *priv)
 {
 	ath9k_htc_exit_debug(priv->ah);
 	ath9k_hw_deinit(priv->ah);
-	tasklet_kill(&priv->swba_tasklet);
-	tasklet_kill(&priv->rx_tasklet);
-	tasklet_kill(&priv->tx_tasklet);
 	kfree(priv->ah);
 	priv->ah = NULL;
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index f14f37d..a702089 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1026,12 +1026,6 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	int ret = 0;
 	u8 cmd_rsp;
 
-	/* Cancel all the running timers/work .. */
-	cancel_work_sync(&priv->fatal_work);
-	cancel_work_sync(&priv->ps_work);
-	cancel_delayed_work_sync(&priv->ath9k_led_blink_work);
-	ath9k_led_stop_brightness(priv);
-
 	mutex_lock(&priv->mutex);
 
 	if (priv->op_flags & OP_INVALID) {
@@ -1045,8 +1039,23 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
 	WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
 	WMI_CMD(WMI_STOP_RECV_CMDID);
+
+	tasklet_kill(&priv->swba_tasklet);
+	tasklet_kill(&priv->rx_tasklet);
+	tasklet_kill(&priv->tx_tasklet);
+
 	skb_queue_purge(&priv->tx_queue);
 
+	mutex_unlock(&priv->mutex);
+
+	/* Cancel all the running timers/work .. */
+	cancel_work_sync(&priv->fatal_work);
+	cancel_work_sync(&priv->ps_work);
+	cancel_delayed_work_sync(&priv->ath9k_led_blink_work);
+	ath9k_led_stop_brightness(priv);
+
+	mutex_lock(&priv->mutex);
+
 	/* Remove monitor interface here */
 	if (ah->opmode == NL80211_IFTYPE_MONITOR) {
 		if (ath9k_htc_remove_monitor_interface(priv))
-- 
1.7.1


