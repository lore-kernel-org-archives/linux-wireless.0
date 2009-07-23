Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10297 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbZGWWtj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 18:49:39 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 15:49:40 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <rossi.f@inwind.it>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] mac80211: do not trigger beacon loss work if scanning
Date: Thu, 23 Jul 2009 15:49:37 -0700
Message-ID: <1248389377-30379-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were issues probe requests to the associated AP on the wrong
band by having our beacon timer loss trigger while we are scanning.
When we would scan the timer could hit and force us to send a
probe request to the AP but with a chance we'd be on the wrong band.

This leads to finding no usable bitrate but we should not get so
far on the xmit path. We should not be trying to send these probe
request frames so prevent the timer from stuffing beacon loss work
on the mac80211 workqueue when scanning.

Tested-by: Fabio Rossi <rossi.f@inwind.it>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/mlme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 523c0d9..e90992e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2187,7 +2187,7 @@ static void ieee80211_sta_bcn_mon_timer(unsigned long data)
 		(struct ieee80211_sub_if_data *) data;
 	struct ieee80211_local *local = sdata->local;
 
-	if (local->quiescing)
+	if (local->quiescing || local->sw_scanning || local->hw_scanning)
 		return;
 
 	queue_work(sdata->local->hw.workqueue,
-- 
1.6.3.3

