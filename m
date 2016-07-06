Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33538 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932084AbcGFKpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:45:14 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Guenter Roeck <linux@roeck-us.net>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:17 +0300
Message-Id: <1467801651-1816-22-git-send-email-luca@coelho.fi> (sfid-20160706_124529_693722_645CFFD4)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 22/56] iwlwifi: dvm: Remove unused array 'iwlagn_loose_lookup'
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Guenter Roeck <linux@roeck-us.net>

gcc-6 reports the following error if -Werror=unused-const-variable
is enabled.

drivers/net/wireless/intel/iwlwifi/dvm/lib.c:210:21: error:
	'iwlagn_loose_lookup' defined but not used

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
index 8dda52a..6c2d6da 100644
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
2.8.1

