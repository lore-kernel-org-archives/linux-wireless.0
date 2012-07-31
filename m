Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39101 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab2GaLoG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 07:44:06 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 07/10] mac80211: check operating channel in scan
Date: Tue, 31 Jul 2012 13:43:55 +0200
Message-Id: <1343735038-16030-8-git-send-email-johannes@sipsolutions.net> (sfid-20120731_134411_327572_3B45EAC6)
In-Reply-To: <1343735038-16030-1-git-send-email-johannes@sipsolutions.net>
References: <1343735038-16030-1-git-send-email-johannes@sipsolutions.net>
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

