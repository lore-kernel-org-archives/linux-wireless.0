Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41077 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbeIRRoa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 13:44:30 -0400
Received: by mail-wr1-f68.google.com with SMTP id z96-v6so1832187wrb.8
        for <linux-wireless@vger.kernel.org>; Tue, 18 Sep 2018 05:12:10 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org
Subject: [PATCH] mt76: usb: remove WARN_ON in mt76u_get_rx_entry_len
Date: Tue, 18 Sep 2018 14:12:05 +0200
Message-Id: <c9d8d73f3353c2ad953d8a298c52a32922ed2bcc.1537272524.git.lorenzo.bianconi@redhat.com> (sfid-20180918_141227_572635_3C019727)
In-Reply-To: <cover.1537272524.git.lorenzo.bianconi@redhat.com>
References: <cover.1537272524.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove not useful WARN_ON macros in mt76u_get_rx_entry_len routine
since corrupted frames should just be silently discarded

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 7780b07543bb..81f036b3df86 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -326,9 +326,9 @@ static int mt76u_get_rx_entry_len(u8 *data, u32 data_len)
 	min_len = MT_DMA_HDR_LEN + MT_RX_RXWI_LEN +
 		  MT_FCE_INFO_LEN;
 
-	if (data_len < min_len || WARN_ON(!dma_len) ||
-	    WARN_ON(dma_len + MT_DMA_HDR_LEN > data_len) ||
-	    WARN_ON(dma_len & 0x3))
+	if (data_len < min_len || !dma_len ||
+	    dma_len + MT_DMA_HDR_LEN > data_len ||
+	    (dma_len & 0x3))
 		return -EINVAL;
 	return dma_len;
 }
-- 
2.17.1
