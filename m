Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:53636 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbdAMVUl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:20:41 -0500
Date: Fri, 13 Jan 2017 22:20:32 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 04/40] rt2x00: rt2800lib: fix beacon generation on RT3593
Message-ID: <20170113212027.GA3372@makrotopia.org> (sfid-20170113_222044_027498_EEA8B23B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

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
 drivers/net/wireless/ralink/rt2x00/rt2800.h    |  3 ++
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 44 ++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800.h b/drivers/net/wireless/ralink/rt2x00/rt2800.h
index 2371896c1e99..a81852cfb4f9 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800.h
@@ -574,6 +574,7 @@
 #define PBF_SYS_CTRL			0x0400
 #define PBF_SYS_CTRL_READY		FIELD32(0x00000080)
 #define PBF_SYS_CTRL_HOST_RAM_WRITE	FIELD32(0x00010000)
+#define PBF_SYS_CTRL_SHR_MSEL		FIELD32(0x00080000)
 
 /*
  * HOST-MCU shared memory
@@ -2026,6 +2027,8 @@ struct mac_iveiv_entry {
 	  (((__index) < 6) ? (HW_BEACON_BASE4 + ((__index - 4) * 0x0200)) : \
 	  (HW_BEACON_BASE6 - ((__index - 6) * 0x0200))))
 
+#define HW_BEACON_BASE_HIGH(__index)	(0x4000 + (__index) * 512)
+
 #define BEACON_BASE_TO_OFFSET(_base)	(((_base) - 0x4000) / 64)
 
 /*
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 0fd67026f806..dcacfa54b3d6 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -82,6 +82,39 @@ static inline bool rt2800_is_305x_soc(struct rt2x00_dev *rt2x00dev)
 	return false;
 }
 
+static inline void rt2800_shared_mem_select(struct rt2x00_dev *rt2x00dev,
+					    bool high)
+{
+	u32 reg;
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
@@ -948,6 +981,9 @@ EXPORT_SYMBOL_GPL(rt2800_txdone_entry);
 static unsigned int rt2800_hw_beacon_base(struct rt2x00_dev *rt2x00dev,
 					  unsigned int index)
 {
+	if (rt2x00_rt(rt2x00dev, RT3593))
+		return HW_BEACON_BASE_HIGH(index);
+
 	return HW_BEACON_BASE(index);
 }
 
@@ -1046,8 +1082,12 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 	beacon_base = rt2800_hw_beacon_base(rt2x00dev, entry->entry_idx);
 
 	rt2800_shared_mem_lock(rt2x00dev);
+
+	rt2800_select_beacon_mem(rt2x00dev);
 	rt2800_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
 				   entry->skb->len + padding_len);
+	rt2800_deselect_beacon_mem(rt2x00dev);
+
 	rt2800_shared_mem_unlock(rt2x00dev);
 	__set_bit(ENTRY_BCN_ENABLED, &entry->flags);
 
@@ -1080,6 +1120,8 @@ static inline void rt2800_clear_beacon_register(struct rt2x00_dev *rt2x00dev,
 
 	rt2800_shared_mem_lock(rt2x00dev);
 
+	rt2800_select_beacon_mem(rt2x00dev);
+
 	/*
 	 * For the Beacon base registers we only need to clear
 	 * the whole TXWI which (when set to 0) will invalidate
@@ -1088,6 +1130,8 @@ static inline void rt2800_clear_beacon_register(struct rt2x00_dev *rt2x00dev,
 	for (i = 0; i < txwi_desc_size; i += sizeof(__le32))
 		rt2800_register_write(rt2x00dev, beacon_base + i, 0);
 
+	rt2800_deselect_beacon_mem(rt2x00dev);
+
 	rt2800_shared_mem_unlock(rt2x00dev);
 }
 
-- 
2.11.0
