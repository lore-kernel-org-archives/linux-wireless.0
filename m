Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:50693 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbYIZHOU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 03:14:20 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/3] iwlwifi: enable power save setting upon config
Date: Fri, 26 Sep 2008 15:09:33 +0800
Message-Id: <1222412974-18221-2-git-send-email-yi.zhu@intel.com> (sfid-20080926_091423_947295_7616E5D0)
In-Reply-To: <1222412974-18221-1-git-send-email-yi.zhu@intel.com>
References: <1222412974-18221-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ester Kummer <ester.kummer@intel.com>

This patch enables power save setting from config (iwconfig power)
The sysfs power_level interface is still preserved as it has
mac80211 power implementation is not yet rich enough.

Signed-off-by: Ester Kummer <ester.kummer@intel.com>
Reviewed-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7330890..a589f7e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2875,6 +2875,13 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 		goto out;
 	}
 
+	if (conf->flags & IEEE80211_CONF_PS)
+		ret = iwl_power_set_user_mode(priv, IWL_POWER_INDEX_3);
+	else
+		ret = iwl_power_set_user_mode(priv, IWL_POWER_MODE_CAM);
+	if (ret)
+		IWL_DEBUG_MAC80211("Error setting power level\n");
+
 	IWL_DEBUG_MAC80211("TX Power old=%d new=%d\n",
 			   priv->tx_power_user_lmt, conf->power_level);
 
-- 
1.5.3.6

