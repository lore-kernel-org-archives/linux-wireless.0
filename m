Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:50154 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932577AbeFFIr2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Jun 2018 04:47:28 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Matthias Fritzsche <txt.file@txtfile.eu>,
        Thomas Lauer <holminateur@gmail.com>,
        Marcel Schmidt <ff.z-casparistrasse@mailbox.org>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: [PATCH] cfg80211: initialize sinfo.filled in cfg80211_get_station
Date: Wed,  6 Jun 2018 10:47:02 +0200
Message-Id: <20180606084702.19825-1-sven@narfation.org> (sfid-20180606_104735_264206_D48BB1B6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most of the implementations behind cfg80211_get_station will not initialize
sinfo to zero before manipulating it. The member "filled", which indicates
the filled in parts of this struct, is often only modified by enabling
certain bits in the bitfield while keeping the remaining bits in their
original state. A caller without a preinitialized sinfo.filled can then no
longer decide which parts of sinfo were filled in by cfg80211_get_station
(or actually the underlying implementations).

cfg80211_get_station must therefore take care that sinfo.filled is
initialized to zero. Otherwise, the caller may tries to read information
which was not filled in and which must therefore also be considered
uninitialized. In batadv_v_elp_get_throughput's case, an invalid "random"
expected throughput may be stored for this neighbor and thus the
B.A.T.M.A.N V algorithm may switch to non-optimal neighbors for certain
destinations.

Fixes: 7406353d43c8 ("cfg80211: implement cfg80211_get_station cfg80211 API")
Reported-by: Thomas Lauer <holminateur@gmail.com>
Reported-by: Marcel Schmidt <ff.z-casparistrasse@mailbox.org>
Cc: b.a.t.m.a.n@lists.open-mesh.org
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
Matthias, you may want to take care that this is integrated in your
firmware.
---
 net/wireless/util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index b5bb1c309914..cd6a695d1230 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1746,6 +1746,8 @@ int cfg80211_get_station(struct net_device *dev, const u8 *mac_addr,
 	if (!rdev->ops->get_station)
 		return -EOPNOTSUPP;
 
+	sinfo->filled = 0;
+
 	return rdev_get_station(rdev, dev, mac_addr, sinfo);
 }
 EXPORT_SYMBOL(cfg80211_get_station);
-- 
2.11.0
