Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:53948 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbYLTKBz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 05:01:55 -0500
Received: by ey-out-2122.google.com with SMTP id 22so125886eye.37
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2008 02:01:54 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 3/15] rt2x00: Reduce calls to bbp_read()
Date: Sat, 20 Dec 2008 10:54:22 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200812201052.00655.IvDoorn@gmail.com> <200812201052.43061.IvDoorn@gmail.com> <200812201053.29348.IvDoorn@gmail.com>
In-Reply-To: <200812201053.29348.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812201054.22904.IvDoorn@gmail.com> (sfid-20081220_110207_880186_CD7ACA5A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The link_tuner() function will always call bbp_read()
at the start of the function. Because this is an
indirect register access has some costs attached
to it (especially for USB hardware).

We already store the value read from the register
into the vgc_level value inside the link structure.
Instead of reading from the register we can read that
field directly and base the tuner on that value.

This reduces the time the registers are locked with
the csr_mutex and speeds up the link_tuner processing.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |   27 ++++++++--------
 drivers/net/wireless/rt2x00/rt2500pci.c |   50 +++++++++++++++---------------
 drivers/net/wireless/rt2x00/rt2x00.h    |    9 ++++-
 drivers/net/wireless/rt2x00/rt61pci.c   |   49 +++++++++++++----------------
 drivers/net/wireless/rt2x00/rt73usb.c   |   52 ++++++++++++++----------------
 5 files changed, 92 insertions(+), 95 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 031cb0a..a186e4b 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -600,35 +600,36 @@ static void rt2400pci_link_stats(struct rt2x00_dev *rt2x00dev,
 	qual->false_cca = bbp;
 }
 
+static inline void rt2400pci_set_vgc(struct rt2x00_dev *rt2x00dev, u8 vgc_level)
+{
+	rt2400pci_bbp_write(rt2x00dev, 13, vgc_level);
+	rt2x00dev->link.vgc_level = vgc_level;
+	rt2x00dev->link.vgc_level_reg = vgc_level;
+}
+
 static void rt2400pci_reset_tuner(struct rt2x00_dev *rt2x00dev)
 {
-	rt2400pci_bbp_write(rt2x00dev, 13, 0x08);
-	rt2x00dev->link.vgc_level = 0x08;
+	rt2400pci_set_vgc(rt2x00dev, 0x08);
 }
 
 static void rt2400pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
-	u8 reg;
+	struct link *link = &rt2x00dev->link;
 
 	/*
 	 * The link tuner should not run longer then 60 seconds,
 	 * and should run once every 2 seconds.
 	 */
-	if (rt2x00dev->link.count > 60 || !(rt2x00dev->link.count & 1))
+	if (link->count > 60 || !(link->count & 1))
 		return;
 
 	/*
 	 * Base r13 link tuning on the false cca count.
 	 */
-	rt2400pci_bbp_read(rt2x00dev, 13, &reg);
-
-	if (rt2x00dev->link.qual.false_cca > 512 && reg < 0x20) {
-		rt2400pci_bbp_write(rt2x00dev, 13, ++reg);
-		rt2x00dev->link.vgc_level = reg;
-	} else if (rt2x00dev->link.qual.false_cca < 100 && reg > 0x08) {
-		rt2400pci_bbp_write(rt2x00dev, 13, --reg);
-		rt2x00dev->link.vgc_level = reg;
-	}
+	if ((link->qual.false_cca > 512) && (link->vgc_level < 0x20))
+		rt2400pci_set_vgc(rt2x00dev, ++link->vgc_level);
+	else if ((link->qual.false_cca < 100) && (link->vgc_level > 0x08))
+		rt2400pci_set_vgc(rt2x00dev, --link->vgc_level);
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 780c96b..dd1f2c0 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -639,16 +639,23 @@ static void rt2500pci_link_stats(struct rt2x00_dev *rt2x00dev,
 	qual->false_cca = rt2x00_get_field32(reg, CNT3_FALSE_CCA);
 }
 
+static inline void rt2500pci_set_vgc(struct rt2x00_dev *rt2x00dev, u8 vgc_level)
+{
+	if (rt2x00dev->link.vgc_level_reg != vgc_level) {
+		rt2500pci_bbp_write(rt2x00dev, 17, vgc_level);
+		rt2x00dev->link.vgc_level_reg = vgc_level;
+	}
+}
+
 static void rt2500pci_reset_tuner(struct rt2x00_dev *rt2x00dev)
 {
-	rt2500pci_bbp_write(rt2x00dev, 17, 0x48);
-	rt2x00dev->link.vgc_level = 0x48;
+	rt2500pci_set_vgc(rt2x00dev, 0x48);
 }
 
 static void rt2500pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
-	int rssi = rt2x00_get_link_rssi(&rt2x00dev->link);
-	u8 r17;
+	struct link *link = &rt2x00dev->link;
+	int rssi = rt2x00_get_link_rssi(link);
 
 	/*
 	 * To prevent collisions with MAC ASIC on chipsets
@@ -656,12 +663,9 @@ static void rt2500pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * seconds while being associated.
 	 */
 	if (rt2x00_rev(&rt2x00dev->chip) < RT2560_VERSION_D &&
-	    rt2x00dev->intf_associated &&
-	    rt2x00dev->link.count > 20)
+	    rt2x00dev->intf_associated && link->count > 20)
 		return;
 
