Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36611 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbcEBPoW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2016 11:44:22 -0400
Received: by mail-wm0-f54.google.com with SMTP id n129so112597085wmn.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 May 2016 08:44:21 -0700 (PDT)
From: Eduardo Abinader <eabinader@ocedo.com>
To: linux-wireless@vger.kernel.org
Cc: Eduardo Abinader <eduardo.abinader@riverbed.com>,
	ath9k-devel@lists.ath9k.org, kvalo@qca.qualcomm.com,
	ath9k-devel@qca.qualcomm.com
Subject: [PATCH] ath9k: Remove empty test condition
Date: Mon,  2 May 2016 17:44:11 +0200
Message-Id: <1462203851-20431-1-git-send-email-eduardo.abinader@riverbed.com> (sfid-20160502_174426_408257_185BD4CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just some code cleanup to remove an empty if clause.

Signed-off-by: Eduardo Abinader <eduardo.abinader@riverbed.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index f680982..eb206c1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3202,8 +3202,7 @@ static int ar9300_compress_decision(struct ath_hw *ah,
 			it, length);
 		break;
 	case _CompressBlock:
-		if (reference == 0) {
-		} else {
+		if (reference != 0) {
 			eep = ar9003_eeprom_struct_find_by_id(reference);
 			if (eep == NULL) {
 				ath_dbg(common, EEPROM,
-- 
2.5.0

