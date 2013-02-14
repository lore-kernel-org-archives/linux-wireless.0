Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:45838 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071Ab3BNNOT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 08:14:19 -0500
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: mcider@gmail.com, Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [PATCH] mac80211: fix ieee80211_sta_tx_notify for nullfunc
Date: Thu, 14 Feb 2013 14:08:37 +0100
Message-Id: <1360847317-31387-1-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20130214_141423_159188_29A3B6F6)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Function ieee80211_sta_reset_conn_monitor has been
resetting probe_send_count too early and nullfunc
check was never called after succesfull ack.

Reported-by: Magnus Cederlöf <mcider@gmail.com>
Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 net/mac80211/mlme.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cafefb2..a7fb276 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1637,17 +1637,18 @@ void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
 	if (!ieee80211_is_data(hdr->frame_control))
 	    return;
 
-	if (ack)
-		ieee80211_sta_reset_conn_monitor(sdata);
-
 	if (ieee80211_is_nullfunc(hdr->frame_control) &&
 	    sdata->u.mgd.probe_send_count > 0) {
 		if (ack)
-			sdata->u.mgd.probe_send_count = 0;
+			ieee80211_sta_reset_conn_monitor(sdata);
 		else
 			sdata->u.mgd.nullfunc_failed = true;
 		ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+		return;
 	}
+
+	if (ack)
+		ieee80211_sta_reset_conn_monitor(sdata);
 }
 
 static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
-- 
1.7.10.4

