Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A7DC001DF
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Aug 2023 16:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbjHBQK6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Aug 2023 12:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbjHBQKy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2023 12:10:54 -0400
Received: from forward101a.mail.yandex.net (forward101a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F671982
        for <linux-wireless@vger.kernel.org>; Wed,  2 Aug 2023 09:10:52 -0700 (PDT)
Received: from mail-nwsmtp-smtp-production-main-84.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-84.vla.yp-c.yandex.net [IPv6:2a02:6b8:c0f:26a7:0:640:a2d5:0])
        by forward101a.mail.yandex.net (Yandex) with ESMTP id BD30942325;
        Wed,  2 Aug 2023 19:10:50 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-84.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id oAVvXtADYmI0-xASGPlUv;
        Wed, 02 Aug 2023 19:10:50 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1690992650;
        bh=hOr6+juFy7qQtvXFMCHsrF2u0f0pJFxqx11eHsNDV/4=;
        h=Message-ID:Date:Cc:Subject:To:From;
        b=wudDlGMudWLnhdJHOqEokkkDc6yYcv8e6ZgMGUcvgLaJ5JUARnnzPwKe3IRUj+WQn
         JrAU6W31qpV8S2DUc69ULR/xXKlgqnvpFW76tFVKSoRCjmZ0un8pQkVOvdlFP0pgSP
         33N2ropqhZxFPqEmgysHAjU5NlWQqVLDoPqZK5fg=
Authentication-Results: mail-nwsmtp-smtp-production-main-84.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From:   Dmitry Antipov <dmantipov@yandex.ru>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH 1/2] wifi: mwifiex: simplify PCIE DMA mapping management
Date:   Wed,  2 Aug 2023 19:09:33 +0300
Message-ID: <20230802161049.89326-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Simplify PCIE DMA mapping management by eliminating extra copies
of {address, size} pairs to/from temporary data structures. Map
and unmap operations may use skb fields directly via introduced
'MWIFIEX_SKB_DMA_ADDR()' and 'MWIFIEX_SKB_DMA_SIZE()' macros.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 14 +++++------
 drivers/net/wireless/marvell/mwifiex/util.h | 27 +++------------------
 2 files changed, 10 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 6697132ecc97..4c7c17fd2387 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -197,15 +197,14 @@ mwifiex_map_pci_memory(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 		       size_t size, int flags)
 {
 	struct pcie_service_card *card = adapter->card;
-	struct mwifiex_dma_mapping mapping;
 
-	mapping.addr = dma_map_single(&card->dev->dev, skb->data, size, flags);
-	if (dma_mapping_error(&card->dev->dev, mapping.addr)) {
+	MWIFIEX_SKB_DMA_ADDR(skb) = dma_map_single(&card->dev->dev, skb->data,
+						   size, flags);
+	if (dma_mapping_error(&card->dev->dev, MWIFIEX_SKB_DMA_ADDR(skb))) {
 		mwifiex_dbg(adapter, ERROR, "failed to map pci memory!\n");
 		return -1;
 	}
-	mapping.len = size;
-	mwifiex_store_mapping(skb, &mapping);
+	MWIFIEX_SKB_DMA_SIZE(skb) = size;
 	return 0;
 }
 
@@ -213,10 +212,9 @@ static void mwifiex_unmap_pci_memory(struct mwifiex_adapter *adapter,
 				     struct sk_buff *skb, int flags)
 {
 	struct pcie_service_card *card = adapter->card;
-	struct mwifiex_dma_mapping mapping;
 
-	mwifiex_get_mapping(skb, &mapping);
-	dma_unmap_single(&card->dev->dev, mapping.addr, mapping.len, flags);
+	dma_unmap_single(&card->dev->dev, MWIFIEX_SKB_DMA_ADDR(skb),
+			 MWIFIEX_SKB_DMA_SIZE(skb), flags);
 }
 
 /*
diff --git a/drivers/net/wireless/marvell/mwifiex/util.h b/drivers/net/wireless/marvell/mwifiex/util.h
index 4699c505c0a0..495f1a74b62d 100644
--- a/drivers/net/wireless/marvell/mwifiex/util.h
+++ b/drivers/net/wireless/marvell/mwifiex/util.h
@@ -53,30 +53,11 @@ static inline struct mwifiex_txinfo *MWIFIEX_SKB_TXCB(struct sk_buff *skb)
 	return &cb->tx_info;
 }
 
-static inline void mwifiex_store_mapping(struct sk_buff *skb,
-					 struct mwifiex_dma_mapping *mapping)
-{
-	struct mwifiex_cb *cb = (struct mwifiex_cb *)skb->cb;
-
-	memcpy(&cb->dma_mapping, mapping, sizeof(*mapping));
-}
-
-static inline void mwifiex_get_mapping(struct sk_buff *skb,
-				       struct mwifiex_dma_mapping *mapping)
-{
-	struct mwifiex_cb *cb = (struct mwifiex_cb *)skb->cb;
+#define MWIFIEX_SKB_DMA_ADDR(skb) \
+	(((struct mwifiex_cb *)((skb)->cb))->dma_mapping.addr)
 
-	memcpy(mapping, &cb->dma_mapping, sizeof(*mapping));
-}
-
-static inline dma_addr_t MWIFIEX_SKB_DMA_ADDR(struct sk_buff *skb)
-{
-	struct mwifiex_dma_mapping mapping;
-
-	mwifiex_get_mapping(skb, &mapping);
-
-	return mapping.addr;
-}
+#define MWIFIEX_SKB_DMA_SIZE(skb) \
+	(((struct mwifiex_cb *)((skb)->cb))->dma_mapping.len)
 
 int mwifiex_debug_info_to_buffer(struct mwifiex_private *priv, char *buf,
 				 struct mwifiex_debug_info *info);
-- 
2.41.0

