Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50023 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565Ab1LLNEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 08:04:10 -0500
Received: by lagp5 with SMTP id p5so1900157lag.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2011 05:04:09 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: don't check sdata_running in vif notifier
Date: Mon, 12 Dec 2011 15:04:44 +0200
Message-Id: <1323695084-28109-1-git-send-email-eliad@wizery.com> (sfid-20111212_140414_107223_B5763E51)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ip address of the vif can be set even before the
vif is up. requiring the vif to be up in the vif
notifier makes the notifer ignore this event, which
causes wrong arp filter configuration later on.

Reported-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/main.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 8022c62..ad8f712 100644
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
-- 
1.7.6.401.g6a319

