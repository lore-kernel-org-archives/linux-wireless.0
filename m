Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:51255 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab3HPWPy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 18:15:54 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/2] rt2x00: rt2800lib: pass beacon index to rt2800_clear_beacon_register
Date: Sat, 17 Aug 2013 00:15:50 +0200
Message-Id: <1376691350-19851-2-git-send-email-juhosg@openwrt.org> (sfid-20130817_001604_066136_D4206773)
In-Reply-To: <1376691350-19851-1-git-send-email-juhosg@openwrt.org>
References: <1376691350-19851-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of precomputing the beacon base in
each caller, pass the beacon index to the
'rt2800_clear_beacon_register' function
and compute the beacon base in there.

This allows to simplify the caller functions
a bit.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index a25862a..ea97ac6 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1011,10 +1011,13 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 EXPORT_SYMBOL_GPL(rt2800_write_beacon);
 
 static inline void rt2800_clear_beacon_register(struct rt2x00_dev *rt2x00dev,
-						unsigned int beacon_base)
+						unsigned int index)
 {
 	int i;
 	const int txwi_desc_size = rt2x00dev->bcn->winfo_size;
+	unsigned int beacon_base;
+
+	beacon_base = HW_BEACON_BASE(index);
 
 	/*
 	 * For the Beacon base registers we only need to clear
@@ -1041,8 +1044,7 @@ void rt2800_clear_beacon(struct queue_entry *entry)
 	/*
 	 * Clear beacon.
 	 */
-	rt2800_clear_beacon_register(rt2x00dev,
-				     HW_BEACON_BASE(entry->entry_idx));
+	rt2800_clear_beacon_register(rt2x00dev, entry->entry_idx);
 
 	/*
 	 * Enabled beaconing again.
@@ -4813,14 +4815,8 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Clear all beacons
 	 */
-	rt2800_clear_beacon_register(rt2x00dev, HW_BEACON_BASE0);
-	rt2800_clear_beacon_register(rt2x00dev, HW_BEACON_BASE1);
-	rt2800_clear_beacon_register(rt2x00dev, HW_BEACON_BASE2);
-	rt2800_clear_beacon_register(rt2x00dev, HW_BEACON_BASE3);
-	rt2800_clear_beacon_register(rt2x00dev, HW_BEACON_BASE4);
-	rt2800_clear_beacon_register(rt2x00dev, HW_BEACON_BASE5);
-	rt2800_clear_beacon_register(rt2x00dev, HW_BEACON_BASE6);
-	rt2800_clear_beacon_register(rt2x00dev, HW_BEACON_BASE7);
+	for (i = 0; i < 8; i++)
+		rt2800_clear_beacon_register(rt2x00dev, i);
 
 	if (rt2x00_is_usb(rt2x00dev)) {
 		rt2800_register_read(rt2x00dev, US_CYC_CNT, &reg);
-- 
1.7.10
