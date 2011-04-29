Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755581Ab1D2Pv3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 11:51:29 -0400
Date: Fri, 29 Apr 2011 17:51:06 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH wireless-2.6 v2] iwlagn: fix "Received BA when not expected"
Message-ID: <20110429155105.GB5537@redhat.com> (sfid-20110429_175132_603213_63544DC0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Need to use broadcast sta_id for management frames, otherwise we broke
BA session in the firmware and get messages like that:

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
devices that need to be investigated.

Cc: stable@kernel.org # 2.6.35+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 494de0e..4afae14 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -582,12 +582,17 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	hdr_len = ieee80211_hdrlen(fc);
 
-	/* Find index into station table for destination station */
-	sta_id = iwl_sta_id_or_broadcast(priv, ctx, info->control.sta);
-	if (sta_id == IWL_INVALID_STATION) {
-		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
-			       hdr->addr1);
-		goto drop_unlock;
+	/* For management frames use broadcast id to do not break aggregation */
+	if (!ieee80211_is_data(fc))
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

