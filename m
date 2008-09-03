Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41622 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265AbYICDa6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 23:30:58 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 02/39] iwlwifi: W/A for the TSF correction in IBSS
Date: Wed,  3 Sep 2008 11:26:22 +0800
Message-Id: <1220412419-15404-3-git-send-email-yi.zhu@intel.com> (sfid-20080903_053101_325229_094A804C)
In-Reply-To: <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
 <1220412419-15404-2-git-send-email-yi.zhu@intel.com>
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
index 676fc0a..1badcf3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3578,7 +3578,7 @@ static int iwl4965_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 
 	priv->assoc_id = 0;
 	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
-	priv->timestamp = le64_to_cpu(timestamp) +  (priv->beacon_int * 1000);
+	priv->timestamp = le64_to_cpu(timestamp);
 
 	IWL_DEBUG_MAC80211("leave\n");
 	spin_unlock_irqrestore(&priv->lock, flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index b92a580..faad4d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -1068,7 +1068,10 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 		rx_status.rate_idx -= IWL_FIRST_OFDM_RATE;
 
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

