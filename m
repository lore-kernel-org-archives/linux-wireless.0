Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53403 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbZHIW65 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2009 18:58:57 -0400
Received: by ewy10 with SMTP id 10so2673834ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 09 Aug 2009 15:58:57 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Fix beacon de-synchronization while update beacon
Date: Mon, 10 Aug 2009 00:58:54 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com, igor.perminov@inbox.ru
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908100058.55057.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Perminov <igor.perminov@inbox.ru>

When beacon is being updated to refresh TIM (AP mode), beacon frames are
de-synchronizing (i.e. two neighbor beacon frames - before and after
update - are being transmitted with a wrong time interval).
That is because xxx_write_beacon should disable beacon generation only
while beacon data are being uploaded to the device, but it should not
disable the beacon clock.

Signed-off-by: Igor Perminov <igor.perminov@inbox.ru>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    2 --
 drivers/net/wireless/rt2x00/rt2500pci.c |    2 --
 drivers/net/wireless/rt2x00/rt2500usb.c |   15 ++++++++-------
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 --
 drivers/net/wireless/rt2x00/rt61pci.c   |    2 --
 drivers/net/wireless/rt2x00/rt73usb.c   |    2 --
 7 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 30185ad..164df93 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1069,8 +1069,6 @@ static void rt2400pci_write_beacon(struct queue_entry *entry)
 	 * otherwise we might be sending out invalid data.
 	 */
 	rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
-	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 0);
-	rt2x00_set_field32(&reg, CSR14_TBCN, 0);
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 3b31715..4186582 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1227,8 +1227,6 @@ static void rt2500pci_write_beacon(struct queue_entry *entry)
 	 * otherwise we might be sending out invalid data.
 	 */
 	rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
-	rt2x00_set_field32(&reg, CSR14_TSF_COUNT, 0);
-	rt2x00_set_field32(&reg, CSR14_TBCN, 0);
 	rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 0);
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index de48c5c..09a5894 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1238,8 +1238,6 @@ static void rt2500usb_write_beacon(struct queue_entry *entry)
 	 * otherwise we might be sending out invalid data.
 	 */
 	rt2500usb_register_read(rt2x00dev, TXRX_CSR19, &reg);
-	rt2x00_set_field16(&reg, TXRX_CSR19_TSF_COUNT, 0);
-	rt2x00_set_field16(&reg, TXRX_CSR19_TBCN, 0);
 	rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 0);
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
 
@@ -1287,7 +1285,7 @@ static int rt2500usb_get_tx_data_len(struct queue_entry *entry)
 static void rt2500usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 				    const enum data_queue_qid queue)
 {
-	u16 reg;
+	u16 reg, reg0;
 
 	if (queue != QID_BEACON) {
 		rt2x00usb_kick_tx_queue(rt2x00dev, queue);
@@ -1298,16 +1296,19 @@ static void rt2500usb_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 	if (!rt2x00_get_field16(reg, TXRX_CSR19_BEACON_GEN)) {
 		rt2x00_set_field16(&reg, TXRX_CSR19_TSF_COUNT, 1);
 		rt2x00_set_field16(&reg, TXRX_CSR19_TBCN, 1);
+		reg0 = reg;
 		rt2x00_set_field16(&reg, TXRX_CSR19_BEACON_GEN, 1);
 		/*
 		 * Beacon generation will fail initially.
-		 * To prevent this we need to register the TXRX_CSR19
-		 * register several times.
+		 * To prevent this we need to change the TXRX_CSR19
+		 * register several times (reg0 is the same as reg
+		 * except for TXRX_CSR19_BEACON_GEN, which is 0 in reg0
+		 * and 1 in reg).
 		 */
 		rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
-		rt2500usb_register_write(rt2x00dev, TXRX_CSR19, 0);
+		rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg0);
 		rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
-		rt2500usb_register_write(rt2x00dev, TXRX_CSR19, 0);
+		rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg0);
 		rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
 	}
 }
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 2de0389..3856f06 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -2050,8 +2050,6 @@ static void rt2800usb_write_beacon(struct queue_entry *entry)
 	 * otherwise we might be sending out invalid data.
 	 */
 	rt2x00usb_register_read(rt2x00dev, BCN_TIME_CFG, &reg);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_TSF_TICKING, 0);
-	rt2x00_set_field32(&reg, BCN_TIME_CFG_TBTT_ENABLE, 0);
 	rt2x00_set_field32(&reg, BCN_TIME_CFG_BEACON_GEN, 0);
 	rt2x00usb_register_write(rt2x00dev, BCN_TIME_CFG, reg);
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 3447997..f4b4b86 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1855,8 +1855,6 @@ static void rt61pci_write_beacon(struct queue_entry *entry)
 	 * otherwise we might be sending out invalid data.
 	 */
 	rt2x00pci_register_read(rt2x00dev, TXRX_CSR9, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 0);
-	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 0);
 	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 4b9955b..4d94b65 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1527,8 +1527,6 @@ static void rt73usb_write_beacon(struct queue_entry *entry)
 	 * otherwise we might be sending out invalid data.
 	 */
 	rt2x00usb_register_read(rt2x00dev, TXRX_CSR9, &reg);
-	rt2x00_set_field32(&reg, TXRX_CSR9_TSF_TICKING, 0);
-	rt2x00_set_field32(&reg, TXRX_CSR9_TBTT_ENABLE, 0);
 	rt2x00_set_field32(&reg, TXRX_CSR9_BEACON_GEN, 0);
 	rt2x00usb_register_write(rt2x00dev, TXRX_CSR9, reg);
 
-- 
1.6.3.3

