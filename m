Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35492 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbaK0QaJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 11:30:09 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: don't crash sending invalid chandef
Date: Thu, 27 Nov 2014 17:30:05 +0100
Message-Id: <1417105805-10065-1-git-send-email-johannes@sipsolutions.net> (sfid-20141127_173019_050173_D0F3B864)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

One of the cases for an invalid channel definition is that
the channel pointer is NULL, in which case the warning is
a bit late since we'll dereference the pointer. Bail out
of the function upon warning about this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e11980e74a04..4fae26d722f8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2317,7 +2317,8 @@ static inline u64 wdev_id(struct wireless_dev *wdev)
 static int nl80211_send_chandef(struct sk_buff *msg,
 				const struct cfg80211_chan_def *chandef)
 {
-	WARN_ON(!cfg80211_chandef_valid(chandef));
+	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
+		return -EINVAL;
 
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ,
 			chandef->chan->center_freq))
-- 
2.1.1

