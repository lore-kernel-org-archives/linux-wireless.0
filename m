Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35412 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab1HMQ55 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 12:57:57 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/13] iwlagn: default smps mode for 1000 series device
Date: Sat, 13 Aug 2011 09:17:57 -0700
Message-Id: <1313252287-22858-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_185810_750607_800BF23C)
In-Reply-To: <1313252287-22858-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313252287-22858-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

1000 series are 1x2 devices, the old default using static smps which only
use single antenna for rx, set the default to dynamic smps.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 01b49eb..d502004 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -201,7 +201,7 @@ static struct iwl_base_params iwl1000_base_params = {
 static struct iwl_ht_params iwl1000_ht_params = {
 	.ht_greenfield_support = true,
 	.use_rts_for_aggregation = true, /* use rts/cts protection */
-	.smps_mode = IEEE80211_SMPS_STATIC,
+	.smps_mode = IEEE80211_SMPS_DYNAMIC,
 };
 
 #define IWL_DEVICE_1000						\
-- 
1.7.0.4

