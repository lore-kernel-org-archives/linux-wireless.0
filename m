Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14460 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbYEOF4a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 01:56:30 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Guy Cohen <guy.cohen@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 16/26] iwlwifi: don't switch to SGI if not supported by AP
Date: Thu, 15 May 2008 13:54:08 +0800
Message-Id: <1210830858-3410-17-git-send-email-yi.zhu@intel.com> (sfid-20080515_081615_693237_E3151ACC)
In-Reply-To: <1210830858-3410-16-git-send-email-yi.zhu@intel.com>
References: <1210830858-3410-1-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-2-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-3-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-4-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-5-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-6-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-7-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-8-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-9-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-10-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-11-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-12-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-13-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-14-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-15-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-16-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch fixes SGI support. RS didn't look at the capabilities of the AP
before switching to SGI, this should lead to a stall in the traffic with an
AP that doesn't support SGI.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Guy Cohen  <guy.cohen@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |   18 ++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    4 ++--
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 071c7b6..2adc228 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -1439,6 +1439,15 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 			}
 			break;
 		case IWL_SISO_SWITCH_GI:
+			if (!tbl->is_fat &&
+				!(priv->current_ht_config.sgf &
+						HT_SHORT_GI_20MHZ))
+				break;
+			if (tbl->is_fat &&
+				!(priv->current_ht_config.sgf &
+						HT_SHORT_GI_40MHZ))
+				break;
+
 			IWL_DEBUG_RATE("LQ: SISO toggle SGI/NGI\n");
 
 			memcpy(search_tbl, tbl, sz);
@@ -1521,6 +1530,15 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 			break;
 
 		case IWL_MIMO_SWITCH_GI:
+			if (!tbl->is_fat &&
+				!(priv->current_ht_config.sgf &
+						HT_SHORT_GI_20MHZ))
+				break;
+			if (tbl->is_fat &&
+				!(priv->current_ht_config.sgf &
+						HT_SHORT_GI_40MHZ))
+				break;
+
 			IWL_DEBUG_RATE("LQ: MIMO toggle SGI/NGI\n");
 
 			/* Set up new search table for MIMO */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4106efd..7a54682 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -610,8 +610,8 @@ struct iwl_hw_params {
 #endif
 };
 
-#define HT_SHORT_GI_20MHZ_ONLY	(1 << 0)
-#define HT_SHORT_GI_40MHZ_ONLY	(1 << 1)
+#define HT_SHORT_GI_20MHZ	(1 << 0)
+#define HT_SHORT_GI_40MHZ	(1 << 1)
 
 
 #define IWL_RX_HDR(x) ((struct iwl4965_rx_frame_hdr *)(\
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index dd2fd40..a532a9e 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -700,9 +700,9 @@ static void iwl4965_ht_conf(struct iwl_priv *priv,
 	priv->ps_mode = (u8)((ht_conf->cap & IEEE80211_HT_CAP_MIMO_PS) >> 2);
 
 	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_20)
-		iwl_conf->sgf |= 0x1;
+		iwl_conf->sgf |= HT_SHORT_GI_20MHZ;
 	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_40)
-		iwl_conf->sgf |= 0x2;
+		iwl_conf->sgf |= HT_SHORT_GI_40MHZ;
 
 	iwl_conf->is_green_field = !!(ht_conf->cap & IEEE80211_HT_CAP_GRN_FLD);
 	iwl_conf->max_amsdu_size =
-- 
1.5.3.6

