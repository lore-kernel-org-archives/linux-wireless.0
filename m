Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37611 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab3HVSxd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Aug 2013 14:53:33 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3 2/2] rt2x00: rt2800lib: don't hardcode beacon offsets
Date: Thu, 22 Aug 2013 20:53:22 +0200
Message-Id: <1377197602-5567-2-git-send-email-juhosg@openwrt.org> (sfid-20130822_205346_357951_1E21636D)
In-Reply-To: <1377197602-5567-1-git-send-email-juhosg@openwrt.org>
References: <1377197602-5567-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The values written into the BCN_OFFSET[01] registers are
hardcoded in the rt2800_init_register function.

Add a macro and a helper function to derive these values
directly from the base address of a given beacon, and use
the new function instead of the hardcoded numbers.

The patch contains no functional changes. The programmed
register values are the same before and after the patch.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
Changes since v2:
  - separated from the 'rt2x00: fix beaconing on RT3593' patch-set

Changes since v1: ---
---
 drivers/net/wireless/rt2x00/rt2800.h    |    2 ++
 drivers/net/wireless/rt2x00/rt2800lib.c |   30 ++++++++++++++++++++++--------
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index e25e5bf..fa33b5e 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2024,6 +2024,8 @@ struct mac_iveiv_entry {
 	  (((__index) < 6) ? (HW_BEACON_BASE4 + ((__index - 4) * 0x0200)) : \
 	  (HW_BEACON_BASE6 - ((__index - 6) * 0x0200))))
 
+#define BEACON_BASE_TO_OFFSET(_base)	(((_base) - 0x4000) / 64)
+
 /*
  * BBP registers.
  * The wordsize of the BBP is 8 bits.
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 38606e2..20243dc 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -946,6 +946,12 @@ static unsigned int rt2800_hw_beacon_base(struct rt2x00_dev *rt2x00dev,
 	return HW_BEACON_BASE(index);
 }
 
+static inline u8 rt2800_get_beacon_offset(struct rt2x00_dev *rt2x00dev,
+					  unsigned int index)
+{
+	return BEACON_BASE_TO_OFFSET(rt2800_hw_beacon_base(rt2x00dev, index));
+}
+
 void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
@@ -4474,17 +4480,25 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		return ret;
 
 	rt2800_register_read(rt2x00dev, BCN_OFFSET0, &reg);
-	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN0, 0xe0); /* 0x3800 */
-	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN1, 0xe8); /* 0x3a00 */
-	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN2, 0xf0); /* 0x3c00 */
-	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN3, 0xf8); /* 0x3e00 */
+	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN0,
+			   rt2800_get_beacon_offset(rt2x00dev, 0));
+	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN1,
+			   rt2800_get_beacon_offset(rt2x00dev, 1));
+	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN2,
+			   rt2800_get_beacon_offset(rt2x00dev, 2));
+	rt2x00_set_field32(&reg, BCN_OFFSET0_BCN3,
+			   rt2800_get_beacon_offset(rt2x00dev, 3));
 	rt2800_register_write(rt2x00dev, BCN_OFFSET0, reg);
 
 	rt2800_register_read(rt2x00dev, BCN_OFFSET1, &reg);
-	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN4, 0xc8); /* 0x3200 */
-	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN5, 0xd0); /* 0x3400 */
-	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN6, 0x77); /* 0x1dc0 */
-	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN7, 0x6f); /* 0x1bc0 */
+	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN4,
+			   rt2800_get_beacon_offset(rt2x00dev, 4));
+	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN5,
+			   rt2800_get_beacon_offset(rt2x00dev, 5));
+	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN6,
+			   rt2800_get_beacon_offset(rt2x00dev, 6));
+	rt2x00_set_field32(&reg, BCN_OFFSET1_BCN7,
+			   rt2800_get_beacon_offset(rt2x00dev, 7));
 	rt2800_register_write(rt2x00dev, BCN_OFFSET1, reg);
 
 	rt2800_register_write(rt2x00dev, LEGACY_BASIC_RATE, 0x0000013f);
-- 
1.7.10
