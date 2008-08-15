Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17686 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbYHOCEn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 22:04:43 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 02/15] iwlwifi: W/A for the TSF correction in IBSS
Date: Fri, 15 Aug 2008 10:01:07 +0800
Message-Id: <1218765680-8378-3-git-send-email-yi.zhu@intel.com> (sfid-20080815_040450_440999_50A21AF5)
In-Reply-To: <1218765680-8378-2-git-send-email-yi.zhu@intel.com>
References: <1218765680-8378-1-git-send-email-yi.zhu@intel.com>
 <1218765680-8378-2-git-send-email-yi.zhu@intel.com>
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
index 981fdad..5262a2d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3579,7 +3579,7 @@ static int iwl4965_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
 
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

