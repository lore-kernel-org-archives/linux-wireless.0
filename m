Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:47936 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750945AbdAMVTf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:19:35 -0500
Date: Fri, 13 Jan 2017 22:19:25 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 02/40] rt2x00: rt2800lib: introduce
 RT2800_HAS_HIGH_SHARED_MEM flag
Message-ID: <20170113211914.GA3357@makrotopia.org> (sfid-20170113_221937_398236_B8CEF191)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Some chipsets have more than 16KB of shared memory.
Introduce a new rt2800 specific flag to indicate that
and add a helper function which helps to check the
presence of the new flag.

Also enable the new flag for the RT3593 chipset which
has 24KB of shared memory. The flag can also be used
for other chipsets, but none of those has been tested
yet.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |  4 ++++
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h | 13 +++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 5436cdb07937..5045af1b0dc9 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -7770,6 +7770,7 @@ static int rt2800_probe_rt(struct rt2x00_dev *rt2x00dev)
 
 int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
 	int retval;
 	u32 reg;
 
@@ -7777,6 +7778,9 @@ int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev)
 	if (retval)
 		return retval;
 
+	if (rt2x00_rt(rt2x00dev, RT3593))
+		__set_bit(RT2800_HAS_HIGH_SHARED_MEM, &drv_data->rt2800_flags);
+
 	/*
 	 * Allocate eeprom data.
 	 */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
index 256928f0ea6a..4ee424dfe23f 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
@@ -22,6 +22,10 @@
 
 #include "rt2800.h"
 
+enum rt2800_flag {
+	RT2800_HAS_HIGH_SHARED_MEM,
+};
+
 /* RT2800 driver data structure */
 struct rt2800_drv_data {
 	u8 calibration_bw20;
@@ -34,6 +38,8 @@ struct rt2800_drv_data {
 	unsigned int tbtt_tick;
 	unsigned int ampdu_factor_cnt[4];
 	DECLARE_BITMAP(sta_ids, STA_IDS_SIZE);
+
+	unsigned long rt2800_flags;
 };
 
 struct rt2800_ops {
@@ -66,6 +72,13 @@ struct rt2800_ops {
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
2.11.0
