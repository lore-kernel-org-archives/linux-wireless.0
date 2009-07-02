Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:62077 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbZGBVxU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 17:53:20 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.org
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	kalle.valo@nokia.com, vidhya.govindan@nokia.com, nbd@openwrt.org
Subject: [PATCH] mac80211: minstrel: avoid accessing negative indices in rix_to_ndx()
Date: Fri,  3 Jul 2009 00:52:29 +0300
Message-Id: <1246571549-29014-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If rix is not found in mi->r[], i will become -1 after the loop.  This value
is eventually used to access arrays, so we were accessing arrays with a
negative index, which is obviously not what we want to do.  This patch fixes
this potential problem.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 net/mac80211/rc80211_minstrel.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index b218b98..e2dd248 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -66,7 +66,7 @@ rix_to_ndx(struct minstrel_sta_info *mi, int rix)
 	for (i = rix; i >= 0; i--)
 		if (mi->r[i].rix == rix)
 			break;
-	WARN_ON(mi->r[i].rix != rix);
+	WARN_ON(i < 0 || mi->r[i].rix != rix);
 	return i;
 }
 
@@ -181,6 +181,9 @@ minstrel_tx_status(void *priv, struct ieee80211_supported_band *sband,
 			break;
 
 		ndx = rix_to_ndx(mi, ar[i].idx);
+		if (ndx < 0)
+			continue;
+
 		mi->r[ndx].attempts += ar[i].count;
 
 		if ((i != IEEE80211_TX_MAX_RATES - 1) && (ar[i + 1].idx < 0))
-- 
1.6.0.4

