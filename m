Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:11397 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab0CJFWE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:04 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/24] iwlwifi: remove superfluous channel check
Date: Tue,  9 Mar 2010 21:21:33 -0800
Message-Id: <1268198512-6572-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

mac80211 will not allow using channels not
marked as allowing IBSS for IBSS mode.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index b994eee..166087d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1238,14 +1238,6 @@ void iwl_connection_init_rx_config(struct iwl_priv *priv, int mode)
 	if (!ch_info)
 		ch_info = &priv->channel_info[0];
 
-	/*
-	 * in some case A channels are all non IBSS
-	 * in this case force B/G channel
-	 */
-	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
-	    !(is_channel_ibss(ch_info)))
-		ch_info = &priv->channel_info[0];
-
 	priv->staging_rxon.channel = cpu_to_le16(ch_info->channel);
 	priv->band = ch_info->band;
 
-- 
1.6.3.3

