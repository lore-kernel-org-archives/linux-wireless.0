Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:58394 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab0EXISd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 04:18:33 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 2/6] wl1271: Idle handling into own function
Date: Mon, 24 May 2010 11:18:16 +0300
Message-Id: <1274689100-14785-3-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1274689100-14785-1-git-send-email-luciano.coelho@nokia.com>
References: <1274689100-14785-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

As there is more and more stuff triggered by going in and out of idle,
create a separate function for handling that.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    1 +
 drivers/net/wireless/wl12xx/wl1271_main.c |   60 +++++++++++++++++++----------
 2 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 6f1b6b5..973b742 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -375,6 +375,7 @@ struct wl1271 {
 #define WL1271_FLAG_IRQ_PENDING        (9)
 #define WL1271_FLAG_IRQ_RUNNING       (10)
 #define WL1271_FLAG_IDLE              (11)
+#define WL1271_FLAG_IDLE_REQUESTED    (12)
 	unsigned long flags;
 
 	struct wl1271_partition_set part;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 1407cdb..7404aa6 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1128,11 +1128,6 @@ static int wl1271_dummy_join(struct wl1271 *wl)
 
 	memcpy(wl->bssid, dummy_bssid, ETH_ALEN);
 
-	/* increment the session counter */
-	wl->session_counter++;
-	if (wl->session_counter >= SESSION_COUNTER_MAX)
-		wl->session_counter = 0;
-
 	/* pass through frames from all BSS */
 	wl1271_configure_filters(wl, FIF_OTHER_BSS);
 
@@ -1246,6 +1241,42 @@ static u32 wl1271_min_rate_get(struct wl1271 *wl)
 	return rate;
 }
 
+static int wl1271_handle_idle(struct wl1271 *wl, bool idle)
+{
+	int ret;
+
+	if (idle) {
+		if (test_bit(WL1271_FLAG_JOINED, &wl->flags)) {
+			ret = wl1271_unjoin(wl);
+			if (ret < 0)
+				goto out;
+		}
+		wl->rate_set = wl1271_min_rate_get(wl);
+		wl->sta_rate_set = 0;
+		ret = wl1271_acx_rate_policies(wl);
+		if (ret < 0)
+			goto out;
+		ret = wl1271_acx_keep_alive_config(
+			wl, CMD_TEMPL_KLV_IDX_NULL_DATA,
+			ACX_KEEP_ALIVE_TPL_INVALID);
+		if (ret < 0)
+			goto out;
+		set_bit(WL1271_FLAG_IDLE, &wl->flags);
+	} else {
+		/* increment the session counter */
+		wl->session_counter++;
+		if (wl->session_counter >= SESSION_COUNTER_MAX)
+			wl->session_counter = 0;
+		ret = wl1271_dummy_join(wl);
+		if (ret < 0)
+			goto out;
+		clear_bit(WL1271_FLAG_IDLE, &wl->flags);
+	}
+
+out:
+	return ret;
+}
+
 static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct wl1271 *wl = hw->priv;
@@ -1300,22 +1331,9 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
-		if (conf->flags & IEEE80211_CONF_IDLE &&
-		    test_bit(WL1271_FLAG_JOINED, &wl->flags))
-			wl1271_unjoin(wl);
-		else if (!(conf->flags & IEEE80211_CONF_IDLE))
-			wl1271_dummy_join(wl);
-
-		if (conf->flags & IEEE80211_CONF_IDLE) {
-			wl->rate_set = wl1271_min_rate_get(wl);
-			wl->sta_rate_set = 0;
-			wl1271_acx_rate_policies(wl);
-			wl1271_acx_keep_alive_config(
-				wl, CMD_TEMPL_KLV_IDX_NULL_DATA,
-				ACX_KEEP_ALIVE_TPL_INVALID);
-			set_bit(WL1271_FLAG_IDLE, &wl->flags);
-		} else
-			clear_bit(WL1271_FLAG_IDLE, &wl->flags);
+		ret = wl1271_handle_idle(wl, conf->flags & IEEE80211_CONF_IDLE);
+		if (ret < 0)
+			wl1271_warning("idle mode change failed %d", ret);
 	}
 
 	if (conf->flags & IEEE80211_CONF_PS &&
-- 
1.6.3.3

