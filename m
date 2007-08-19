Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbXHSSai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:30:38 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446922ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:30:37 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/30] rt2x00: Be consistent with unsigned
Date: Sun, 19 Aug 2007 20:24:27 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192024.27274.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From cdc01c652d3b058111e8a2567649e198c7c77cc5 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 13:00:39 +0200
Subject: [PATCH 09/30] rt2x00: Be consistent with unsigned

unsigned should be used consistently,
all values used as flags should be unsigned
and the ring identifier should also be unsigned everywhere.

char is not consistently signed over all platforms,
make the signedness more explicit where it is demanded
so we resolve some warnings of the type:
"warning: comparison is always false due to limited range of data type"

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c |    8 +++++---
 drivers/net/wireless/rt2500pci.c |    8 +++++---
 drivers/net/wireless/rt2500usb.c |    8 +++++---
 drivers/net/wireless/rt2x00.h    |    9 +++++----
 drivers/net/wireless/rt61pci.c   |   14 ++++++++------
 drivers/net/wireless/rt73usb.c   |   14 ++++++++------
 6 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index 8365171..aa1209b 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -278,7 +278,7 @@ static void rt2400pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 }
 
 static void rt2400pci_config_packet_filter(struct rt2x00_dev *rt2x00dev,
-					   const int filter)
+					   const unsigned int filter)
 {
 	int promisc = !!(filter & IFF_PROMISC);
 	u32 reg;
@@ -561,7 +561,8 @@ static void rt2400pci_config_duration(struct rt2x00_dev *rt2x00dev,
 	rt2x00pci_register_write(rt2x00dev, CSR12, reg);
 }
 
-static void rt2400pci_config(struct rt2x00_dev *rt2x00dev, const int flags,
+static void rt2400pci_config(struct rt2x00_dev *rt2x00dev,
+			     const unsigned int flags,
 			     struct ieee80211_conf *conf)
 {
 	int short_slot_time = conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME;
@@ -1177,7 +1178,8 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 /*
  * TX data initialization
  */
-static void rt2400pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev, int queue)
+static void rt2400pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
+				    unsigned int queue)
 {
 	u32 reg;
 
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index a794989..3a1da1f 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -278,7 +278,7 @@ static void rt2500pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 }
 
 static void rt2500pci_config_packet_filter(struct rt2x00_dev *rt2x00dev,
-					   const int filter)
+					   const unsigned int filter)
 {
 	int promisc = !!(filter & IFF_PROMISC);
 	int multicast = !!(filter & IFF_MULTICAST);
@@ -672,7 +672,8 @@ static void rt2500pci_config_duration(struct rt2x00_dev *rt2x00dev,
 	rt2x00pci_register_write(rt2x00dev, CSR12, reg);
 }
 
-static void rt2500pci_config(struct rt2x00_dev *rt2x00dev, const int flags,
+static void rt2500pci_config(struct rt2x00_dev *rt2x00dev,
+			     const unsigned int flags,
 			     struct ieee80211_conf *conf)
 {
 	int short_slot_time = conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME;
@@ -1355,7 +1356,8 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 /*
  * TX data initialization
  */
-static void rt2500pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev, int queue)
+static void rt2500pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
+				    unsigned int queue)
 {
 	u32 reg;
 
diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index 581cc6f..71b7bf2 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -283,7 +283,7 @@ static void rt2500usb_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 }
 
 static void rt2500usb_config_packet_filter(struct rt2x00_dev *rt2x00dev,
-					   const int filter)
+					   const unsigned int filter)
 {
 	int promisc = !!(filter & IFF_PROMISC);
 	int multicast = !!(filter & IFF_MULTICAST);
@@ -625,7 +625,8 @@ static void rt2500usb_config_duration(struct rt2x00_dev *rt2x00dev,
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR18, reg);
 }
 
