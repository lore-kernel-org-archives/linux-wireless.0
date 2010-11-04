Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:50204 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab0KDX7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 19:59:43 -0400
Received: by pxi15 with SMTP id 15so373926pxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 16:59:43 -0700 (PDT)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Brian Cavagnolo <brian@cozybit.com>
Subject: [PATCH] mac80211: unset SDATA_STATE_OFFCHANNEL when cancelling a scan
Date: Thu,  4 Nov 2010 16:59:28 -0700
Message-Id: <1288915168-12804-1-git-send-email-brian@cozybit.com>
In-Reply-To: <1288885952.3659.9.camel@jlt3.sipsolutions.net>
References: <1288885952.3659.9.camel@jlt3.sipsolutions.net>
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
cancel the scan before unsetting the SDATA_STATE_RUNNING bit.

Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 net/mac80211/iface.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index f9163b1..7aa8559 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -391,6 +391,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	u32 hw_reconf_flags = 0;
 	int i;
 
+	if (local->scan_sdata == sdata)
+		ieee80211_scan_cancel(local);
+
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 
 	/*
@@ -523,9 +526,6 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		synchronize_rcu();
 		skb_queue_purge(&sdata->skb_queue);
 
-		if (local->scan_sdata == sdata)
-			ieee80211_scan_cancel(local);
-
 		/*
 		 * Disable beaconing here for mesh only, AP and IBSS
 		 * are already taken care of.
-- 
1.7.1.1

