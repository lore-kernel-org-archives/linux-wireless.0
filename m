Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:44255 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbYFPRol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 13:44:41 -0400
Received: by py-out-1112.google.com with SMTP id p76so2084603pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2008 10:44:40 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/9] rt2x00: Properly clean up beacon skbs.
Date: Mon, 16 Jun 2008 19:55:18 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200806161954.04241.IvDoorn@gmail.com> <200806161954.34838.IvDoorn@gmail.com>
In-Reply-To: <200806161954.34838.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806161955.18775.IvDoorn@gmail.com> (sfid-20080616_194502_147498_EC3DF508)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@kpnplanet.nl>

The skbs containing the beacons weren't properly cleaned up for rt2400pci, rt2500pci,
rt61pci, and rt73usb. Clean up those skbs in the manner appropriate for each driver.

Signed-off-by: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    6 ++++++
 drivers/net/wireless/rt2x00/rt61pci.c   |    6 ++++++
 drivers/net/wireless/rt2x00/rt73usb.c   |    6 ++++++
 3 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index f9e7531..b8e0c4c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -474,6 +474,12 @@ static void rt2x00lib_beacondone_iter(void *data, u8 *mac,
 	    vif->type != IEEE80211_IF_TYPE_IBSS)
 		return;
 
+	/*
+	 * Clean up the beacon skb.
+	 */
+	dev_kfree_skb_irq(intf->beacon->skb);
+	intf->beacon->skb = NULL;
+
 	spin_lock(&intf->lock);
 	intf->delayed_flags |= DELAYED_UPDATE_BEACON;
 	spin_unlock(&intf->lock);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 5b7267e..27f30ae 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2402,6 +2402,12 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 				      skb->data, skb->len);
 	rt61pci_kick_tx_queue(rt2x00dev, QID_BEACON);
 
+	/*
+	 * Clean up beacon skb.
+	 */
+	dev_kfree_skb_any(skb);
+	intf->beacon->skb = NULL;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index fceefd7..42b7e98 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2001,6 +2001,12 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 				 REGISTER_TIMEOUT32(skb->len));
 	rt73usb_kick_tx_queue(rt2x00dev, QID_BEACON);
 
+	/*
+	 * Clean up the beacon skb.
+	 */
+	dev_kfree_skb(skb);
+	intf->beacon->skb = NULL;
+
 	return 0;
 }
 
-- 
1.5.5.4

