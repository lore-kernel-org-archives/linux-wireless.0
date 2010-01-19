Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:45041 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754937Ab0ASSzV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 13:55:21 -0500
Date: Tue, 19 Jan 2010 10:53:30 -0800
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Allow association to change channels during
 reassociation
Message-ID: <20100119185330.GA26351@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nl80211_associate() was rejecting (re)association attempts with EBUSY
in some cases where we are currently associated with an AP that uses
different channel from the destination AP. Fix this by passing the
current wdev to rdev_fixed_channel() in the same way that was already
done for join-IBSS and connect commands. This allows the fixedchan
check to skipped for the current wdev and allows the reassociation to
proceed.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 net/wireless/nl80211.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

I'm not sure when exactly this issue showed up (i.e., whether this
reassociation case used to work or whether we managed to break it at
some point), but the EBUSY is certainly showing up very frequently
with the current wireless-testing.git snapshot in an environment with
large number of APs in the ESS and frequent roaming between them.


--- wireless-testing.orig/net/wireless/nl80211.c	2010-01-19 10:38:20.000000000 -0800
+++ wireless-testing/net/wireless/nl80211.c	2010-01-19 10:38:46.000000000 -0800
@@ -3571,6 +3571,7 @@ static int nl80211_associate(struct sk_b
 {
 	struct cfg80211_registered_device *rdev;
 	struct net_device *dev;
+	struct wireless_dev *wdev;
 	struct cfg80211_crypto_settings crypto;
 	struct ieee80211_channel *chan, *fixedchan;
 	const u8 *bssid, *ssid, *ie = NULL, *prev_bssid = NULL;
@@ -3616,7 +3617,8 @@ static int nl80211_associate(struct sk_b
 	}
 
 	mutex_lock(&rdev->devlist_mtx);
-	fixedchan = rdev_fixed_channel(rdev, NULL);
+	wdev = dev->ieee80211_ptr;
+	fixedchan = rdev_fixed_channel(rdev, wdev);
 	if (fixedchan && chan != fixedchan) {
 		err = -EBUSY;
 		mutex_unlock(&rdev->devlist_mtx);

-- 
Jouni Malinen                                            PGP id EFC895FA
