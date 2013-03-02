Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:61776 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3CBGEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 01:04:13 -0500
Received: by mail-pb0-f44.google.com with SMTP id wz12so2143622pbc.31
        for <linux-wireless@vger.kernel.org>; Fri, 01 Mar 2013 22:04:13 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 5/6] mac80211: disallow changing auto_open_plinks
Date: Fri,  1 Mar 2013 22:02:51 -0800
Message-Id: <1362204172-28307-5-git-send-email-thomas@cozybit.com> (sfid-20130302_070422_162214_9EFED872)
In-Reply-To: <1362204172-28307-1-git-send-email-thomas@cozybit.com>
References: <1362204172-28307-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

while user MPM is running.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/cfg.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index cd9c222..f27eac5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1770,8 +1770,11 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 		conf->dot11MeshTTL = nconf->dot11MeshTTL;
 	if (_chg_mesh_attr(NL80211_MESHCONF_ELEMENT_TTL, mask))
 		conf->element_ttl = nconf->element_ttl;
-	if (_chg_mesh_attr(NL80211_MESHCONF_AUTO_OPEN_PLINKS, mask))
+	if (_chg_mesh_attr(NL80211_MESHCONF_AUTO_OPEN_PLINKS, mask)) {
+		if (ifmsh->user_mpm)
+			return -EBUSY;
 		conf->auto_open_plinks = nconf->auto_open_plinks;
+	}
 	if (_chg_mesh_attr(NL80211_MESHCONF_SYNC_OFFSET_MAX_NEIGHBOR, mask))
 		conf->dot11MeshNbrOffsetMaxNeighbor =
 			nconf->dot11MeshNbrOffsetMaxNeighbor;
-- 
1.7.10.4

