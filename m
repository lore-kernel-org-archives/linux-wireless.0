Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:43236 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab2F0S0D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 14:26:03 -0400
Received: by werb10 with SMTP id b10so480737wer.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 11:26:02 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: allow Rx in reconfig only after removing BA sessions
Date: Wed, 27 Jun 2012 21:25:57 +0300
Message-Id: <1340821557-27009-1-git-send-email-arik@wizery.com> (sfid-20120627_202607_487422_04B1F433)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, a connected STA/AP could send us some AMPDUs right after
recovery, without the driver knowing anything about it.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/util.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 242ecde..a041f20 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1411,9 +1411,6 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		if (ieee80211_sdata_running(sdata))
 			ieee80211_enable_keys(sdata);
 
-	local->in_reconfig = false;
-	barrier();
-
  wake_up:
 	/*
 	 * Clear the WLAN_STA_BLOCK_BA flag so new aggregation
@@ -1436,6 +1433,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		mutex_unlock(&local->sta_mtx);
 	}
 
+	local->in_reconfig = false;
+
 	ieee80211_wake_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
-- 
1.7.9.5

