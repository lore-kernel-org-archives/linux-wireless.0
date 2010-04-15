Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32920 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365Ab0DOVjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:45 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH v3 67/97] ath9k_hw: rename eep_AR9287_ops to eep_ar9287_ops
Date: Thu, 15 Apr 2010 17:39:12 -0400
Message-Id: <1271367582-992-68-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.c      |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom.h      |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index 1a48f43..aec6ebb 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -257,7 +257,7 @@ int ath9k_hw_eeprom_init(struct ath_hw *ah)
 	int status;
 
 	if (AR_SREV_9287(ah)) {
-		ah->eep_ops = &eep_AR9287_ops;
+		ah->eep_ops = &eep_ar9287_ops;
 	} else if (AR_SREV_9285(ah) || AR_SREV_9271(ah)) {
 		ah->eep_ops = &eep_4k_ops;
 	} else {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index c0cd717..60fd5b6 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -707,6 +707,6 @@ int ath9k_hw_eeprom_init(struct ath_hw *ah);
 
 extern const struct eeprom_ops eep_def_ops;
 extern const struct eeprom_ops eep_4k_ops;
-extern const struct eeprom_ops eep_AR9287_ops;
+extern const struct eeprom_ops eep_ar9287_ops;
 
 #endif /* EEPROM_H */
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index e57c5b4..0b1e885 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -1170,7 +1170,7 @@ static u16 ath9k_hw_AR9287_get_spur_channel(struct ath_hw *ah,
 #undef EEP_MAP9287_SPURCHAN
 }
 
-const struct eeprom_ops eep_AR9287_ops = {
+const struct eeprom_ops eep_ar9287_ops = {
 	.check_eeprom		= ath9k_hw_AR9287_check_eeprom,
 	.get_eeprom		= ath9k_hw_AR9287_get_eeprom,
 	.fill_eeprom		= ath9k_hw_AR9287_fill_eeprom,
-- 
1.6.3.3

