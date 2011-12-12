Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32777 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab1LLN33 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 08:29:29 -0500
Received: by bkcjm19 with SMTP id jm19so1426862bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2011 05:29:28 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] mac80211: don't check sdata_running in vif notifier
Date: Mon, 12 Dec 2011 15:30:04 +0200
Message-Id: <1323696604-4533-1-git-send-email-eliad@wizery.com> (sfid-20111212_142932_909101_F174EE82)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ip address of the vif can be set even before the
vif is up. requiring the vif to be up in the vif
notifier makes the notifer ignore this event, which
causes wrong arp filter configuration later on.

Reported-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: update the comment (thanks Johannes)

 net/mac80211/main.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 8022c62..7c491ad 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -436,9 +436,6 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
 	sdata = IEEE80211_DEV_TO_SUB_IF(ndev);
 	bss_conf = &sdata->vif.bss_conf;
 
-	if (!ieee80211_sdata_running(sdata))
-		return NOTIFY_DONE;
-
 	/* ARP filtering is only supported in managed mode */
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return NOTIFY_DONE;
@@ -467,7 +464,7 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
 	}
 	bss_conf->arp_addr_cnt = c;
 
-	/* Configure driver only if associated */
+	/* Configure driver only if associated (which also implies it is up) */
 	if (ifmgd->associated) {
 		bss_conf->arp_filter_enabled = sdata->arp_filter_state;
 		ieee80211_bss_info_change_notify(sdata,
-- 
1.7.6.401.g6a319

