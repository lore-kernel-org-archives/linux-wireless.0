Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4774 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388AbYCYQHh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 12:07:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	"John W. Linville" <linville@linville-t41.local>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: silently accept deletion of non-existant key
Date: Tue, 25 Mar 2008 11:43:15 -0400
Message-Id: <1206459795-18167-1-git-send-email-linville@tuxdriver.com> (sfid-20080325_160740_822036_736A9E3D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: John W. Linville <linville@linville-t41.local>

Otherwise, 'iwconfig wlan0 key off' with no key set results in:

	Error for wireless request "Set Encode" (8B2A) :
	    SET failed on device wlan0 ; No such file or directory.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Is it really worth returning an error if someone tries to delete an
non-existant key?  Does hostapd make some use of that?

Would it be worth having a debug message in the non-existant key case?

 net/mac80211/ieee80211_ioctl.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index 1d91575..7d6d52d 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -55,9 +55,6 @@ static int ieee80211_set_encryption(struct net_device *dev, u8 *sta_addr,
 			key = sta->key;
 		}
 
-		if (!key)
-			return -ENOENT;
-
 		ieee80211_key_free(key);
 		return 0;
 	} else {
-- 
1.5.4.1

