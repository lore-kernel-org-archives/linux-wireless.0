Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sj-iport-1.cisco.com ([171.71.176.70]:35929 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZHUAkf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 20:40:35 -0400
Received: from sj-core-3.cisco.com (sj-core-3.cisco.com [171.68.223.137])
	by sj-dkim-4.cisco.com (8.12.11/8.12.11) with ESMTP id n7L0eb2T019489
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2009 17:40:37 -0700
Received: from xbh-sjc-221.amer.cisco.com (xbh-sjc-221.cisco.com [128.107.191.63])
	by sj-core-3.cisco.com (8.13.8/8.14.3) with ESMTP id n7L0ebfn016450
	for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2009 00:40:37 GMT
Message-ID: <4A8DED03.2050502@cs.ucla.edu>
Date: Thu, 20 Aug 2009 17:40:35 -0700
From: Rafael Laufer <rlaufer@cs.ucla.edu>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH] Implementation of the IEEE80211_RADIOTAP_RATE option
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements the IEEE80211_RADIOTAP_RATE 
option when parsing radiotap headers to allow rate 
selection on a per-packet basis.


Signed-off-by: Rafael Laufer <rlaufer@cs.ucla.edu>
---
 Implementation of the IEEE80211_RADIOTAP_RATE 
 option when parsing radiotap headers to allow
 rate selection on a per-packet basis.

 net/mac80211/tx.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 10a1099..41d636b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -549,7 +549,10 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	 * If we're associated with the sta at this point we know we can at
 	 * least send the frame at the lowest bit rate.
 	 */
-	rate_control_get_rate(tx->sdata, tx->sta, &txrc);
+
+	/* in monitor mode, we already have the rate from the radiotap header */
+	if (likely(!(info->flags & IEEE80211_TX_CTL_INJECTED)))
+		rate_control_get_rate(tx->sdata, tx->sta, &txrc);
 
 	if (unlikely(info->control.rates[0].idx < 0))
 		return TX_DROP;
@@ -972,6 +975,19 @@ static bool __ieee80211_parse_tx_radiotap(struct ieee80211_tx_data *tx,
 				tx->flags |= IEEE80211_TX_FRAGMENTED;
 			break;
 
+		/* Get the rate parameter from the radiotap header, 
+		 * allowing rate selection on a per-packet basis 
+		 */
+		case IEEE80211_RADIOTAP_RATE:
+			bitrate = (*iterator.this_arg) * 5;
+			for (i = 0; i < sband->n_bitrates; i++) {
+				if (sband->bitrates[i].bitrate == bitrate)
+					break;
+			}
+			if (i != sband->n_bitrates)
+				info->control.rates[0].idx = i;
+			break;
+
 		/*
 		 * Please update the file
 		 * Documentation/networking/mac80211-injection.txt
-- 
1.6.0.4

