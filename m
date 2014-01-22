Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:41629 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaAVGxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 01:53:23 -0500
Received: by mail-pd0-f178.google.com with SMTP id y13so9293215pdi.9
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jan 2014 22:53:22 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	devel@lists.open80211s.org, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: fix the increment of mesh precedence value
Date: Wed, 22 Jan 2014 14:53:04 +0800
Message-Id: <1390373584-24716-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20140122_075329_742648_520B21D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mesh precedence value in ieee80211_channel_switch
should be incremented or set to 1 only if this is the
initiator of mesh channel switch. For non-initiator,
the precedence value has updated using the Mesh
Channel Switch Parameters element. Fix this.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/cfg.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 032081c..e948b38 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3207,13 +3207,13 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 		    params->chandef.chan->band)
 			return -EINVAL;
 
-		if (!ifmsh->pre_value)
-			ifmsh->pre_value = 1;
-		else
-			ifmsh->pre_value++;
-
-		if (ifmsh->csa_role == IEEE80211_MESH_CSA_ROLE_NONE)
+		if (ifmsh->csa_role == IEEE80211_MESH_CSA_ROLE_NONE) {
 			ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_INIT;
+			if (!ifmsh->pre_value)
+				ifmsh->pre_value = 1;
+			else
+				ifmsh->pre_value++;
+		}
 
 		/* see comments in the NL80211_IFTYPE_AP block */
 		if (params->count > 1) {
-- 
1.7.9.5

