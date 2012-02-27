Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:45594 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab2B0XTJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:09 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 19/24] iwlwifi: remove iwl_reset_traffic_log from shared
Date: Mon, 27 Feb 2012 14:07:43 -0800
Message-Id: <1330380468-17674-20-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_001924_455261_D66B0332)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

It is op_mode related

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h   |    2 ++
 drivers/net/wireless/iwlwifi/iwl-shared.h |    4 ----
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 930e247..42630f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -197,6 +197,8 @@ const char *get_ctrl_string(int cmd);
 void iwl_clear_traffic_stats(struct iwl_priv *priv);
 void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc,
 		      u16 len);
+void iwl_reset_traffic_log(struct iwl_priv *priv);
+
 #else
 static inline int iwl_alloc_traffic_mem(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 5140c78..a644162 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -553,10 +553,6 @@ void __releases(wait_entry)
 iwl_remove_notification(struct iwl_shared *shrd,
 			   struct iwl_notification_wait *wait_entry);
 
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-void iwl_reset_traffic_log(struct iwl_priv *priv);
-#endif /* CONFIG_IWLWIFI_DEBUGFS */
-
 #define IWL_CMD(x) case x: return #x
 #define IWL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
 
-- 
1.7.0.4