-	rt2500pci_bbp_read(rt2x00dev, 17, &r17);
-
 	/*
 	 * Chipset versions C and lower should directly continue
 	 * to the dynamic CCA tuning. Chipset version D and higher
@@ -677,11 +681,9 @@ static void rt2500pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * then corrupt the R17 tuning. To remidy this the tuning should
 	 * be stopped (While making sure the R17 value will not exceed limits)
 	 */
-	if (rssi < -80 && rt2x00dev->link.count > 20) {
-		if (r17 >= 0x41) {
-			r17 = rt2x00dev->link.vgc_level;
-			rt2500pci_bbp_write(rt2x00dev, 17, r17);
-		}
+	if (rssi < -80 && link->count > 20) {
+		if (link->vgc_level_reg >= 0x41)
+			rt2500pci_set_vgc(rt2x00dev, link->vgc_level);
 		return;
 	}
 
@@ -689,8 +691,7 @@ static void rt2500pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * Special big-R17 for short distance
 	 */
 	if (rssi >= -58) {
-		if (r17 != 0x50)
-			rt2500pci_bbp_write(rt2x00dev, 17, 0x50);
+		rt2500pci_set_vgc(rt2x00dev, 0x50);
 		return;
 	}
 
@@ -698,8 +699,7 @@ static void rt2500pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * Special mid-R17 for middle distance
 	 */
 	if (rssi >= -74) {
-		if (r17 != 0x41)
-			rt2500pci_bbp_write(rt2x00dev, 17, 0x41);
+		rt2500pci_set_vgc(rt2x00dev, 0x41);
 		return;
 	}
 
@@ -707,8 +707,8 @@ static void rt2500pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * Leave short or middle distance condition, restore r17
 	 * to the dynamic tuning range.
 	 */
-	if (r17 >= 0x41) {
-		rt2500pci_bbp_write(rt2x00dev, 17, rt2x00dev->link.vgc_level);
+	if (link->vgc_level_reg >= 0x41) {
+		rt2500pci_set_vgc(rt2x00dev, link->vgc_level);
 		return;
 	}
 
@@ -718,12 +718,12 @@ dynamic_cca_tune:
 	 * R17 is inside the dynamic tuning range,
 	 * start tuning the link based on the false cca counter.
 	 */
-	if (rt2x00dev->link.qual.false_cca > 512 && r17 < 0x40) {
-		rt2500pci_bbp_write(rt2x00dev, 17, ++r17);
-		rt2x00dev->link.vgc_level = r17;
-	} else if (rt2x00dev->link.qual.false_cca < 100 && r17 > 0x32) {
-		rt2500pci_bbp_write(rt2x00dev, 17, --r17);
-		rt2x00dev->link.vgc_level = r17;
+	if (link->qual.false_cca > 512 && link->vgc_level_reg < 0x40) {
+		rt2500pci_set_vgc(rt2x00dev, ++link->vgc_level_reg);
+		link->vgc_level = link->vgc_level_reg;
+	} else if (link->qual.false_cca < 100 && link->vgc_level_reg > 0x32) {
+		rt2500pci_set_vgc(rt2x00dev, --link->vgc_level_reg);
+		link->vgc_level = link->vgc_level_reg;
 	}
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 19c0687..8935f2c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -286,9 +286,14 @@ struct link {
 	struct link_ant ant;
 
 	/*
-	 * Active VGC level
+	 * Active VGC level (for false cca tuning)
 	 */
-	int vgc_level;
+	u8 vgc_level;
+
+	/*
+	 * VGC level as configured in register
+	 */
+	u8 vgc_level_reg;
 
 	/*
 	 * Work structure for scheduling periodic link tuning.
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 3f91a6e..abd7b43 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1046,21 +1046,27 @@ static void rt61pci_link_stats(struct rt2x00_dev *rt2x00dev,
 	qual->false_cca = rt2x00_get_field32(reg, STA_CSR1_FALSE_CCA_ERROR);
 }
 
+static inline void rt61pci_set_vgc(struct rt2x00_dev *rt2x00dev, u8 vgc_level)
+{
+	if (rt2x00dev->link.vgc_level != vgc_level) {
+		rt61pci_bbp_write(rt2x00dev, 17, vgc_level);
+		rt2x00dev->link.vgc_level = vgc_level;
+		rt2x00dev->link.vgc_level_reg = vgc_level;
+	}
+}
+
 static void rt61pci_reset_tuner(struct rt2x00_dev *rt2x00dev)
 {
-	rt61pci_bbp_write(rt2x00dev, 17, 0x20);
-	rt2x00dev->link.vgc_level = 0x20;
+	rt61pci_set_vgc(rt2x00dev, 0x20);
 }
 
 static void rt61pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
-	int rssi = rt2x00_get_link_rssi(&rt2x00dev->link);
-	u8 r17;
+	struct link *link = &rt2x00dev->link;
+	int rssi = rt2x00_get_link_rssi(link);
 	u8 up_bound;
 	u8 low_bound;
 
-	rt61pci_bbp_read(rt2x00dev, 17, &r17);
-
 	/*
 	 * Determine r17 bounds.
 	 */
@@ -1091,8 +1097,7 @@ static void rt61pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * Special big-R17 for very short distance
 	 */
 	if (rssi >= -35) {
-		if (r17 != 0x60)
-			rt61pci_bbp_write(rt2x00dev, 17, 0x60);
+		rt61pci_set_vgc(rt2x00dev, 0x60);
 		return;
 	}
 
@@ -1100,8 +1105,7 @@ static void rt61pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * Special big-R17 for short distance
 	 */
 	if (rssi >= -58) {
-		if (r17 != up_bound)
-			rt61pci_bbp_write(rt2x00dev, 17, up_bound);
+		rt61pci_set_vgc(rt2x00dev, up_bound);
 		return;
 	}
 
@@ -1109,9 +1113,7 @@ static void rt61pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * Special big-R17 for middle-short distance
 	 */
 	if (rssi >= -66) {
-		low_bound += 0x10;
-		if (r17 != low_bound)
-			rt61pci_bbp_write(rt2x00dev, 17, low_bound);
+		rt61pci_set_vgc(rt2x00dev, low_bound + 0x10);
 		return;
 	}
 
@@ -1119,9 +1121,7 @@ static void rt61pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * Special mid-R17 for middle distance
 	 */
 	if (rssi >= -74) {
-		low_bound += 0x08;
-		if (r17 != low_bound)
-			rt61pci_bbp_write(rt2x00dev, 17, low_bound);
+		rt61pci_set_vgc(rt2x00dev, low_bound + 0x08);
 		return;
 	}
 
@@ -1133,8 +1133,8 @@ static void rt61pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	if (low_bound > up_bound)
 		up_bound = low_bound;
 
-	if (r17 > up_bound) {
-		rt61pci_bbp_write(rt2x00dev, 17, up_bound);
+	if (link->vgc_level > up_bound) {
+		rt61pci_set_vgc(rt2x00dev, up_bound);
 		return;
 	}
 
@@ -1144,15 +1144,10 @@ dynamic_cca_tune:
 	 * r17 does not yet exceed upper limit, continue and base
 	 * the r17 tuning on the false CCA count.
 	 */
-	if (rt2x00dev->link.qual.false_cca > 512 && r17 < up_bound) {
-		if (++r17 > up_bound)
-			r17 = up_bound;
-		rt61pci_bbp_write(rt2x00dev, 17, r17);
-	} else if (rt2x00dev->link.qual.false_cca < 100 && r17 > low_bound) {
-		if (--r17 < low_bound)
-			r17 = low_bound;
-		rt61pci_bbp_write(rt2x00dev, 17, r17);
-	}
+	if ((link->qual.false_cca > 512) && (link->vgc_level < up_bound))
+		rt61pci_set_vgc(rt2x00dev, ++link->vgc_level);
+	else if ((link->qual.false_cca < 100) && (link->vgc_level > low_bound))
+		rt61pci_set_vgc(rt2x00dev, --link->vgc_level);
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 8a365c9..49fd42a 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -924,21 +924,27 @@ static void rt73usb_link_stats(struct rt2x00_dev *rt2x00dev,
 	qual->false_cca = rt2x00_get_field32(reg, STA_CSR1_FALSE_CCA_ERROR);
 }
 
+static inline void rt73usb_set_vgc(struct rt2x00_dev *rt2x00dev, u8 vgc_level)
+{
+	if (rt2x00dev->link.vgc_level != vgc_level) {
+		rt73usb_bbp_write(rt2x00dev, 17, vgc_level);
+		rt2x00dev->link.vgc_level = vgc_level;
+		rt2x00dev->link.vgc_level_reg = vgc_level;
+	}
+}
+
 static void rt73usb_reset_tuner(struct rt2x00_dev *rt2x00dev)
 {
-	rt73usb_bbp_write(rt2x00dev, 17, 0x20);
-	rt2x00dev->link.vgc_level = 0x20;
+	rt73usb_set_vgc(rt2x00dev, 0x20);
 }
 
 static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
-	int rssi = rt2x00_get_link_rssi(&rt2x00dev->link);
-	u8 r17;
+	struct link *link = &rt2x00dev->link;
+	int rssi = rt2x00_get_link_rssi(link);
 	u8 up_bound;
 	u8 low_bound;
 
-	rt73usb_bbp_read(rt2x00dev, 17, &r17);
-
 	/*
 	 * Determine r17 bounds.
 	 */
@@ -979,8 +985,7 @@ static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * Special big-R17 for very short distance
 	 */
 	if (rssi > -35) {
-		if (r17 != 0x60)
-			rt73usb_bbp_write(rt2x00dev, 17, 0x60);
+		rt73usb_set_vgc(rt2x00dev, 0x60);
 		return;
 	}
 
@@ -988,8 +993,7 @@ static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * Special big-R17 for short distance
 	 */
 	if (rssi >= -58) {
-		if (r17 != up_bound)
-			rt73usb_bbp_write(rt2x00dev, 17, up_bound);
+		rt73usb_set_vgc(rt2x00dev, up_bound);
 		return;
 	}
 
@@ -997,9 +1001,7 @@ static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * Special big-R17 for middle-short distance
 	 */
 	if (rssi >= -66) {
-		low_bound += 0x10;
-		if (r17 != low_bound)
-			rt73usb_bbp_write(rt2x00dev, 17, low_bound);
+		rt73usb_set_vgc(rt2x00dev, low_bound + 0x10);
 		return;
 	}
 
@@ -1007,8 +1009,7 @@ static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 	 * Special mid-R17 for middle distance
 	 */
 	if (rssi >= -74) {
-		if (r17 != (low_bound + 0x10))
-			rt73usb_bbp_write(rt2x00dev, 17, low_bound + 0x08);
+		rt73usb_set_vgc(rt2x00dev, low_bound + 0x08);
 		return;
 	}
 
@@ -1020,8 +1021,8 @@ static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 	if (low_bound > up_bound)
 		up_bound = low_bound;
 
-	if (r17 > up_bound) {
-		rt73usb_bbp_write(rt2x00dev, 17, up_bound);
+	if (link->vgc_level > up_bound) {
+		rt73usb_set_vgc(rt2x00dev, up_bound);
 		return;
 	}
 
@@ -1031,17 +1032,12 @@ dynamic_cca_tune:
 	 * r17 does not yet exceed upper limit, continue and base
 	 * the r17 tuning on the false CCA count.
 	 */
-	if (rt2x00dev->link.qual.false_cca > 512 && r17 < up_bound) {
-		r17 += 4;
-		if (r17 > up_bound)
-			r17 = up_bound;
-		rt73usb_bbp_write(rt2x00dev, 17, r17);
-	} else if (rt2x00dev->link.qual.false_cca < 100 && r17 > low_bound) {
-		r17 -= 4;
-		if (r17 < low_bound)
-			r17 = low_bound;
-		rt73usb_bbp_write(rt2x00dev, 17, r17);
-	}
+	if ((link->qual.false_cca > 512) && (link->vgc_level < up_bound))
+		rt73usb_set_vgc(rt2x00dev,
+				min_t(u8, link->vgc_level + 4, up_bound));
+	else if ((link->qual.false_cca < 100) && (link->vgc_level > low_bound))
+		rt73usb_set_vgc(rt2x00dev,
+				max_t(u8, link->vgc_level - 4, low_bound));
 }
 
 /*
-- 
1.5.6.1

