Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.149.72]:39989 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751213AbdEIEd5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 00:33:57 -0400
Received: from cm6.websitewelcome.com (cm6.websitewelcome.com [108.167.139.19])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 36277392178
        for <linux-wireless@vger.kernel.org>; Mon,  8 May 2017 22:48:16 -0500 (CDT)
Date: Mon, 8 May 2017 22:48:14 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] net: wireless: ath: ath9k: remove unnecessary code
Message-ID: <20170509034814.GA18034@embeddedgus> (sfid-20170509_063406_544576_511628E0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The name of an array used by itself will always return the array's address.
So this test will always evaluate as true.

Addresses-Coverity-ID: 1364903
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
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
