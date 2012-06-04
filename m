Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46266 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822Ab2FDLnO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 07:43:14 -0400
Message-ID: <1338810191.4512.10.camel@jlt3.sipsolutions.net> (sfid-20120604_134322_137939_988A2C37)
Subject: [PATCH 3.5 v2] iwlwifi: disable WoWLAN if !CONFIG_PM_SLEEP
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Sebastian Kemper <sebastian_ml@gmx.net>
Date: Mon, 04 Jun 2012 13:43:11 +0200
In-Reply-To: <1338533803.4884.6.camel@jlt3.sipsolutions.net> (sfid-20120601_085648_998164_987CB355)
References: <1338533803.4884.6.camel@jlt3.sipsolutions.net>
	 (sfid-20120601_085648_998164_987CB355)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If CONFIG_PM_SLEEP is disabled, then iwlwifi doesn't
support suspend/resume handlers and thus mac80211
(correctly) refuses advertising WoWLAN. Disable
WoWLAN in the driver in this case.

Cc: stable@kernel.org
Reported-by: Sebastian Kemper <sebastian_ml@gmx.net>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index ab2f4d7..5d158ca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -199,6 +199,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
 			    WIPHY_FLAG_IBSS_RSN;
 
+#ifdef CONFIG_PM_SLEEP
 	if (priv->fw->img[IWL_UCODE_WOWLAN].sec[0].len &&
 	    priv->trans->ops->wowlan_suspend &&
 	    device_can_wakeup(priv->trans->dev)) {
@@ -217,6 +218,7 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 		hw->wiphy->wowlan.pattern_max_len =
 					IWLAGN_WOWLAN_MAX_PATTERN_LEN;
 	}
+#endif
 
 	if (iwlwifi_mod_params.power_save)
 		hw->wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;
-- 
1.7.10



