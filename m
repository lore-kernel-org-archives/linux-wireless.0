Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:39722 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230Ab0AOAu2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 19:50:28 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH] mac80211: check that ieee80211_set_power_mgmt only handles STA interfaces.
Date: Fri, 15 Jan 2010 01:48:17 +0100
Message-Id: <1263516497-17332-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_set_power_mgmt is meant for STA interfaces only. Moreover,
since sdata->u.mgd.mtx is only initialized for STA interfaces, using
this code for any other type of interface (like IBSS) will result in a
oops.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 net/mac80211/cfg.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8286df5..c9de4e3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1382,6 +1382,9 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_conf *conf = &local->hw.conf;
 
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return 0;
+
 	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
 		return -EOPNOTSUPP;
 
-- 
1.6.3.3

