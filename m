Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64201 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab0L0OIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Dec 2010 09:08:14 -0500
Received: by mail-ww0-f44.google.com with SMTP id 36so9024113wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Dec 2010 06:08:13 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/10] rt2x00: remove intf->mac field.
Date: Mon, 27 Dec 2010 15:05:35 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201012271504.30848.IvDoorn@gmail.com> <201012271504.55450.IvDoorn@gmail.com> <201012271505.15849.IvDoorn@gmail.com>
In-Reply-To: <201012271505.15849.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012271505.36104.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

The mac field of the rt2x00_intf structure is written to once and used
twice. In both these uses the mac address is available via other means.

Remove this field as it does not appear to be necessary.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    5 -----
 drivers/net/wireless/rt2x00/rt2x00mac.c |    6 ++----
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 5f7f52f..755b723 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -360,11 +360,6 @@ struct rt2x00_intf {
 	spinlock_t lock;
 
 	/*
-	 * MAC of the device.
-	 */
-	u8 mac[ETH_ALEN];
-
-	/*
 	 * beacon->skb must be protected with the mutex.
 	 */
 	struct mutex beacon_skb_mutex;
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 23250a5..f8775c4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -282,9 +282,8 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	 * STA interfaces at this time, since this can cause
 	 * invalid behavior in the device.
 	 */
-	memcpy(&intf->mac, vif->addr, ETH_ALEN);
 	rt2x00lib_config_intf(rt2x00dev, intf, vif->type,
-			      intf->mac, NULL);
+			      vif->addr, NULL);
 
 	/*
 	 * Some filters depend on the current working mode. We can force
@@ -492,7 +491,6 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		      struct ieee80211_key_conf *key)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct rt2x00_intf *intf = vif_to_intf(vif);
 	int (*set_key) (struct rt2x00_dev *rt2x00dev,
 			struct rt2x00lib_crypto *crypto,
 			struct ieee80211_key_conf *key);
@@ -516,7 +514,7 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	if (rt2x00dev->intf_sta_count)
 		crypto.bssidx = 0;
 	else
-		crypto.bssidx = intf->mac[5] & (rt2x00dev->ops->max_ap_intf - 1);
+		crypto.bssidx = vif->addr[5] & (rt2x00dev->ops->max_ap_intf - 1);
 
 	crypto.cipher = rt2x00crypto_key_to_cipher(key);
 	if (crypto.cipher == CIPHER_NONE)
-- 
1.7.2.3

