Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50326 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbYEHDer (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 23:34:47 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2.6.26] iwlwifi: Fix frequency in rx_status fill
Date: Thu,  8 May 2008 11:34:05 +0800
Message-Id: <1210217645-17474-1-git-send-email-yi.zhu@intel.com> (sfid-20080508_053350_926393_B12CEE8C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch fixes a bug in RX path, the frequency was wrongly set in the
ieee80211_rx_status. This bug led to an empty scan list in A band.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 2869533..414dbfc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -670,7 +670,7 @@ static void iwl3945_rx_reply_rx(struct iwl3945_priv *priv,
 	rx_status.flag = 0;
 	rx_status.mactime = le64_to_cpu(rx_end->timestamp);
 	rx_status.freq =
-		ieee80211_frequency_to_channel(le16_to_cpu(rx_hdr->channel));
+		ieee80211_channel_to_frequency(le16_to_cpu(rx_hdr->channel));
 	rx_status.band = (rx_hdr->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
 				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 9035fc8..caeee50 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2905,7 +2905,7 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 
 	rx_status.mactime = le64_to_cpu(rx_start->timestamp);
 	rx_status.freq =
-		ieee80211_frequency_to_channel(le16_to_cpu(rx_start->channel));
+		ieee80211_channel_to_frequency(le16_to_cpu(rx_start->channel));
 	rx_status.band = (rx_start->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
 				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
 	rx_status.rate_idx =
-- 
1.5.3.6

