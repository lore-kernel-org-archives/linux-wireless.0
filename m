Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:42347 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbZHZTEL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 15:04:11 -0400
Received: by ewy2 with SMTP id 2so477259ewy.17
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 12:04:12 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Cleanup rt2x00mac_bss_info_changed()
Date: Wed, 26 Aug 2009 21:04:08 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908262104.09230.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since patch "rt2x00: bss_info_changed() callback is allowed to sleep" the
variable delayed wasn't used anymore. This means it can be removed
along with the call to schedule_work which depended on that variable.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index a91f316..929b85f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -582,7 +582,6 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct rt2x00_intf *intf = vif_to_intf(vif);
-	unsigned int delayed = 0;
 	int update_bssid = 0;
 
 	/*
@@ -645,13 +644,6 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 	 */
 	if (changes & ~(BSS_CHANGED_ASSOC | BSS_CHANGED_HT))
 		rt2x00lib_config_erp(rt2x00dev, intf, bss_conf);
-
-	spin_lock(&intf->lock);
-	if (delayed) {
-		intf->delayed_flags |= delayed;
-		schedule_work(&rt2x00dev->intf_work);
-	}
-	spin_unlock(&intf->lock);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_bss_info_changed);
 


