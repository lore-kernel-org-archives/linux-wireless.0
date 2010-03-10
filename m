Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:11397 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939Ab0CJFWG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:06 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/24] iwlwifi: remove IBSS channel sanity check
Date: Tue,  9 Mar 2010 21:21:38 -0800
Message-Id: <1268198512-6572-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

mac80211 will always enforce using a channel
that the driver allowed for IBSS use.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 8e8f528..4365e85 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2436,15 +2436,6 @@ int iwl_mac_config(struct ieee80211_hw *hw, u32 changed)
 			goto set_ch_out;
 		}
 
-		if (priv->iw_mode == NL80211_IFTYPE_ADHOC &&
-			!is_channel_ibss(ch_info)) {
-			IWL_ERR(priv, "channel %d in band %d not "
-				"IBSS channel\n",
-				conf->channel->hw_value, conf->channel->band);
-			ret = -EINVAL;
-			goto set_ch_out;
-		}
-
 		spin_lock_irqsave(&priv->lock, flags);
 
 		/* Configure HT40 channels */
-- 
1.6.3.3

