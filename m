Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54982 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab1JJINQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:13:16 -0400
Received: by mail-wy0-f174.google.com with SMTP id 34so5615227wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:13:15 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 23/29] wl12xx: add power_level field to wlvif
Date: Mon, 10 Oct 2011 10:13:11 +0200
Message-Id: <1318234397-21081-24-git-send-email-eliad@wizery.com> (sfid-20111010_101322_078322_84586150)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move power_level into the per-interface data.

mac80211 configures some values (e.g. band, channel)
globally, while we configure them per-interface.

In order to make it easier to keep track of the
configured value for each value while keeping sync
with mac80211, save these values both globally
and per-vif.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/init.c   |    2 +-
 drivers/net/wireless/wl12xx/main.c   |    4 +++-
 drivers/net/wireless/wl12xx/wl12xx.h |    3 +++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index e596f5c..42a696b 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -554,7 +554,7 @@ static int wl12xx_init_ap_role(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		return ret;
 
 	/* initialize Tx power */
-	ret = wl1271_acx_tx_power(wl, wlvif, wl->power_level);
+	ret = wl1271_acx_tx_power(wl, wlvif, wlvif->power_level);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 0536808..c8b5290 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1974,6 +1974,7 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 	 */
 	wlvif->band = wl->band;
 	wlvif->channel = wl->channel;
+	wlvif->power_level = wl->power_level;
 
 	INIT_WORK(&wlvif->rx_streaming_enable_work,
 		  wl1271_rx_streaming_enable_work);
@@ -2552,12 +2553,13 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 						 wlvif->basic_rate, true);
 	}
 
-	if (conf->power_level != wl->power_level) {
+	if (conf->power_level != wlvif->power_level) {
 		ret = wl1271_acx_tx_power(wl, wlvif, conf->power_level);
 		if (ret < 0)
 			goto out_sleep;
 
 		wl->power_level = conf->power_level;
+		wlvif->power_level = conf->power_level;
 	}
 
 out_sleep:
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 16e1022..0f1dfd2 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -629,6 +629,9 @@ struct wl12xx_vif {
 	/* retry counter for PSM entries */
 	u8 psm_entry_retry;
 
+	/* in dBm */
+	int power_level;
+
 	int rssi_thold;
 	int last_rssi_event;
 
-- 
1.7.6.401.g6a319

