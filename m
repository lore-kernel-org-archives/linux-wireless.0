Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:63415 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3FREJb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 00:09:31 -0400
Received: by mail-pa0-f54.google.com with SMTP id kx10so3541509pab.27
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 21:09:31 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: allow key deletion for mesh interface
Date: Tue, 18 Jun 2013 12:07:02 +0800
Message-Id: <1371528422-20710-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130618_060934_526524_83376635)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is to support key deletion for mesh interface, especially
to be used for key which is not deleted even with the deletion
of peer mesh station.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/cfg.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 64cf294..6ff3414 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -239,7 +239,10 @@ static int ieee80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 	if (mac_addr) {
 		ret = -ENOENT;
 
-		sta = sta_info_get_bss(sdata, mac_addr);
+		if (ieee80211_vif_is_mesh(&sdata->vif))
+			sta = sta_info_get(sdata, mac_addr);
+		else
+			sta = sta_info_get_bss(sdata, mac_addr);
 		if (!sta)
 			goto out_unlock;
 
-- 
1.7.0.4

