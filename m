Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51461 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab2G0LR6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:17:58 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 14/20] mac80211: check operating channel in scan
Date: Fri, 27 Jul 2012 13:16:50 +0200
Message-Id: <1343387816-9414-15-git-send-email-johannes@sipsolutions.net> (sfid-20120727_131834_247965_AA5A7136)
In-Reply-To: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The optimisation of scanning only on the current
channel should check the operating channel. Also
modify it to compare channel pointer rather than
the frequency.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/scan.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index e80a8b6..0045869 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -480,11 +480,10 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	if (local->ops->hw_scan) {
 		__set_bit(SCAN_HW_SCANNING, &local->scanning);
 	} else if ((req->n_channels == 1) &&
-		   (req->channels[0]->center_freq ==
-		    local->hw.conf.channel->center_freq)) {
-
-		/* If we are scanning only on the current channel, then
-		 * we do not need to stop normal activities
+		   (req->channels[0] == local->oper_channel)) {
+		/*
+		 * If we are scanning only on the operating channel
+		 * then we do not need to stop normal activities
 		 */
 		unsigned long next_delay;
 
-- 
1.7.10.4

