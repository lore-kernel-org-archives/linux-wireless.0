Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63540 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbYJ2VF1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 17:05:27 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/7] iwlwifi: iwl-agn-rs: initialize rs with valid antenna
Date: Wed, 29 Oct 2008 14:05:48 -0700
Message-Id: <1225314349-11139-7-git-send-email-reinette.chatre@intel.com> (sfid-20081029_220538_716866_519D188F)
In-Reply-To: <1225314349-11139-6-git-send-email-reinette.chatre@intel.com>
References: <>
 <1225314349-11139-1-git-send-email-reinette.chatre@intel.com>
 <1225314349-11139-2-git-send-email-reinette.chatre@intel.com>
 <1225314349-11139-3-git-send-email-reinette.chatre@intel.com>
 <1225314349-11139-4-git-send-email-reinette.chatre@intel.com>
 <1225314349-11139-5-git-send-email-reinette.chatre@intel.com>
 <1225314349-11139-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch fix rate scaling initialization. Rate scaling
was initialized always with B antenna.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 4ba3163..af68709 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2073,15 +2073,13 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 	if ((i < 0) || (i >= IWL_RATE_COUNT))
 		i = 0;
 
-	/* FIXME:RS: This is also wrong in 4965 */
 	rate = iwl_rates[i].plcp;
-	rate |= RATE_MCS_ANT_B_MSK;
-	rate &= ~RATE_MCS_ANT_A_MSK;
+	tbl->ant_type = first_antenna(valid_tx_ant);
+	rate |= tbl->ant_type << RATE_MCS_ANT_POS;
 
 	if (i >= IWL_FIRST_CCK_RATE && i <= IWL_LAST_CCK_RATE)
 		rate |= RATE_MCS_CCK_MSK;
 
-	tbl->ant_type = ANT_B;
 	rs_get_tbl_info_from_mcs(rate, priv->band, tbl, &rate_idx);
 	if (!rs_is_valid_ant(valid_tx_ant, tbl->ant_type))
 	    rs_toggle_antenna(valid_tx_ant, &rate, tbl);
-- 
1.5.4.3

