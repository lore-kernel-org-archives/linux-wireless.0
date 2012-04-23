Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32825 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861Ab2DWVxA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:53:00 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 27/29] iwlwifi: revert workaround to restore 1000 rx throughput
Date: Mon, 23 Apr 2012 14:47:38 -0700
Message-Id: <1335217660-21950-28-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235318_431404_1324AE98)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

A workaround in commit c0486b7ccc5 resulted in a 40% drop in receive
throughput in order to fix a transmit problem.  The transmit problem
no longer occurs, so restore the receive throughput.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index c1aa5f2..8c7a0cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -71,7 +71,6 @@ static const struct iwl_base_params iwl1000_base_params = {
 static const struct iwl_ht_params iwl1000_ht_params = {
 	.ht_greenfield_support = true,
 	.use_rts_for_aggregation = true, /* use rts/cts protection */
-	.smps_mode = IEEE80211_SMPS_DYNAMIC,
 };
 
 #define IWL_DEVICE_1000						\
-- 
1.7.0.4

