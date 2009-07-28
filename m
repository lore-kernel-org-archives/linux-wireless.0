Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:40597 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbZG1Q64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 12:58:56 -0400
Received: by ewy26 with SMTP id 26so186642ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2009 09:58:56 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>,
	Ken Lewis <kennylewis@gmail.com>
Subject: [PATCH] rt2x00: Fix build error when crypto support is disabled
Date: Tue, 28 Jul 2009 18:58:54 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200907281858.54519.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When only rt2400pci or rt2500pci is compiled without any of the other
rt2x00 modules, then CONFIG_RT2X00_LIB_CRYPTO will not be enabled.

However rt2x00mac_set_tim() implemented within #ifdef CONFIG_RT2X00_LIB_CRYPTO 
statements while the declaration is placed outside the definition. This results in linking
errors as reporte by Ken.

rt2x00_set_tim() has nothing to do with crypto, and thus should be moved outside
of the #ifdef statements.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 7de1a2c..e92c8f9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -435,6 +435,16 @@ void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_configure_filter);
 
+int rt2x00mac_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+		      bool set)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+
+	rt2x00lib_beacondone(rt2x00dev);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2x00mac_set_tim);
+
 #ifdef CONFIG_RT2X00_LIB_CRYPTO
 static void memcpy_tkip(struct rt2x00lib_crypto *crypto, u8 *key, u8 key_len)
 {
@@ -454,16 +464,6 @@ static void memcpy_tkip(struct rt2x00lib_crypto *crypto, u8 *key, u8 key_len)
 		       sizeof(crypto->rx_mic));
 }
 
-int rt2x00mac_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
-		      bool set)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-
-	rt2x00lib_beacondone(rt2x00dev);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(rt2x00mac_set_tim);
-
 int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		      struct ieee80211_vif *vif, struct ieee80211_sta *sta,
 		      struct ieee80211_key_conf *key)
