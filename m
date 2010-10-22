Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:37350 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab0JVNAe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 09:00:34 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 06:00:24 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [RFC] mac80211: Fix ibss station got expired immediately
Date: Fri, 22 Oct 2010 18:36:27 +0530
Message-ID: <1287752787-6616-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Station addition in ieee80211_ibss_rx_queued_mgmt is not updating
sta->last_rx which is causing station expiry in ieee80211_ibss_work
path. So sta addition and deletion happens repeatedly.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 net/mac80211/ibss.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index ff60c02..239c483 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -456,6 +456,7 @@ struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	if (!sta)
 		return NULL;
 
+	sta->last_rx = jiffies;
 	set_sta_flags(sta, WLAN_STA_AUTHORIZED);
 
 	/* make sure mandatory rates are always added */
-- 
1.7.3.1

