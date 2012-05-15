Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42488 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757113Ab2EOHmf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 03:42:35 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/1] ath9k: Fix modal EERPOM dump
Date: Tue, 15 May 2012 12:56:10 +0530
Message-ID: <1337066770-22978-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120515_094239_492013_A324E109)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

we provide excess buffer size for 'simple_read_from_buffer'
for modal EEPROM dump. This results in trailing NULL bytes
at the end of EEPROM dump, fix this.

Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Reported-by: Holger Schurig <holgerschurig@googlemail.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    4 ++--
 drivers/net/wireless/ath/ath9k/eeprom_4k.c     |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c    |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index ac53d90..868f30f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3412,11 +3412,11 @@ static u32 ath9k_hw_ar9003_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
 	if (!dump_base_hdr) {
 		len += snprintf(buf + len, size - len,
 				"%20s :\n", "2GHz modal Header");
-		len += ar9003_dump_modal_eeprom(buf, len, size,
+		len = ar9003_dump_modal_eeprom(buf, len, size,
 						&eep->modalHeader2G);
 		len += snprintf(buf + len, size - len,
 				"%20s :\n", "5GHz modal Header");
-		len += ar9003_dump_modal_eeprom(buf, len, size,
+		len = ar9003_dump_modal_eeprom(buf, len, size,
 						&eep->modalHeader5G);
 		goto out;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 4322ac8..a850f44 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -135,7 +135,7 @@ static u32 ath9k_hw_4k_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
 	if (!dump_base_hdr) {
 		len += snprintf(buf + len, size - len,
 				"%20s :\n", "2GHz modal Header");
-		len += ath9k_dump_4k_modal_eeprom(buf, len, size,
+		len = ath9k_dump_4k_modal_eeprom(buf, len, size,
 						  &eep->modalHeader);
 		goto out;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index aa61476..cd742fb 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -132,7 +132,7 @@ static u32 ath9k_hw_ar9287_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
 	if (!dump_base_hdr) {
 		len += snprintf(buf + len, size - len,
 				"%20s :\n", "2GHz modal Header");
-		len += ar9287_dump_modal_eeprom(buf, len, size,
+		len = ar9287_dump_modal_eeprom(buf, len, size,
 						&eep->modalHeader);
 		goto out;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index b5fba8b..56290f3 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -211,11 +211,11 @@ static u32 ath9k_hw_def_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
 	if (!dump_base_hdr) {
 		len += snprintf(buf + len, size - len,
 				"%20s :\n", "2GHz modal Header");
-		len += ath9k_def_dump_modal_eeprom(buf, len, size,
+		len = ath9k_def_dump_modal_eeprom(buf, len, size,
 						   &eep->modalHeader[0]);
 		len += snprintf(buf + len, size - len,
 				"%20s :\n", "5GHz modal Header");
-		len += ath9k_def_dump_modal_eeprom(buf, len, size,
+		len = ath9k_def_dump_modal_eeprom(buf, len, size,
 						   &eep->modalHeader[1]);
 		goto out;
 	}
-- 
1.7.0.4

