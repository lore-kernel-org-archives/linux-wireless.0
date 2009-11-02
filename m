Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:62217 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbZKBHBT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 02:01:19 -0500
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2009 23:01:25 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19182.33851.980271.360757@gargle.gargle.HOWL>
Date: Mon, 2 Nov 2009 12:33:23 +0530
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Fix IBSS merge
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, in IBSS mode, a single creator would go into
a loop trying to merge/scan. This happens because the IBSS timer is
rearmed on finishing a scan and the subsequent
timer invocation requests another scan immediately.

This patch fixes this issue by checking if we have just completed
a scan run trying to merge with other IBSS networks.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 net/mac80211/ibss.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index f1362f3..fbffce9 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -455,6 +455,10 @@ static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
 
 	ieee80211_sta_expire(sdata, IEEE80211_IBSS_INACTIVITY_LIMIT);
 
+	if (time_before(jiffies, ifibss->last_scan_completed +
+		       IEEE80211_IBSS_MERGE_INTERVAL))
+		return;
+
 	if (ieee80211_sta_active_ibss(sdata))
 		return;
 
-- 
1.6.5.2

