Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54255 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758505AbZCMPAj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 11:00:39 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2009 08:00:38 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Populate HT limitation with TKIP/WEP to the handler for SIOCSIWENCODE too
Date: Fri, 13 Mar 2009 20:26:52 +0530
Message-ID: <1236956212-28648-1-git-send-email-vasanth@atheros.com> (sfid-20090313_160050_022208_CF3B2FD6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 net/mac80211/wext.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 935c63e..e55d283 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -630,7 +630,7 @@ static int ieee80211_ioctl_siwencode(struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata;
 	int idx, i, alg = ALG_WEP;
 	u8 bcaddr[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
-	int remove = 0;
+	int remove = 0, ret;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -656,11 +656,20 @@ static int ieee80211_ioctl_siwencode(struct net_device *dev,
 		return 0;
 	}
 
-	return ieee80211_set_encryption(
+	ret = ieee80211_set_encryption(
 		sdata, bcaddr,
 		idx, alg, remove,
 		!sdata->default_key,
 		keybuf, erq->length);
+
+	if (!ret) {
+		if (remove)
+			sdata->u.mgd.flags &= ~IEEE80211_STA_TKIP_WEP_USED;
+		else
+			sdata->u.mgd.flags |= IEEE80211_STA_TKIP_WEP_USED;
+	}
+
+	return ret;
 }
 
 
-- 
1.5.5.1

