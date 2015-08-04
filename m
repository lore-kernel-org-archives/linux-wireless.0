Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37362 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068AbbHDU7O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:14 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Gregory Greenman <gregory.greenman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 28/37] iwlwifi: mvm: fix beacon filtering temperature thresholds for D0i3
Date: Tue,  4 Aug 2015 23:43:18 +0300
Message-Id: <1438721007-23283-28-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_225927_746295_D7EC8671)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

The slow filtering threshold should be higher in D0i3 case.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
index b1baa33..b86b169 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
@@ -413,7 +413,7 @@ struct iwl_beacon_filter_cmd {
 #define IWL_BF_TEMP_FAST_FILTER_MIN 0
 
 #define IWL_BF_TEMP_SLOW_FILTER_DEFAULT 5
-#define IWL_BF_TEMP_SLOW_FILTER_D0I3 5
+#define IWL_BF_TEMP_SLOW_FILTER_D0I3 20
 #define IWL_BF_TEMP_SLOW_FILTER_MAX 255
 #define IWL_BF_TEMP_SLOW_FILTER_MIN 0
 
-- 
2.1.4

