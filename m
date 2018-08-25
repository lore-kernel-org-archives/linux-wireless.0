Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42624 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbeHYOTy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Aug 2018 10:19:54 -0400
Received: by mail-wr1-f67.google.com with SMTP id v17-v6so9438579wrr.9
        for <linux-wireless@vger.kernel.org>; Sat, 25 Aug 2018 03:41:19 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 15/16] mt76x0: use mt76u_mcu_fw_send_data for fw uploading
Date: Sat, 25 Aug 2018 12:40:55 +0200
Message-Id: <20180825104056.9130-16-lorenzo.bianconi@redhat.com> (sfid-20180825_124130_934286_E460229C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use mt76u_mcu_fw_send_data utility routine for firmware uploading and
remove unused __mt76x0_dma_fw/mt76x0_dma_fw functions

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/mcu.c   | 88 ++-----------------
 1 file changed, 6 insertions(+), 82 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
index d49557834658..0a0deaf1c65d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
@@ -239,83 +239,9 @@ struct mt76_fw {
 	u8 ilm[];
 };
 
-static int __mt76x0_dma_fw(struct mt76x0_dev *dev,
-			    const struct mt76x0_dma_buf *dma_buf,
-			    const void *data, u32 len, u32 dst_addr)
-{
-	DECLARE_COMPLETION_ONSTACK(cmpl);
-	struct mt76x0_dma_buf buf = *dma_buf; /* we need to fake length */
-	__le32 reg;
-	u32 val;
-	int ret;
-
-	reg = cpu_to_le32(FIELD_PREP(MT_TXD_INFO_TYPE, DMA_COMMAND) |
-			  FIELD_PREP(MT_TXD_INFO_D_PORT, CPU_TX_PORT) |
-			  FIELD_PREP(MT_TXD_INFO_LEN, len));
-	memcpy(buf.buf, &reg, sizeof(reg));
-	memcpy(buf.buf + sizeof(reg), data, len);
-	memset(buf.buf + sizeof(reg) + len, 0, 8);
-
-	mt76u_single_wr(&dev->mt76, MT_VEND_WRITE_FCE, MT_FCE_DMA_ADDR,
-			dst_addr);
-
-	len = roundup(len, 4);
-	mt76u_single_wr(&dev->mt76, MT_VEND_WRITE_FCE, MT_FCE_DMA_LEN,
-			len << 16);
-
-	buf.len = MT_DMA_HDR_LEN + len + 4;
-	ret = mt76x0_usb_submit_buf(dev, USB_DIR_OUT, MT_EP_OUT_INBAND_CMD,
-				     &buf, GFP_KERNEL,
-				     mt76u_mcu_complete_urb, &cmpl);
-	if (ret)
-		return ret;
-
-	if (!wait_for_completion_timeout(&cmpl, msecs_to_jiffies(1000))) {
-		dev_err(dev->mt76.dev, "Error: firmware upload timed out\n");
-		usb_kill_urb(buf.urb);
-		return -ETIMEDOUT;
-	}
-	if (mt76x0_urb_has_error(buf.urb)) {
-		dev_err(dev->mt76.dev, "Error: firmware upload urb failed:%d\n",
-			buf.urb->status);
-		return buf.urb->status;
-	}
-
-	val = mt76_rr(dev, MT_TX_CPU_FROM_FCE_CPU_DESC_IDX);
-	val++;
-	mt76_wr(dev, MT_TX_CPU_FROM_FCE_CPU_DESC_IDX, val);
-
-	msleep(5);
-
-	return 0;
-}
-
-static int
-mt76x0_dma_fw(struct mt76x0_dev *dev, struct mt76x0_dma_buf *dma_buf,
-	       const void *data, int len, u32 dst_addr)
-{
-	int n, ret;
-
-	if (len == 0)
-		return 0;
-
-	n = min(MCU_FW_URB_MAX_PAYLOAD, len);
-	ret = __mt76x0_dma_fw(dev, dma_buf, data, n, dst_addr);
-	if (ret)
-		return ret;
-
-#if 0
-	if (!mt76_poll_msec(dev, MT_MCU_COM_REG1, BIT(31), BIT(31), 500))
-		return -ETIMEDOUT;
-#endif
-
-	return mt76x0_dma_fw(dev, dma_buf, data + n, len - n, dst_addr + n);
-}
-
 static int
 mt76x0_upload_firmware(struct mt76x0_dev *dev, const struct mt76_fw *fw)
 {
-	struct mt76x0_dma_buf dma_buf;
 	void *ivb;
 	u32 ilm_len, dlm_len;
 	int i, ret;
@@ -323,22 +249,21 @@ mt76x0_upload_firmware(struct mt76x0_dev *dev, const struct mt76_fw *fw)
 	ivb = kmemdup(fw->ivb, sizeof(fw->ivb), GFP_KERNEL);
 	if (!ivb)
 		return -ENOMEM;
-	if (mt76x0_usb_alloc_buf(dev, MCU_FW_URB_SIZE, &dma_buf)) {
-		ret = -ENOMEM;
-		goto error;
-	}
 
 	ilm_len = le32_to_cpu(fw->hdr.ilm_len) - sizeof(fw->ivb);
 	dev_dbg(dev->mt76.dev, "loading FW - ILM %u + IVB %zu\n",
 		ilm_len, sizeof(fw->ivb));
-	ret = mt76x0_dma_fw(dev, &dma_buf, fw->ilm, ilm_len, sizeof(fw->ivb));
+	ret = mt76u_mcu_fw_send_data(&dev->mt76, fw->ilm, ilm_len,
+				     MCU_FW_URB_MAX_PAYLOAD,
+				     sizeof(fw->ivb));
 	if (ret)
 		goto error;
 
 	dlm_len = le32_to_cpu(fw->hdr.dlm_len);
 	dev_dbg(dev->mt76.dev, "loading FW - DLM %u\n", dlm_len);
-	ret = mt76x0_dma_fw(dev, &dma_buf, fw->ilm + ilm_len,
-			     dlm_len, MT_MCU_DLM_OFFSET);
+	ret = mt76u_mcu_fw_send_data(&dev->mt76, fw->ilm + ilm_len,
+				     dlm_len, MCU_FW_URB_MAX_PAYLOAD,
+				     MT_MCU_DLM_OFFSET);
 	if (ret)
 		goto error;
 
@@ -359,7 +284,6 @@ mt76x0_upload_firmware(struct mt76x0_dev *dev, const struct mt76_fw *fw)
 	dev_dbg(dev->mt76.dev, "Firmware running!\n");
 error:
 	kfree(ivb);
-	mt76x0_usb_free_buf(dev, &dma_buf);
 
 	return ret;
 }
-- 
2.18.0
