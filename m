Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:35173 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab3HSNL2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Aug 2013 09:11:28 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 6/6] rt2x00: rt2800lib: fix beacon generation on RT3593
Date: Mon, 19 Aug 2013 15:11:18 +0200
Message-Id: <1376917878-25094-7-git-send-email-juhosg@openwrt.org> (sfid-20130819_151136_234555_61D7F613)
In-Reply-To: <1376917878-25094-1-git-send-email-juhosg@openwrt.org>
References: <1376917878-25094-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On the RT3593 chipset, the beacon registers are located
in the high 8KB part of the shared memory.

The high part of the shared memory is only accessible
if it is explicitly selected. Add a helper function
in order to be able to control the SHR_MSEL bit in
the PBF_SYS_CTRL register. Also add a few more helper
functions and use those to select the correct part of
the shared memory before and after accessing the beacon
registers.

The base addresses of the beacon registers are also
different from the actually used values, so fix the
'rt2800_hw_beacon_base' function to return the correct
values.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
Changes since v1: ---
---
 drivers/net/wireless/rt2x00/rt2800.h    |    3 ++
 drivers/net/wireless/rt2x00/rt2800lib.c |   47 +++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 48018a5..67498b0 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -572,6 +572,7 @@
 #define PBF_SYS_CTRL			0x0400
 #define PBF_SYS_CTRL_READY		FIELD32(0x00000080)
 #define PBF_SYS_CTRL_HOST_RAM_WRITE	FIELD32(0x00010000)
+#define PBF_SYS_CTRL_SHR_MSEL		FIELD32(0x00080000)
 
 /*
  * HOST-MCU shared memory
@@ -2024,6 +2025,8 @@ struct mac_iveiv_entry {
 	  (((__index) < 6) ? (HW_BEACON_BASE4 + ((__index - 4) * 0x0200)) : \
 	  (HW_BEACON_BASE6 - ((__index - 6) * 0x0200))))
 
+#define HW_BEACON_BASE_HIGH(__index)	(0x4000 + (__index) * 512)
+
 #define BEACON_BASE_TO_OFFSET(_base)	(((_base) - 0x4000) / 64)
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 3bd0fae..13df86c 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -84,6 +84,42 @@ static inline bool rt2800_is_305x_soc(struct rt2x00_dev *rt2x00dev)
 	return false;
 }
 
+static inline void rt2800_shared_mem_select(struct rt2x00_dev *rt2x00dev,
+					    bool high)
+{
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+	u32 reg;
+
+	lockdep_assert_held(&drv_data->shared_mem_mutex);
+
+	if (WARN_ON_ONCE(!rt2800_has_high_shared_mem(rt2x00dev)))
+		return;
+
+	rt2800_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
+	rt2x00_set_field32(&reg, PBF_SYS_CTRL_SHR_MSEL, high);
+	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, reg);
+}
+
+static inline bool rt2800_beacon_uses_high_mem(struct rt2x00_dev *rt2x00dev)
+{
+	if (rt2x00_rt(rt2x00dev, RT3593))
+		return true;
+
+	return false;
+}
+
+static inline void rt2800_select_beacon_mem(struct rt2x00_dev *rt2x00dev)
+{
+	if (rt2800_beacon_uses_high_mem(rt2x00dev))
+		rt2800_shared_mem_select(rt2x00dev, true);
+}
+
+static inline void rt2800_deselect_beacon_mem(struct rt2x00_dev *rt2x00dev)
+{
+	if (rt2800_beacon_uses_high_mem(rt2x00dev))
+		rt2800_shared_mem_select(rt2x00dev, false);
+}
+
 static void rt2800_bbp_write(struct rt2x00_dev *rt2x00dev,
 			     const unsigned int word, const u8 value)
 {
@@ -951,6 +987,9 @@ EXPORT_SYMBOL_GPL(rt2800_txdone_entry);
 static unsigned int rt2800_hw_beacon_base(struct rt2x00_dev *rt2x00dev,
 					  unsigned int index)
 {
+	if (rt2x00_rt(rt2x00dev, RT3593))
+		return HW_BEACON_BASE_HIGH(index);
+
 	return HW_BEACON_BASE(index);
 }
 
@@ -1015,8 +1054,12 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 	beacon_base = rt2800_hw_beacon_base(rt2x00dev, entry->entry_idx);
 
 	rt2800_shared_mem_lock(rt2x00dev);
+
+	rt2800_select_beacon_mem(rt2x00dev);
 	rt2800_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
 				   entry->skb->len + padding_len);
+	rt2800_deselect_beacon_mem(rt2x00dev);
+
 	rt2800_shared_mem_unlock(rt2x00dev);
 
 	/*
@@ -1044,6 +1087,8 @@ static inline void rt2800_clear_beacon_register(struct rt2x00_dev *rt2x00dev,
 
 	rt2800_shared_mem_lock(rt2x00dev);
 
+	rt2800_select_beacon_mem(rt2x00dev);
+
 	/*
 	 * For the Beacon base registers we only need to clear
 	 * the whole TXWI which (when set to 0) will invalidate
@@ -1052,6 +1097,8 @@ static inline void rt2800_clear_beacon_register(struct rt2x00_dev *rt2x00dev,
 	for (i = 0; i < txwi_desc_size; i += sizeof(__le32))
 		rt2800_register_write(rt2x00dev, beacon_base + i, 0);
 
+	rt2800_deselect_beacon_mem(rt2x00dev);
+
 	rt2800_shared_mem_unlock(rt2x00dev);
 }
 
-- 
1.7.10
