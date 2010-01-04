Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36561 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab0ADPcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 10:32:51 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: greg@kroah.com
Cc: linux-wireless@vger.kernel.org,
	Sujith <Sujith.Manoharan@atheros.com>, lucisandor@gmail.com,
	Bob Copeland <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH stable 2.6.32.y] mac80211: Fix IBSS merge
Date: Mon,  4 Jan 2010 10:32:50 -0500
Message-Id: <1262619170-11181-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith <Sujith.Manoharan@atheros.com>

Upstream commit 450aae3d7b60a970f266349a837dfb30a539198b

Currently, in IBSS mode, a single creator would go into
a loop trying to merge/scan. This happens because the IBSS timer is
rearmed on finishing a scan and the subsequent
timer invocation requests another scan immediately.

This patch fixes this issue by checking if we have just completed
a scan run trying to merge with other IBSS networks.

Cc: lucisandor@gmail.com
Cc: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---

Greg, without this you could end up spamming the /var/log/messages it
applies on top of 2.6.32.2

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
1.6.3.3

