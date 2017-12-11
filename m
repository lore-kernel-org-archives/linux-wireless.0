Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:57205 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752566AbdLKLrf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 06:47:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "Reizer, Eyal" <eyalr@ti.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Iain Hunter <drhunter95@gmail.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Kees Cook <keescook@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wlcore: fix unused function warning
Date: Mon, 11 Dec 2017 12:46:29 +0100
Message-Id: <20171211114718.3637010-1-arnd@arndb.de> (sfid-20171211_124740_379480_3261BC61)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The newly added wlcore_fw_sleep function is called conditionally,
which causes a warning without CONFIG_PM:

drivers/net/wireless/ti/wlcore/main.c:981:12: error: 'wlcore_fw_sleep' defined but not used [-Werror=unused-function]

Instead of trying to keep track of what should be in the #ifdef and what
should not, it's easier to mark the top-level suspend/resume functions
as __maybe_unused so the compiler can silently drop all the unused code.

Fixes: 37bf241b8e7b ("wlcore: allow elp during wowlan suspend")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ti/wlcore/acx.h  | 2 --
 drivers/net/wireless/ti/wlcore/main.c | 8 +++-----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/acx.h b/drivers/net/wireless/ti/wlcore/acx.h
index f46d7fdf9a00..7011c5d9599f 100644
--- a/drivers/net/wireless/ti/wlcore/acx.h
+++ b/drivers/net/wireless/ti/wlcore/acx.h
@@ -1129,10 +1129,8 @@ int wl12xx_acx_config_hangover(struct wl1271 *wl);
 int wlcore_acx_average_rssi(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			    s8 *avg_rssi);
 
-#ifdef CONFIG_PM
 int wl1271_acx_default_rx_filter_enable(struct wl1271 *wl, bool enable,
 					enum rx_filter_action action);
 int wl1271_acx_set_rx_filter(struct wl1271 *wl, u8 index, bool enable,
 			     struct wl12xx_rx_filter *filter);
-#endif /* CONFIG_PM */
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 6ce457022dc9..09714034dbf1 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1343,7 +1343,6 @@ static struct sk_buff *wl12xx_alloc_dummy_packet(struct wl1271 *wl)
 }
 
 
-#ifdef CONFIG_PM
 static int
 wl1271_validate_wowlan_pattern(struct cfg80211_pkt_pattern *p)
 {
@@ -1715,8 +1714,8 @@ static void wl1271_configure_resume(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	}
 }
 
-static int wl1271_op_suspend(struct ieee80211_hw *hw,
-			    struct cfg80211_wowlan *wow)
+static int __maybe_unused wl1271_op_suspend(struct ieee80211_hw *hw,
+					    struct cfg80211_wowlan *wow)
 {
 	struct wl1271 *wl = hw->priv;
 	struct wl12xx_vif *wlvif;
@@ -1810,7 +1809,7 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static int wl1271_op_resume(struct ieee80211_hw *hw)
+static int __maybe_unused wl1271_op_resume(struct ieee80211_hw *hw)
 {
 	struct wl1271 *wl = hw->priv;
 	struct wl12xx_vif *wlvif;
@@ -1894,7 +1893,6 @@ static int wl1271_op_resume(struct ieee80211_hw *hw)
 
 	return 0;
 }
-#endif
 
 static int wl1271_op_start(struct ieee80211_hw *hw)
 {
-- 
2.9.0
