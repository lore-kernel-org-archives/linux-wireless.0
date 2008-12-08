Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36558 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYLHToN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 14:44:13 -0500
Subject: [RFT] ath9k: remove fragmentation workaround again
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 17:19:48 +0100
Message-Id: <1228753189.22164.86.camel@johannes.berg> (sfid-20081208_204417_251976_E60102B9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looking at the RC algorithm this no longer seems to be necessary.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/ath9k/main.c |    6 ------
 1 file changed, 6 deletions(-)

--- everything.orig/drivers/net/wireless/ath9k/main.c	2008-12-08 17:16:57.000000000 +0100
+++ everything/drivers/net/wireless/ath9k/main.c	2008-12-08 17:17:03.000000000 +0100
@@ -2427,11 +2427,6 @@ static int ath9k_ampdu_action(struct iee
 	return ret;
 }
 
-static int ath9k_no_fragmentation(struct ieee80211_hw *hw, u32 value)
-{
-	return -EOPNOTSUPP;
-}
-
 static struct ieee80211_ops ath9k_ops = {
 	.tx 		    = ath9k_tx,
 	.start 		    = ath9k_start,
@@ -2448,7 +2443,6 @@ static struct ieee80211_ops ath9k_ops = 
 	.get_tsf 	    = ath9k_get_tsf,
 	.reset_tsf 	    = ath9k_reset_tsf,
 	.ampdu_action       = ath9k_ampdu_action,
-	.set_frag_threshold = ath9k_no_fragmentation,
 };
 
 static struct {


