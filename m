Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:57990 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab2GBMIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 08:08:17 -0400
Received: by wibhq12 with SMTP id hq12so2691470wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jul 2012 05:08:16 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: always set in_reconfig=false on wakeup
Date: Mon,  2 Jul 2012 15:08:25 +0300
Message-Id: <1341230905-8929-1-git-send-email-eliad@wizery.com> (sfid-20120702_140821_279531_928FEEE7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the interfaces were removed just before a restart
work was started, open_count will be 0, and most of
the reconfig work will be skipped, including the
resetting of local->in_reconfig to false.

Leaving local->inconfig = true will result in
dropping any incoming packet.

Fix it by always setting local->in_reconfig = false
(even if there are no active interfaces).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
this should go to 3.5

 net/mac80211/util.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 242ecde..e1b7c63 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1411,10 +1411,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		if (ieee80211_sdata_running(sdata))
 			ieee80211_enable_keys(sdata);
 
+ wake_up:
 	local->in_reconfig = false;
 	barrier();
 
- wake_up:
 	/*
 	 * Clear the WLAN_STA_BLOCK_BA flag so new aggregation
 	 * sessions can be established after a resume.
-- 
1.7.6.401.g6a319

