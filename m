Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:35164 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab3HSNLZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Aug 2013 09:11:25 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 2/6] rt2x00: rt2800lib: introduce RT2800_HAS_HIGH_SHARED_MEM flag
Date: Mon, 19 Aug 2013 15:11:14 +0200
Message-Id: <1376917878-25094-3-git-send-email-juhosg@openwrt.org> (sfid-20130819_151134_346684_64AC22C1)
In-Reply-To: <1376917878-25094-1-git-send-email-juhosg@openwrt.org>
References: <1376917878-25094-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some chipsets have more than 16KB of shared memory.
Introduce a new rt2800 specific flag to indicate that
and add a helper function which helps to check the
presence of the new flag.

Also enable the new flag for the RT3593 chipset which
has 24KB of shared memory. The flag can also be used
for other chipsets, but none of those has been tested
yet.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
Changes since v1:
  - don't enable the new flag for RT3071 and RT5592
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++++
 drivers/net/wireless/rt2x00/rt2800lib.h |   13 +++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index aa6b6b0..94da67c 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -7697,6 +7697,7 @@ static int rt2800_probe_rt(struct rt2x00_dev *rt2x00dev)
 
 int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
 	int retval;
 	u32 reg;
 
@@ -7704,6 +7705,9 @@ int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev)
 	if (retval)
 		return retval;
 
+	if (rt2x00_rt(rt2x00dev, RT3593))
+		__set_bit(RT2800_HAS_HIGH_SHARED_MEM, &drv_data->rt2800_flags);
+
 	/*
 	 * Allocate eeprom data.
 	 */
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 9b3e8ef..f89d413 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -22,6 +22,10 @@
 #ifndef RT2800LIB_H
 #define RT2800LIB_H
 
+enum rt2800_flag {
+	RT2800_HAS_HIGH_SHARED_MEM,
+};
+
 /* RT2800 driver data structure */
 struct rt2800_drv_data {
 	u8 calibration_bw20;
@@ -31,6 +35,8 @@ struct rt2800_drv_data {
 	u8 txmixer_gain_24g;
 	u8 txmixer_gain_5g;
 	unsigned int tbtt_tick;
+
+	unsigned long rt2800_flags;
 };
 
 struct rt2800_ops {
@@ -63,6 +69,13 @@ struct rt2800_ops {
 	__le32 *(*drv_get_txwi)(struct queue_entry *entry);
 };
 
+static inline bool rt2800_has_high_shared_mem(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+
+	return test_bit(RT2800_HAS_HIGH_SHARED_MEM, &drv_data->rt2800_flags);
+}
+
 static inline void rt2800_register_read(struct rt2x00_dev *rt2x00dev,
 					const unsigned int offset,
 					u32 *value)
-- 
1.7.10
