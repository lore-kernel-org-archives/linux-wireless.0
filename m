Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31544 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbXI0Dez (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 23:34:55 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: add debugfs framework to rate scale
Date: Thu, 27 Sep 2007 11:27:37 +0800
Message-Id: <11908636753775-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11908636743625-git-send-email-yi.zhu@intel.com>
References: <11908636643693-git-send-email-yi.zhu@intel.com>
 <11908636662994-git-send-email-yi.zhu@intel.com>
 <11908636683204-git-send-email-yi.zhu@intel.com>
 <11908636692415-git-send-email-yi.zhu@intel.com>
 <119086367088-git-send-email-yi.zhu@intel.com>
 <11908636712746-git-send-email-yi.zhu@intel.com>
 <11908636732679-git-send-email-yi.zhu@intel.com>
 <11908636743625-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds debugfs handler to rate scale algorithms.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 86e650d..e849ab5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -1999,6 +1999,23 @@ static void rs_free_sta(void *priv, void *priv_sta)
 }
 
 
+#ifdef CONFIG_MAC80211_DEBUGFS
+static void rs_add_debugfs(void *priv, void *priv_sta,
+					struct dentry *dir)
+{
+	/* struct iwl_rate_scale_priv *rs_priv = priv_sta; */
+	IWL_DEBUG_RATE("%s enter\n", __FUNCTION__);
+	IWL_DEBUG_RATE("%s leave\n", __FUNCTION__);
+}
+
+static void rs_remove_debugfs(void *priv, void *priv_sta)
+{
+	/* struct iwl_rate_scale_priv *rs_priv = priv_sta; */
+	IWL_DEBUG_RATE("%s enter\n", __FUNCTION__);
+	IWL_DEBUG_RATE("%s leave\n", __FUNCTION__);
+}
+#endif
+
 static struct rate_control_ops rs_ops = {
 	.module = NULL,
 	.name = RS_NAME,
@@ -2010,6 +2027,10 @@ static struct rate_control_ops rs_ops = {
 	.free = rs_free,
 	.alloc_sta = rs_alloc_sta,
 	.free_sta = rs_free_sta,
+#ifdef CONFIG_MAC80211_DEBUGFS
+	.add_sta_debugfs = rs_add_debugfs,
+	.remove_sta_debugfs = rs_remove_debugfs,
+#endif
 };
 
 int iwl_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
-- 
1.5.1
