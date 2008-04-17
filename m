Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6294 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbYDQXDm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 19:03:42 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/5] iwlwifi: export int iwl4965_set_pwr_src
Date: Thu, 17 Apr 2008 16:03:39 -0700
Message-Id: <1208473420-16550-5-git-send-email-reinette.chatre@intel.com> (sfid-20080418_000347_983563_71A73445)
In-Reply-To: <1208473420-16550-4-git-send-email-reinette.chatre@intel.com>
References: <1208473420-16550-1-git-send-email-reinette.chatre@intel.com>
 <1208473420-16550-2-git-send-email-reinette.chatre@intel.com>
 <1208473420-16550-3-git-send-email-reinette.chatre@intel.com>
 <1208473420-16550-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This handler is universal for most of the HW

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.h |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 890dfa4..2b9471f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -492,7 +492,7 @@ int iwl4965_hw_rxq_stop(struct iwl_priv *priv)
 	return 0;
 }
 
-static int iwl4965_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
+int iwl4965_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
 {
 	int ret;
 	unsigned long flags;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 8672c88..b8c86c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -674,6 +674,8 @@ extern unsigned int iwl4965_fill_beacon_frame(struct iwl_priv *priv,
 extern int iwl4965_rx_queue_update_write_ptr(struct iwl_priv *priv,
 					 struct iwl4965_rx_queue *q);
 extern __le16 *ieee80211_get_qos_ctrl(struct ieee80211_hdr *hdr);
+int iwl4965_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src);
+
 int iwl4965_init_geos(struct iwl_priv *priv);
 void iwl4965_free_geos(struct iwl_priv *priv);
 
-- 
1.5.3.4

