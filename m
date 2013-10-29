Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:50789 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3J2WOU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 18:14:20 -0400
Received: by mail-qa0-f51.google.com with SMTP id ii20so412973qab.17
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 15:14:20 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] Revert "mac80211: allow disable power save in mesh"
Date: Tue, 29 Oct 2013 18:11:59 -0400
Message-Id: <1383084719-26610-1-git-send-email-me@bobcopeland.com> (sfid-20131029_231424_570524_73E2C93C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit ee1f668136b2fb6640ee2d54c2a525ea41f98211.

The aformentioned commit added a check to allow
'iw wlan0 set power_save off' to work for mesh interfaces.

However, this is problematic because it also allows
'iw wlan0 set power_save on', which will crash in short order
because all of the subsequent code manipulates sdata->u.mgd.

The power-saving states for mesh interfaces can be manipulated
through the mesh config, e.g:
'iw wlan0 set mesh_param mesh_power_save=active' (which,
despite the name, actualy disables power saving since the
setting refers to the type of sleep the interface undergoes).

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
Chun-Yeow, I ran into the above mentioned crash when playing with
mesh PS.  Can you clarify how the original patch helped?

 net/mac80211/cfg.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ed1e9a8..478211c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2488,8 +2488,7 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
-	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
-	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return -EOPNOTSUPP;
 
 	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
-- 
1.7.10.4

