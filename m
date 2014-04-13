Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:38131 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbaDMNDG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 09:03:06 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 13/13] iwlwifi: mvm: BT Coex - fix Look Up Table
Date: Sun, 13 Apr 2014 16:02:03 +0300
Message-Id: <1397394123-25102-13-git-send-email-egrumbach@gmail.com> (sfid-20140413_150341_586718_AF9E7790)
In-Reply-To: <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
References: <534A8A49.2030100@gmail.com>
 <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

A few entries were wrong and this caused throughput issues.

Cc: <stable@vger.kernel.org> [3.13+]
Fixes: dac94da8dba3 ("iwlwifi: mvm: new BT Coex API")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index f9c7b30..fa858d54 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -190,7 +190,7 @@ static const __le32 iwl_combined_lookup[BT_COEX_MAX_LUT][BT_COEX_LUT_SIZE] = {
 		cpu_to_le32(0xcc00aaaa),
 		cpu_to_le32(0x0000aaaa),
 		cpu_to_le32(0xc0004000),
-		cpu_to_le32(0x00000000),
+		cpu_to_le32(0x00004000),
 		cpu_to_le32(0xf0005000),
 		cpu_to_le32(0xf0005000),
 	},
@@ -213,16 +213,16 @@ static const __le32 iwl_combined_lookup[BT_COEX_MAX_LUT][BT_COEX_LUT_SIZE] = {
 		/* Tx Tx disabled */
 		cpu_to_le32(0xaaaaaaaa),
 		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xaaaaaaaa),
+		cpu_to_le32(0xeeaaaaaa),
 		cpu_to_le32(0xaaaaaaaa),
 		cpu_to_le32(0xcc00ff28),
 		cpu_to_le32(0x0000aaaa),
 		cpu_to_le32(0xcc00aaaa),
 		cpu_to_le32(0x0000aaaa),
-		cpu_to_le32(0xC0004000),
-		cpu_to_le32(0xC0004000),
-		cpu_to_le32(0xF0005000),
-		cpu_to_le32(0xF0005000),
+		cpu_to_le32(0xc0004000),
+		cpu_to_le32(0xc0004000),
+		cpu_to_le32(0xf0005000),
+		cpu_to_le32(0xf0005000),
 	},
 };
 
-- 
1.8.3.2

