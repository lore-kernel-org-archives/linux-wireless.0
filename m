Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:54683 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbXK0Tj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 14:39:57 -0500
Received: by nf-out-0910.google.com with SMTP id g13so1085881nfb
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 11:39:54 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Only update rssi average approximation on receiving beacon frames.
Date: Tue, 27 Nov 2007 21:50:26 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200711272146.53518.IvDoorn@gmail.com>
In-Reply-To: <200711272146.53518.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711272150.26860.IvDoorn@gmail.com> (sfid-20071127_194249_296091_6B038CAF)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mattias Nissler <mattias.nissler@gmx.de>

Restrict rssi average updating to beacon frames of the bssid the
interface is
associated with. Without this restriction, strong signals belonging to other
BSS, e.g. beacon frames coming from a nearby AP, would cause incorrectly high
rssi approximation values. This would then cause the link tuner to reduce
sensitivity, resulting in transmissions from the BSS associated to to be
missed.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    7 +++++++
 drivers/net/wireless/rt2x00/rt2x00dev.c |   19 ++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 103a122..218068b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -32,6 +32,7 @@
 #include <linux/workqueue.h>
 #include <linux/firmware.h>
 #include <linux/mutex.h>
+#include <linux/etherdevice.h>
 
 #include <net/mac80211.h>
 
@@ -149,6 +150,12 @@ static inline int is_probe_resp(u16 fc)
 		((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PROBE_RESP));
 }
 
+static inline int is_beacon(u16 fc)
+{
+	return (((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT) &&
+		((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON));
+}
+
 /*
  * Chipset identification
  * The chipset on the device is composed of a RT and RF chip.
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index bd7b738..a771a09 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -526,11 +526,14 @@ void rt2x00lib_rxdone(struct data_entry *entry, struct sk_buff *skb,
 		      struct rxdata_entry_desc *desc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->ring->rt2x00dev;
+	struct interface *intf = &rt2x00dev->interface;
 	struct ieee80211_rx_status *rx_status = &rt2x00dev->rx_status;
 	struct ieee80211_hw_mode *mode;
 	struct ieee80211_rate *rate;
+	struct ieee80211_hdr *hdr;
 	unsigned int i;
 	int val = 0;
+	u16 fc;
 
 	/*
 	 * Update RX statistics.
@@ -555,7 +558,21 @@ void rt2x00lib_rxdone(struct data_entry *entry, struct sk_buff *skb,
 		}
 	}
 
-	rt2x00lib_update_link_stats(&rt2x00dev->link, desc->rssi);
+	/*
+	 * Only update link status if this is a beacon frame carrying our
+	 * bssid.
+	 */
+	hdr = (struct ieee80211_hdr *) skb->data;
+	if (skb->len >= sizeof(struct ieee80211_hdr *)) {
+		fc = le16_to_cpu(hdr->frame_control);
+		if ((intf->type == IEEE80211_IF_TYPE_STA
+		     || intf->type == IEEE80211_IF_TYPE_IBSS)
+		    && is_beacon(fc)
+		    && compare_ether_addr(hdr->addr3, intf->bssid) == 0)
+			rt2x00lib_update_link_stats(&rt2x00dev->link,
+						    desc->rssi);
+	}
+
 	rt2x00dev->link.qual.rx_success++;
 
 	rx_status->rate = val;
-- 
1.5.3.6

