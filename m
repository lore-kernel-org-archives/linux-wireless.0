Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:12831 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966065AbXFHNdU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 09:33:20 -0400
Received: by ug-out-1314.google.com with SMTP id j3so955435ugf
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2007 06:33:19 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Don't stop tx queue on master device while scanning.
Date: Fri, 8 Jun 2007 15:31:13 +0200
Cc: "John Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>,
	Mattias Nissler <mattias.nissler@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200706081531.14086.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mattias Nissler <mattias.nissler@gmx.de>

mac80211 stops the tx queues during scans. This is wrong with respect
to the master deivce tx queue, since stopping it prevents any probes
from being sent during the scan. Instead, they accumulate in the queue
and are only sent after the scan is finished, which is obviously
wrong.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>

---
 net/mac80211/ieee80211_sta.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 8bd8031..9fdd265 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -3533,11 +3533,17 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 
 	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
+
+		/* No need to wake the master device. */
+		if (sdata->dev == local->mdev)
+			continue;
+
 		if (sdata->type == IEEE80211_IF_TYPE_STA) {
 			if (sdata->u.sta.associated)
 				ieee80211_send_nullfunc(local, sdata, 0);
 			ieee80211_sta_timer((unsigned long)sdata);
 		}
+
 		netif_wake_queue(sdata->dev);
 	}
 	read_unlock(&local->sub_if_lock);
@@ -3679,6 +3685,12 @@ static int ieee80211_sta_start_scan(struct net_device *dev,
 
 	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
+
+		/* Don't stop the master interface, otherwise we can't transmit
+		 * probes! */
+		if (sdata->dev == local->mdev)
+			continue;
+
 		netif_stop_queue(sdata->dev);
 		if (sdata->type == IEEE80211_IF_TYPE_STA &&
 		    sdata->u.sta.associated)
-- 
1.5.2
