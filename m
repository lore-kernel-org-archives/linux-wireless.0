Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15248 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366Ab0KJSBG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 13:01:06 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/16] iwlagn: fix needed chains calculation
Date: Wed, 10 Nov 2010 09:56:44 -0800
Message-Id: <1289411810-23093-11-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289411810-23093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Garen noticed that this was wrong. Fix
the calibration -- default to multiple
chains and fall back to single where
possible.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 0228877..1fab1bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -458,11 +458,13 @@ static void iwlagn_check_needed_chains(struct iwl_priv *priv,
 					>> IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT;
 			maxstreams += 1;
 
+			need_multiple = true;
+
 			if ((ht_cap->mcs.rx_mask[1] == 0) &&
 			    (ht_cap->mcs.rx_mask[2] == 0))
 				need_multiple = false;
 			if (maxstreams <= 1)
-				need_multiple = true;
+				need_multiple = false;
 		} else {
 			/*
 			 * If at all, this can only happen through a race
-- 
1.7.0.4

