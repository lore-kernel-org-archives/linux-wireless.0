Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:15024 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757924Ab0JWQSM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Oct 2010 12:18:12 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 6/8] iwlagn: turn dynamic smps on while BT is on
Date: Sat, 23 Oct 2010 09:15:44 -0700
Message-Id: <1287850546-23500-7-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1287850546-23500-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1287850546-23500-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While BT is on and doing iscan and/or pscan, BT is in listen
mode which will impact WiFi throughput, we need to
enable dynamic smps in order to improve the rx throughput.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index b555edd..931af54 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1889,7 +1889,10 @@ static void iwlagn_bt_traffic_change_work(struct work_struct *work)
 
 	switch (priv->bt_traffic_load) {
 	case IWL_BT_COEX_TRAFFIC_LOAD_NONE:
-		smps_request = IEEE80211_SMPS_AUTOMATIC;
+		if (priv->bt_status)
+			smps_request = IEEE80211_SMPS_DYNAMIC;
+		else
+			smps_request = IEEE80211_SMPS_AUTOMATIC;
 		break;
 	case IWL_BT_COEX_TRAFFIC_LOAD_LOW:
 		smps_request = IEEE80211_SMPS_DYNAMIC;
-- 
1.7.0.4

