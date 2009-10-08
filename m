Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:56916 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759933AbZJHS7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 14:59:49 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 18/20] wl1271: Enable beacon filtering with the stack
Date: Thu,  8 Oct 2009 21:56:34 +0300
Message-Id: <1255028196-6565-19-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
References: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Enable beacon filtering with the mac80211 stack.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h       |    2 ++
 drivers/net/wireless/wl12xx/wl1271_event.c |   14 ++++++++------
 drivers/net/wireless/wl12xx/wl1271_main.c  |   12 ++++++++++++
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 34a52b3..96a5813 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -420,6 +420,8 @@ struct wl1271 {
 
 	struct wl1271_fw_status *fw_status;
 	struct wl1271_tx_hw_res_if *tx_res_if;
+
+	struct ieee80211_vif *vif;
 };
 
 int wl1271_plt_start(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index 87055f7..f329276 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -70,14 +70,16 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 			return ret;
 	}
 
-	if (vector & BSS_LOSE_EVENT_ID) {
+	/*
+	 * The BSS_LOSE_EVENT_ID is only needed while psm (and hence beacon
+	 * filtering) is enabled. Without PSM, the stack will receive all
+	 * beacons and can detect beacon loss by itself.
+	 */
+	if (vector & BSS_LOSE_EVENT_ID && wl->psm) {
 		wl1271_debug(DEBUG_EVENT, "BSS_LOSE_EVENT");
 
-		if (wl->psm_requested && wl->psm) {
-			ret = wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE);
-			if (ret < 0)
-				return ret;
-		}
+		/* indicate to the stack, that beacons have been lost */
+		ieee80211_beacon_loss(wl->vif);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index d22de23..e6f9e9b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -665,6 +665,12 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		     conf->type, conf->mac_addr);
 
 	mutex_lock(&wl->mutex);
+	if (wl->vif) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	wl->vif = conf->vif;
 
 	switch (conf->type) {
 	case NL80211_IFTYPE_STATION:
@@ -688,7 +694,12 @@ out:
 static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 					 struct ieee80211_if_init_conf *conf)
 {
+	struct wl1271 *wl = hw->priv;
+
+	mutex_lock(&wl->mutex);
 	wl1271_debug(DEBUG_MAC80211, "mac80211 remove interface");
+	wl->vif = NULL;
+	mutex_unlock(&wl->mutex);
 }
 
 #if 0
@@ -1382,6 +1393,7 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	wl->dtim_period = WL1271_DEFAULT_DTIM_PERIOD;
 	wl->basic_rate_set = WL1271_DEFAULT_BASIC_RATE_SET;
 	wl->band = IEEE80211_BAND_2GHZ;
+	wl->vif = NULL;
 
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
 		wl->tx_frames[i] = NULL;
-- 
1.5.6.5

