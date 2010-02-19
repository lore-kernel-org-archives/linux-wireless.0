Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41037 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab0BSGBq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 01:01:46 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, stable@kernel.org,
	Dan Halperin <dhalperi@cs.washington.edu>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/3] iwlwifi: set HT flags after channel in rxon
Date: Thu, 18 Feb 2010 22:01:39 -0800
Message-Id: <1266559301-19581-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1266559301-19581-1-git-send-email-reinette.chatre@intel.com>
References: <1266559301-19581-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Halperin <dhalperi@cs.washington.edu>

The HT extension channel settings require priv->staging_rxon.channel to be
accurate. However, iwl_set_rxon_ht was being called before iwl_set_rxon_channel
and thus HT40 could be broken unless another call to iwl_mac_config came in.

This problem was recently introduced by "iwlwifi: Fix to set correct ht
configuration"

The particular setting in which I noticed this was monitor mode:

	iwconfig wlan0 mode monitor
	ifconfig wlan0 up
	./iw wlan0 set channel 64 HT40-
	#./iw wlan0 set channel 64 HT40-
	tcpdump -i wlan0 -y IEEE802_11_RADIO

would only catch HT40 packets if I issued the IW command twice.

>From visual inspection, iwl_set_rxon_channel does not depend on
iwl_set_rxon_ht, so simply swapping them should be safe and fixes this problem.

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
CC: stable@kernel.org
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d10bea6..f36f804 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2744,8 +2744,8 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 		if ((le16_to_cpu(priv->staging_rxon.channel) != ch))
 			priv->staging_rxon.flags = 0;
 
-		iwl_set_rxon_ht(priv, ht_conf);
 		iwl_set_rxon_channel(priv, conf->channel);
+		iwl_set_rxon_ht(priv, ht_conf);
 
 		iwl_set_flags_for_band(priv, conf->channel->band);
 		spin_unlock_irqrestore(&priv->lock, flags);
-- 
1.6.3.3

