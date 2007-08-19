Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbXHSSak convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:30:40 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446922ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:30:39 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/30] rt2x00: Correctly reset TX/RX success/failed counters
Date: Sun, 19 Aug 2007 20:24:54 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192024.54809.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 9e26ed7c8a87978caf02f8c6510bab37007c5259 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 13:01:14 +0200
Subject: [PATCH 10/30] rt2x00: Correctly reset TX/RX success/failed counters

The TX/RX Success/Failed counters should be reset
_before_ updating the statistics. Otherwise all signal
quality calculations will be done with a rx_failed count
of 0.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c |    5 +----
 drivers/net/wireless/rt2500pci.c |    5 +----
 drivers/net/wireless/rt2500usb.c |    5 +----
 drivers/net/wireless/rt2x00dev.c |   22 ++++++++++++----------
 drivers/net/wireless/rt61pci.c   |    5 +----
 drivers/net/wireless/rt73usb.c   |    5 +----
 6 files changed, 17 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index aa1209b..8ebfae8 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -634,7 +634,6 @@ static void rt2400pci_disable_led(struct rt2x00_dev *rt2x00dev)
  */
 static void rt2400pci_link_stats(struct rt2x00_dev *rt2x00dev)
 {
-	int fcs;
 	u32 reg;
 	u8 bbp;
 
@@ -642,9 +641,7 @@ static void rt2400pci_link_stats(struct rt2x00_dev *rt2x00dev)
 	 * Update FCS error count from register.
 	 */
 	rt2x00pci_register_read(rt2x00dev, CNT0, &reg);
-	fcs = rt2x00_get_field32(reg, CNT0_FCS_ERROR);
-	rt2x00dev->link.rx_failed += fcs;
-	rt2x00dev->low_level_stats.dot11FCSErrorCount += fcs;
+	rt2x00dev->link.rx_failed = rt2x00_get_field32(reg, CNT0_FCS_ERROR);
 
 	/*
 	 * Update False CCA count from register.
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index 3a1da1f..a5bfb00 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -735,16 +735,13 @@ static void rt2500pci_disable_led(struct rt2x00_dev *rt2x00dev)
  */
 static void rt2500pci_link_stats(struct rt2x00_dev *rt2x00dev)
 {
-	int fcs;
 	u32 reg;
 
 	/*
 	 * Update FCS error count from register.
 	 */
 	rt2x00pci_register_read(rt2x00dev, CNT0, &reg);
-	fcs = rt2x00_get_field32(reg, CNT0_FCS_ERROR);
-	rt2x00dev->link.rx_failed += fcs;
-	rt2x00dev->low_level_stats.dot11FCSErrorCount += fcs;
+	rt2x00dev->link.rx_failed = rt2x00_get_field32(reg, CNT0_FCS_ERROR);
 
 	/*
 	 * Update False CCA count from register.
diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index 71b7bf2..e9f6747 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -690,16 +690,13 @@ static void rt2500usb_disable_led(struct rt2x00_dev *rt2x00dev)
  */
 static void rt2500usb_link_stats(struct rt2x00_dev *rt2x00dev)
 {
-	int fcs;
 	u16 reg;
 
 	/*
 	 * Update FCS error count from register.
 	 */
 	rt2500usb_register_read(rt2x00dev, STA_CSR0, &reg);
-	fcs = rt2x00_get_field16(reg, STA_CSR0_FCS_ERROR);
-	rt2x00dev->link.rx_failed += fcs;
-	rt2x00dev->low_level_stats.dot11FCSErrorCount += fcs;
+	rt2x00dev->link.rx_failed = rt2x00_get_field16(reg, STA_CSR0_FCS_ERROR);
 
 	/*
 	 * Update False CCA count from register.
diff --git a/drivers/net/wireless/rt2x00dev.c b/drivers/net/wireless/rt2x00dev.c
index 7f3eaf1..f952595 100644
--- a/drivers/net/wireless/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00dev.c
@@ -225,9 +225,21 @@ static void rt2x00lib_link_tuner(struct work_struct *work)
 	    container_of(work, struct rt2x00_dev, link.work.work);
 
 	/*
+	 * Reset statistics.
+	 * This will cause the signal value to be
+	 * based on the statistics of the last second.
+	 */
+	rt2x00dev->link.rx_success = 0;
+	rt2x00dev->link.rx_failed = 0;
+	rt2x00dev->link.tx_success = 0;
+	rt2x00dev->link.tx_failed = 0;
+
+	/*
 	 * Update statistics.
 	 */
 	rt2x00dev->ops->lib->link_stats(rt2x00dev);
+	rt2x00dev->low_level_stats.dot11FCSErrorCount +=
+	    rt2x00dev->link.rx_failed;
 
 	/*
 	 * Only perform the link tuning when Link tuning
@@ -237,16 +249,6 @@ static void rt2x00lib_link_tuner(struct work_struct *work)
 		rt2x00dev->ops->lib->link_tuner(rt2x00dev);
 
 	/*
-	 * Reset statistics.
-	 * This will cause the signal value to be
-	 * based on the statistics of the last second.
-	 */
-	rt2x00dev->link.rx_success = 0;
-	rt2x00dev->link.rx_failed = 0;
-	rt2x00dev->link.tx_success = 0;
-	rt2x00dev->link.tx_failed = 0;
-
-	/*
 	 * Increase tuner counter, and reschedule the next link tuner run.
 	 */
 	rt2x00dev->link.count++;
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index f592397..8c6c778 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -947,16 +947,13 @@ static void rt61pci_activity_led(struct rt2x00_dev *rt2x00dev, int rssi)
  */
 static void rt61pci_link_stats(struct rt2x00_dev *rt2x00dev)
 {
-	int fcs;
 	u32 reg;
 
 	/*
 	 * Update FCS error count from register.
 	 */
 	rt2x00pci_register_read(rt2x00dev, STA_CSR0, &reg);
-	fcs = rt2x00_get_field32(reg, STA_CSR0_FCS_ERROR);
-	rt2x00dev->link.rx_failed += fcs;
-	rt2x00dev->low_level_stats.dot11FCSErrorCount += fcs;
+	rt2x00dev->link.rx_failed = rt2x00_get_field32(reg, STA_CSR0_FCS_ERROR);
 
 	/*
 	 * Update False CCA count from register.
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 9f059ce..30d4189 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -836,16 +836,13 @@ static void rt73usb_activity_led(struct rt2x00_dev *rt2x00dev, int rssi)
  */
 static void rt73usb_link_stats(struct rt2x00_dev *rt2x00dev)
 {
-	int fcs;
 	u32 reg;
 
 	/*
 	 * Update FCS error count from register.
 	 */
 	rt73usb_register_read(rt2x00dev, STA_CSR0, &reg);
-	fcs = rt2x00_get_field32(reg, STA_CSR0_FCS_ERROR);
-	rt2x00dev->link.rx_failed += fcs;
-	rt2x00dev->low_level_stats.dot11FCSErrorCount += fcs;
+	rt2x00dev->link.rx_failed = rt2x00_get_field32(reg, STA_CSR0_FCS_ERROR);
 
 	/*
 	 * Update False CCA count from register.
-- 
1.5.3.rc5

