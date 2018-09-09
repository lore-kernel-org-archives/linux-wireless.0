Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41732 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbeIJBX7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 21:23:59 -0400
Received: by mail-wr1-f68.google.com with SMTP id z96-v6so19761406wrb.8
        for <linux-wireless@vger.kernel.org>; Sun, 09 Sep 2018 13:33:06 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 11/11] mt76x0: remove mt76x0_burst_write_regs()
Date: Sun,  9 Sep 2018 22:32:46 +0200
Message-Id: <20180909203246.21608-12-lorenzo.bianconi@redhat.com> (sfid-20180909_223312_069168_5FE9A2ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <sgruszka@redhat.com>

We don't need to use custom burst write regs via MCU, we can use
generic mt76_wr_copy() for the same purpose.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  | 25 ++++++----------
 .../net/wireless/mediatek/mt76/mt76x0/mcu.c   | 29 -------------------
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  3 --
 3 files changed, 9 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index a68161e1a2bf..7e415b361ad1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -249,7 +249,7 @@ static void mt76x0_init_mac_registers(struct mt76x0_dev *dev)
 static int mt76x0_init_wcid_mem(struct mt76x0_dev *dev)
 {
 	u32 *vals;
-	int i, ret;
+	int i;
 
 	vals = kmalloc(sizeof(*vals) * MT76_N_WCIDS * 2, GFP_KERNEL);
 	if (!vals)
@@ -260,25 +260,22 @@ static int mt76x0_init_wcid_mem(struct mt76x0_dev *dev)
 		vals[i * 2 + 1] = 0x00ffffff;
 	}
 
-	ret = mt76x0_burst_write_regs(dev, MT_WCID_ADDR_BASE,
-				      vals, MT76_N_WCIDS * 2);
+	mt76_wr_copy(dev, MT_WCID_ADDR_BASE, vals, MT76_N_WCIDS * 2);
 	kfree(vals);
-
-	return ret;
+	return 0;
 }
 
-static int mt76x0_init_key_mem(struct mt76x0_dev *dev)
+static void mt76x0_init_key_mem(struct mt76x0_dev *dev)
 {
 	u32 vals[4] = {};
 
-	return mt76x0_burst_write_regs(dev, MT_SKEY_MODE_BASE_0,
-					vals, ARRAY_SIZE(vals));
+	mt76_wr_copy(dev, MT_SKEY_MODE_BASE_0, vals, ARRAY_SIZE(vals));
 }
 
 static int mt76x0_init_wcid_attr_mem(struct mt76x0_dev *dev)
 {
 	u32 *vals;
-	int i, ret;
+	int i;
 
 	vals = kmalloc(sizeof(*vals) * MT76_N_WCIDS * 2, GFP_KERNEL);
 	if (!vals)
@@ -287,11 +284,9 @@ static int mt76x0_init_wcid_attr_mem(struct mt76x0_dev *dev)
 	for (i = 0; i < MT76_N_WCIDS * 2; i++)
 		vals[i] = 1;
 
-	ret = mt76x0_burst_write_regs(dev, MT_WCID_ATTR_BASE,
-				      vals, MT76_N_WCIDS * 2);
+	mt76_wr_copy(dev, MT_WCID_ATTR_BASE, vals, MT76_N_WCIDS * 2);
 	kfree(vals);
-
-	return ret;
+	return 0;
 }
 
 static void mt76x0_reset_counters(struct mt76x0_dev *dev)
@@ -443,9 +438,7 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
 	if (ret)
 		return ret;
 
-	ret = mt76x0_init_key_mem(dev);
-	if (ret)
-		return ret;
+	mt76x0_init_key_mem(dev);
 
 	ret = mt76x0_init_wcid_attr_mem(dev);
 	if (ret)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
index c14ae6c3e863..4a5739e056a7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
@@ -77,35 +77,6 @@ mt76x0_mcu_calibrate(struct mt76x0_dev *dev, enum mcu_calibrate cal, u32 val)
 	return mt76_mcu_send_msg(dev, skb, CMD_CALIBRATION_OP, true);
 }
 
-int mt76x0_burst_write_regs(struct mt76x0_dev *dev, u32 offset,
-			     const u32 *data, int n)
-{
-	const int max_regs_per_cmd = MT_INBAND_PACKET_MAX_LEN / 4 - 1;
-	struct sk_buff *skb;
-	int cnt, i, ret;
-
-	if (!n)
-		return 0;
-
-	cnt = min(max_regs_per_cmd, n);
-
-	skb = alloc_skb(cnt * 4 + MT_DMA_HDR_LEN + 4, GFP_KERNEL);
-	if (!skb)
-		return -ENOMEM;
-	skb_reserve(skb, MT_DMA_HDR_LEN);
-
-	skb_put_le32(skb, MT_MCU_MEMMAP_WLAN + offset);
-	for (i = 0; i < cnt; i++)
-		skb_put_le32(skb, data[i]);
-
-	ret = mt76_mcu_send_msg(dev, skb, CMD_BURST_WRITE, cnt == n);
-	if (ret)
-		return ret;
-
-	return mt76x0_burst_write_regs(dev, offset + cnt * 4,
-					data + cnt, n - cnt);
-}
-
 struct mt76_fw_header {
 	__le32 ilm_len;
 	__le32 dlm_len;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 92ecf4e8bda1..6aaa9a5b51db 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -126,9 +126,6 @@ void mt76x0_init_debugfs(struct mt76x0_dev *dev);
 #define mt76_rmw_field(_dev, _reg, _field, _val)	\
 	mt76_rmw(_dev, _reg, _field, FIELD_PREP(_field, _val))
 
-int mt76x0_burst_write_regs(struct mt76x0_dev *dev, u32 offset,
-			     const u32 *data, int n);
-
 /* Init */
 struct mt76x0_dev *
 mt76x0_alloc_device(struct device *pdev, const struct mt76_driver_ops *drv_ops);
-- 
2.18.0
