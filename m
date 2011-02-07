Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49083 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab1BGTD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 14:03:56 -0500
Date: Mon, 7 Feb 2011 22:03:35 +0300
From: Dan Carpenter <error27@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mac80211: remove unneeded check
Message-ID: <20110207190335.GK4384@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"ap" is the address of sdata->u.ap so it can never be NULL here.  Also
we dereferenced it on the previous line.  I removed the check.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f305835..ce01bee 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2242,7 +2242,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
 		ap = &sdata->u.ap;
 		beacon = rcu_dereference(ap->beacon);
-		if (ap && beacon) {
+		if (beacon) {
 			/*
 			 * headroom, head length,
 			 * tail length and maximum TIM length
