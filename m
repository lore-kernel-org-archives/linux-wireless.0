Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15047 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab0KYBia (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 20:38:30 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/12] iwlagn: advertise reliable TX status
Date: Wed, 24 Nov 2010 17:32:41 -0800
Message-Id: <1290648768-10075-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Our hardware has reliable TX status, but we're
not currently advertising that to mac80211.
Since the packet loss monitoring will depend
on it, advertise it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5b96b0d..50cee2b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3175,7 +3175,8 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_AMPDU_AGGREGATION |
 		    IEEE80211_HW_NEED_DTIM_PERIOD |
-		    IEEE80211_HW_SPECTRUM_MGMT;
+		    IEEE80211_HW_SPECTRUM_MGMT |
+		    IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
 	if (!priv->cfg->base_params->broken_powersave)
 		hw->flags |= IEEE80211_HW_SUPPORTS_PS |
-- 
1.7.0.4

