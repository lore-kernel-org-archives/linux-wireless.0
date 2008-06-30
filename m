Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34532 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302AbYF3J0V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:26:21 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 04/33] iwlwifi: use iwl_is_associated when possible
Date: Mon, 30 Jun 2008 17:23:04 +0800
Message-Id: <1214817813-17639-5-git-send-email-yi.zhu@intel.com> (sfid-20080630_112625_541798_9783E112)
In-Reply-To: <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch add uses of iwl_is_associated in places it is suitable in.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 92d1b2e..fe60319 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -970,7 +970,7 @@ static int iwl3945_full_rxon_required(struct iwl3945_priv *priv)
 {
 
 	/* These items are only settable from the full RXON command */
-	if (!(priv->active_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) ||
+	if (!(iwl3945_is_associated(priv)) ||
 	    compare_ether_addr(priv->staging_rxon.bssid_addr,
 			       priv->active_rxon.bssid_addr) ||
 	    compare_ether_addr(priv->staging_rxon.node_addr,
@@ -6836,7 +6836,7 @@ static void iwl3945_config_ap(struct iwl3945_priv *priv)
 		return;
 
 	/* The following should be done only at AP bring up */
-	if ((priv->active_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) == 0) {
+	if (!(iwl3945_is_associated(priv))) {
 
 		/* RXON - unassoc (to set timing command) */
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 1558b9a..a2dffe4 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -192,7 +192,7 @@ static int iwl4965_full_rxon_required(struct iwl_priv *priv)
 {
 
 	/* These items are only settable from the full RXON command */
-	if (!(priv->active_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) ||
+	if (!(iwl_is_associated(priv)) ||
 	    compare_ether_addr(priv->staging_rxon.bssid_addr,
 			       priv->active_rxon.bssid_addr) ||
 	    compare_ether_addr(priv->staging_rxon.node_addr,
@@ -3008,7 +3008,7 @@ static void iwl4965_config_ap(struct iwl_priv *priv)
 		return;
 
 	/* The following should be done only at AP bring up */
-	if ((priv->active_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) == 0) {
+	if (!(iwl_is_associated(priv))) {
 
 		/* RXON - unassoc (to set timing command) */
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
-- 
1.5.3.6

