Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26464 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817Ab1C1U5p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 16:57:45 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 13:57:21 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>, <stable@kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 8/9] ath9k_htc: fix race conditions when stop device
Date: Mon, 28 Mar 2011 13:57:14 -0700
Message-ID: <1301345835-11401-9-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301345835-11401-1-git-send-email-lrodriguez@atheros.com>
References: <1301345835-11401-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit ea888357ec005abffb95acee2e61aac68dff429c upstream

We do not kill any scheduled tasklets when stopping device, that may
cause usage of resources after free. Disable interrupts, kill tasklets
and then works in correct order.

Cc: stable@kernel.org
Tested-by: Sujith <m.sujith@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    3 ---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   19 ++++++++++++++-----
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 8776f49..51029a2 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -142,9 +142,6 @@ static void ath9k_deinit_priv(struct ath9k_htc_priv *priv)
 {
 	ath9k_htc_exit_debug(priv->ah);
 	ath9k_hw_deinit(priv->ah);
-	tasklet_kill(&priv->wmi_tasklet);
-	tasklet_kill(&priv->rx_tasklet);
-	tasklet_kill(&priv->tx_tasklet);
 	kfree(priv->ah);
 	priv->ah = NULL;
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 51977ca..41dc30d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1228,18 +1228,27 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
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
 	WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
 	WMI_CMD(WMI_STOP_RECV_CMDID);
+
+	tasklet_kill(&priv->wmi_tasklet);
+	tasklet_kill(&priv->rx_tasklet);
+	tasklet_kill(&priv->tx_tasklet);
+
 	skb_queue_purge(&priv->tx_queue);
 
+	mutex_unlock(&priv->mutex);
+
+	/* Cancel all the running timers/work .. */
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
1.7.4.15.g7811d

