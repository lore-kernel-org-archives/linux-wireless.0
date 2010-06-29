Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38012 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847Ab0F2TvR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:51:17 -0400
Received: by mail-wy0-f174.google.com with SMTP id 38so2999610wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 12:51:16 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 17/21] rt2x00: fix beacon reset on rt2800
Date: Tue, 29 Jun 2010 21:48:06 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006292138.13509.IvDoorn@gmail.com> <201006292147.11774.IvDoorn@gmail.com> <201006292147.38367.IvDoorn@gmail.com>
In-Reply-To: <201006292147.38367.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006292148.07594.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

When an interface is removed the according beacon entry should be reset.
The current approach to only clear the first word is not enough to stop
the device from sending out the beacon, hence resulting in beacons being
sent out for already removed interfaces.

Fix this by invalidating the entire TXWI in front of the beacon instead
of only the first word.

Also clear all beacons during startup in the same way.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   42 +++++++++++++++++-------------
 1 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index f7e9e76..5125315 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -432,6 +432,20 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 }
 EXPORT_SYMBOL(rt2800_write_beacon);
 
+static void inline rt2800_clear_beacon(struct rt2x00_dev *rt2x00dev,
+				       unsigned int beacon_base)
+{
+	int i;
+
+	/*
+	 * For the Beacon base registers we only need to clear
+	 * the whole TXWI which (when set to 0) will invalidate
+	 * the entire beacon.
+	 */
+	for (i = 0; i < TXWI_DESC_SIZE; i += sizeof(__le32))
+		rt2800_register_write(rt2x00dev, beacon_base + i, 0);
+}
+
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 const struct rt2x00debug rt2800_rt2x00debug = {
 	.owner	= THIS_MODULE,
@@ -733,19 +747,14 @@ EXPORT_SYMBOL_GPL(rt2800_config_filter);
 void rt2800_config_intf(struct rt2x00_dev *rt2x00dev, struct rt2x00_intf *intf,
 			struct rt2x00intf_conf *conf, const unsigned int flags)
 {
-	unsigned int beacon_base;
 	u32 reg;
 
 	if (flags & CONFIG_UPDATE_TYPE) {
 		/*
 		 * Clear current synchronisation setup.
-		 * For the Beacon base registers we only need to clear
-		 * the first byte since that byte contains the VALID and OWNER
-		 * bits which (when set to 0) will invalidate the entire beacon.
 		 */
-		beacon_base = HW_BEACON_OFFSET(intf->beacon->entry_idx);
-		rt2800_register_write(rt2x00dev, beacon_base, 0);
-
+		rt2800_clear_beacon(rt2x00dev,
+				    HW_BEACON_OFFSET(intf->beacon->entry_idx));
 		/*
 		 * Enable synchronisation.
 		 */
@@ -1565,18 +1574,15 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	/*
 	 * Clear all beacons
-	 * For the Beacon base registers we only need to clear
-	 * the first byte since that byte contains the VALID and OWNER
-	 * bits which (when set to 0) will invalidate the entire beacon.
 	 */
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE0, 0);
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE1, 0);
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE2, 0);
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE3, 0);
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE4, 0);
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE5, 0);
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE6, 0);
-	rt2800_register_write(rt2x00dev, HW_BEACON_BASE7, 0);
+	rt2800_clear_beacon(rt2x00dev, HW_BEACON_BASE0);
+	rt2800_clear_beacon(rt2x00dev, HW_BEACON_BASE1);
+	rt2800_clear_beacon(rt2x00dev, HW_BEACON_BASE2);
+	rt2800_clear_beacon(rt2x00dev, HW_BEACON_BASE3);
+	rt2800_clear_beacon(rt2x00dev, HW_BEACON_BASE4);
+	rt2800_clear_beacon(rt2x00dev, HW_BEACON_BASE5);
+	rt2800_clear_beacon(rt2x00dev, HW_BEACON_BASE6);
+	rt2800_clear_beacon(rt2x00dev, HW_BEACON_BASE7);
 
 	if (rt2x00_is_usb(rt2x00dev)) {
 		rt2800_register_read(rt2x00dev, US_CYC_CNT, &reg);
-- 
1.6.6.1

