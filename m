Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774AbZFLUPv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 16:15:51 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/8 v2.6.31 and w-t ] iwlwifi: check control channel for pure 40MHz
Date: Fri, 12 Jun 2009 13:22:50 -0700
Message-Id: <1244838175-15491-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1244838175-15491-3-git-send-email-reinette.chatre@intel.com>
References: <1244838175-15491-1-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-2-git-send-email-reinette.chatre@intel.com>
 <1244838175-15491-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

for pure 40MHz mode, set the control channel location if provided, but not
like Mixed mode; if information is not provided, still allow 40MHz
operation.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index b2875fe..b122eed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -826,9 +826,18 @@ void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
 			 RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK);
 	if (iwl_is_fat_tx_allowed(priv, NULL)) {
 		/* pure 40 fat */
-		if (ht_info->ht_protection == IEEE80211_HT_OP_MODE_PROTECTION_20MHZ)
+		if (ht_info->ht_protection == IEEE80211_HT_OP_MODE_PROTECTION_20MHZ) {
 			rxon->flags |= RXON_FLG_CHANNEL_MODE_PURE_40;
-		else {
+			/* Note: control channel is opposite of extension channel */
+			switch (ht_info->extension_chan_offset) {
+			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+				rxon->flags &= ~RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK;
+				break;
+			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+				rxon->flags |= RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK;
+				break;
+			}
+		} else {
 			/* Note: control channel is opposite of extension channel */
 			switch (ht_info->extension_chan_offset) {
 			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-- 
1.5.6.3

