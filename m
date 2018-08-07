Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34480 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726951AbeHGK4f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Aug 2018 06:56:35 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] mt76x0: correct type for eeprom gain value
Date: Tue,  7 Aug 2018 10:43:09 +0200
Message-Id: <1533631389-417-1-git-send-email-sgruszka@redhat.com> (sfid-20180807_104331_159088_DC25644E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change type to u8 to allow sanity check agaist 0xff;

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: e87b5039511a ("mt76x0: eeprom files")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 1ecd018f12b8..9ea5f5ebd3be 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -241,7 +241,7 @@
 static void
 mt76x0_set_lna_gain(struct mt76x0_dev *dev, u8 *eeprom)
 {
-	s8 gain;
+	u8 gain;
 
 	dev->ee->lna_gain_2ghz = eeprom[MT_EE_LNA_GAIN_2GHZ];
 	dev->ee->lna_gain_5ghz[0] = eeprom[MT_EE_LNA_GAIN_5GHZ_0];
-- 
1.9.3
