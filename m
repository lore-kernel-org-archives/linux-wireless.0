Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47723 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020Ab0EKKyT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 06:54:19 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 03:54:19 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19433.14190.31764.174876@gargle.gargle.HOWL>
Date: Tue, 11 May 2010 16:24:38 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/5] ath9k_htc: Lock sta_notify() callback
From: <Sujith.Manoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since ->sta_notify() can sleep, protect
the callback with a mutex.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 6c386da..9d371c1 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1452,6 +1452,8 @@ static void ath9k_htc_sta_notify(struct ieee80211_hw *hw,
 	struct ath9k_htc_priv *priv = hw->priv;
 	int ret;
 
+	mutex_lock(&priv->mutex);
+
 	switch (cmd) {
 	case STA_NOTIFY_ADD:
 		ret = ath9k_htc_add_station(priv, vif, sta);
@@ -1464,6 +1466,8 @@ static void ath9k_htc_sta_notify(struct ieee80211_hw *hw,
 	default:
 		break;
 	}
+
+	mutex_unlock(&priv->mutex);
 }
 
 static int ath9k_htc_conf_tx(struct ieee80211_hw *hw, u16 queue,
-- 
1.7.1


-- 
