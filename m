Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:39982 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab3LBIG3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 03:06:29 -0500
Received: by mail-pd0-f179.google.com with SMTP id r10so17699721pdi.10
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 00:06:28 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] nl80211: allow the use of DFS channel in mesh
Date: Mon,  2 Dec 2013 16:05:49 +0800
Message-Id: <1385971550-4892-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20131202_090632_203138_30FA4F45)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This permits the use of DFS channel once the CAC is conducted and
no radar is detected.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/wireless/mesh.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index b0e1869..9c7a11a 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -99,6 +99,7 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 			 const struct mesh_config *conf)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	u8 radar_detect_width = 0;
 	int err;
 
 	BUILD_BUG_ON(IEEE80211_MAX_SSID_LEN != IEEE80211_MAX_MESH_ID_LEN);
@@ -177,8 +178,16 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef))
 		return -EINVAL;
 
-	err = cfg80211_can_use_chan(rdev, wdev, setup->chandef.chan,
-				    CHAN_MODE_SHARED);
+	err = cfg80211_chandef_dfs_required(wdev->wiphy, &setup->chandef);
+	if (err < 0)
+		return err;
+	if (err)
+		radar_detect_width = BIT(setup->chandef.width);
+
+	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
+					   setup->chandef.chan,
+					   CHAN_MODE_SHARED,
+					   radar_detect_width);
 	if (err)
 		return err;
 
-- 
1.7.9.5

