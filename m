Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:48472 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab0KBA4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 20:56:35 -0400
Received: by mail-px0-f174.google.com with SMTP id 15so630739pxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 17:56:35 -0700 (PDT)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Brian Cavagnolo <brian@cozybit.com>
Subject: [PATCH 7/7] mac80211: unset SDATA_STATE_OFFCHANNEL when cancelling a scan
Date: Mon,  1 Nov 2010 17:55:51 -0700
Message-Id: <1288659351-22313-7-git-send-email-brian@cozybit.com>
In-Reply-To: <1288659351-22313-1-git-send-email-brian@cozybit.com>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com>
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

Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
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

