Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:33324 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752499AbeAOIOI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 03:14:08 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: fully initialize old channel for event
Date: Mon, 15 Jan 2018 09:14:03 +0100
Message-Id: <20180115081403.4370-1-johannes@sipsolutions.net> (sfid-20180115_091412_212292_1103E657)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Paul reported that he got a report about undefined behaviour
that seems to me to originate in using uninitialized memory
when the channel structure here is used in the event code in
nl80211 later.

He never reported whether this fixed it, and I wasn't able
to trigger this so far, but we should do the right thing and
fully initialize the on-stack structure anyway.

Reported-by: Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 78e71b0390be..7b42f0bacfd8 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1769,8 +1769,7 @@ static void handle_reg_beacon(struct wiphy *wiphy, unsigned int chan_idx,
 	if (wiphy->regulatory_flags & REGULATORY_DISABLE_BEACON_HINTS)
 		return;
 
-	chan_before.center_freq = chan->center_freq;
-	chan_before.flags = chan->flags;
+	chan_before = *chan;
 
 	if (chan->flags & IEEE80211_CHAN_NO_IR) {
 		chan->flags &= ~IEEE80211_CHAN_NO_IR;
-- 
2.15.1
