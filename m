Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:38116 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab3AJPxl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2013 10:53:41 -0500
Received: by mail-pb0-f44.google.com with SMTP id uo1so374181pbc.3
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2013 07:53:40 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: allow disable power save in mesh
Date: Thu, 10 Jan 2013 23:31:54 +0800
Message-Id: <1357831914-27209-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130110_165347_025685_D558AAC2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow mesh interface to disable the power save which is by default
turn on in certain chipset. Testing with 2 units of ZCN-1523H-5-16
featuring AR9280 chipset which have power save enabled by default.
Constant reset if the average signal of the peer mesh STA is below
-80 dBm and power save is enabled.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/cfg.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7d290bc..817992b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2232,7 +2232,8 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
+	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
 		return -EOPNOTSUPP;
 
 	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
-- 
1.7.0.4

