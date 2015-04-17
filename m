Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35910 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933937AbbDQRaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 13:30:21 -0400
Received: by pdea3 with SMTP id a3so134444319pde.3
        for <linux-wireless@vger.kernel.org>; Fri, 17 Apr 2015 10:30:21 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v2] cfg80211: allow the plink state blocking for user managed mesh
Date: Sat, 18 Apr 2015 01:30:02 +0800
Message-Id: <1429291802-14168-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20150417_193025_697424_9F170FBA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wpa_supplicant or authsae handles the mesh peering in user
space, but the plink state is still managed in kernel space.
Currently, there is no implementation by wpa_supplicant or
authsae to block the plink state after it is set to ESTAB.

By applying this patch, we can use the "iw mesh0 station set
<MAC address> plink_action block" to block the peer mesh STA.
This is useful for experimenting purposes.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

v2: respin the commit log (Johannes)
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

