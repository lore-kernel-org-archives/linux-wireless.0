Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:34581 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab3KZPpV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 10:45:21 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH] mac80211: check csa wiphy flag in ibss before switching
Date: Tue, 26 Nov 2013 16:45:18 +0100
Message-Id: <1385480718-13702-1-git-send-email-sw@simonwunderlich.de> (sfid-20131126_164524_076498_0EA16859)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When external CSA IEs are received (beacons or action messages), a
channel switch is triggered as well. This should only be allowed on
devices which actually support channel switches, otherwise disconnect.
(For the corresponding userspace invocation, the wiphy flag is checked
in nl80211).

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/mac80211/ibss.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 0f1fb5d..2eda7b1 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -823,6 +823,10 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (err)
 		return false;
 
+	/* channel switch is not supported, disconnect */
+	if (!(sdata->local->hw.wiphy->flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH))
+		goto disconnect;
+
 	params.count = csa_ie.count;
 	params.chandef = csa_ie.chandef;
 
-- 
1.7.10.4

