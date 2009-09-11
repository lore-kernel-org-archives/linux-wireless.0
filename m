Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49357 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbZIKRiR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 13:38:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel C Halperin <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/13 v2.6.32 and w-t] iwlwifi: fix HT operation in 2.4 GHz band
Date: Fri, 11 Sep 2009 10:38:08 -0700
Message-Id: <1252690699-25796-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
References: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C Halperin <daniel.c.halperin@intel.com>

When we cleaned up the driver to properly tell mac80211 about HT rates
("iwlwifi: use iwl_hwrate_get_mac80211_idx where appropriate"), we broke
internal rate indexing in 2.4 GHz band.

Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Tested-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 40b207a..fd73153 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -883,6 +883,12 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 		mac_index &= RATE_MCS_CODE_MSK;	/* Remove # of streams */
 		if (mac_index >= (IWL_RATE_9M_INDEX - IWL_FIRST_OFDM_RATE))
 			mac_index++;
+		/*
+		 * mac80211 HT index is always zero-indexed; we need to move
+		 * HT OFDM rates after CCK rates in 2.4 GHz band
+		 */
+		if (priv->band == IEEE80211_BAND_2GHZ)
+			mac_index += IWL_FIRST_OFDM_RATE;
 	}
 
 	if ((mac_index < 0) ||
-- 
1.5.6.3

