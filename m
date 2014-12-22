Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33152 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616AbaLVLxL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2014 06:53:11 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: David Binderman <dcb314@hotmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: fix check for custom world regdom array size
Date: Mon, 22 Dec 2014 12:53:07 +0100
Message-Id: <1419249187-8823-1-git-send-email-johannes@sipsolutions.net> (sfid-20141222_125317_968318_6BEE314D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

David Binderman reports that the conditions in the first loop
are the wrong way around - checking the array contents before
the size.

Instead of leaving the empty loop there and reordering the two
checks unify it into a single loop that skips over non-matches
and exits after the first match.

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index a71b9d5e353d..057a99e01637 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2150,14 +2150,14 @@ static int append_radio_msg(struct sk_buff *skb, int id,
 	if (param->regd) {
 		int i;
 
-		for (i = 0; hwsim_world_regdom_custom[i] != param->regd &&
-		     i < ARRAY_SIZE(hwsim_world_regdom_custom); i++)
-			;
+		for (i = 0; i < ARRAY_SIZE(hwsim_world_regdom_custom); i++) {
+			if (hwsim_world_regdom_custom[i] != param->regd)
+				continue;
 
-		if (i < ARRAY_SIZE(hwsim_world_regdom_custom)) {
 			ret = nla_put_u32(skb, HWSIM_ATTR_REG_CUSTOM_REG, i);
 			if (ret < 0)
 				return ret;
+			break;
 		}
 	}
 
-- 
2.1.1

