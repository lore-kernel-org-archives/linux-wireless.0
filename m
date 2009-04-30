Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17738 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027AbZD3UuQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 16:50:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/5] iwlwifi: "is_fat" bit in rate scale match RXON flag
Date: Thu, 30 Apr 2009 13:56:28 -0700
Message-Id: <1241124991-12492-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1241124991-12492-3-git-send-email-reinette.chatre@intel.com>
References: <1241124991-12492-1-git-send-email-reinette.chatre@intel.com>
 <1241124991-12492-2-git-send-email-reinette.chatre@intel.com>
 <1241124991-12492-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

This patch change the "is_fat" checking in rate scale to use
iwl_is_fat_tx_allowed() to match the sta and RX_ON command setting.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Tested-by: Conrad Kostecki <ConiKost@gmx.de>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 3504279..5c758d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1207,8 +1207,7 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 	tbl->action = 0;
 	rate_mask = lq_sta->active_mimo2_rate;
 
-	if (priv->current_ht_config.supported_chan_width
-					== IWL_CHANNEL_WIDTH_40MHZ)
+	if (iwl_is_fat_tx_allowed(priv, &sta->ht_cap))
 		tbl->is_fat = 1;
 	else
 		tbl->is_fat = 0;
@@ -1273,8 +1272,7 @@ static int rs_switch_to_mimo3(struct iwl_priv *priv,
 	tbl->action = 0;
 	rate_mask = lq_sta->active_mimo3_rate;
 
-	if (priv->current_ht_config.supported_chan_width
-					== IWL_CHANNEL_WIDTH_40MHZ)
+	if (iwl_is_fat_tx_allowed(priv, &sta->ht_cap))
 		tbl->is_fat = 1;
 	else
 		tbl->is_fat = 0;
@@ -1332,8 +1330,7 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 	tbl->action = 0;
 	rate_mask = lq_sta->active_siso_rate;
 
-	if (priv->current_ht_config.supported_chan_width
-	    == IWL_CHANNEL_WIDTH_40MHZ)
+	if (iwl_is_fat_tx_allowed(priv, &sta->ht_cap))
 		tbl->is_fat = 1;
 	else
 		tbl->is_fat = 0;
-- 
1.5.6.3

