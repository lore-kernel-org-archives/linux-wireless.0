Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47350 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab1LVXqz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 18:46:55 -0500
Received: by wgbdr13 with SMTP id dr13so16641189wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Dec 2011 15:46:54 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: always clear SDATA_STATE_OFFCHANNEL flag
Date: Fri, 23 Dec 2011 01:48:06 +0200
Message-Id: <1324597686-1021-1-git-send-email-eliad@wizery.com> (sfid-20111223_004706_973140_38A92017)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the vif is stopped while it is offchannel (e.g. right
after p2p negotiation) the SDATA_STATE_OFFCHANNEL flag
is never get cleared, resulting in various bad effects
(e.g. GO can't start beaconing).

Fix it by clearing the SDATA_STATE_OFFCHANNEL flag
even if the vif is stopped.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/offchannel.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index e4330d8..2948f8e 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -162,6 +162,9 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
+			clear_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
+
 		if (!ieee80211_sdata_running(sdata))
 			continue;
 
@@ -173,7 +176,6 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
 		}
 
 		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
-			clear_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
 			/*
 			 * This may wake up queues even though the driver
 			 * currently has them stopped. This is not very
-- 
1.7.6.401.g6a319

