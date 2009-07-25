Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:59060 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZGYNG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 09:06:28 -0400
Received: by fg-out-1718.google.com with SMTP id e12so244068fga.17
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2009 06:06:27 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] mac80211: fix oops in ieee80211_scan_state_set_channel()
Date: Sat, 25 Jul 2009 15:06:34 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <20090725051801.2965.76768.stgit@ct.roinet.com>
In-Reply-To: <20090725051801.2965.76768.stgit@ct.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200907251506.34943.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag, 25. Juli 2009 schrieb Pavel Roskin:
> Move check for the final value of local->scan_channel_idx from
> ieee80211_scan_state_decision() to ieee80211_scan_state_set_channel().
> 
> Stop the state machine in ieee80211_scan_work() by checking
> local->scanning.  Don't return a value from
> ieee80211_scan_state_decision().

Hmm, I'd prefer to keep the decision state as entry and exit point to
the scan state machine. The patch below should also fix this issue
by returning back to the decision state after every skipped channel.

In the long run I would like to move the channel selection also to
the decision state in order to implement various improvements (like
scanning multiple channels in a row or reordering the channel list).

I was in the meantime able to reproduce the oops by setting an other
regulatory domain. Pavel, Larry, does this patch help you as well? 

Thanks,
Helmut

---
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index b376775..147772a 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -605,8 +605,11 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	/* advance state machine to next channel/band */
 	local->scan_channel_idx++;
 
-	if (skip)
+	if (skip) {
+		/* if we skip this channel return to the decision state */
+		local->next_scan_state = SCAN_DECISION;
 		return;
+	}
 
 	/*
 	 * Probe delay is used to update the NAV, cf. 11.1.3.2.2
