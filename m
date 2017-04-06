Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37827 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752211AbdDFFMo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 01:12:44 -0400
Date: Thu, 6 Apr 2017 08:12:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Gabor Juhos <juhosg@openwrt.org>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] ath9k: off by one in ath9k_hw_nvram_read_array()
Message-ID: <20170406051220.GA23650@mwanda> (sfid-20170406_071307_767292_77EA2EC6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The > should be >= or we read one space beyond the end of the array.

Fixes: ab5c4f71d8c7 ("ath9k: allow to load EEPROM content via firmware API")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index fb80ec86e53d..6ccf24814514 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -112,7 +112,7 @@ void ath9k_hw_usb_gen_fill_eeprom(struct ath_hw *ah, u16 *eep_data,
 static bool ath9k_hw_nvram_read_array(u16 *blob, size_t blob_size,
 				      off_t offset, u16 *data)
 {
-	if (offset > blob_size)
+	if (offset >= blob_size)
 		return false;
 
 	*data =  blob[offset];
