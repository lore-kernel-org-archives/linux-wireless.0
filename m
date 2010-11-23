Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2765 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448Ab0KWTE3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:04:29 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/5] iwlagn: name change for BT config flag
Date: Tue, 23 Nov 2010 10:58:52 -0800
Message-Id: <1290538736-10816-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1290538736-10816-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1290538736-10816-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bit 7 of BT config flag is used to enable/disable PSPoll sync.
Make the name to match it.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 9c1b7fb..4028ed3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2439,8 +2439,9 @@ struct iwl_bt_cmd {
 #define IWLAGN_BT_FLAG_COEX_MODE_3W		2
 #define IWLAGN_BT_FLAG_COEX_MODE_4W		3
 
-#define IWLAGN_BT_FLAG_UCODE_DEFAULT	BIT(6)
-#define IWLAGN_BT_FLAG_NOCOEX_NOTIF	BIT(7)
+#define IWLAGN_BT_FLAG_UCODE_DEFAULT		BIT(6)
+/* Disable Sync PSPoll on SCO/eSCO */
+#define IWLAGN_BT_FLAG_SYNC_2_BT_DISABLE	BIT(7)
 
 #define IWLAGN_BT_PRIO_BOOST_MAX	0xFF
 #define IWLAGN_BT_PRIO_BOOST_MIN	0x00
-- 
1.7.0.4

