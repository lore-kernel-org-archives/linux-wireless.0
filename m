Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50995 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932616AbZHUUe2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 16:34:28 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Daniel C Halperin <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/14] iwlwifi: clear rate control flags on non-HT packet
Date: Fri, 21 Aug 2009 13:34:20 -0700
Message-Id: <1250886867-4112-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
References: <1250886867-4112-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C Halperin <daniel.c.halperin@intel.com>

Clear the flags (most importantly, the IEEE80211_TX_RC_MCS flag)
when sending a non-HT packet so that the rate index can be properly treated.
This fixes the reporting of legacy rates in wireless-extensions for packets
sent after an HT packet.

Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index fee110d..26ec969 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2546,6 +2546,7 @@ static void rs_get_rate(void *priv_r, struct ieee80211_sta *sta, void *priv_sta,
 			rate_idx = rate_lowest_index(sband, sta);
 		else if (sband->band == IEEE80211_BAND_5GHZ)
 			rate_idx -= IWL_FIRST_OFDM_RATE;
+		info->control.rates[0].flags = 0;
 	}
 	info->control.rates[0].idx = rate_idx;
 
-- 
1.5.6.3

