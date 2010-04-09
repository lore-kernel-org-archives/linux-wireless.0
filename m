Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17339 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793Ab0DIUJl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 16:09:41 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/12] iwlwifi: remove pointless sta_id invalid check
Date: Fri,  9 Apr 2010 13:09:22 -0700
Message-Id: <1270843769-30017-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
References: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

lq->sta_id cannot be invalid here since this
function will only be called after the station
has been added properly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index a43493f..6876f7c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1187,13 +1187,9 @@ int iwl_send_lq_cmd(struct iwl_priv *priv,
 		.data = lq,
 	};
 
-	if ((lq->sta_id == 0xFF) &&
-	    (priv->iw_mode == NL80211_IFTYPE_ADHOC))
+	if (WARN_ON(lq->sta_id == IWL_INVALID_STATION))
 		return -EINVAL;
 
-	if (lq->sta_id == 0xFF)
-		lq->sta_id = IWL_AP_ID;
-
 	iwl_dump_lq_cmd(priv, lq);
 	BUG_ON(init && (cmd.flags & CMD_ASYNC));
 
-- 
1.6.3.3

