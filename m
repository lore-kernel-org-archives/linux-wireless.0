Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13981 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbZGWXht (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 19:37:49 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 16:37:50 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <rossi.f@inwind.it>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Christian Lamparter <chunkeey@web.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] mac80211: fix MLME issuing of probe requests while scanning
Date: Thu, 23 Jul 2009 16:37:47 -0700
Message-ID: <1248392267-32086-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were issuing probe requests to the associated AP on the wrong
band by having our beacon timer loss trigger while we are scanning.
When we would scan the timer could hit and force us to send a
probe request to the AP but with a chance we'd be on the wrong band.

This leads to finding no usable bitrate but we should not get so
far on the xmit path. We should not be trying to send these probe
request frames so prevent ieee80211_mgd_probe_ap() from sending
these.

As it turns out all callers of ieee80211_mgd_probe_ap() need this
check so we just move the scan check there. This means we can remove
the recenlty added check during ieee80211_sta_monitor_work().

Additionally we now fix a race condition added by the patch
"mac80211: do not monitor the connection while scanning" which
had the same check in ieee80211_sta_conn_mon_timer(). The race
happens because the timer routine *does* a valid check for
scanning but after it queues work into the mac80211 workqueue
the work callback can kick off with scanning enabled and cause
the same issue we were trying to avoid.

The more appropriate solution would be to disable the respective
timers during scan and re-enable them after scan but requires more
complex code and testing.

Cc: Christian Lamparter <chunkeey@web.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Fabio Rossi <rossi.f@inwind.it>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/mlme.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 523c0d9..db0b4b2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1166,6 +1166,9 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 	if (!netif_running(sdata->dev))
 		return;
 
+	if (sdata->local->sw_scanning || sdata->local->hw_scanning)
+		return;
+
 	mutex_lock(&ifmgd->mtx);
 
 	if (!ifmgd->associated)
@@ -2213,9 +2216,6 @@ static void ieee80211_sta_monitor_work(struct work_struct *work)
 		container_of(work, struct ieee80211_sub_if_data,
 			     u.mgd.monitor_work);
 
-	if (sdata->local->sw_scanning || sdata->local->hw_scanning)
-		return;
-
 	ieee80211_mgd_probe_ap(sdata, false);
 }
 
-- 
1.6.3.3

