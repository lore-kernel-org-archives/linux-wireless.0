Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36011 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbbDPFQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2015 01:16:08 -0400
Received: by pabsx10 with SMTP id sx10so76385396pab.3
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2015 22:16:07 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] cfg80211: allow the plink state blocking for user managed mesh
Date: Thu, 16 Apr 2015 13:15:37 +0800
Message-Id: <1429161337-32680-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20150416_071611_579545_1DEDB2F2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

User managed peering has no way to block the plink state
for mesh peering setup by wpa_supp or authsae. Try to do
allow this in kernel space, so that we can use iw utility
to do that.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dd78445..8a33bba 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4061,7 +4061,8 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 			return -EINVAL;
 		break;
 	case CFG80211_STA_MESH_PEER_USER:
-		if (params->plink_action != NL80211_PLINK_ACTION_NO_ACTION)
+		if (params->plink_action != NL80211_PLINK_ACTION_NO_ACTION &&
+		    params->plink_action != NL80211_PLINK_ACTION_BLOCK)
 			return -EINVAL;
 		break;
 	}
-- 
2.3.0

