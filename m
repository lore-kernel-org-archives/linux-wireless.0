Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:29366 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab0I0KmQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 06:42:16 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8RAgEJi008348
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 05:42:15 -0500
From: juuso.oikarinen@nokia.com
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv2] wl1271: Add support for hardware GEM cipher
Date: Mon, 27 Sep 2010 13:42:07 +0300
Message-Id: <1285584127-19854-1-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1285581677.5768.70.camel@chilepepper>
References: <1285581677.5768.70.camel@chilepepper>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch adds support for the hardware GEM cipher suite.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    2 ++
 drivers/net/wireless/wl12xx/wl1271_cmd.h  |    2 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |   16 ++++++++++++++++
 3 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 763ece8..22e850f 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -117,6 +117,8 @@ enum {
 #define WL1271_TX_SECURITY_LO16(s) ((u16)((s) & 0xffff))
 #define WL1271_TX_SECURITY_HI32(s) ((u32)(((s) >> 16) & 0xffffffff))
 
+#define WL1271_CIPHER_SUITE_GEM 0x00147201
+
 #define WL1271_BUSY_WORD_CNT 1
 #define WL1271_BUSY_WORD_LEN (WL1271_BUSY_WORD_CNT * sizeof(u32))
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index ff8e35e..33b946b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -279,7 +279,7 @@ enum wl1271_cmd_key_type {
 	KEY_WEP  = 1,
 	KEY_TKIP = 2,
 	KEY_AES  = 3,
-	KEY_GEM  = 4
+	KEY_GEM  = 4,
 };
 
 /* FIXME: Add description for key-types */
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index f0c2532..39b5985 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1528,6 +1528,11 @@ static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		tx_seq_32 = WL1271_TX_SECURITY_HI32(wl->tx_security_seq);
 		tx_seq_16 = WL1271_TX_SECURITY_LO16(wl->tx_security_seq);
 		break;
+	case WL1271_CIPHER_SUITE_GEM:
+		key_type = KEY_GEM;
+		tx_seq_32 = WL1271_TX_SECURITY_HI32(wl->tx_security_seq);
+		tx_seq_16 = WL1271_TX_SECURITY_LO16(wl->tx_security_seq);
+		break;
 	default:
 		wl1271_error("Unknown key algo 0x%x", key_conf->cipher);
 
@@ -2382,6 +2387,14 @@ EXPORT_SYMBOL_GPL(wl1271_unregister_hw);
 
 int wl1271_init_ieee80211(struct wl1271 *wl)
 {
+	static const u32 cipher_suites[] = {
+		WLAN_CIPHER_SUITE_WEP40,
+		WLAN_CIPHER_SUITE_WEP104,
+		WLAN_CIPHER_SUITE_TKIP,
+		WLAN_CIPHER_SUITE_CCMP,
+		WL1271_CIPHER_SUITE_GEM,
+	};
+
 	/* The tx descriptor buffer and the TKIP space. */
 	wl->hw->extra_tx_headroom = WL1271_TKIP_IV_SPACE +
 		sizeof(struct wl1271_tx_hw_descr);
@@ -2399,6 +2412,9 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 		IEEE80211_HW_CONNECTION_MONITOR |
 		IEEE80211_HW_SUPPORTS_CQM_RSSI;
 
+	wl->hw->wiphy->cipher_suites = cipher_suites;
+	wl->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
+
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
 	wl->hw->wiphy->max_scan_ssids = 1;
-- 
1.6.3.3

