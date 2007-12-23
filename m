Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:59247 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754166AbXLWDsG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 22:48:06 -0500
Date: Sun, 23 Dec 2007 04:43:57 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Mattias Nissler <mattias.nissler@gmx.de>
Subject: [PATCH 4/7] rc80211-pid: fix sta_info refcounting
Message-ID: <20071223044357.0693c63a@morte> (sfid-20071223_034809_772408_E0BF0D14)
In-Reply-To: <20071223033633.710907923@polimi.it>
References: <20071223033633.710907923@polimi.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a bug which caused uncorrect refcounting of PHYs in mac80211. Thanks to
Johannes Berg for spotting this out.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
 rc80211_pid_algo.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: wireless-2.6/net/mac80211/rc80211_pid_algo.c
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_pid_algo.c
+++ wireless-2.6/net/mac80211/rc80211_pid_algo.c
@@ -254,7 +254,7 @@ static void rate_control_pid_tx_status(v
 	/* Ignore all frames that were sent with a different rate than the rate
 	 * we currently advise mac80211 to use. */
 	if (status->control.rate != &local->oper_hw_mode->rates[sta->txrate])
-		return;
+		goto ignore;

 	spinfo = sta->rate_ctrl_priv;
 	spinfo->tx_num_xmit++;
@@ -295,6 +295,7 @@ static void rate_control_pid_tx_status(v
 	if (time_after(jiffies, spinfo->last_sample + period))
 		rate_control_pid_sample(pinfo, local, sta);

+ignore:
 	sta_info_put(sta);
 }


-- 
Ciao
Stefano
