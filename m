Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:44140 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648Ab2A1Rhe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 12:37:34 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 4/4] iwlwifi: always restrict scan dwell in P2P
Date: Sat, 28 Jan 2012 08:30:52 -0800
Message-Id: <1327768252-22742-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120128_183740_299826_D351C06B)
In-Reply-To: <1327768252-22742-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1327768252-22742-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Whenever the PAN (P2P) context is active, it
has timers in the uCode that prevent sleep,
so scanning can't be out of channel for more
than the beacon interval programmed into the
device.

Before this patch, a full scan including any
passive channels when P2P was active would
stall forever because it wouldn't find time
to execute the passive requests (for default
beacon intervals of 100 TU.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 2aea20b..7f2e3a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -414,10 +414,25 @@ static u16 iwl_limit_dwell(struct iwl_priv *priv, u16 dwell_time)
 	for_each_context(priv, ctx) {
 		u16 value;
 
-		if (!iwl_is_associated_ctx(ctx))
-			continue;
-		if (ctx->staging.dev_type == RXON_DEV_TYPE_P2P)
+		switch (ctx->staging.dev_type) {
+		case RXON_DEV_TYPE_P2P:
+			/* no timing constraints */
 			continue;
+		case RXON_DEV_TYPE_ESS:
+		default:
+			/* timing constraints if associated */
+			if (!iwl_is_associated_ctx(ctx))
+				continue;
+			break;
+		case RXON_DEV_TYPE_CP:
+		case RXON_DEV_TYPE_2STA:
+			/*
+			 * These seem to always have timers for TBTT
+			 * active in uCode even when not associated yet.
+			 */
+			break;
+		}
+
 		value = ctx->beacon_int;
 		if (!value)
 			value = IWL_PASSIVE_DWELL_BASE;
-- 
1.7.0.4

