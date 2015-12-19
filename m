Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27184 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbbLSK7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Dec 2015 05:59:44 -0500
Date: Sat, 19 Dec 2015 13:59:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net, kernel-janitors@vger.kernel.org
Subject: [patch -next] ath9k: fix ath9k_hw_nvram_check_version()
Message-ID: <20151219105919.GB3749@mwanda> (sfid-20151219_115951_243040_2CC8641D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a type bug so it always returns success.

Fixes: 6fa658fd5ab2 ('ath9k: Simplify and fix eeprom endianness swapping')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index f8c5065..a7afdee 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -206,7 +206,7 @@ bool ath9k_hw_nvram_check_version(struct ath_hw *ah, int version, int minrev)
 		ath_err(common, "Bad EEPROM VER 0x%04x or REV 0x%04x\n",
 			ah->eep_ops->get_eeprom_ver(ah),
 			ah->eep_ops->get_eeprom_rev(ah));
-		return -EINVAL;
+		return false;
 	}
 
 	return true;
