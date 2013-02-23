Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:65302 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758602Ab3BWTk4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 14:40:56 -0500
Received: by mail-wg0-f54.google.com with SMTP id fm10so1368326wgb.33
        for <linux-wireless@vger.kernel.org>; Sat, 23 Feb 2013 11:40:54 -0800 (PST)
From: Michal Kazior <kazikcz@gmail.com>
To: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: Michal Kazior <kazikcz@gmail.com>
Subject: [PATCH] ath: sanitize 0xFFFF regdomain
Date: Sat, 23 Feb 2013 20:34:15 +0100
Message-Id: <1361648055-15871-1-git-send-email-kazikcz@gmail.com> (sfid-20130223_204111_590324_72DC3627)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dbii F52N-PRO mini pci device reports an invalid
regdomain. This card has been reported to work on
MikroTik's RouterOS but failed on Linux:

[   14.320000] ath: EEPROM regdomain: 0xffff
[   14.320000] ath: EEPROM indicates we should expect a country code
[   14.320000] ath: invalid regulatory domain/country code 0xbfff
[   14.320000] ath: Invalid EEPROM contents
[   14.320000] ath9k 0000:00:12.0: Failed to initialize device
[   14.330000] ath9k: probe of 0000:00:12.0 failed with error -22

With the patch the device works fine.

Signed-off-by: Michal Kazior <kazikcz@gmail.com>
---
 drivers/net/wireless/ath/regd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index ccc4c71..48fb1b9 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -533,10 +533,11 @@ ath_regd_init_wiphy(struct ath_regulatory *reg,
  * but since we have more than one user with it we need
  * a solution for them. We default to 0x64, which is the
  * default Atheros world regulatory domain.
+ * There is also at least one report of 0xFFFF being set.
  */
 static void ath_regd_sanitize(struct ath_regulatory *reg)
 {
-	if (reg->current_rd != COUNTRY_ERD_FLAG)
+	if (reg->current_rd != COUNTRY_ERD_FLAG && reg->current_rd != 0xFFFF)
 		return;
 	printk(KERN_DEBUG "ath: EEPROM regdomain sanitized\n");
 	reg->current_rd = 0x64;
-- 
1.7.12.4

