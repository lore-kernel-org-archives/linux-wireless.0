Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:59183 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525Ab3GLLCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 07:02:43 -0400
Received: by mail-pb0-f49.google.com with SMTP id jt11so8845534pbb.8
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jul 2013 04:02:42 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: set the forwading in mesh capability info accordingly
Date: Fri, 12 Jul 2013 18:55:22 +0800
Message-Id: <1373626522-19486-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130712_130246_466187_16005499)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the Forwarding bit in Mesh Capability Info according
to dot11MeshForwarding as defined in IEEE 802.11-2012
section 8.4.2.100.8.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/mesh.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index e536f22..885a5f6 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -273,7 +273,9 @@ int mesh_add_meshconf_ie(struct ieee80211_sub_if_data *sdata,
 	neighbors = min_t(int, neighbors, IEEE80211_MAX_MESH_PEERINGS);
 	*pos++ = neighbors << 1;
 	/* Mesh capability */
-	*pos = IEEE80211_MESHCONF_CAPAB_FORWARDING;
+	*pos = 0x00;
+	*pos |= ifmsh->mshcfg.dot11MeshForwarding ?
+			IEEE80211_MESHCONF_CAPAB_FORWARDING : 0x00;
 	*pos |= ifmsh->accepting_plinks ?
 			IEEE80211_MESHCONF_CAPAB_ACCEPT_PLINKS : 0x00;
 	/* Mesh PS mode. See IEEE802.11-2012 8.4.2.100.8 */
-- 
1.7.0.4

