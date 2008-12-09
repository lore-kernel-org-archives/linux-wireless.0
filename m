Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52863 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbYLIL0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 06:26:47 -0500
Subject: [PATCH] ath9k: remove fragmentation workaround again
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 12:26:14 +0100
Message-Id: <1228821974.22164.201.camel@johannes.berg> (sfid-20081209_122651_474268_E3DC40AC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looking at the RC algorithm this is no longer necessary.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Untested, but the error that used to happen will no longer happen since
now the sub-structure is assigned by the driver, in rate_driver_data,
per fragment.

 drivers/net/wireless/ath9k/main.c |    6 ------
 1 file changed, 6 deletions(-)

--- everything.orig/drivers/net/wireless/ath9k/main.c	2008-12-08 21:54:08.000000000 +0100
+++ everything/drivers/net/wireless/ath9k/main.c	2008-12-08 21:54:20.000000000 +0100
@@ -2423,11 +2423,6 @@ static int ath9k_ampdu_action(struct iee
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
@@ -2444,7 +2439,6 @@ static struct ieee80211_ops ath9k_ops = 
 	.get_tsf 	    = ath9k_get_tsf,
 	.reset_tsf 	    = ath9k_reset_tsf,
 	.ampdu_action       = ath9k_ampdu_action,
-	.set_frag_threshold = ath9k_no_fragmentation,
 };
 
 static struct {


