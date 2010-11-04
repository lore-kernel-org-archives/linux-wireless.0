Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49718 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab0KDAVP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 20:21:15 -0400
Received: by ywc21 with SMTP id 21so936815ywc.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 17:21:15 -0700 (PDT)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Brian Cavagnolo <brian@cozybit.com>
Subject: [PATCH] mac80211: unset SDATA_STATE_OFFCHANNEL when cancelling a scan
Date: Wed,  3 Nov 2010 17:20:56 -0700
Message-Id: <1288830056-841-1-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For client STA interfaces, ieee80211_do_stop unsets the relevant
interface's SDATA_STATE_RUNNING state bit prior to cancelling an
interrupted scan.  When ieee80211_offchannel_return is invoked as
part of cancelling the scan, it doesn't bother unsetting the
SDATA_STATE_OFFCHANNEL bit because it sees that the interface is
down.  Normally this doesn't matter because when the client STA
interface is brought back up, it will probably issue a scan.  But
in some cases (e.g., the user changes the interface type while it
is down), the SDATA_STATE_OFFCHANNEL bit will remain set.  This
prevents the interface queues from being started.  So we
unconditionally unset this bit when we cancel a scan.
---
 net/mac80211/offchannel.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 4b56409..6252a76 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -156,8 +156,10 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!ieee80211_sdata_running(sdata))
+		if (!ieee80211_sdata_running(sdata)) {
+			clear_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
 			continue;
+		}
 
 		/* Tell AP we're back */
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-- 
1.7.1.1

