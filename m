Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:53437 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328Ab3CDVIC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 16:08:02 -0500
Received: by mail-pb0-f51.google.com with SMTP id un15so3423910pbc.10
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2013 13:08:01 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolution.net
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v2 5/5] mac80211: disallow changing auto_open_plinks
Date: Mon,  4 Mar 2013 13:06:14 -0800
Message-Id: <1362431174-4747-5-git-send-email-thomas@cozybit.com> (sfid-20130304_220807_122680_9E3B622F)
In-Reply-To: <1362431174-4747-1-git-send-email-thomas@cozybit.com>
References: <1362431174-4747-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

while user MPM is running.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/cfg.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 89c7b00..ebfb060 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1773,8 +1773,11 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
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

