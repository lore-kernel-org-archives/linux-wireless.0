Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:59537 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab3GEFsz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 01:48:55 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Handle zero RTS threshold
Date: Fri,  5 Jul 2013 11:15:43 +0530
Message-Id: <1373003143-29211-1-git-send-email-sujith@msujith.org> (sfid-20130705_074912_292898_F98E6E39)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The spec says:

"Setting this attribute to 0 has the effect of turning on the RTS/CTS
handshake for all frames of Data or Management type transmitted by this
STA."

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 net/mac80211/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4105d0c..50c7309 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -651,7 +651,8 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 		    tx->sdata->vif.type == NL80211_IFTYPE_ADHOC);
 
 	/* set up RTS protection if desired */
-	if (len > tx->local->hw.wiphy->rts_threshold) {
+	if (!tx->local->hw.wiphy->rts_threshold ||
+	    (len > tx->local->hw.wiphy->rts_threshold)) {
 		txrc.rts = true;
 	}
 
-- 
1.8.3.2

