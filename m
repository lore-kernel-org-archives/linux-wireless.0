Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47097 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab3F2W7Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Jun 2013 18:59:24 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [WT PATCH 2/6] mac80211: Make un-found-rate splat a warn-once.
Date: Sat, 29 Jun 2013 15:58:54 -0700
Message-Id: <1372546738-25827-2-git-send-email-greearb@candelatech.com> (sfid-20130630_005926_867232_CB3CEEA7)
In-Reply-To: <1372546738-25827-1-git-send-email-greearb@candelatech.com>
References: <1372546738-25827-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

After that, print it out with net_ratelimit.  We saw a system
continually hit this warning, for reasons unknown, and it
seems it bogged the system down enough to make it go OOM.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/tx.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4105d0c..8601f3f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -678,14 +678,21 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	 * Lets not bother rate control if we're associated and cannot
 	 * talk to the sta. This should not happen.
 	 */
-	if (WARN(test_bit(SCAN_SW_SCANNING, &tx->local->scanning) && assoc &&
-		 !rate_usable_index_exists(sband, &tx->sta->sta),
-		 "%s: Dropped data frame as no usable bitrate found while "
-		 "scanning and associated. Target station: "
-		 "%pM on %d GHz band\n",
-		 tx->sdata->name, hdr->addr1,
-		 info->band ? 5 : 2))
+	if (test_bit(SCAN_SW_SCANNING, &tx->local->scanning) && assoc &&
+	    !rate_usable_index_exists(sband, &tx->sta->sta)) {
+		static bool do_once = true;
+		if (do_once) {
+			WARN(1, "%s: Dropped data frame as no usable bitrate found while scanning and associated. Target station: %pM on %d GHz band\n",
+			     tx->sdata->name, hdr->addr1,
+			     info->band ? 5 : 2);
+			do_once = false;
+		} else {
+			net_info_ratelimited("%s: Dropped data frame as no usable bitrate found while scanning and associated. Target station: %pM on %d GHz band\n",
+					     tx->sdata->name, hdr->addr1,
+					     info->band ? 5 : 2);
+		}
 		return TX_DROP;
+	}
 
 	/*
 	 * If we're associated with the sta at this point we know we can at
-- 
1.7.3.4

