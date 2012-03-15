Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52489 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab2COOPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 10:15:37 -0400
Subject: [PATCH] mac80211: report only dBm station signal
From: Johannes Berg <johannes@sipsolutions.net>
To: Cristian Morales Vega <cristian@samknows.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1331820417.3432.16.camel@jlt3.sipsolutions.net> (sfid-20120315_150702_997199_9C292885)
References: <CAGUfO+wJd8wdcwzaigV=DYzhCNt8cNtWc4P=MoXJLd9ozHyPjg@mail.gmail.com>
	 (sfid-20120315_145933_601091_9647B8FA)  <1331820417.3432.16.camel@jlt3.sipsolutions.net>
	 (sfid-20120315_150702_997199_9C292885)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 15:15:35 +0100
Message-ID: <1331820935.3432.18.camel@jlt3.sipsolutions.net> (sfid-20120315_151540_937993_65922EE3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The station signal can currently only be reported
in dBm, so don't report it at all if we only have
unspecified units from the device.

Cc: stable@kernel.org
Reported-by: Cristian Morales Vega <cristian@samknows.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/mac80211/cfg.c	2012-03-10 09:17:06.000000000 +0100
+++ b/net/mac80211/cfg.c	2012-03-15 15:14:01.000000000 +0100
@@ -385,8 +385,7 @@ static void sta_set_sinfo(struct sta_inf
 	sinfo->rx_dropped_misc = sta->rx_dropped;
 	sinfo->beacon_loss_count = sta->beacon_loss_count;
 
-	if ((sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) ||
-	    (sta->local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)) {
+	if (sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) {
 		sinfo->filled |= STATION_INFO_SIGNAL | STATION_INFO_SIGNAL_AVG;
 		sinfo->signal = (s8)sta->last_signal;
 		sinfo->signal_avg = (s8) -ewma_read(&sta->avg_signal);


