Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45928 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932770Ab1IRXY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Sep 2011 19:24:29 -0400
Received: by yxm8 with SMTP id 8so3746212yxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2011 16:24:28 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Manual Munz <freifunk@somakoma.de>, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@kernel.org>
Subject: [PATCH] b43: Fix beacon problem in ad-hoc mode
Date: Sun, 18 Sep 2011 18:24:03 -0500
Message-Id: <1316388243-5830-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110919_012432_424921_5D3D3BB9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Manual Munz <freifunk@somakoma.de>

In ad-hoc mode, driver b43 does not issue beacons.

Signed-off-by: Manual Munz <freifunk@somakoma.de>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@kernel.org>
---

 drivers/net/wireless/b43/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 2407702..56fa3a3 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1637,7 +1637,8 @@ static void handle_irq_beacon(struct b43_wldev *dev)
 	u32 cmd, beacon0_valid, beacon1_valid;
 
 	if (!b43_is_mode(wl, NL80211_IFTYPE_AP) &&
-	    !b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT))
+	    !b43_is_mode(wl, NL80211_IFTYPE_MESH_POINT) &&
+	    !b43_is_mode(wl, NL80211_IFTYPE_ADHOC))
 		return;
 
 	/* This is the bottom half of the asynchronous beacon update. */
-- 
1.7.6.1

