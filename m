Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52887 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759620Ab2EPUyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:54:37 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/9] iwlwifi: move IWL_CMD_FAILED_MSK
Date: Wed, 16 May 2012 22:54:26 +0200
Message-Id: <1337201670-21604-6-git-send-email-johannes@sipsolutions.net> (sfid-20120516_225500_947966_AD819D34)
In-Reply-To: <1337201670-21604-1-git-send-email-johannes@sipsolutions.net>
References: <1337201670-21604-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is common, not uCode API specific, so move
it to the transport together with the command
header struct definition.

Reviewed-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Reviewed-by: Guy Cohen <guy.cohen@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    3 ---
 drivers/net/wireless/iwlwifi/iwl-trans.h    |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 9af6a23..b9f7361 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -197,9 +197,6 @@ enum {
  *
  *****************************************************************************/
 
-/* iwl_cmd_header flags value */
-#define IWL_CMD_FAILED_MSK 0x40
-
 /**
  * iwlagn rate_n_flags bit fields
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 78b89f1..0aeeb7c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -154,6 +154,9 @@ struct iwl_cmd_header {
 	__le16 sequence;
 } __packed;
 
+/* iwl_cmd_header flags value */
+#define IWL_CMD_FAILED_MSK 0x40
+
 
 #define FH_RSCSR_FRAME_SIZE_MSK		0x00003FFF	/* bits 0-13 */
 #define FH_RSCSR_FRAME_INVALID		0x55550000
-- 
1.7.10

