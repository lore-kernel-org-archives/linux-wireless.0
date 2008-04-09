Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:63074 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbYDISme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 14:42:34 -0400
Received: by nf-out-0910.google.com with SMTP id g13so1240239nfb.21
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2008 11:42:32 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: rt2x00: Only free skb when beacon_update fails
Date: Wed, 9 Apr 2008 20:46:27 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804092046.28984.IvDoorn@gmail.com> (sfid-20080409_194241_166696_4B8CC27F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In rt2x00lib_intf_scheduled_iter() we use the hw->beacon_update()
callback function. This means that it should behave similarly as mac80211
when that uses the function.

This means that the skb should only be freed when beacon_update() has failed,
otherwise the driver is the owner and is responsible for freeing the buffer.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 0361524..f8fe7a1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -433,11 +433,9 @@ static void rt2x00lib_intf_scheduled_iter(void *data, u8 *mac,
 
 	if (delayed_flags & DELAYED_UPDATE_BEACON) {
 		skb = ieee80211_beacon_get(rt2x00dev->hw, vif, &control);
-		if (skb) {
-			rt2x00dev->ops->hw->beacon_update(rt2x00dev->hw, skb,
-							  &control);
+		if (skb && rt2x00dev->ops->hw->beacon_update(rt2x00dev->hw,
+							     skb, &control))
 			dev_kfree_skb(skb);
-		}
 	}
 
 	if (delayed_flags & DELAYED_CONFIG_ERP)
