Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:19035 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbYBAFvu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 00:51:50 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/2] iwlwifi: set rate_idx correctly from plcp
Date: Thu, 31 Jan 2008 21:46:41 -0800
Message-Id: <1201844801-7326-2-git-send-email-reinette.chatre@intel.com> (sfid-20080201_055152_947116_7BC185C3)
In-Reply-To: <1201844801-7326-1-git-send-email-reinette.chatre@intel.com>
References: <1201844801-7326-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

rate_idx is derived from plcp information

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 79545d6..29797db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3546,7 +3546,7 @@ static void iwl4965_rx_reply_rx(struct iwl4965_priv *priv,
 			(rx_start->phy_flags & RX_RES_PHY_FLAGS_BAND_24_MSK) ?
 			IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ,
 		.antenna = 0,
-		.rate_idx = iwl4965_hw_get_rate(
+		.rate_idx = iwl4965_rate_index_from_plcp(
 				le32_to_cpu(rx_start->rate_n_flags)),
 		.flag = 0,
 	};
-- 
1.5.3.4

