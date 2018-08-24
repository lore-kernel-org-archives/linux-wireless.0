Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:55374 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726860AbeHXOt4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:49:56 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 06/17] mt76: unify mac_get_key_info
Date: Fri, 24 Aug 2018 13:15:10 +0200
Message-Id: <1535109321-17126-7-git-send-email-sgruszka@redhat.com> (sfid-20180824_131551_774894_10D7F274)
In-Reply-To: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
References: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Merge mt76x{0,2} mac_get_key_info into new mt76xx_mac.c file.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Makefile        |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    | 30 +-------------
 .../net/wireless/mediatek/mt76/mt76x2_mac_common.c | 30 +-------------
 drivers/net/wireless/mediatek/mt76/mt76xx_mac.c    | 46 ++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76xx_mac.h    |  3 ++
 5 files changed, 54 insertions(+), 57 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76xx_mac.c

diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 4acf10a9916c..bc4ab7057b28 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -14,7 +14,7 @@ mt76-usb-y := usb.o usb_trace.o usb_mcu.o
 CFLAGS_trace.o := -I$(src)
 CFLAGS_usb_trace.o := -I$(src)
 
-mt76xx-lib-y := mt76xx_util.o
+mt76xx-lib-y := mt76xx_util.o mt76xx_mac.o
 
 mt76x2-common-y := \
 	mt76x2_eeprom.o mt76x2_tx_common.o mt76x2_mac_common.o \
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 4f2c8e121c27..282796b24acb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -566,32 +566,6 @@ u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
 	return len;
 }
 
-static enum mt76xx_cipher_type
-mt76_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data)
-{
-	memset(key_data, 0, 32);
-	if (!key)
-		return MT_CIPHER_NONE;
-
-	if (key->keylen > 32)
-		return MT_CIPHER_NONE;
-
-	memcpy(key_data, key->key, key->keylen);
-
-	switch (key->cipher) {
-	case WLAN_CIPHER_SUITE_WEP40:
-		return MT_CIPHER_WEP40;
-	case WLAN_CIPHER_SUITE_WEP104:
-		return MT_CIPHER_WEP104;
-	case WLAN_CIPHER_SUITE_TKIP:
-		return MT_CIPHER_TKIP;
-	case WLAN_CIPHER_SUITE_CCMP:
-		return MT_CIPHER_AES_CCMP;
-	default:
-		return MT_CIPHER_NONE;
-	}
-}
-
 int mt76x0_mac_wcid_set_key(struct mt76x0_dev *dev, u8 idx,
 			  struct ieee80211_key_conf *key)
 {
@@ -600,7 +574,7 @@ int mt76x0_mac_wcid_set_key(struct mt76x0_dev *dev, u8 idx,
 	u8 iv_data[8];
 	u32 val;
 
-	cipher = mt76_mac_get_key_info(key, key_data);
+	cipher = mt76xx_mac_get_key_info(key, key_data);
 	if (cipher == MT_CIPHER_NONE && key)
 		return -EINVAL;
 
@@ -640,7 +614,7 @@ int mt76x0_mac_shared_key_setup(struct mt76x0_dev *dev, u8 vif_idx, u8 key_idx,
 	u8 key_data[32];
 	u32 val;
 
-	cipher = mt76_mac_get_key_info(key, key_data);
+	cipher = mt76xx_mac_get_key_info(key, key_data);
 	if (cipher == MT_CIPHER_NONE && key)
 		return -EINVAL;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
index 247bb4342fe3..706c9b604fc0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
@@ -229,32 +229,6 @@ void mt76x2_send_tx_status(struct mt76x2_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mt76x2_send_tx_status);
 
-static enum mt76xx_cipher_type
-mt76x2_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data)
-{
-	memset(key_data, 0, 32);
-	if (!key)
-		return MT_CIPHER_NONE;
-
-	if (key->keylen > 32)
-		return MT_CIPHER_NONE;
-
-	memcpy(key_data, key->key, key->keylen);
-
-	switch (key->cipher) {
-	case WLAN_CIPHER_SUITE_WEP40:
-		return MT_CIPHER_WEP40;
-	case WLAN_CIPHER_SUITE_WEP104:
-		return MT_CIPHER_WEP104;
-	case WLAN_CIPHER_SUITE_TKIP:
-		return MT_CIPHER_TKIP;
-	case WLAN_CIPHER_SUITE_CCMP:
-		return MT_CIPHER_AES_CCMP;
-	default:
-		return MT_CIPHER_NONE;
-	}
-}
-
 int mt76x2_mac_shared_key_setup(struct mt76x2_dev *dev, u8 vif_idx, u8 key_idx,
 				struct ieee80211_key_conf *key)
 {
@@ -262,7 +236,7 @@ int mt76x2_mac_shared_key_setup(struct mt76x2_dev *dev, u8 vif_idx, u8 key_idx,
 	u8 key_data[32];
 	u32 val;
 
-	cipher = mt76x2_mac_get_key_info(key, key_data);
+	cipher = mt76xx_mac_get_key_info(key, key_data);
 	if (cipher == MT_CIPHER_NONE && key)
 		return -EOPNOTSUPP;
 
@@ -285,7 +259,7 @@ int mt76x2_mac_wcid_set_key(struct mt76x2_dev *dev, u8 idx,
 	u8 key_data[32];
 	u8 iv_data[8];
 
-	cipher = mt76x2_mac_get_key_info(key, key_data);
+	cipher = mt76xx_mac_get_key_info(key, key_data);
 	if (cipher == MT_CIPHER_NONE && key)
 		return -EOPNOTSUPP;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76xx_mac.c b/drivers/net/wireless/mediatek/mt76/mt76xx_mac.c
new file mode 100644
index 000000000000..5b00865c0b81
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76xx_mac.c
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ * Copyright (C) 2018 Stanislaw Gruszka <stf_xl@wp.pl>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "mt76.h"
+#include "mt76xx_regs.h"
+
+enum mt76xx_cipher_type
+mt76xx_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data)
+{
+	memset(key_data, 0, 32);
+	if (!key)
+		return MT_CIPHER_NONE;
+
+	if (key->keylen > 32)
+		return MT_CIPHER_NONE;
+
+	memcpy(key_data, key->key, key->keylen);
+
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+		return MT_CIPHER_WEP40;
+	case WLAN_CIPHER_SUITE_WEP104:
+		return MT_CIPHER_WEP104;
+	case WLAN_CIPHER_SUITE_TKIP:
+		return MT_CIPHER_TKIP;
+	case WLAN_CIPHER_SUITE_CCMP:
+		return MT_CIPHER_AES_CCMP;
+	default:
+		return MT_CIPHER_NONE;
+	}
+}
+EXPORT_SYMBOL_GPL(mt76xx_mac_get_key_info);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76xx_mac.h b/drivers/net/wireless/mediatek/mt76/mt76xx_mac.h
index 177f8770136f..237dd13667d4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76xx_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76xx_mac.h
@@ -39,4 +39,7 @@ static inline bool mt76xx_wait_for_mac(struct mt76_dev *dev)
 	return false;
 }
 
+enum mt76xx_cipher_type
+mt76xx_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data);
+
 #endif
-- 
1.9.3
