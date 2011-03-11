Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45130 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab1CKE3h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 23:29:37 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/2] iwlagn: fix offchannel TX bug
Date: Thu, 10 Mar 2011 20:13:27 -0800
Message-Id: <1299816807-26813-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1299816807-26813-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1299816807-26813-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In the case where remain-on-channel rather than
offchannel TX should be used, my offchannel TX
patch introduced a bug because mac80211 will
use the now-freed SKB.

iwlagn shouldn't free the SKB when it returns 1
here since then the SKB will still be used.

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5f4e481..b57fbbf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2996,7 +2996,7 @@ static int iwl_mac_offchannel_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
  out:
 	mutex_unlock(&priv->mutex);
  free:
-	if (ret)
+	if (ret < 0)
 		kfree_skb(skb);
 
 	return ret;
-- 
1.7.0.4

