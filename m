Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45521 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab2LDTuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 14:50:44 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: honour no-OFDM flag for channel wider than 20 MHz
Date: Tue,  4 Dec 2012 20:51:06 +0100
Message-Id: <1354650666-28067-1-git-send-email-johannes@sipsolutions.net> (sfid-20121204_205047_309032_0C83467F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For channels wider than 20 MHz OFDM will be used, so when
checking whether or not a channel is usable, check for the
no-OFDM flag if the channel is wider than 20 MHz.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/chan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index b5f6983..a7990bb 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -265,6 +265,9 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 
 	/* TODO: missing regulatory check on 80/160 bandwidth */
 
+	if (width > 20)
+		prohibited_flags |= IEEE80211_CHAN_NO_OFDM;
+
 	if (!cfg80211_secondary_chans_ok(wiphy, chandef->center_freq1,
 					 width, prohibited_flags))
 		return false;
-- 
1.8.0

