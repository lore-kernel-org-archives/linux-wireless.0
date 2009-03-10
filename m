Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:42110 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679AbZCJVaN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 17:30:13 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/6] iwlwifi: verify the antenna selection when receive fixed rate debugfs
Date: Tue, 10 Mar 2009 14:35:12 -0700
Message-Id: <1236720912-6502-7-git-send-email-reinette.chatre@intel.com> (sfid-20090310_223025_194393_E0C04487)
In-Reply-To: <1236720912-6502-6-git-send-email-reinette.chatre@intel.com>
References: <1236720912-6502-1-git-send-email-reinette.chatre@intel.com>
 <1236720912-6502-2-git-send-email-reinette.chatre@intel.com>
 <1236720912-6502-3-git-send-email-reinette.chatre@intel.com>
 <1236720912-6502-4-git-send-email-reinette.chatre@intel.com>
 <1236720912-6502-5-git-send-email-reinette.chatre@intel.com>
 <1236720912-6502-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When iwlwifi driver receive fixed rate debugfs command, validate the
antenna selection, if the selection is invalid, report the valid antenna
choice and do not set the rate scale table to fixed rate. Otherwise, set
the entire rate scale table to the fixed rate request by the user. this
validation can prevent sysassert happen in uCode

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 43c796b..cab7842 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2473,18 +2473,25 @@ static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
 			     u32 *rate_n_flags, int index)
 {
 	struct iwl_priv *priv;
+	u8 valid_tx_ant;
+	u8 ant_sel_tx;
 
 	priv = lq_sta->drv;
+	valid_tx_ant = priv->hw_params.valid_tx_ant;
 	if (lq_sta->dbg_fixed_rate) {
-		if (index < 12) {
+		ant_sel_tx =
+		  ((lq_sta->dbg_fixed_rate & RATE_MCS_ANT_ABC_MSK)
+		  >> RATE_MCS_ANT_POS);
+		if ((valid_tx_ant & ant_sel_tx) == ant_sel_tx) {
 			*rate_n_flags = lq_sta->dbg_fixed_rate;
+			IWL_DEBUG_RATE(priv, "Fixed rate ON\n");
 		} else {
-			if (lq_sta->band == IEEE80211_BAND_5GHZ)
-				*rate_n_flags = 0x800D;
-			else
-				*rate_n_flags = 0x820A;
+			lq_sta->dbg_fixed_rate = 0;
+			IWL_ERR(priv,
+			    "Invalid antenna selection 0x%X, Valid is 0x%X\n",
+			    ant_sel_tx, valid_tx_ant);
+			IWL_DEBUG_RATE(priv, "Fixed rate OFF\n");
 		}
-		IWL_DEBUG_RATE(priv, "Fixed rate ON\n");
 	} else {
 		IWL_DEBUG_RATE(priv, "Fixed rate OFF\n");
 	}
-- 
1.5.6.3

