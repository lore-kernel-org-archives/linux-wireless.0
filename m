Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40058 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293AbaKSRxt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 12:53:49 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: jukka.rissanen@linux.intel.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211-hwsim: remove unnecessary hwname check
Date: Wed, 19 Nov 2014 18:53:44 +0100
Message-Id: <1416419624-10626-1-git-send-email-johannes@sipsolutions.net> (sfid-20141119_185358_546833_B6BFCCCD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The hwname will always be set if idx is negative (as it's
a u32 read into an s64 it can't overflow either) so we can
remove the unnecessary check for hwname being non-NULL.

This was reported by smatch.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index bbbcc4d8bb91..c88a21acda64 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2808,8 +2808,7 @@ static int hwsim_del_radio_nl(struct sk_buff *msg, struct genl_info *info)
 			if (data->idx != idx)
 				continue;
 		} else {
-			if (hwname &&
-			    strcmp(hwname, wiphy_name(data->hw->wiphy)))
+			if (strcmp(hwname, wiphy_name(data->hw->wiphy)))
 				continue;
 		}
 
-- 
2.1.1

