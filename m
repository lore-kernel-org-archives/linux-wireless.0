Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:41056 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab0AQVpr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 16:45:47 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH 2/2] mac80211: Fixed a bug in IBSS merge
Date: Sun, 17 Jan 2010 22:45:24 +0100
Message-Id: <1263764724-14660-2-git-send-email-benoit.papillault@free.fr>
In-Reply-To: <1263764724-14660-1-git-send-email-benoit.papillault@free.fr>
References: <1263764724-14660-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First, both beacons and probe responses can be used for IBSS merge.
Next, sdata->u.ibss.bssid was always true (and thus IBSS merge was
disabled). We should use sdata->u.ibss.fixed_bssid instead.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 net/mac80211/ibss.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index e0019f9..86bd2a0 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -355,12 +355,8 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 
 	/* check if we need to merge IBSS */
 
-	/* merge only on beacons (???) */
-	if (!beacon)
-		goto put_bss;
-
 	/* we use a fixed BSSID */
-	if (sdata->u.ibss.bssid)
+	if (sdata->u.ibss.fixed_bssid)
 		goto put_bss;
 
 	/* not an IBSS */
-- 
1.6.3.3

