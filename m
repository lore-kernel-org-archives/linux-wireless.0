Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34813 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbYHDID7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 04:03:59 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 10/10] iwl3945: fix merge mistake for packet injection
Date: Mon,  4 Aug 2008 16:00:48 +0800
Message-Id: <1217836848-24288-11-git-send-email-yi.zhu@intel.com> (sfid-20080804_101544_232373_E77BA5E0)
In-Reply-To: <1217836848-24288-10-git-send-email-yi.zhu@intel.com>
References: <1217836848-24288-1-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-2-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-3-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-4-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-5-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-6-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-7-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-8-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-9-git-send-email-yi.zhu@intel.com>
 <1217836848-24288-10-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should allow packets transmission in monitor mode for 3945. The
patch fixes a merge error with 2.6.26 kernel.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 28cf4e7..7095d8c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6589,12 +6589,6 @@ static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	IWL_DEBUG_MAC80211("enter\n");
 
-	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
-		IWL_DEBUG_MAC80211("leave - monitor\n");
-		dev_kfree_skb_any(skb);
-		return 0;
-	}
-
 	IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 		     ieee80211_get_tx_rate(hw, IEEE80211_SKB_CB(skb))->bitrate);
 
-- 
1.5.3.6

