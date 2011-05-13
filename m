Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:27767 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab1EMTiq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 15:38:46 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/13] iwlagn: change default beacon interval
Date: Fri, 13 May 2011 12:13:29 -0700
Message-Id: <1305314010-18073-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110513_213851_543003_5B9A6C26)
In-Reply-To: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the PAN context is active, but unused, it
may still block scans that take more dwell time
than its beacon interval (which is odd). Work
around this problem by using a default beacon
interval of 200 so scans will fit between.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ab29ab5..22a6e3e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -81,7 +81,7 @@ struct iwl_tx_queue;
 #define MAX_RTS_THRESHOLD         2347U
 #define MAX_MSDU_SIZE		  2304U
 #define MAX_MPDU_SIZE		  2346U
-#define DEFAULT_BEACON_INTERVAL   100U
+#define DEFAULT_BEACON_INTERVAL   200U
 #define	DEFAULT_SHORT_RETRY_LIMIT 7U
 #define	DEFAULT_LONG_RETRY_LIMIT  4U
 
-- 
1.7.0.4

