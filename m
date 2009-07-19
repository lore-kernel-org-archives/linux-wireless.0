Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:52947 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZGSULL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 16:11:11 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] mac80211: do not monitor the connection while scanning
Date: Sun, 19 Jul 2009 22:09:32 +0200
Cc: Bob Copeland <me@bobcopeland.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
References: <4A611FC0.9040507@lwfinger.net> <200907190032.58156.chunkeey@web.de> <4A632F9C.8080207@lwfinger.net>
In-Reply-To: <4A632F9C.8080207@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907192209.32164.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 constantly monitors the connection to the associated AP
in order to check if it is out of reach/dead.

This is absolutely fine most of the time.
Except when there is a scheduled scan for the whole neighborhood.
After all this path could trigger while scanning on different channel.
Or even worse: this AP probing triggers a WARN_ON in rate_lowest_index
when the scan code did a band transition!
( http://www.kerneloops.org/raw.php?rawid=449304 )

Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
---
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 18dad22..4833e7c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2210,6 +2210,9 @@ static void ieee80211_sta_monitor_work(struct work_struct *work)
 		container_of(work, struct ieee80211_sub_if_data,
 			     u.mgd.monitor_work);
 
+	if (sdata->local->sw_scanning || sdata->local->hw_scanning)
+		return;
+
 	ieee80211_mgd_probe_ap(sdata, false);
 }
 
