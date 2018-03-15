Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:55595 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751929AbeCORY0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 13:24:26 -0400
Received: by mail-wm0-f65.google.com with SMTP id q83so11987468wme.5
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2018 10:24:25 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: use mt76_poll_msec routine in mt76pci_load_firmware()
Date: Thu, 15 Mar 2018 18:24:20 +0100
Message-Id: <b2abf42bbd5e5f41082bd17df018dcb203aa2f86.1521128408.git.lorenzo.bianconi@redhat.com> (sfid-20180315_182429_828869_1CFEE3C6)
In-Reply-To: <cover.1521128408.git.lorenzo.bianconi@redhat.com>
References: <cover.1521128408.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use mt76_poll_msec() in mt76pci_load_firmware to check if the firmware
has been started instead of explicitly poll MCU running register

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
index 15820b11f9db..dfd36d736b06 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
@@ -187,7 +187,7 @@ mt76pci_load_firmware(struct mt76x2_dev *dev)
 {
 	const struct firmware *fw;
 	const struct mt76x2_fw_header *hdr;
-	int i, len, ret;
+	int len, ret;
 	__le32 *cur;
 	u32 offset, val;
 
@@ -240,16 +240,7 @@ mt76pci_load_firmware(struct mt76x2_dev *dev)
 
 	/* trigger firmware */
 	mt76_wr(dev, MT_MCU_INT_LEVEL, 2);
-	for (i = 200; i > 0; i--) {
-		val = mt76_rr(dev, MT_MCU_COM_REG0);
-
-		if (val & 1)
-			break;
-
-		msleep(10);
-	}
-
-	if (!i) {
+	if (!mt76_poll_msec(dev, MT_MCU_COM_REG0, 1, 1, 200)) {
 		dev_err(dev->mt76.dev, "Firmware failed to start\n");
 		release_firmware(fw);
 		return -ETIMEDOUT;
-- 
2.14.3
