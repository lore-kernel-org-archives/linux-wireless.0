Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:39216 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab3GKKbD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 06:31:03 -0400
Received: by mail-pd0-f169.google.com with SMTP id y10so7430165pdj.28
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jul 2013 03:31:02 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v2] nl80211: fix the setting of RSSI threshold value for mesh
Date: Thu, 11 Jul 2013 18:24:03 +0800
Message-Id: <1373538243-17628-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130711_123108_093401_9DF7B752)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RSSI threshold value used for mesh peering should be in
negative value. After range checks to mesh parameters is
introduced, this is not allowed. Fix this.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
v2:
	use nla_get_s32 instead (Johannes)

 net/wireless/nl80211.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a9444cd..0fc6e3a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4803,9 +4803,9 @@ do {									    \
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshForwarding, 0, 1,
 				  mask, NL80211_MESHCONF_FORWARDING,
 				  nla_get_u8);
-	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, rssi_threshold, 1, 255,
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, rssi_threshold, -255, 0,
 				  mask, NL80211_MESHCONF_RSSI_THRESHOLD,
-				  nla_get_u32);
+				  nla_get_s32);
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, ht_opmode, 0, 16,
 				  mask, NL80211_MESHCONF_HT_OPMODE,
 				  nla_get_u16);
-- 
1.7.0.4