-static void rt2500usb_config(struct rt2x00_dev *rt2x00dev, const int flags,
+static void rt2500usb_config(struct rt2x00_dev *rt2x00dev,
+			     const unsigned int flags,
 			     struct ieee80211_conf *conf)
 {
 	int short_slot_time = conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME;
@@ -1153,7 +1154,8 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 /*
  * TX data initialization
  */
-static void rt2500usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev, int queue)
+static void rt2500usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
+				    unsigned int queue)
 {
 	u16 reg;
 
diff --git a/drivers/net/wireless/rt2x00.h b/drivers/net/wireless/rt2x00.h
index 0db81eb..5c6d7d0 100644
--- a/drivers/net/wireless/rt2x00.h
+++ b/drivers/net/wireless/rt2x00.h
@@ -310,7 +310,7 @@ struct interface {
 	 * Monitor mode count, the number of interfaces
 	 * in monitor mode that that have been added.
 	 */
-	char monitor_count;
+	unsigned short monitor_count;
 };
 
 static inline int is_interface_present(struct interface *intf)
@@ -396,7 +396,8 @@ struct rt2x00lib_ops {
 	int (*write_tx_data) (struct rt2x00_dev *rt2x00dev,
 			      struct data_ring *ring, struct sk_buff *skb,
 			      struct ieee80211_tx_control *control);
-	void (*kick_tx_queue) (struct rt2x00_dev *rt2x00dev, int queue);
+	void (*kick_tx_queue) (struct rt2x00_dev *rt2x00dev,
+			       unsigned int queue);
 
 	/*
 	 * RX control handlers
@@ -410,9 +411,9 @@ struct rt2x00lib_ops {
 	void (*config_mac_addr) (struct rt2x00_dev *rt2x00dev, u8 *mac);
 	void (*config_bssid) (struct rt2x00_dev *rt2x00dev, u8 *bssid);
 	void (*config_packet_filter) (struct rt2x00_dev *rt2x00dev,
-				      const int filter);
+				      const unsigned int filter);
 	void (*config_type) (struct rt2x00_dev *rt2x00dev, const int type);
-	void (*config) (struct rt2x00_dev *rt2x00dev, const int flags,
+	void (*config) (struct rt2x00_dev *rt2x00dev, const unsigned int flags,
 			struct ieee80211_conf *conf);
 #define CONFIG_UPDATE_PHYMODE		( 1 << 1 )
 #define CONFIG_UPDATE_CHANNEL		( 1 << 2 )
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index edacb46..f592397 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -307,7 +307,7 @@ static void rt61pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 }
 
 static void rt61pci_config_packet_filter(struct rt2x00_dev *rt2x00dev,
-					 const int filter)
+					 const unsigned int filter)
 {
 	int promisc = !!(filter & IFF_PROMISC);
 	int multicast = !!(filter & IFF_MULTICAST);
@@ -846,7 +846,8 @@ static void rt61pci_config_duration(struct rt2x00_dev *rt2x00dev,
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
 }
 
-static void rt61pci_config(struct rt2x00_dev *rt2x00dev, const int flags,
+static void rt61pci_config(struct rt2x00_dev *rt2x00dev,
+			   const unsigned int flags,
 			   struct ieee80211_conf *conf)
 {
 	int short_slot_time = conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME;
@@ -1726,7 +1727,8 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 /*
  * TX data initialization
  */
-static void rt61pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev, int queue)
+static void rt61pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
+				  unsigned int queue)
 {
 	u32 reg;
 
@@ -1759,8 +1761,8 @@ static void rt61pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev, int queue)
 static int rt61pci_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 {
 	u16 eeprom;
-	char offset;
-	char lna;
+	u8 offset;
+	u8 lna;
 
 	lna = rt2x00_get_field32(rxd_w1, RXD_W1_RSSI_LNA);
 	switch (lna) {
@@ -1960,7 +1962,7 @@ static int rt61pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	u32 reg;
 	u16 word;
 	u8 *mac;
-	char value;
+	s8 value;
 
 	rt2x00pci_register_read(rt2x00dev, E2PROM_CSR, &reg);
 
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 74e4173..9f059ce 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -282,7 +282,7 @@ static void rt73usb_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
 }
 
 static void rt73usb_config_packet_filter(struct rt2x00_dev *rt2x00dev,
-					 const int filter)
+					 const unsigned int filter)
 {
 	int promisc = !!(filter & IFF_PROMISC);
 	int multicast = !!(filter & IFF_MULTICAST);
@@ -742,7 +742,8 @@ static void rt73usb_config_duration(struct rt2x00_dev *rt2x00dev,
 	rt73usb_register_write(rt2x00dev, TXRX_CSR9, reg);
 }
 
-static void rt73usb_config(struct rt2x00_dev *rt2x00dev, const int flags,
+static void rt73usb_config(struct rt2x00_dev *rt2x00dev,
+			   const unsigned int flags,
 			   struct ieee80211_conf *conf)
 {
 	int short_slot_time = conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME;
@@ -1370,7 +1371,8 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 /*
  * TX data initialization
  */
-static void rt73usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev, int queue)
+static void rt73usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
+				  unsigned int queue)
 {
 	u32 reg;
 
@@ -1390,8 +1392,8 @@ static void rt73usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev, int queue)
 static int rt73usb_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 {
 	u16 eeprom;
-	char offset;
-	char lna;
+	u8 offset;
+	u8 lna;
 
 	lna = rt2x00_get_field32(rxd_w1, RXD_W1_RSSI_LNA);
 	switch (lna) {
@@ -1469,7 +1471,7 @@ static int rt73usb_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	u16 word;
 	u8 *mac;
-	char value;
+	s8 value;
 
 	rt2x00usb_eeprom_read(rt2x00dev, rt2x00dev->eeprom, EEPROM_SIZE);
 
-- 
1.5.3.rc5

