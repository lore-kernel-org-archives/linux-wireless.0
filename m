Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33953 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbeHXOQK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:16:10 -0400
Received: by mail-wr1-f67.google.com with SMTP id g33-v6so7095818wrd.1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Aug 2018 03:42:06 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: verify evt type in usb mcu response
Date: Fri, 24 Aug 2018 12:41:44 +0200
Message-Id: <56664707fd600dc2ff49c6e845b0d573a9cf9c89.1535106415.git.lorenzo.bianconi@redhat.com> (sfid-20180824_124209_848368_F33DBE44)
In-Reply-To: <cover.1535106415.git.lorenzo.bianconi@redhat.com>
References: <cover.1535106415.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Verify if evt field is set to EVT_CMD_DONE in usb mcu
response messages

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/dma.h     | 10 ++++++++++
 drivers/net/wireless/mediatek/mt76/usb_mcu.c |  3 ++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.h b/drivers/net/wireless/mediatek/mt76/dma.h
index 27248e24a19b..828e52ae70e8 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.h
+++ b/drivers/net/wireless/mediatek/mt76/dma.h
@@ -75,6 +75,16 @@ enum dma_msg_port {
 	DISCARD,
 };
 
+enum mt76_mcu_evt_type {
+	EVT_CMD_DONE,
+	EVT_CMD_ERROR,
+	EVT_CMD_RETRY,
+	EVT_EVENT_PWR_RSP,
+	EVT_EVENT_WOW_RSP,
+	EVT_EVENT_CARRIER_DETECT_RSP,
+	EVT_EVENT_DFS_DETECT_RSP,
+};
+
 int mt76_dma_attach(struct mt76_dev *dev);
 void mt76_dma_cleanup(struct mt76_dev *dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
index 070be803d463..ebf3e7ffb26b 100644
--- a/drivers/net/wireless/mediatek/mt76/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
@@ -73,7 +73,8 @@ static int mt76u_mcu_wait_resp(struct mt76_dev *dev, u8 seq)
 		if (ret)
 			return ret;
 
-		if (seq == FIELD_GET(MT_RX_FCE_INFO_CMD_SEQ, rxfce))
+		if (seq == FIELD_GET(MT_RX_FCE_INFO_CMD_SEQ, rxfce) &&
+		    FIELD_GET(MT_RX_FCE_INFO_EVT_TYPE, rxfce) == EVT_CMD_DONE)
 			return 0;
 
 		dev_err(dev->dev, "error: MCU resp evt:%lx seq:%hhx-%lx\n",
-- 
2.17.1
