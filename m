Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37084 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab2IJROy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 13:14:54 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/6] iwlwifi: fix indentation in iwl_load_given_ucode
Date: Mon, 10 Sep 2012 19:15:27 +0200
Message-Id: <1347297330-23338-4-git-send-email-johannes@sipsolutions.net> (sfid-20120910_191459_117772_E426B60F)
In-Reply-To: <1347297330-23338-1-git-send-email-johannes@sipsolutions.net>
References: <1347297330-23338-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's a block of code that's indented too
far, move it out to where it should be.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 7da075f..3f11b17 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -979,17 +979,16 @@ static int iwl_load_section(struct iwl_trans *trans, u8 section_num,
 static int iwl_load_given_ucode(struct iwl_trans *trans,
 				const struct fw_img *image)
 {
-	int ret = 0;
-		int i;
+	int i, ret = 0;
 
-		for (i = 0; i < IWL_UCODE_SECTION_MAX; i++) {
-			if (!image->sec[i].p_addr)
-				break;
+	for (i = 0; i < IWL_UCODE_SECTION_MAX; i++) {
+		if (!image->sec[i].p_addr)
+			break;
 
-			ret = iwl_load_section(trans, i, &image->sec[i]);
-			if (ret)
-				return ret;
-		}
+		ret = iwl_load_section(trans, i, &image->sec[i]);
+		if (ret)
+			return ret;
+	}
 
 	/* Remove all resets to allow NIC to operate */
 	iwl_write32(trans, CSR_RESET, 0);
-- 
1.7.10.4

