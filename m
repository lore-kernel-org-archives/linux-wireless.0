Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:30801 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460AbYAFWmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jan 2008 17:42:54 -0500
Received: by ug-out-1314.google.com with SMTP id z38so3071365ugc.16
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jan 2008 14:42:54 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/12] rt2x00: Determine MY_BSS from descriptor
Date: Sun, 6 Jan 2008 23:41:28 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200801062337.35904.IvDoorn@gmail.com>
In-Reply-To: <200801062337.35904.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801062341.28145.IvDoorn@gmail.com> (sfid-20080106_224259_958709_80A3B7D2)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the MY_BSS descriptor field to determine if the
received frame belongs to the same BSS as the interface.
This can be used by rxdone to determine if the frame
should be updated or not.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c  |    1 +
 drivers/net/wireless/rt2x00/rt2500pci.c  |    1 +
 drivers/net/wireless/rt2x00/rt2500usb.c  |    3 +--
 drivers/net/wireless/rt2x00/rt2x00dev.c  |   18 +++++-------------
 drivers/net/wireless/rt2x00/rt2x00ring.h |    1 +
 drivers/net/wireless/rt2x00/rt61pci.c    |    3 +--
 drivers/net/wireless/rt2x00/rt73usb.c    |    3 +--
 7 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index ffc7e20..95db2cc 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1117,6 +1117,7 @@ static void rt2400pci_fill_rxdone(struct data_entry *entry,
 	    entry->ring->rt2x00dev->rssi_offset;
 	desc->ofdm = 0;
 	desc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
+	desc->my_bss = !!rt2x00_get_field32(word0, RXD_W0_MY_BSS);
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 81a48e8..133967e 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1264,6 +1264,7 @@ static void rt2500pci_fill_rxdone(struct data_entry *entry,
 	    entry->ring->rt2x00dev->rssi_offset;
 	desc->ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
 	desc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
+	desc->my_bss = !!rt2x00_get_field32(word0, RXD_W0_MY_BSS);
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index f136703..2a4e939 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1138,8 +1138,7 @@ static void rt2500usb_fill_rxdone(struct data_entry *entry,
 	    entry->ring->rt2x00dev->rssi_offset;
 	desc->ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
 	desc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
-
-	return;
+	desc->my_bss = !!rt2x00_get_field32(word0, RXD_W0_MY_BSS);
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index a95cf53..a114212 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -526,7 +526,6 @@ void rt2x00lib_rxdone(struct data_entry *entry, struct sk_buff *skb,
 		      struct rxdata_entry_desc *desc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->ring->rt2x00dev;
-	struct interface *intf = &rt2x00dev->interface;
 	struct ieee80211_rx_status *rx_status = &rt2x00dev->rx_status;
 	struct ieee80211_hw_mode *mode;
 	struct ieee80211_rate *rate;
@@ -559,19 +558,12 @@ void rt2x00lib_rxdone(struct data_entry *entry, struct sk_buff *skb,
 	}
 
 	/*
-	 * Only update link status if this is a beacon frame carrying our
-	 * bssid.
+	 * Only update link status if this is a beacon frame carrying our bssid.
 	 */
-	hdr = (struct ieee80211_hdr *) skb->data;
-	if (skb->len >= sizeof(struct ieee80211_hdr *)) {
-		fc = le16_to_cpu(hdr->frame_control);
-		if ((intf->type == IEEE80211_IF_TYPE_STA
-		     || intf->type == IEEE80211_IF_TYPE_IBSS)
-		    && is_beacon(fc)
-		    && compare_ether_addr(hdr->addr3, intf->bssid) == 0)
-			rt2x00lib_update_link_stats(&rt2x00dev->link,
-						    desc->rssi);
-	}
+	hdr = (struct ieee80211_hdr*)skb->data;
+	fc = le16_to_cpu(hdr->frame_control);
+	if (is_beacon(fc) && desc->my_bss)
+		rt2x00lib_update_link_stats(&rt2x00dev->link, desc->rssi);
 
 	rt2x00dev->link.qual.rx_success++;
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00ring.h b/drivers/net/wireless/rt2x00/rt2x00ring.h
index e9a5648..1caa6d6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00ring.h
+++ b/drivers/net/wireless/rt2x00/rt2x00ring.h
@@ -59,6 +59,7 @@ struct rxdata_entry_desc {
 	int ofdm;
 	int size;
 	int flags;
+	int my_bss;
 };
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 3080984..47b7430 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1695,8 +1695,7 @@ static void rt61pci_fill_rxdone(struct data_entry *entry,
 	desc->rssi = rt61pci_agc_to_rssi(entry->ring->rt2x00dev, word1);
 	desc->ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
 	desc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
-
-	return;
+	desc->my_bss = !!rt2x00_get_field32(word0, RXD_W0_MY_BSS);
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 2982470..beaa264 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1396,13 +1396,12 @@ static void rt73usb_fill_rxdone(struct data_entry *entry,
 	desc->rssi = rt73usb_agc_to_rssi(entry->ring->rt2x00dev, word1);
 	desc->ofdm = rt2x00_get_field32(word0, RXD_W0_OFDM);
 	desc->size = rt2x00_get_field32(word0, RXD_W0_DATABYTE_COUNT);
+	desc->my_bss = !!rt2x00_get_field32(word0, RXD_W0_MY_BSS);
 
 	/*
 	 * Pull the skb to clear the descriptor area.
 	 */
 	skb_pull(entry->skb, entry->ring->desc_size);
-
-	return;
 }
 
 /*
-- 
1.5.3.7

