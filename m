Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46638 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbbG0IL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2015 04:11:29 -0400
Date: Mon, 27 Jul 2015 11:11:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mac80211: remove always true condition
Message-ID: <20150727081111.GB2937@mwanda> (sfid-20150727_101134_862939_89BE60D8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The outside if statement checks that IEEE80211_TX_INTFL_MLME_CONN_TX is
set so this condition is always true.  Checking twice upsets the static
checkers.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 45628f3..8ba5832 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -515,7 +515,7 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 
 		if (!sdata) {
 			skb->dev = NULL;
-		} else if (info->flags & IEEE80211_TX_INTFL_MLME_CONN_TX) {
+		} else {
 			unsigned int hdr_size =
 				ieee80211_hdrlen(hdr->frame_control);
 
@@ -529,9 +529,6 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 				ieee80211_mgd_conn_tx_status(sdata,
 							     hdr->frame_control,
 							     acked);
-		} else {
-			/* we assign ack frame ID for the others */
-			WARN_ON(1);
 		}
 
 		rcu_read_unlock();
