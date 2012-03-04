Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51544 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019Ab2CDUnC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:02 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 028/101] iwlwifi: move traffic log definitions
Date: Sun,  4 Mar 2012 11:28:42 -0800
Message-Id: <1330889395-533-29-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214343_955724_EC68A506)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These are DVM specific, and shouldn't be
in iwl-shared.h.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h   |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-shared.h |    3 ---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 42630f5..db44115 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -265,6 +265,10 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 
 #define IWL_SCAN_CHECK_WATCHDOG		(HZ * 7)
 
+/* traffic log definitions */
+#define IWL_TRAFFIC_ENTRIES	(256)
+#define IWL_TRAFFIC_ENTRY_SIZE  (64)
+
 /*****************************************************
  *   S e n d i n g     H o s t     C o m m a n d s   *
  *****************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 976e6c5..b816e70 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -445,9 +445,6 @@ iwl_remove_notification(struct iwl_shared *shrd,
 
 #define IWL_CMD(x) case x: return #x
 
-#define IWL_TRAFFIC_ENTRIES	(256)
-#define IWL_TRAFFIC_ENTRY_SIZE  (64)
-
 /*****************************************************
 * DRIVER STATUS FUNCTIONS
 ******************************************************/
-- 
1.7.0.4

