Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:38170 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751056AbeAWHlY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Jan 2018 02:41:24 -0500
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [PATCH 1/4] ath9k: Alternative EEPROM size for AR9003
Date: Tue, 23 Jan 2018 08:35:22 +0100
Message-Id: <1516692925-6695-2-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20180123_084132_019412_013B6343)
In-Reply-To: <1516692925-6695-1-git-send-email-Wojciech.Dubowik@neratec.com>
References: <1516692925-6695-1-git-send-email-Wojciech.Dubowik@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9003 factory calibration allows to use bigger EEPROM than
standard 1k without changing the default layout. Allow
probing of EEPROM at alternative address if initial check
for default fails.
The original ar9003 eeprom ops are still be used.

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index c2e210c..23bb677 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3310,6 +3310,12 @@ static int ar9300_eeprom_restore_internal(struct ath_hw *ah,
 	if (ar9300_check_eeprom_header(ah, read, cptr))
 		goto found;
 
+	cptr = AR9300_BASE_ADDR_4K;
+	ath_dbg(common, EEPROM, "Trying EEPROM access at Address 0x%04x\n",
+		cptr);
+	if (ar9300_check_eeprom_header(ah, read, cptr))
+		goto found;
+
 	cptr = AR9300_BASE_ADDR_512;
 	ath_dbg(common, EEPROM, "Trying EEPROM access at Address 0x%04x\n",
 		cptr);
-- 
2.7.4
