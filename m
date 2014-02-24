Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48991 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaBXJQ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 04:16:59 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14] mac80211: don't validate unchanged AP bandwidth while tracking
Date: Mon, 24 Feb 2014 10:16:53 +0100
Message-Id: <1393233413-7964-1-git-send-email-johannes@sipsolutions.net> (sfid-20140224_101704_854365_6125D5BC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The MLME code in mac80211 must track whether or not the AP changed
bandwidth, but if there's no change while tracking it shouldn't do
anything, otherwise regulatory updates can make it impossible to
connect to certain APs if the regulatory database doesn't match the
information from the AP. See the precise scenario described in the
code.

This still leaves some possible problems with CSA or if the AP
actually changed bandwidth, but those cases are less common and
won't completely prevent using it.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=70881

Cc: stable@vger.kernel.org
Reported-and-tested-by: Nate Carlson <kernel@natecarlson.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 57d5482b10fa..c415f00cd6b6 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -271,6 +271,28 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 	ret = 0;
 
 out:
+	/*
+	 * When tracking the current AP, don't do any further checks if the
+	 * new chandef is identical to the one we're currently using for the
+	 * connection. This keeps us from playing ping-pong with regulatory,
+	 * without it the following can happen (for example):
+	 *  - connect to an AP with 80 MHz, world regdom allows 80 MHz
+	 *  - AP advertises regdom US
+	 *  - CRDA loads regdom US with 80 MHz prohibited (old database)
+	 *  - the code below detects an unsupported channel, downgrades, and
+	 *    we disconnect from the AP in the caller
+	 *  - disconnect causes CRDA to reload world regdomain and the game
+	 *    starts anew.
+	 * (see https://bugzilla.kernel.org/show_bug.cgi?id=70881)
+	 *
+	 * It seems possible that there are still scenarios with CSA or real
+	 * bandwidth changes where a this could happen, but those cases are
+	 * less common and wouldn't completely prevent using the AP.
+	 */
+	if (tracking &&
+	    cfg80211_chandef_identical(chandef, &sdata->vif.bss_conf.chandef))
+		return ret;
+
 	/* don't print the message below for VHT mismatch if VHT is disabled */
 	if (ret & IEEE80211_STA_DISABLE_VHT)
 		vht_chandef = *chandef;
-- 
1.8.5.3

