Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:52532 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2LSSxS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2012 13:53:18 -0500
Received: by mail-pb0-f42.google.com with SMTP id rp2so1420358pbb.1
        for <linux-wireless@vger.kernel.org>; Wed, 19 Dec 2012 10:53:18 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net, greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 1/3] cfg80211: do not process beacon hints if one is already queued
Date: Wed, 19 Dec 2012 10:53:02 -0800
Message-Id: <1355943184-966-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20121219_195323_017434_6236DF30)
In-Reply-To: <1355943184-966-1-git-send-email-mcgrof@do-not-panic.com>
References: <1355943184-966-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Regulatory beacon hints are used to help with world roaming
and as it is right now we learn from a beacon hint processed
on one wiphy to all other wiphys. The processing of beacon
hints however is scheduled and if we have a lot of interfaces
we may hit the case that we'll queue a the same beacon hint
many times until its processed.

To avoid this do a lookup on the queued up beacon hints prior
to adding a new beacon hint. If the beacon hint is removed
from the pending reg beacon hint list then it would be processed
and we'd ensure all wiphys would have learned from it, if its
on the pending reg beacon list we'd now find it prior to it
being processed.

Tested-by: Ben Greear <greearb@candelatech.com>
Reported-by: Ben Greear <greearb@candelatech.com>
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6e53089..a2d5a03 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2051,11 +2051,23 @@ static bool freq_is_chan_12_13_14(u16 freq)
 	return false;
 }
 
+static bool pending_reg_beacon(struct ieee80211_channel *beacon_chan)
+{
+	struct reg_beacon *pending_beacon;
+
+	list_for_each_entry(pending_beacon, &reg_pending_beacons, list)
+		if (beacon_chan->center_freq ==
+		    pending_beacon->chan.center_freq)
+			return true;
+	return false;
+}
+
 int regulatory_hint_found_beacon(struct wiphy *wiphy,
 				 struct ieee80211_channel *beacon_chan,
 				 gfp_t gfp)
 {
 	struct reg_beacon *reg_beacon;
+	bool processing;
 
 	if (likely((beacon_chan->beacon_found ||
 	    (beacon_chan->flags & IEEE80211_CHAN_RADAR) ||
@@ -2063,6 +2075,13 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
 	     !freq_is_chan_12_13_14(beacon_chan->center_freq)))))
 		return 0;
 
+	spin_lock_bh(&reg_pending_beacons_lock);
+	processing = pending_reg_beacon(beacon_chan);
+	spin_unlock_bh(&reg_pending_beacons_lock);
+
+	if (processing)
+		return 0;
+
 	reg_beacon = kzalloc(sizeof(struct reg_beacon), gfp);
 	if (!reg_beacon)
 		return -ENOMEM;
-- 
1.7.10.4

