Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22294 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbYICDWt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:22:49 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 1/9] iwlwifi: W/A for the TSF correction in IBSS
Date: Wed,  3 Sep 2008 11:18:42 +0800
Message-Id: <1220411930-15216-2-git-send-email-yi.zhu@intel.com> (sfid-20080903_052303_600454_63E57A04)
In-Reply-To: <1220411930-15216-1-git-send-email-yi.zhu@intel.com>
References: <1220411930-15216-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

This patch is a W/A for the TSF sync issue in IBSS merging. HW is not
capable to sync TSF (it's constantly little behind). This creates
constant IBSS merging upon reception of each beacon, adding and removing
station which in turn creates above 50% packet loss and thus dramatically
degrade the throughput. The W/A simply stops the driver from declaring it
has a reliable TSF value and thus eliminates IBSS merging.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c  |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c0b73c4..2afa1fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3588,7 +3588,7 @@ static int iwl4965_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 
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

