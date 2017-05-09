Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.148.194]:46928 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753357AbdEINEh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 09:04:37 -0400
Received: from cm4.websitewelcome.com (unknown [108.167.139.16])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 6E7E617EA
        for <linux-wireless@vger.kernel.org>; Tue,  9 May 2017 08:04:34 -0500 (CDT)
Date: Tue, 9 May 2017 08:04:30 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH v2] ath9k: remove unnecessary code
Message-ID: <20170509130430.GA22190@embeddedgus> (sfid-20170509_150508_909669_3F179888)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The array field eeprom_data in struct th9k_platform_data
is a fixed size array so it can never be NULL.

Addresses-Coverity-ID: 1364903
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
Changes in v2:
 Rephrase commit log.

 drivers/net/wireless/ath/ath9k/eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index fb80ec8..5c3bc28 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -143,7 +143,7 @@ bool ath9k_hw_nvram_read(struct ath_hw *ah, u32 off, u16 *data)
 
 	if (ah->eeprom_blob)
 		ret = ath9k_hw_nvram_read_firmware(ah->eeprom_blob, off, data);
-	else if (pdata && !pdata->use_eeprom && pdata->eeprom_data)
+	else if (pdata && !pdata->use_eeprom)
 		ret = ath9k_hw_nvram_read_pdata(pdata, off, data);
 	else
 		ret = common->bus_ops->eeprom_read(common, off, data);
-- 
2.5.0
