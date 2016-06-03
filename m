Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:35161 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980AbcFCVjY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 17:39:24 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linuxwifi@intel.com, Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] iwlwifi: Remove unused array 'iwlagn_loose_lookup'
Date: Fri,  3 Jun 2016 14:39:19 -0700
Message-Id: <1464989959-2021-1-git-send-email-linux@roeck-us.net> (sfid-20160603_234016_500754_9DDBBA01)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gcc-6 reports the following error if -Werror=unused-const-variable
is enabled.

drivers/net/wireless/intel/iwlwifi/dvm/lib.c:210:21: error:
	'iwlagn_loose_lookup' defined but not used

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
index 8dda52ae3bb5..6c2d6da7eec6 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
@@ -205,23 +205,6 @@ static const __le32 iwlagn_def_3w_lookup[IWLAGN_BT_DECISION_LUT_SIZE] = {
 	cpu_to_le32(0xf0005000),
 };
 
-
-/* Loose Coex */
-static const __le32 iwlagn_loose_lookup[IWLAGN_BT_DECISION_LUT_SIZE] = {
-	cpu_to_le32(0xaaaaaaaa),
-	cpu_to_le32(0xaaaaaaaa),
-	cpu_to_le32(0xaeaaaaaa),
-	cpu_to_le32(0xaaaaaaaa),
-	cpu_to_le32(0xcc00ff28),
-	cpu_to_le32(0x0000aaaa),
-	cpu_to_le32(0xcc00aaaa),
-	cpu_to_le32(0x0000aaaa),
-	cpu_to_le32(0x00000000),
-	cpu_to_le32(0x00000000),
-	cpu_to_le32(0xf0005000),
-	cpu_to_le32(0xf0005000),
-};
-
 /* Full concurrency */
 static const __le32 iwlagn_concurrent_lookup[IWLAGN_BT_DECISION_LUT_SIZE] = {
 	cpu_to_le32(0xaaaaaaaa),
-- 
2.5.0

