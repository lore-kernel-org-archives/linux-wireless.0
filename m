Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:63004 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750938AbaK1F7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 00:59:43 -0500
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	<linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH] cfg80211: do not check for carrier during start_radar_detect
Date: Fri, 28 Nov 2014 16:58:47 +0530
Message-ID: <1417174127-24712-1-git-send-email-patila@marvell.com> (sfid-20141128_065946_328398_4C9C2336)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Radar detection happens before starting AP; so netdev carrier may be dormant
at this time. Remove this check from cfg80211_start_radar_detection.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 net/wireless/nl80211.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6e41777..25f68d6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6132,9 +6132,6 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (err)
 		return err;
 
-	if (netif_carrier_ok(dev))
-		return -EBUSY;
-
 	if (wdev->cac_started)
 		return -EBUSY;
 
-- 
1.8.1.4

