Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45651 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab2GEIZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 04:25:04 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/9] iwlwifi: limit dwell time more strictly
Date: Thu,  5 Jul 2012 10:24:50 +0200
Message-Id: <1341476695-6889-5-git-send-email-johannes@sipsolutions.net> (sfid-20120705_102549_089919_154027A1)
In-Reply-To: <1341476695-6889-1-git-send-email-johannes@sipsolutions.net>
References: <1341476695-6889-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The dwell time for scanning is currently limited
so that it fits into the timings inside the ucode
when that is tracking DTIM/beacon periods for the
AP(s) it's connected to.

However, when it's connected to two APs, those
may be in lockstep, for example if they both have
a DTIM interval of 100 TU, then one could be 50
TU after the other, leaving only 50 TU free to
be used by scanning.

Since we can't know how far apart they are the
only option is to restrict to 1/2 of the minium
of the two APs.

In theory, it would be possible to not use 1/2 of
the minimum but take into account that if they
have different intervals then there will be a bit
more time since they can't be in lockstep, but as
they will have 100 TU intervals in practice that
complex calculation will probably just result in
hard-to-find bugs.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/scan.c |   37 ++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/scan.c b/drivers/net/wireless/iwlwifi/dvm/scan.c
index 6633074..e3467fa 100644
--- a/drivers/net/wireless/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/dvm/scan.c
@@ -396,15 +396,21 @@ static u16 iwl_get_active_dwell_time(struct iwl_priv *priv,
 static u16 iwl_limit_dwell(struct iwl_priv *priv, u16 dwell_time)
 {
 	struct iwl_rxon_context *ctx;
+	int limits[NUM_IWL_RXON_CTX] = {};
+	int n_active = 0;
+	u16 limit;
+
+	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
 
 	/*
 	 * If we're associated, we clamp the dwell time 98%
-	 * of the smallest beacon interval (minus 2 * channel
-	 * tune time)
+	 * of the beacon interval (minus 2 * channel tune time)
+	 * If both contexts are active, we have to restrict to
+	 * 1/2 of the minimum of them, because they might be in
+	 * lock-step with the time inbetween only half of what
+	 * time we'd have in each of them.
 	 */
 	for_each_context(priv, ctx) {
-		u16 value;
-
 		switch (ctx->staging.dev_type) {
 		case RXON_DEV_TYPE_P2P:
 			/* no timing constraints */
@@ -424,14 +430,25 @@ static u16 iwl_limit_dwell(struct iwl_priv *priv, u16 dwell_time)
 			break;
 		}
 
-		value = ctx->beacon_int;
-		if (!value)
-			value = IWL_PASSIVE_DWELL_BASE;
-		value = (value * 98) / 100 - IWL_CHANNEL_TUNE_TIME * 2;
-		dwell_time = min(value, dwell_time);
+		limits[n_active++] = ctx->beacon_int ?: IWL_PASSIVE_DWELL_BASE;
 	}
 
-	return dwell_time;
+	switch (n_active) {
+	case 0:
+		return dwell_time;
+	case 2:
+		limit = (limits[1] * 98) / 100 - IWL_CHANNEL_TUNE_TIME * 2;
+		limit /= 2;
+		dwell_time = min(limit, dwell_time);
+		/* fall through to limit further */
+	case 1:
+		limit = (limits[0] * 98) / 100 - IWL_CHANNEL_TUNE_TIME * 2;
+		limit /= n_active;
+		return min(limit, dwell_time);
+	default:
+		WARN_ON_ONCE(1);
+		return dwell_time;
+	}
 }
 
 static u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
-- 
1.7.10

