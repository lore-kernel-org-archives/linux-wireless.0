Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24096 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbYEECYH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:07 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 03/25] iwlwifi: don't override association channel with control channel
Date: Mon,  5 May 2008 10:22:30 +0800
Message-Id: <1209954172-3092-4-git-send-email-yi.zhu@intel.com> (sfid-20080505_042355_491135_2E1B9814)
In-Reply-To: <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes override of association channel with HT control channel.
The scenario is currently happening because disassociation flow
doesn't clean previous association information (such as is_ht and control
channel).

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 20c5deb..ca33346 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3772,10 +3772,10 @@ void iwl4965_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
 				 RXON_FLG_CHANNEL_MODE_PURE_40_MSK);
 
 	if (le16_to_cpu(rxon->channel) != ht_info->control_channel) {
-		IWL_DEBUG_ASSOC("control diff than current %d %d\n",
+		IWL_ERROR("control diff than current %d %d\n",
 				le16_to_cpu(rxon->channel),
 				ht_info->control_channel);
-		rxon->channel = cpu_to_le16(ht_info->control_channel);
+		WARN_ON(1);
 		return;
 	}
 
-- 
1.5.3.6

