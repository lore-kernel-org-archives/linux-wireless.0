Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:5860 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907Ab0BETkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 14:40:03 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>, stable@kernel.org
Subject: [PATCH wireless-2.6] iwlwifi: Fix to set correct ht configuration
Date: Fri,  5 Feb 2010 11:40:00 -0800
Message-Id: <1265398800-8367-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

iwl_set_rxon_ht() only get called in iwl_post_associate(); which cause
possible incorrect ht configuration. Adding the call in iwl_mac_config() if
IEEE80211_CONF_CHANGE_CHANNEL flag is set to re-configure and send rxon
command.

Fixes
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2146

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
CC: stable@kernel.org
---

This patchs is also available from wireless-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5461f10..d10bea6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2744,6 +2744,7 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 		if ((le16_to_cpu(priv->staging_rxon.channel) != ch))
 			priv->staging_rxon.flags = 0;
 
+		iwl_set_rxon_ht(priv, ht_conf);
 		iwl_set_rxon_channel(priv, conf->channel);
 
 		iwl_set_flags_for_band(priv, conf->channel->band);
-- 
1.6.3.3

