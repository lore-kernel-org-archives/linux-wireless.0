Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:53844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbYCIVu4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:50:56 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1676623fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:50:55 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 09/24] rt2x00: Only disable beaconing just before beacon update
Date: Sun, 9 Mar 2008 22:42:59 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092242.59261.IvDoorn@gmail.com> (sfid-20080309_215130_180718_D1B6D7D7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should not write 0 to the beacon sync register during
config_intf() since that will clear out the beacon interval
and forces the beacon to be send out at the lowest interval.
(reported by Mattias Nissler).

The side effect of the same bug was that while working with
multiple virtual AP interfaces a change for any of those
interfaces would disable beaconing untill an beacon update
was provided.

This is resolved by only updating the TSF_SYNC value during
config_intf(). In update_beacon() we disable beaconing
temporarily to prevent fake beacons to be transmitted.
Finally kick_tx_queue() will enable beaconing again.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |   20 +++++++++++++-------
 drivers/net/wireless/rt2x00/rt2500pci.c |   19 +++++++++++++------
 drivers/net/wireless/rt2x00/rt2500usb.c |   19 +++++++++++++------
 drivers/net/wireless/rt2x00/rt61pci.c   |   18 +++++++++++++-----
 drivers/net/wireless/rt2x00/rt73usb.c   |   18 +++++++++++++-----
 5 files changed, 65 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 460ef2f..a1c38a1 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -279,8 +279,6 @@ static void rt2400pci_config_intf(struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 
 	if (flags & CONFIG_UPDATE_TYPE) {
-		rt2x00pci_register_write(rt2x00dev, CSR14, 0);
-
 		/*
 		 * Enable beacon config
 		 */
@@ -293,10 +291,6 @@ static void rt2400pci_config_intf(struct rt2x00_dev *rt2x00dev,
 		 * Enable synchronisation.
 		 */
 		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
-		rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
-		rt2x00_set_field32(&reg, CSR14_TBCN,
-				   (conf->sync == TSF_SYNC_BEACON));
-		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
 		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, conf->sync);
 		rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 	}
@@ -1040,6 +1034,8 @@ static void rt2400pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 	if (queue == RT2X00_BCN_QUEUE_BEACON) {
 		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
 		if (!rt2x00_get_field32(reg, CSR14_BEACON_GEN)) {
+			rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
+			rt2x00_set_field32(&reg, CSR14_TBCN, 1);
 			rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
 			rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 		}
@@ -1517,10 +1513,10 @@ static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct rt2x00_intf *intf = vif_to_intf(control->vif);
 	struct queue_entry_priv_pci_tx *priv_tx;
 	struct skb_frame_desc *skbdesc;
+	u32 reg;
 
 	if (unlikely(!intf->beacon))
 		return -ENOBUFS;
-
 	priv_tx = intf->beacon->priv_data;
 
 	/*
@@ -1536,6 +1532,16 @@ static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	skbdesc->entry = intf->beacon;
 
 	/*
+	 * Disable beaconing while we are reloading the beacon data,
+	 * otherwise we might be sending out invalid data.
+	 */
+	rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
+	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 0);
+	rt2x00_set_field32(&reg, CSR14_TBCN, 0);
+	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
+	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
+
+	/*
 	 * mac80211 doesn't provide the control->queue variable
 	 * for beacons. Set our own queue identification so
 	 * it can be used during descriptor initialization.
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index ffcd996..0962327 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -281,8 +281,6 @@ static void rt2500pci_config_intf(struct rt2x00_dev *rt2x00dev,
 	u32 reg;
 
 	if (flags & CONFIG_UPDATE_TYPE) {
-		rt2x00pci_register_write(rt2x00dev, CSR14, 0);
-
 		/*
 		 * Enable beacon config
 		 */
@@ -296,10 +294,6 @@ static void rt2500pci_config_intf(struct rt2x00_dev *rt2x00dev,
 		 * Enable synchronisation.
 		 */
 		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
-		rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
-		rt2x00_set_field32(&reg, CSR14_TBCN,
-				   (conf->sync == TSF_SYNC_BEACON));
-		rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
 		rt2x00_set_field32(&reg, CSR14_TSF_SYNC, conf->sync);
 		rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 	}
@@ -1193,6 +1187,8 @@ static void rt2500pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 	if (queue == RT2X00_BCN_QUEUE_BEACON) {
 		rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
 		if (!rt2x00_get_field32(reg, CSR14_BEACON_GEN)) {
+			rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 1);
+			rt2x00_set_field32(&reg, CSR14_TBCN, 1);
 			rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
 			rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 		}
@@ -1828,6 +1824,7 @@ static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct rt2x00_intf *intf = vif_to_intf(control->vif);
 	struct queue_entry_priv_pci_tx *priv_tx;
 	struct skb_frame_desc *skbdesc;
+	u32 reg;
 
 	if (unlikely(!intf->beacon))
 		return -ENOBUFS;
@@ -1847,6 +1844,16 @@ static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	skbdesc->entry = intf->beacon;
 
 	/*
+	 * Disable beaconing while we are reloading the beacon data,
+	 * otherwise we might be sending out invalid data.
+	 */
+	rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
+	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 0);
+	rt2x00_set_field32(&reg, CSR14_TBCN, 0);
+	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
+	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
+
+	/*
 	 * mac80211 doesn't provide the control->queue variable
 	 * for beacons. Set our own queue identification so
 	 * it can be used during descriptor initialization.
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 559131f..b6c6f7d 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -324,8 +324,6 @@ static void rt2500usb_config_intf(struct rt2x00_dev *rt2x00dev,
 	u16 reg;
 
 	if (flags & CONFIG_UPDATE_TYPE) {
-		rt2500usb_register_write(rt2x00dev, TXRX_CSR19, 0);
-
 		/*
 		 * Enable beacon config
 		 */
@@ -344,10 +342,6 @@ static void rt2500usb_config_intf(struct rt2x00_dev *rt2x00dev,
 		rt2500usb_register_write(rt2x00dev, TXRX_CSR18, reg);
 
 		rt2500usb_register_read(rt2x00dev, TXRX_CSR19, &reg);
-		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_COUNT, 1);
-		rt2x00_set_field16(&reg, TXRX_CSR19_TBCN,
-				   (conf->sync == TSF_SYNC_BEACON));
-		rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 0);
 		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_SYNC, conf->sync);
 		rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
 	}
