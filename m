Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:53675 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429AbZHGKe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 06:34:58 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 14/23] wl1251: initialise default channel to zero
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Aug 2009 13:34:27 +0300
Message-ID: <20090807103426.31717.54343.stgit@tikku>
In-Reply-To: <20090807102732.31717.84006.stgit@tikku>
References: <20090807102732.31717.84006.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Because wl->channel was initialised to one, the first join command in
wl1251_op_config() always failed.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251.h      |    2 ++
 drivers/net/wireless/wl12xx/wl1251_main.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251.h b/drivers/net/wireless/wl12xx/wl1251.h
index 86d2abe..998e4b6 100644
--- a/drivers/net/wireless/wl12xx/wl1251.h
+++ b/drivers/net/wireless/wl12xx/wl1251.h
@@ -398,6 +398,8 @@ void wl1251_disable_interrupts(struct wl1251 *wl);
 #define WL1251_DEFAULT_BEACON_INT 100
 #define WL1251_DEFAULT_DTIM_PERIOD 1
 
+#define WL1251_DEFAULT_CHANNEL 0
+
 #define CHIP_ID_1251_PG10	           (0x7010101)
 #define CHIP_ID_1251_PG11	           (0x7020101)
 #define CHIP_ID_1251_PG12	           (0x7030101)
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index d031692..2514c94 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -461,6 +461,7 @@ static void wl1251_op_stop(struct ieee80211_hw *hw)
 	wl->psm = 0;
 	wl->tx_queue_stopped = false;
 	wl->power_level = WL1251_DEFAULT_POWER_LEVEL;
+	wl->channel = WL1251_DEFAULT_CHANNEL;
 
 	wl1251_debugfs_reset(wl);
 
@@ -1302,7 +1303,6 @@ out:
 }
 EXPORT_SYMBOL_GPL(wl1251_init_ieee80211);
 
-#define WL1251_DEFAULT_CHANNEL 1
 struct ieee80211_hw *wl1251_alloc_hw(void)
 {
 	struct ieee80211_hw *hw;

