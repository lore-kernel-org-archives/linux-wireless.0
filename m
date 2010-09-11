Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9763 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab0IKQGp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 12:06:45 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/10] iwlwifi: fix and describe iwl_adjust_beacon_interval
Date: Sat, 11 Sep 2010 09:08:36 -0700
Message-Id: <1284221318-28281-9-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1284221318-28281-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1284221318-28281-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The iwl_adjust_beacon_interval function is a bit
of black magic, so add comments to it describing
what it does. Also, in the case when there's no
beacon interval set, program the default into
the device (instead of adjusting, which results
in the max) since using the max in that case
interacts badly with dual-mode/PAN parameters.

Also update the PAN parameters accordingly and
use the same constant as here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-core.c     |   25 +++++++++++++++++++++++--
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index a63582f..d86902b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -321,7 +321,7 @@ static int iwlagn_set_pan_params(struct iwl_priv *priv)
 			bcnint = max_t(int, bcnint,
 				       ctx_bss->vif->bss_conf.beacon_int);
 		if (!bcnint)
-			bcnint = 100;
+			bcnint = DEFAULT_BEACON_INTERVAL;
 		slot0 = bcnint / 2;
 		slot1 = bcnint - slot0;
 
@@ -339,7 +339,7 @@ static int iwlagn_set_pan_params(struct iwl_priv *priv)
 		slot0 = 0;
 		slot1 = max_t(int, 1, ctx_pan->vif->bss_conf.dtim_period) *
 					ctx_pan->vif->bss_conf.beacon_int;
-		slot1 = max_t(int, 100, slot1);
+		slot1 = max_t(int, DEFAULT_BEACON_INTERVAL, slot1);
 
 		if (test_bit(STATUS_SCAN_HW, &priv->status)) {
 			slot0 = slot1 * 3 - 20;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c393b20..c9c523b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -491,8 +491,29 @@ EXPORT_SYMBOL(iwl_is_ht40_tx_allowed);
 
 static u16 iwl_adjust_beacon_interval(u16 beacon_val, u16 max_beacon_val)
 {
-	u16 new_val = 0;
-	u16 beacon_factor = 0;
+	u16 new_val;
+	u16 beacon_factor;
+
+	/*
+	 * If mac80211 hasn't given us a beacon interval, program
+	 * the default into the device (not checking this here
+	 * would cause the adjustment below to return the maximum
+	 * value, which may break PAN.)
+	 */
+	if (!beacon_val)
+		return DEFAULT_BEACON_INTERVAL;
+
+	/*
+	 * If the beacon interval we obtained from the peer
+	 * is too large, we'll have to wake up more often
+	 * (and in IBSS case, we'll beacon too much)
+	 *
+	 * For example, if max_beacon_val is 4096, and the
+	 * requested beacon interval is 7000, we'll have to
+	 * use 3500 to be able to wake up on the beacons.
+	 *
+	 * This could badly influence beacon detection stats.
+	 */
 
 	beacon_factor = (beacon_val + max_beacon_val) / max_beacon_val;
 	new_val = beacon_val / beacon_factor;
-- 
1.7.0.4

