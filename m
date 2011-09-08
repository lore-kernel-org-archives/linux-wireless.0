Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38572 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab1IHMj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 08:39:27 -0400
Received: by ewy4 with SMTP id 4so268175ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2011 05:39:26 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/7] rt2x00: Move bssidx calculation into its own function
Date: Thu, 8 Sep 2011 14:34:22 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201109081434.23635.IvDoorn@gmail.com> (sfid-20110908_143930_714252_6BB9132E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

This will be used by a later patch. No functional changes.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    6 ++++++
 drivers/net/wireless/rt2x00/rt2x00dev.c |   16 ++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00mac.c |   10 +---------
 3 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index a15eec6..bacb533 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1240,6 +1240,12 @@ static inline void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
 
 /*
+ * Utility functions.
+ */
+u32 rt2x00lib_get_bssidx(struct rt2x00_dev *rt2x00dev,
+			 struct ieee80211_vif *vif);
+
+/*
  * Interrupt context handlers.
  */
 void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 8374eb3..4db0ebe 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -33,6 +33,22 @@
 #include "rt2x00lib.h"
 
 /*
+ * Utility functions.
+ */
+u32 rt2x00lib_get_bssidx(struct rt2x00_dev *rt2x00dev,
+			 struct ieee80211_vif *vif)
+{
+	/*
+	 * When in STA mode, bssidx is always 0 otherwise local_address[5]
+	 * contains the bss number, see BSS_ID_MASK comments for details.
+	 */
+	if (rt2x00dev->intf_sta_count)
+		return 0;
+	return vif->addr[5] & (rt2x00dev->ops->max_ap_intf - 1);
+}
+EXPORT_SYMBOL_GPL(rt2x00lib_get_bssidx);
+
+/*
  * Radio control handlers.
  */
 int rt2x00lib_enable_radio(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index a9123d4..4cf1848 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -504,15 +504,7 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	memset(&crypto, 0, sizeof(crypto));
 
-	/*
-	 * When in STA mode, bssidx is always 0 otherwise local_address[5]
-	 * contains the bss number, see BSS_ID_MASK comments for details.
-	 */
-	if (rt2x00dev->intf_sta_count)
-		crypto.bssidx = 0;
-	else
-		crypto.bssidx = vif->addr[5] & (rt2x00dev->ops->max_ap_intf - 1);
-
+	crypto.bssidx = rt2x00lib_get_bssidx(rt2x00dev, vif);
 	crypto.cipher = rt2x00crypto_key_to_cipher(key);
 	if (crypto.cipher == CIPHER_NONE)
 		return -EOPNOTSUPP;
-- 
1.7.3.4
