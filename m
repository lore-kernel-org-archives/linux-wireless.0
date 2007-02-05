Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:46986
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432AbXBENSf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 08:18:35 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00-d80211: Use d80211 API to generate RTS/CTS frames
Date: Mon, 5 Feb 2007 14:15:25 +0100
References: <200702051412.50703.mb@bu3sch.de>
In-Reply-To: <200702051412.50703.mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702051415.26156.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the new d80211 API to generate RTS and CTS-to-self frames.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: bu3sch-wireless-dev/drivers/net/wireless/d80211/rt2x00/rt2400pci.c
===================================================================
--- bu3sch-wireless-dev.orig/drivers/net/wireless/d80211/rt2x00/rt2400pci.c	2007-02-05 14:01:37.000000000 +0100
+++ bu3sch-wireless-dev/drivers/net/wireless/d80211/rt2x00/rt2400pci.c	2007-02-05 14:08:19.000000000 +0100
@@ -1351,29 +1351,18 @@ static void rt2400pci_disable_radio(stru
 /*
  * RTS frame creation.
  */
-static struct sk_buff* rt2400pci_create_rts(struct rt2x00_dev *rt2x00dev,
-	struct ieee80211_hdr *hdr, unsigned short duration)
+static struct sk_buff* rt2400pci_create_rts(struct ieee80211_hw *hw,
+					    struct sk_buff *frag_skb,
+					    struct ieee80211_tx_control *control)
 {
-	struct ieee80211_hdr *ieee80211hdr;
 	struct sk_buff *skb;
-	u16 frame_control;
 
-	skb = dev_alloc_skb(IEEE80211_HEADER);
+	skb = dev_alloc_skb(sizeof(struct ieee80211_rts));
 	if (!skb)
 		return NULL;
-
-	/*
-	 * Copy the entire header over to RTS frame.
-	 */
-	memcpy(skb_put(skb, IEEE80211_HEADER), hdr, IEEE80211_HEADER);
-	ieee80211hdr = (struct ieee80211_hdr*)skb->data;
-
-	frame_control = IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS;
-	ieee80211hdr->frame_control = cpu_to_le16(frame_control);
-
-	ieee80211hdr->duration_id = cpu_to_le16(duration);
-
-	ieee80211hdr->seq_ctrl = 0;
+	skb_put(skb, sizeof(struct ieee80211_rts));
+	ieee80211_rts_get(hw, frag_skb->data, frag_skb->len, control,
+			  (struct ieee80211_rts *)(skb->data));
 
 	return skb;
 }
@@ -1785,8 +1774,7 @@ static int rt2400pci_tx(struct ieee80211
 	frame_control = le16_to_cpu(ieee80211hdr->frame_control);
 	if ((control->flags & IEEE80211_TXCTL_USE_RTS_CTS) &&
 	    !is_rts_frame(frame_control)) {
-		skb_rts = rt2400pci_create_rts(rt2x00dev,
-				ieee80211hdr, control->rts_cts_duration);
+		skb_rts = rt2400pci_create_rts(hw, skb, control);
 		if (!skb_rts) {
 			WARNING("Failed to create RTS frame.\n");
 			return NETDEV_TX_BUSY;
Index: bu3sch-wireless-dev/drivers/net/wireless/d80211/rt2x00/rt2500pci.c
===================================================================
--- bu3sch-wireless-dev.orig/drivers/net/wireless/d80211/rt2x00/rt2500pci.c	2007-02-05 14:01:37.000000000 +0100
+++ bu3sch-wireless-dev/drivers/net/wireless/d80211/rt2x00/rt2500pci.c	2007-02-05 14:08:19.000000000 +0100
@@ -1477,29 +1477,18 @@ static void rt2500pci_disable_radio(stru
 /*
  * RTS frame creation.
  */
-static struct sk_buff* rt2500pci_create_rts(struct rt2x00_dev *rt2x00dev,
-	struct ieee80211_hdr *hdr, unsigned short duration)
+static struct sk_buff* rt2500pci_create_rts(struct ieee80211_hw *hw,
+					    struct sk_buff *frag_skb,
+					    struct ieee80211_tx_control *control)
 {
-	struct ieee80211_hdr *ieee80211hdr;
 	struct sk_buff *skb;
-	u16 frame_control;
 
-	skb = dev_alloc_skb(IEEE80211_HEADER);
+	skb = dev_alloc_skb(sizeof(struct ieee80211_rts));
 	if (!skb)
 		return NULL;
-
-	/*
-	 * Copy the entire header over to RTS frame.
-	 */
-	memcpy(skb_put(skb, IEEE80211_HEADER), hdr, IEEE80211_HEADER);
-	ieee80211hdr = (struct ieee80211_hdr*)skb->data;
-
-	frame_control = IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS;
-	ieee80211hdr->frame_control = cpu_to_le16(frame_control);
-
-	ieee80211hdr->duration_id = cpu_to_le16(duration);
-
-	ieee80211hdr->seq_ctrl = 0;
+	skb_put(skb, sizeof(struct ieee80211_rts));
+	ieee80211_rts_get(hw, frag_skb->data, frag_skb->len, control,
+			  (struct ieee80211_rts *)(skb->data));
 
 	return skb;
 }
@@ -1949,8 +1938,7 @@ static int rt2500pci_tx(struct ieee80211
 	frame_control = le16_to_cpu(ieee80211hdr->frame_control);
 	if ((control->flags & IEEE80211_TXCTL_USE_RTS_CTS) &&
 	    !is_rts_frame(frame_control)) {
-		skb_rts = rt2500pci_create_rts(rt2x00dev,
-				ieee80211hdr, control->rts_cts_duration);
+		skb_rts = rt2500pci_create_rts(hw, skb, control);
 		if (!skb_rts) {
 			WARNING("Failed to create RTS frame.\n");
 			return NETDEV_TX_BUSY;
Index: bu3sch-wireless-dev/drivers/net/wireless/d80211/rt2x00/rt2500usb.c
===================================================================
--- bu3sch-wireless-dev.orig/drivers/net/wireless/d80211/rt2x00/rt2500usb.c	2007-02-05 14:01:37.000000000 +0100
+++ bu3sch-wireless-dev/drivers/net/wireless/d80211/rt2x00/rt2500usb.c	2007-02-05 14:08:19.000000000 +0100
@@ -1442,29 +1442,18 @@ static void rt2500usb_disable_radio(stru
 /*
  * RTS frame creation.
  */
-static struct sk_buff* rt2500usb_create_rts(struct rt2x00_dev *rt2x00dev,
-	struct ieee80211_hdr *hdr, unsigned short duration)
+static struct sk_buff* rt2500usb_create_rts(struct ieee80211_hw *hw,
+					    struct sk_buff *frag_skb,
+					    struct ieee80211_tx_control *control)
 {
-	struct ieee80211_hdr *ieee80211hdr;
 	struct sk_buff *skb;
-	u16 frame_control;
 
-	skb = dev_alloc_skb(IEEE80211_HEADER);
+	skb = dev_alloc_skb(sizeof(struct ieee80211_rts));
 	if (!skb)
 		return NULL;
-
-	/*
-	 * Copy the entire header over to RTS frame.
-	 */
-	memcpy(skb_put(skb, IEEE80211_HEADER), hdr, IEEE80211_HEADER);
-	ieee80211hdr = (struct ieee80211_hdr*)skb->data;
-
-	frame_control = IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS;
-	ieee80211hdr->frame_control = cpu_to_le16(frame_control);
-
-	ieee80211hdr->duration_id = cpu_to_le16(duration);
-
-	ieee80211hdr->seq_ctrl = 0;
+	skb_put(skb, sizeof(struct ieee80211_rts));
+	ieee80211_rts_get(hw, frag_skb->data, frag_skb->len, control,
+			  (struct ieee80211_rts *)(skb->data));
 
 	return skb;
 }
@@ -1882,8 +1871,7 @@ static int rt2500usb_tx(struct ieee80211
 	frame_control = le16_to_cpu(ieee80211hdr->frame_control);
 	if ((control->flags & IEEE80211_TXCTL_USE_RTS_CTS) &&
 	    !is_rts_frame(frame_control)) {
-		skb_rts = rt2500usb_create_rts(rt2x00dev,
-				ieee80211hdr, control->rts_cts_duration);
+		skb_rts = rt2500usb_create_rts(hw, skb, control);
 		if (!skb_rts) {
 			WARNING("Failed to create RTS frame.\n");
 			return NETDEV_TX_BUSY;
Index: bu3sch-wireless-dev/drivers/net/wireless/d80211/rt2x00/rt61pci.c
===================================================================
--- bu3sch-wireless-dev.orig/drivers/net/wireless/d80211/rt2x00/rt61pci.c	2007-02-05 14:01:37.000000000 +0100
+++ bu3sch-wireless-dev/drivers/net/wireless/d80211/rt2x00/rt61pci.c	2007-02-05 14:08:19.000000000 +0100
@@ -1925,29 +1925,18 @@ static void rt61pci_disable_radio(struct
 /*
  * RTS frame creation.
  */
-static struct sk_buff* rt61pci_create_rts(struct rt2x00_dev *rt2x00dev,
-	struct ieee80211_hdr *hdr, unsigned short duration)
+static struct sk_buff* rt61pci_create_rts(struct ieee80211_hw *hw,
+					  struct sk_buff *frag_skb,
+					  struct ieee80211_tx_control *control)
 {
-	struct ieee80211_hdr *ieee80211hdr;
 	struct sk_buff *skb;
-	u16 frame_control;
 
-	skb = dev_alloc_skb(IEEE80211_HEADER);
+	skb = dev_alloc_skb(sizeof(struct ieee80211_rts));
 	if (!skb)
 		return NULL;
-
-	/*
-	 * Copy the entire header over to RTS frame.
-	 */
-	memcpy(skb_put(skb, IEEE80211_HEADER), hdr, IEEE80211_HEADER);
-	ieee80211hdr = (struct ieee80211_hdr*)skb->data;
-
-	frame_control = IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS;
-	ieee80211hdr->frame_control = cpu_to_le16(frame_control);
-
-	ieee80211hdr->duration_id = cpu_to_le16(duration);
-
-	ieee80211hdr->seq_ctrl = 0;
+	skb_put(skb, sizeof(struct ieee80211_rts));
+	ieee80211_rts_get(hw, frag_skb->data, frag_skb->len, control,
+			  (struct ieee80211_rts *)(skb->data));
 
 	return skb;
 }
@@ -2445,8 +2434,7 @@ static int rt61pci_tx(struct ieee80211_h
 	frame_control = le16_to_cpu(ieee80211hdr->frame_control);
 	if ((control->flags & IEEE80211_TXCTL_USE_RTS_CTS) &&
 	    !is_rts_frame(frame_control)) {
-		skb_rts = rt61pci_create_rts(rt2x00dev,
-				ieee80211hdr, control->rts_cts_duration);
+		skb_rts = rt61pci_create_rts(hw, skb, control);
 		if (!skb_rts) {
 			WARNING("Failed to create RTS frame.\n");
 			return NETDEV_TX_BUSY;
Index: bu3sch-wireless-dev/drivers/net/wireless/d80211/rt2x00/rt73usb.c
===================================================================
--- bu3sch-wireless-dev.orig/drivers/net/wireless/d80211/rt2x00/rt73usb.c	2007-02-05 14:01:37.000000000 +0100
+++ bu3sch-wireless-dev/drivers/net/wireless/d80211/rt2x00/rt73usb.c	2007-02-05 14:08:19.000000000 +0100
@@ -1704,29 +1704,18 @@ static void rt73usb_disable_radio(struct
 /*
  * RTS frame creation.
  */
-static struct sk_buff* rt73usb_create_rts(struct rt2x00_dev *rt2x00dev,
-	struct ieee80211_hdr *hdr, unsigned short duration)
+static struct sk_buff* rt73usb_create_rts(struct ieee80211_hw *hw,
+					  struct sk_buff *frag_skb,
+					  struct ieee80211_tx_control *control)
 {
-	struct ieee80211_hdr *ieee80211hdr;
 	struct sk_buff *skb;
-	u16 frame_control;
 
-	skb = dev_alloc_skb(IEEE80211_HEADER);
+	skb = dev_alloc_skb(sizeof(struct ieee80211_rts));
 	if (!skb)
 		return NULL;
-
-	/*
-	 * Copy the entire header over to RTS frame.
-	 */
-	memcpy(skb_put(skb, IEEE80211_HEADER), hdr, IEEE80211_HEADER);
-	ieee80211hdr = (struct ieee80211_hdr*)skb->data;
-
-	frame_control = IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS;
-	ieee80211hdr->frame_control = cpu_to_le16(frame_control);
-
-	ieee80211hdr->duration_id = cpu_to_le16(duration);
-
-	ieee80211hdr->seq_ctrl = 0;
+	skb_put(skb, sizeof(struct ieee80211_rts));
+	ieee80211_rts_get(hw, frag_skb->data, frag_skb->len, control,
+			  (struct ieee80211_rts *)(skb->data));
 
 	return skb;
 }
@@ -2153,8 +2142,7 @@ static int rt73usb_tx(struct ieee80211_h
 	frame_control = le16_to_cpu(ieee80211hdr->frame_control);
 	if ((control->flags & IEEE80211_TXCTL_USE_RTS_CTS) &&
 	    !is_rts_frame(frame_control)) {
-		skb_rts = rt73usb_create_rts(rt2x00dev,
-				ieee80211hdr, control->rts_cts_duration);
+		skb_rts = rt73usb_create_rts(hw, skb, control);
 		if (!skb_rts) {
 			WARNING("Failed to create RTS frame.\n");
 			return NETDEV_TX_BUSY;


-- 
Greetings Michael.
