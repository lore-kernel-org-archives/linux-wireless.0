Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34707 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbYKPXJo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2008 18:09:44 -0500
Date: Sun, 16 Nov 2008 17:09:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix pid rate-setting algorithm to allow rate
 changes
Message-ID: <4920a825.Othkfehwlj87g6L4%Larry.Finger@lwfinger.net> (sfid-20081117_000949_943241_D7036AE7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 9ea2c74 named "mac80211/drivers: rewrite the rate control API",
the meaning of status.rates[i].count was changed from number of retries
to total number of tries. As a result, the pid rate-setting algorithm fails
because every packet appears to have needed a retransmit.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---

John,

The commit that is being fixed has not yet made it to mainline; therefore
this is 2.6.29 material.

Larry
---

Index: wireless-testing/net/mac80211/rc80211_pid_algo.c
===================================================================
--- wireless-testing.orig/net/mac80211/rc80211_pid_algo.c
+++ wireless-testing/net/mac80211/rc80211_pid_algo.c
@@ -256,7 +256,7 @@ static void rate_control_pid_tx_status(v
 	if (!(info->flags & IEEE80211_TX_STAT_ACK)) {
 		spinfo->tx_num_failed += 2;
 		spinfo->tx_num_xmit++;
-	} else if (info->status.rates[0].count) {
+	} else if (info->status.rates[0].count > 1) {
 		spinfo->tx_num_failed++;
 		spinfo->tx_num_xmit++;
 	}
