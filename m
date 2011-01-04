Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56345 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1ADHrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 02:47:39 -0500
Received: by iyi12 with SMTP id 12so12755573iyi.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jan 2011 23:47:39 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19746.53382.420251.297060@gargle.gargle.HOWL>
Date: Tue, 4 Jan 2011 13:17:18 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH 4/5] ath9k_htc: Add multiple register read API
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

This would decrease latency in reading bulk registers.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath.h                |    2 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   29 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h           |    3 ++
 3 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index e43210c..a6c6a46 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -108,12 +108,14 @@ enum ath_cipher {
  * struct ath_ops - Register read/write operations
  *
  * @read: Register read
+ * @multi_read: Multiple register read
  * @write: Register write
  * @enable_write_buffer: Enable multiple register writes
  * @write_flush: flush buffered register writes and disable buffering
  */
 struct ath_ops {
 	unsigned int (*read)(void *, u32 reg_offset);
+	void (*multi_read)(void *, u32 *addr, u32 *val, u16 count);
 	void (*write)(void *, u32 val, u32 reg_offset);
 	void (*enable_write_buffer)(void *);
 	void (*write_flush) (void *);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 9150ca6..f1c628e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -297,6 +297,34 @@ static unsigned int ath9k_regread(void *hw_priv, u32 reg_offset)
 	return be32_to_cpu(val);
 }
 
+static void ath9k_multi_regread(void *hw_priv, u32 *addr,
+				u32 *val, u16 count)
+{
+	struct ath_hw *ah = (struct ath_hw *) hw_priv;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *) common->priv;
+	__be32 tmpaddr[8];
+	__be32 tmpval[8];
+	int i, ret;
+
+       for (i = 0; i < count; i++) {
+	       tmpaddr[i] = cpu_to_be32(addr[i]);
+       }
+
+       ret = ath9k_wmi_cmd(priv->wmi, WMI_REG_READ_CMDID,
+			   (u8 *)tmpaddr , sizeof(u32) * count,
+			   (u8 *)tmpval, sizeof(u32) * count,
+			   100);
+	if (unlikely(ret)) {
+		ath_dbg(common, ATH_DBG_WMI,
+			"Multiple REGISTER READ FAILED (count: %d)\n", count);
+	}
+
+       for (i = 0; i < count; i++) {
+	       val[i] = be32_to_cpu(tmpval[i]);
+       }
+}
+
 static void ath9k_regwrite_single(void *hw_priv, u32 val, u32 reg_offset)
 {
 	struct ath_hw *ah = (struct ath_hw *) hw_priv;
@@ -407,6 +435,7 @@ static void ath9k_regwrite_flush(void *hw_priv)
 
 static const struct ath_ops ath9k_common_ops = {
 	.read = ath9k_regread,
+	.multi_read = ath9k_multi_regread,
 	.write = ath9k_regwrite,
 	.enable_write_buffer = ath9k_enable_regwrite_buffer,
 	.write_flush = ath9k_regwrite_flush,
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 5a3dfec..c2b3515 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -70,6 +70,9 @@
 #define REG_READ(_ah, _reg) \
 	ath9k_hw_common(_ah)->ops->read((_ah), (_reg))
 
+#define REG_READ_MULTI(_ah, _addr, _val, _cnt)		\
+	ath9k_hw_common(_ah)->ops->multi_read((_ah), (_addr), (_val), (_cnt))
+
 #define ENABLE_REGWRITE_BUFFER(_ah)					\
 	do {								\
 		if (ath9k_hw_common(_ah)->ops->enable_write_buffer)	\
-- 
1.7.3.4

