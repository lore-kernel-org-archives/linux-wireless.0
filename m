Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:53099 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab2DKMzs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 08:55:48 -0400
From: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <lukasz.kucharczyk@tieto.com>
Subject: [PATCH] cfg80211: fix interface combinations check.
Date: Wed, 11 Apr 2012 14:55:10 +0200
Message-ID: <1334148910-25178-1-git-send-email-lukasz.kucharczyk@tieto.com> (sfid-20120411_145552_502783_0F747DDE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
---
 net/wireless/util.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 1b7a08d..957f256 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -989,7 +989,7 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 			if (rdev->wiphy.software_iftypes & BIT(iftype))
 				continue;
 			for (j = 0; j < c->n_limits; j++) {
-				if (!(limits[j].types & iftype))
+				if (!(limits[j].types & BIT(iftype)))
 					continue;
 				if (limits[j].max < num[iftype])
 					goto cont;
-- 
1.7.0.4

