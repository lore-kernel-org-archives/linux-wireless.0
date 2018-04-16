Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:38216 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751172AbeDPXGM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 19:06:12 -0400
Received: by mail-wr0-f194.google.com with SMTP id h3so17729113wrh.5
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2018 16:06:12 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2: fix TXD_INFO bitmask definition
Date: Tue, 17 Apr 2018 01:05:59 +0200
Message-Id: <20180416230559.11268-1-lorenzo.bianconi@redhat.com> (sfid-20180417_010616_253698_EDF89C2B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Despite this issue is not harmful since it is not actually used in
mt76 driver, fix DMA txinfo bitmask definition

Fixes: 7bc04215a66b ('mt76: add driver code for MT76x2e')
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.h b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.h
index 47f79d83fcb4..e9d426bbf91a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.h
@@ -19,7 +19,7 @@
 
 #include "dma.h"
 
-#define MT_TXD_INFO_LEN			GENMASK(13, 0)
+#define MT_TXD_INFO_LEN			GENMASK(15, 0)
 #define MT_TXD_INFO_NEXT_VLD		BIT(16)
 #define MT_TXD_INFO_TX_BURST		BIT(17)
 #define MT_TXD_INFO_80211		BIT(19)
@@ -27,9 +27,8 @@
 #define MT_TXD_INFO_CSO			BIT(21)
 #define MT_TXD_INFO_WIV			BIT(24)
 #define MT_TXD_INFO_QSEL		GENMASK(26, 25)
-#define MT_TXD_INFO_TCO			BIT(29)
-#define MT_TXD_INFO_UCO			BIT(30)
-#define MT_TXD_INFO_ICO			BIT(31)
+#define MT_TXD_INFO_DPORT		GENMASK(29, 27)
+#define MT_TXD_INFO_TYPE		GENMASK(31, 30)
 
 #define MT_RX_FCE_INFO_LEN		GENMASK(13, 0)
 #define MT_RX_FCE_INFO_SELF_GEN		BIT(15)
-- 
2.16.3
