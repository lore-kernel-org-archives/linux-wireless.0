Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:42341 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751815AbeFJKvf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Jun 2018 06:51:35 -0400
Received: by mail-wr0-f194.google.com with SMTP id w10-v6so17421480wrk.9
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jun 2018 03:51:35 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [RFC v3 02/19] mt76x2: move mt76x2_fw_header and mt76x2_patch_header definitions in mcu.h
Date: Sun, 10 Jun 2018 12:51:09 +0200
Message-Id: <20180610105126.28425-3-lorenzo.bianconi@redhat.com> (sfid-20180610_125217_900320_95AE6ED8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move mt76x2_fw_header and mt76x2_patch_header definitions in mcu.h in
order to reuse them in mt76x2u mcu related code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c | 17 -----------------
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
index 3e2a7216ffdd..ba954e7bc426 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
@@ -23,23 +23,6 @@
 #include "mt76x2_dma.h"
 #include "mt76x2_eeprom.h"
 
-struct mt76x2_fw_header {
-	__le32 ilm_len;
-	__le32 dlm_len;
-	__le16 build_ver;
-	__le16 fw_ver;
-	u8 pad[4];
-	char build_time[16];
-};
-
-struct mt76x2_patch_header {
-	char build_time[16];
-	char platform[4];
-	char hw_version[4];
-	char patch_version[4];
-	u8 pad[2];
-};
-
 static struct sk_buff *mt76x2_mcu_msg_alloc(const void *data, int len)
 {
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h
index d7a7e83262ce..e40293f21417 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h
@@ -146,6 +146,23 @@ struct mt76x2_tssi_comp {
 	u8 offset1;
 } __packed __aligned(4);
 
+struct mt76x2_fw_header {
+	__le32 ilm_len;
+	__le32 dlm_len;
+	__le16 build_ver;
+	__le16 fw_ver;
+	u8 pad[4];
+	char build_time[16];
+};
+
+struct mt76x2_patch_header {
+	char build_time[16];
+	char platform[4];
+	char hw_version[4];
+	char patch_version[4];
+	u8 pad[2];
+};
+
 int mt76x2_mcu_calibrate(struct mt76x2_dev *dev, enum mcu_calibration type,
 			 u32 param);
 int mt76x2_mcu_tssi_comp(struct mt76x2_dev *dev, struct mt76x2_tssi_comp *tssi_data);
-- 
2.17.1
