Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:56234 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab0ITJDF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 05:03:05 -0400
From: Gery Kahn <geryk@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH] Add 802.11a support configuration
Date: Mon, 20 Sep 2010 11:02:56 +0200
Message-Id: <1284973376-9396-1-git-send-email-geryk@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds ability to configure 802.11a support on wl1271.

The code is not tested enough, this is why marked as EXPERIMENTAL.


Signed-off-by: Gery Kahn <geryk@ti.com>
---
 drivers/net/wireless/wl12xx/Kconfig       |    7 +++++++
 drivers/net/wireless/wl12xx/wl1271.h      |    7 +------
 drivers/net/wireless/wl12xx/wl1271_main.c |    8 ++------
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 4a8bb25..7f62a6f 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -52,6 +52,13 @@ config WL1271
 	  If you choose to build a module, it'll be called wl1271. Say N if
 	  unsure.
 
+config WL1271_80211A
+        bool "TI wl1271 802.11a support (EXPERIMENTAL)"
+        depends on WL1271 && EXPERIMENTAL
+        default n
+        ---help---
+          This will enable 802.11a support for TI wl1271 chipset.
+
 config WL1271_SPI
 	tristate "TI wl1271 SPI support"
 	depends on WL1271 && SPI_MASTER
diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 4134f44..a22769a 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -117,11 +117,6 @@ enum {
 #define WL1271_TX_SECURITY_LO16(s) ((u16)((s) & 0xffff))
 #define WL1271_TX_SECURITY_HI32(s) ((u32)(((s) >> 16) & 0xffffffff))
 
-/*
- * Enable/disable 802.11a support for WL1273
- */
-#undef WL1271_80211A_ENABLED
-
 #define WL1271_BUSY_WORD_CNT 1
 #define WL1271_BUSY_WORD_LEN (WL1271_BUSY_WORD_CNT * sizeof(u32))
 
@@ -501,7 +496,7 @@ int wl1271_plt_stop(struct wl1271 *wl);
 static inline bool wl1271_11a_enabled(void)
 {
 	/* FIXME: this could be determined based on the NVS-INI file */
-#ifdef WL1271_80211A_ENABLED
+#ifdef CONFIG_WL1271_80211A
 	return true;
 #else
 	return false;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index af26150..783bf7b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -568,8 +568,7 @@ static int wl1271_fetch_nvs(struct wl1271 *wl)
 	 * around.
 	 */
 	if (fw->size != sizeof(struct wl1271_nvs_file) &&
-	    (fw->size != WL1271_INI_LEGACY_NVS_FILE_SIZE ||
-	     wl1271_11a_enabled())) {
+	    (fw->size != WL1271_INI_LEGACY_NVS_FILE_SIZE)) {
 		wl1271_error("nvs size is not as expected: %zu != %zu",
 			     fw->size, sizeof(struct wl1271_nvs_file));
 		ret = -EILSEQ;
@@ -1559,10 +1558,7 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-	if (wl1271_11a_enabled())
-		ret = wl1271_scan(hw->priv, ssid, len, req);
-	else
-		ret = wl1271_scan(hw->priv, ssid, len, req);
+	ret = wl1271_scan(hw->priv, ssid, len, req);
 
 	wl1271_ps_elp_sleep(wl);
 
-- 
1.7.0.4

