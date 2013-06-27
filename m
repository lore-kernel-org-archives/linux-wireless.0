Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47892 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab3F0ITE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 04:19:04 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Us7Px-0004Sb-Al
	for linux-wireless@vger.kernel.org; Thu, 27 Jun 2013 10:19:01 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: fix missing rtnl_unlock()
Date: Thu, 27 Jun 2013 10:18:58 +0200
Message-Id: <1372321138-9694-1-git-send-email-johannes@sipsolutions.net> (sfid-20130627_101914_036426_FC726F28)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the new nl80211_dump_wiphy() handling I forgot to properly
unlock the RTNL (again!), fix that.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 785761f..66382b1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1568,8 +1568,10 @@ static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callback *cb)
 	rtnl_lock();
 	if (!state) {
 		state = kzalloc(sizeof(*state), GFP_KERNEL);
-		if (!state)
+		if (!state) {
+			rtnl_unlock();
 			return -ENOMEM;
+		}
 		state->filter_wiphy = -1;
 		ret = nl80211_dump_wiphy_parse(skb, cb, state);
 		if (ret) {
-- 
1.8.0

