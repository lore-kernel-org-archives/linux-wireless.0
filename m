Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:33573 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab1DTF2n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 01:28:43 -0400
Received: by pxi2 with SMTP id 2so318654pxi.10
        for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 22:28:42 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19886.28574.983271.871943@gargle.gargle.HOWL>
Date: Wed, 20 Apr 2011 11:01:10 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 4/5] ath9k_htc: Use power save wrappers when accessing HW
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c |   24 +++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c  |    2 ++
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index eca7774..894e5ef 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -33,9 +33,15 @@ static ssize_t read_file_tgt_int_stats(struct file *file, char __user *user_buf,
 
 	memset(&cmd_rsp, 0, sizeof(cmd_rsp));
 
+	ath9k_htc_ps_wakeup(priv);
+
 	WMI_CMD(WMI_INT_STATS_CMDID);
-	if (ret)
+	if (ret) {
+		ath9k_htc_ps_restore(priv);
 		return -EINVAL;
+	}
+
+	ath9k_htc_ps_restore(priv);
 
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"%20s : %10u\n", "RX",
@@ -85,9 +91,15 @@ static ssize_t read_file_tgt_tx_stats(struct file *file, char __user *user_buf,
 
 	memset(&cmd_rsp, 0, sizeof(cmd_rsp));
 
+	ath9k_htc_ps_wakeup(priv);
+
 	WMI_CMD(WMI_TX_STATS_CMDID);
-	if (ret)
+	if (ret) {
+		ath9k_htc_ps_restore(priv);
 		return -EINVAL;
+	}
+
+	ath9k_htc_ps_restore(priv);
 
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"%20s : %10u\n", "Xretries",
@@ -149,9 +161,15 @@ static ssize_t read_file_tgt_rx_stats(struct file *file, char __user *user_buf,
 
 	memset(&cmd_rsp, 0, sizeof(cmd_rsp));
 
+	ath9k_htc_ps_wakeup(priv);
+
 	WMI_CMD(WMI_RX_STATS_CMDID);
-	if (ret)
+	if (ret) {
+		ath9k_htc_ps_restore(priv);
 		return -EINVAL;
+	}
+
+	ath9k_htc_ps_restore(priv);
 
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"%20s : %10u\n", "NoBuf",
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index fbc238a..c8577d5 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1582,6 +1582,7 @@ static int ath9k_htc_ampdu_action(struct ieee80211_hw *hw,
 	int ret = 0;
 
 	mutex_lock(&priv->mutex);
+	ath9k_htc_ps_wakeup(priv);
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
@@ -1607,6 +1608,7 @@ static int ath9k_htc_ampdu_action(struct ieee80211_hw *hw,
 		ath_err(ath9k_hw_common(priv->ah), "Unknown AMPDU action\n");
 	}
 
+	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
 
 	return ret;
-- 
1.7.4.4

