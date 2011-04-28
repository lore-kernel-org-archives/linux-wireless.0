Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950Ab1D1LLP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 07:11:15 -0400
Date: Thu, 28 Apr 2011 13:10:23 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH wireless-2.6] iwlagn: fix "Received BA when not expected"
Message-ID: <20110428111011.GA6967@redhat.com> (sfid-20110428_131118_871724_45CC9A2E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Patch partially resolve:
https://bugzilla.kernel.org/show_bug.cgi?id=16691
However, there are still 11n performance problems on 4965 and 5xxx
devices that need to be ivestigated.

Cc: stable@kernel.org # 2.6.35+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 494de0e..dfde372 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
+#include <linux/etherdevice.h>
 
 #include "iwl-dev.h"
 #include "iwl-core.h"
@@ -582,12 +583,17 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	hdr_len = ieee80211_hdrlen(fc);
 
-	/* Find index into station table for destination station */
-	sta_id = iwl_sta_id_or_broadcast(priv, ctx, info->control.sta);
-	if (sta_id == IWL_INVALID_STATION) {
-		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
-			       hdr->addr1);
-		goto drop_unlock;
+	/* If this frame is broadcast or management, use broadcast station id */
+	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1))
+		sta_id = ctx->bcast_sta_id;
+	else {
+		/* Find index into station table for destination station */
+		sta_id = iwl_sta_id_or_broadcast(priv, ctx, info->control.sta);
+		if (sta_id == IWL_INVALID_STATION) {
+			IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
+				       hdr->addr1);
+			goto drop_unlock;
+		}
 	}
 
 	IWL_DEBUG_TX(priv, "station Id %d\n", sta_id);
-- 
1.7.1

