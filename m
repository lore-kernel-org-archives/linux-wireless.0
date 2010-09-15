Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:61632 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab0IOLy6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 07:54:58 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Sep 2010 04:54:52 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [RFC] mac80211: avoid recalc_idle in monitor mode
Date: Wed, 15 Sep 2010 17:26:12 +0530
Message-ID: <1284551772-18574-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k is not receiving frames in monitor mode after the commit 34d4bc.
The problem is mac80211 sets IEEE80211_CONF_IDLE in __ieee80211_recalc_idle
at ieee80211_do_open. Due to this, ath9k disables the radio.

The above said commit sets SDATA_STATE_RUNNING after __ieee80211_recalc_idle.
IMHO avoiding __ieee80211_recalc_idle in monitor mode looks better
than moving SDATA_STATE_RUNNING set before __ieee80211_recalc_idle.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 net/mac80211/iface.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index c1cc200..2bec319 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -310,9 +310,11 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 	if (sdata->flags & IEEE80211_SDATA_PROMISC)
 		atomic_inc(&local->iff_promiscs);
 
-	mutex_lock(&local->mtx);
-	hw_reconf_flags |= __ieee80211_recalc_idle(local);
-	mutex_unlock(&local->mtx);
+	if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
+		mutex_lock(&local->mtx);
+		hw_reconf_flags |= __ieee80211_recalc_idle(local);
+		mutex_unlock(&local->mtx);
+	}
 
 	if (coming_up)
 		local->open_count++;
-- 
1.7.2.3

