Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab1D1K7W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 06:59:22 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH wireless-2.6] iwl4965: fix "Received BA when not expected"
Date: Thu, 28 Apr 2011 12:58:24 +0200
Message-Id: <1303988304-6935-1-git-send-email-sgruszka@redhat.com> (sfid-20110428_125925_275254_2A61F997)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Need to use broadcast sta_id for management and multicast frames,
otherwise we broke BA session and get messages like that:

"Received BA when not expected"

or (on older kernels):

"BA scd_flow 0 does not match txq_id 10"

This fix regression introduced in 2.6.35 during station management
code rewrite by:

commit 2a87c26bbe9587baeb9e56d3ce0b4971bd777643
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Apr 30 11:30:45 2010 -0700

    iwlwifi: use iwl_find_station less

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
index fbec88d..3c2e117 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
+#include <linux/etherdevice.h>
 
 #include "iwl-dev.h"
 #include "iwl-core.h"
@@ -316,12 +317,18 @@ int iwl4965_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	hdr_len = ieee80211_hdrlen(fc);
 
-	/* Find index into station table for destination station */
-	sta_id = iwl_legacy_sta_id_or_broadcast(priv, ctx, info->control.sta);
-	if (sta_id == IWL_INVALID_STATION) {
-		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
-			       hdr->addr1);
-		goto drop_unlock;
+	/* If this frame is broadcast or management, use broadcast station id */
+	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1))
+		sta_id = ctx->bcast_sta_id;
+	else {
+		/* Find index into station table for destination station */
+		sta_id = iwl_legacy_sta_id_or_broadcast(priv, ctx, info->control.sta);
+
+		if (sta_id == IWL_INVALID_STATION) {
+			IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
+				       hdr->addr1);
+			goto drop_unlock;
+		}
 	}
 
 	IWL_DEBUG_TX(priv, "station Id %d\n", sta_id);
-- 
1.7.1

