Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17868 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbZKQQs0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:48:26 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 02/16] wl1251: Enable beacon filtering with the stack
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Nov 2009 18:48:23 +0200
Message-ID: <20091117164822.2236.25815.stgit@tikku>
In-Reply-To: <20091117164614.2236.8543.stgit@tikku>
References: <20091117164614.2236.8543.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Enable beacon filtering with the mac80211 stack.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251.h       |    2 ++
 drivers/net/wireless/wl12xx/wl1251_event.c |    7 +++++++
 drivers/net/wireless/wl12xx/wl1251_main.c  |   12 ++++++++++++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251.h b/drivers/net/wireless/wl12xx/wl1251.h
index 998e4b6..fc2871c 100644
--- a/drivers/net/wireless/wl12xx/wl1251.h
+++ b/drivers/net/wireless/wl12xx/wl1251.h
@@ -374,6 +374,8 @@ struct wl1251 {
 	u8 buffer_busyword[WL1251_BUSY_WORD_LEN];
 	struct wl1251_rx_descriptor *rx_descriptor;
 
+	struct ieee80211_vif *vif;
+
 	u32 chip_id;
 	char fw_ver[21];
 };
diff --git a/drivers/net/wireless/wl12xx/wl1251_event.c b/drivers/net/wireless/wl12xx/wl1251_event.c
index 00076c4..18c301d 100644
--- a/drivers/net/wireless/wl12xx/wl1251_event.c
+++ b/drivers/net/wireless/wl12xx/wl1251_event.c
@@ -79,6 +79,13 @@ static int wl1251_event_process(struct wl1251 *wl, struct event_mailbox *mbox)
 		}
 	}
 
+	if (vector & SYNCHRONIZATION_TIMEOUT_EVENT_ID && wl->psm) {
+		wl1251_debug(DEBUG_EVENT, "SYNCHRONIZATION_TIMEOUT_EVENT");
+
+		/* indicate to the stack, that beacons have been lost */
+		ieee80211_beacon_loss(wl->vif);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index d03a07e..601c430 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -509,6 +509,12 @@ static int wl1251_op_add_interface(struct ieee80211_hw *hw,
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
@@ -538,7 +544,12 @@ out:
 static void wl1251_op_remove_interface(struct ieee80211_hw *hw,
 					 struct ieee80211_if_init_conf *conf)
 {
+	struct wl1251 *wl = hw->priv;
+
+	mutex_lock(&wl->mutex);
 	wl1251_debug(DEBUG_MAC80211, "mac80211 remove interface");
+	wl->vif = NULL;
+	mutex_unlock(&wl->mutex);
 }
 
 static int wl1251_build_null_data(struct wl1251 *wl)
@@ -1372,6 +1383,7 @@ struct ieee80211_hw *wl1251_alloc_hw(void)
 	wl->power_level = WL1251_DEFAULT_POWER_LEVEL;
 	wl->beacon_int = WL1251_DEFAULT_BEACON_INT;
 	wl->dtim_period = WL1251_DEFAULT_DTIM_PERIOD;
+	wl->vif = NULL;
 
 	for (i = 0; i < FW_TX_CMPLT_BLOCK_SIZE; i++)
 		wl->tx_frames[i] = NULL;