@@ -1092,6 +1086,8 @@ static void rt2500usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR19, &reg);
 	if (!rt2x00_get_field16(reg, TXRX_CSR19_BEACON_GEN)) {
+		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_COUNT, 1);
+		rt2x00_set_field16(&reg, TXRX_CSR19_TBCN, 1);
 		rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 1);
 		/*
 		 * Beacon generation will fail initially.
@@ -1740,6 +1736,7 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	struct skb_frame_desc *skbdesc;
 	int pipe = usb_sndbulkpipe(usb_dev, 1);
 	int length;
+	u16 reg;
 
 	if (unlikely(!intf->beacon))
 		return -ENOBUFS;
@@ -1765,6 +1762,16 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	skbdesc->entry = intf->beacon;
 
 	/*
+	 * Disable beaconing while we are reloading the beacon data,
+	 * otherwise we might be sending out invalid data.
+	 */
+	rt2500usb_register_read(rt2x00dev, TXRX_CSR19, &reg);
+	rt2x00_set_field16(&reg, TXRX_CSR19_TSF_COUNT, 0);
+	rt2x00_set_field16(&reg, TXRX_CSR19_TBCN, 0);
+	rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 0);
+	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
+
+	/*
 	 * mac80211 doesn't provide the control->queue variable
 	 * for beacons. Set our own queue identification so
 	 * it can be used during descriptor initialization.
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 9ff7e60..9d8d096 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -336,17 +336,12 @@ static void rt61pci_config_intf(struct rt2x00_dev *rt2x00dev,
 		 * bits which (when set to 0) will invalidate the entire beacon.
 		 */
 		beacon_base = HW_BEACON_OFFSET(intf->beacon->entry_idx);
-		rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, 0);
 		rt2x00pci_register_write(rt2x00dev, beacon_base, 0);
 
 		/*
 		 * Enable synchronisation.
 		 */
 		rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
-		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE,
-				  (conf->sync == TSF_SYNC_BEACON));
-		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
 		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, conf->sync);
 		rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
 	}
@@ -1562,6 +1557,8 @@ static void rt61pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 
 		rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
 		if (!rt2x00_get_field32(reg, TXRX_CSR9_BEACON_GEN)) {
+			rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
+			rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
 			rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
 			rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
 		}
@@ -2373,6 +2370,7 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct rt2x00_intf *intf = vif_to_intf(control->vif);
 	struct skb_frame_desc *skbdesc;
 	unsigned int beacon_base;
+	u32 reg;
 
 	if (unlikely(!intf->beacon))
 		return -ENOBUFS;
@@ -2408,6 +2406,16 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	skbdesc->entry = intf->beacon;
 
 	/*
+	 * Disable beaconing while we are reloading the beacon data,
+	 * otherwise we might be sending out invalid data.
+	 */
+	rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
+	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
+
+	/*
 	 * mac80211 doesn't provide the control->queue variable
 	 * for beacons. Set our own queue identification so
 	 * it can be used during descriptor initialization.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 4506423..d0c0fde 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -347,17 +347,12 @@ static void rt73usb_config_intf(struct rt2x00_dev *rt2x00dev,
 		 * bits which (when set to 0) will invalidate the entire beacon.
 		 */
 		beacon_base = HW_BEACON_OFFSET(intf->beacon->entry_idx);
-		rt73usb_register_write(rt2x00dev, TXRX_CSR9, 0);
 		rt73usb_register_write(rt2x00dev, beacon_base, 0);
 
 		/*
 		 * Enable synchronisation.
 		 */
 		rt73usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
-		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
-		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE,
-				  (conf->sync == TSF_SYNC_BEACON));
-		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
 		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_SYNC, conf->sync);
 		rt73usb_register_write(rt2x00dev, TXRX_CSR9, reg);
 	}
@@ -1312,6 +1307,8 @@ static void rt73usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 
 	rt73usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
 	if (!rt2x00_get_field32(reg, TXRX_CSR9_BEACON_GEN)) {
+		rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 1);
+		rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 1);
 		rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 1);
 		rt73usb_register_write(rt2x00dev, TXRX_CSR9, reg);
 	}
@@ -1987,6 +1984,7 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct skb_frame_desc *skbdesc;
 	unsigned int beacon_base;
 	unsigned int timeout;
+	u32 reg;
 
 	if (unlikely(!intf->beacon))
 		return -ENOBUFS;
@@ -2010,6 +2008,16 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	skbdesc->entry = intf->beacon;
 
 	/*
+	 * Disable beaconing while we are reloading the beacon data,
+	 * otherwise we might be sending out invalid data.
+	 */
+	rt73usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 0);
+	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
+	rt73usb_register_write(rt2x00dev, TXRX_CSR9, reg);
+
+	/*
 	 * mac80211 doesn't provide the control->queue variable
 	 * for beacons. Set our own queue identification so
 	 * it can be used during descriptor initialization.
-- 
1.5.4.3

