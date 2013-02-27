Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:35507 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab3B0TJh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 14:09:37 -0500
Received: by mail-ea0-f174.google.com with SMTP id 1so76360eaa.33
        for <linux-wireless@vger.kernel.org>; Wed, 27 Feb 2013 11:09:35 -0800 (PST)
From: Michal Kazior <kazikcz@gmail.com>
To: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: Michal Kazior <kazikcz@gmail.com>
Subject: [PATCH v2] ath: sanitize 0xFFFF regdomain
Date: Wed, 27 Feb 2013 20:09:32 +0100
Message-Id: <1361992172-4590-1-git-send-email-kazikcz@gmail.com> (sfid-20130227_200941_339966_E7D23A59)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Apparently some Dbii F52N-PRO mini pci devices
have been intentionally programemd with a 0xFFFF
regdomain. This is incorrect and unsupported by
QCA.

The patch sanitizes the 0xFFFF regdomain with 0x64
which is the most restrictive custom world
regulatory domain in the ath module.

This card has been reported to work on MikroTik's
RouterOS but failed on Linux with the following:

[   14.320000] ath: EEPROM regdomain: 0xffff
[   14.320000] ath: EEPROM indicates we should expect a country code
[   14.320000] ath: invalid regulatory domain/country code 0xbfff
[   14.320000] ath: Invalid EEPROM contents
[   14.320000] ath9k 0000:00:12.0: Failed to initialize device
[   14.330000] ath9k: probe of 0000:00:12.0 failed with error -22

With the patch the device works fine.

Signed-off-by: Michal Kazior <kazikcz@gmail.com>
---
v2: updated commit message as suggested by Luis

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
1.8.1.4

