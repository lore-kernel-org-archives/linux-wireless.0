Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32034 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbYH1J3H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 05:29:07 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 01/11] iwlwifi: W/A for the TSF correction in IBSS
Date: Thu, 28 Aug 2008 17:25:00 +0800
Message-Id: <1219915510-3647-2-git-send-email-yi.zhu@intel.com> (sfid-20080828_112912_525856_BDB22C8D)
In-Reply-To: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
References: <1219915510-3647-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

This patch is a W/A for the TSF sync issue, in which the ucode's timestamp
is constantly a little behind incoming beacons' timestamps (in IBSS cells).
The W/A simply stops the driver from declaring it has a reliable TSF value.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c  |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 061ffba..d44587f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3580,7 +3580,7 @@ static int iwl4965_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 
 	priv->assoc_id = 0;
 	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
-	priv->timestamp = le64_to_cpu(timestamp) +  (priv->beacon_int * 1000);
+	priv->timestamp = le64_to_cpu(timestamp);
 
 	IWL_DEBUG_MAC80211("leave\n");
 	spin_unlock_irqrestore(&priv->lock, flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index f3f6ea4..e81bfc4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -1173,7 +1173,10 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 
 	rx_status.antenna = 0;
 	rx_status.flag = 0;
-	rx_status.flag |= RX_FLAG_TSFT;
+
+	/* TSF isn't reliable. In order to allow smooth user experience,
+	 * this W/A doesn't propagate it to the mac80211 */
+	/*rx_status.flag |= RX_FLAG_TSFT;*/
 
 	if ((unlikely(rx_start->cfg_phy_cnt > 20))) {
 		IWL_DEBUG_DROP("dsp size out of range [0,20]: %d/n",
-- 
1.5.3.6

