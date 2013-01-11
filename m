Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45835 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab3AKNXE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2013 08:23:04 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] wireless: fix regulatory HT40 allowed check
Date: Fri, 11 Jan 2013 14:22:58 +0100
Message-Id: <1357910578-6988-1-git-send-email-nbd@openwrt.org> (sfid-20130111_142312_913948_5FDEB381)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 1a9193185f462a51815fe48491f8a6fb6b942551 "regulatory: code cleanup"
changed is_ht40_allowed without considering that IEEE80211_CHAN_NO_HT40 is
not just one flag, but two.
This is causing HT40- to be blocked completely.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/wireless/reg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a21d703..de02d63 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1123,7 +1123,9 @@ static bool is_ht40_allowed(struct ieee80211_channel *chan)
 	if (chan->flags & IEEE80211_CHAN_DISABLED)
 		return false;
 	/* This would happen when regulatory rules disallow HT40 completely */
-	return !(chan->flags & IEEE80211_CHAN_NO_HT40);
+	if ((chan->flags & IEEE80211_CHAN_NO_HT40) == IEEE80211_CHAN_NO_HT40)
+		return false;
+	return true;
 }
 
 static void reg_process_ht_flags_channel(struct wiphy *wiphy,
-- 
1.8.0.2

