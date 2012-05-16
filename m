Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54105 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966166Ab2EPUgH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:36:07 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Subject: [PATCH 1/3] iwlwifi: update BT traffic load states correctly
Date: Wed, 16 May 2012 22:35:57 +0200
Message-Id: <1337200559-11133-2-git-send-email-johannes@sipsolutions.net> (sfid-20120516_223613_981929_2EF74C9A)
In-Reply-To: <1337200559-11133-1-git-send-email-johannes@sipsolutions.net>
References: <1337200559-11133-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

When BT traffic load changes from its
previous state, a new LQ command needs to be
sent down to the firmware. This needs to
be done only once per change. The state
variable that keeps track of this change is
last_bt_traffic_load. However, it was not
being updated when the change had been
handled. Not updating this variable was
causing a flood of advanced BT config
commands to be sent to the firmware. Fix
this.

Cc: stable@vger.kernel.org #2.6.38+
Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 51e1a69..8cebd7c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -884,6 +884,7 @@ static void rs_bt_update_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	if ((priv->bt_traffic_load != priv->last_bt_traffic_load) ||
 	    (priv->bt_full_concurrent != full_concurrent)) {
 		priv->bt_full_concurrent = full_concurrent;
+		priv->last_bt_traffic_load = priv->bt_traffic_load;
 
 		/* Update uCode's rate table. */
 		tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
-- 
1.7.10

