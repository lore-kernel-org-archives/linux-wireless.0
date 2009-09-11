Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49357 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755727AbZIKRiV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 13:38:21 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/13 v2.6.32 and w-t] iwlwifi: find the correct first antenna
Date: Fri, 11 Sep 2009 10:38:18 -0700
Message-Id: <1252690699-25796-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
References: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

We can not assume antenna "A" is the first valid anttena for
all the NIC. Need to make sure choice the correct antenna based on
h/w configuration for transmit to avoid sending frame on invalid
antenna

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 9d0758a..18af37c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -760,6 +760,7 @@ static u32 rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
 	u16 high_low;
 	u8 switch_to_legacy = 0;
 	u8 is_green = lq_sta->is_green;
+	struct iwl_priv *priv = lq_sta->drv;
 
 	/* check if we need to switch from HT to legacy rates.
 	 * assumption is that mandatory rates (1Mbps or 6Mbps)
@@ -773,7 +774,8 @@ static u32 rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
 			tbl->lq_type = LQ_G;
 
 		if (num_of_ant(tbl->ant_type) > 1)
-			tbl->ant_type = ANT_A;/*FIXME:RS*/
+			tbl->ant_type =
+				first_antenna(priv->hw_params.valid_tx_ant);
 
 		tbl->is_ht40 = 0;
 		tbl->is_SGI = 0;
-- 
1.5.6.3

