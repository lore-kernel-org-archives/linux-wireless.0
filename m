Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:55810 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753172AbeD3OMy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 10:12:54 -0400
Received: by mail-wm0-f68.google.com with SMTP id a8so13434083wmg.5
        for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2018 07:12:53 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [RFC 02/18] mt76x2: move mt76x2_fw_header and mt76x2_patch_header definitions in mcu.h
Date: Mon, 30 Apr 2018 16:12:17 +0200
Message-Id: <41e2b10a374b529afe6ebc4e015c53812f23b125.1525096206.git.lorenzo.bianconi@redhat.com> (sfid-20180430_161257_979549_D41271A4)
In-Reply-To: <cover.1525096206.git.lorenzo.bianconi@redhat.com>
References: <cover.1525096206.git.lorenzo.bianconi@redhat.com>
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
2.14.3
