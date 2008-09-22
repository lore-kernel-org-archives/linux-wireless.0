Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:47389 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbYIVRkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 13:40:10 -0400
Received: by ug-out-1314.google.com with SMTP id k3so1437232ugf.37
        for <linux-wireless@vger.kernel.org>; Mon, 22 Sep 2008 10:40:08 -0700 (PDT)
To: John W Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Fix HW crypto key handling
Date: Mon, 22 Sep 2008 19:40:04 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	"Stephen Blackheath" <tramp.enshrine.stephen@blacksapphire.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200809221940.04297.IvDoorn@gmail.com> (sfid-20080922_194014_493747_E74A5B00)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a crypto key is being removed, rt2x00mac should not
reset the key->hw_key_idx value because that will prevent
the driver from removing the correct key from the hardware.

Furthermore ffz() starts counting at 0 instead of 1, so we don't
need to substract 1 from the resulting value.

Signed-off-by: Stephen Blackheath <tramp.enshrine.stephen@blacksapphire.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 56829fa..bad7662 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -543,7 +543,8 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	 * provided but key 0 is not, then the key is not found
 	 * by the hardware during RX).
 	 */
-	key->hw_key_idx = 0;
+	if (cmd == SET_KEY)
+		key->hw_key_idx = 0;
 
 	if (key->flags & IEEE80211_KEY_FLAG_PAIRWISE)
 		set_key = rt2x00dev->ops->lib->config_pairwise_key;
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 2c36b91..a461620 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -381,7 +381,7 @@ static int rt61pci_config_shared_key(struct rt2x00_dev *rt2x00dev,
 		if (reg && reg == mask)
 			return -ENOSPC;
 
-		key->hw_key_idx += reg ? (ffz(reg) - 1) : 0;
+		key->hw_key_idx += reg ? ffz(reg) : 0;
 
 		/*
 		 * Upload key to hardware
@@ -477,7 +477,7 @@ static int rt61pci_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 				return -ENOSPC;
 		}
 
-		key->hw_key_idx += reg ? (ffz(reg) - 1) : 0;
+		key->hw_key_idx += reg ? ffz(reg) : 0;
 
 		/*
 		 * Upload key to hardware
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 27dde3e..934f8e0 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -393,7 +393,7 @@ static int rt73usb_config_shared_key(struct rt2x00_dev *rt2x00dev,
 		if (reg && reg == mask)
 			return -ENOSPC;
 
-		key->hw_key_idx += reg ? (ffz(reg) - 1) : 0;
+		key->hw_key_idx += reg ? ffz(reg) : 0;
 
 		/*
 		 * Upload key to hardware
@@ -494,7 +494,7 @@ static int rt73usb_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 				return -ENOSPC;
 		}
 
-		key->hw_key_idx += reg ? (ffz(reg) - 1) : 0;
+		key->hw_key_idx += reg ? ffz(reg) : 0;
 
 		/*
 		 * Upload key to hardware
