Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:45714 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3GKJaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 05:30:46 -0400
Received: by mail-pb0-f53.google.com with SMTP id xb12so7686524pbc.26
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jul 2013 02:30:46 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] nl80211: fix the setting of RSSI threshold value for mesh
Date: Thu, 11 Jul 2013 17:23:35 +0800
Message-Id: <1373534615-17270-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130711_113054_293010_A6AB87C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RSSI threshold value used for mesh peering should be in
negative value. After range checks to mesh parameters is
introduced, this is not allowed. Fix this.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/wireless/nl80211.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a9444cd..e6164ab 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4803,9 +4803,9 @@ do {									    \
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshForwarding, 0, 1,
 				  mask, NL80211_MESHCONF_FORWARDING,
 				  nla_get_u8);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, rssi_threshold, 1, 255,
-				  mask, NL80211_MESHCONF_RSSI_THRESHOLD,
-				  nla_get_u32);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, rssi_threshold,
+				  0x80000000, 0xFFFFFFFF, mask,
+				  NL80211_MESHCONF_RSSI_THRESHOLD, nla_get_u32);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, ht_opmode, 0, 16,
 				  mask, NL80211_MESHCONF_HT_OPMODE,
 				  nla_get_u16);
-- 
1.7.0.4

