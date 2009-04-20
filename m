Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12239 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756650AbZDTVbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 17:31:03 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/11] iwlwifi: support truly passive scanning
Date: Mon, 20 Apr 2009 14:36:57 -0700
Message-Id: <1240263424-8495-5-git-send-email-reinette.chatre@intel.com> (sfid-20090420_233112_482991_F84090E9)
In-Reply-To: <1240263424-8495-4-git-send-email-reinette.chatre@intel.com>
References: <1240263424-8495-1-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-2-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-3-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

If passive scanning is requested we should not ask the
microcode to do active scanning after detecting traffic
on a channel -- that should only be used when an active
scan is requested but some channels are marked passive.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    7 ++++++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 9edcf8c..25311e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -712,7 +712,12 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	} else if (priv->scan_bands & BIT(IEEE80211_BAND_5GHZ)) {
 		band = IEEE80211_BAND_5GHZ;
 		rate = IWL_RATE_6M_PLCP;
-		scan->good_CRC_th = IWL_GOOD_CRC_TH;
+		/*
+		 * If active scaning is requested but a certain channel
+		 * is marked passive, we can do active scanning if we
+		 * detect transmissions.
+		 */
+		scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH : 0;
 
 		/* Force use of chains B and C (0x6) for scan Rx for 4965
 		 * Avoid A (0x1) because of its off-channel reception on A-band.
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 94f10f2..5520a79 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3078,7 +3078,12 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		band = IEEE80211_BAND_2GHZ;
 	} else if (priv->scan_bands & BIT(IEEE80211_BAND_5GHZ)) {
 		scan->tx_cmd.rate = IWL_RATE_6M_PLCP;
-		scan->good_CRC_th = IWL_GOOD_CRC_TH;
+		/*
+		 * If active scaning is requested but a certain channel
+		 * is marked passive, we can do active scanning if we
+		 * detect transmissions.
+		 */
+		scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH : 0;
 		band = IEEE80211_BAND_5GHZ;
 	} else {
 		IWL_WARN(priv, "Invalid scan band count\n");
-- 
1.5.6.3

