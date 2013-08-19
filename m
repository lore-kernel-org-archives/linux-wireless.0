Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:35174 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab3HSNL1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Aug 2013 09:11:27 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 5/6] rt2x00: rt2800lib: don't hardcode beacon offsets
Date: Mon, 19 Aug 2013 15:11:17 +0200
Message-Id: <1376917878-25094-6-git-send-email-juhosg@openwrt.org> (sfid-20130819_151135_011994_85B3CCBD)
In-Reply-To: <1376917878-25094-1-git-send-email-juhosg@openwrt.org>
References: <1376917878-25094-1-git-send-email-juhosg@openwrt.org>
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
Changes since v1: ---
---
 drivers/net/wireless/rt2x00/rt2800.h    |    2 ++
 drivers/net/wireless/rt2x00/rt2800lib.c |   30 ++++++++++++++++++++++--------
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 426129a..48018a5 100644
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
index 18a95e3..3bd0fae 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -954,6 +954,12 @@ static unsigned int rt2800_hw_beacon_base(struct rt2x00_dev *rt2x00dev,
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
@@ -4505,17 +4511,25 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
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
