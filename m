Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43060 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab1FHL1a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 07:27:30 -0400
Subject: [PATCH v2] mac80211: fix IBSS teardown race
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ignacy Gawedzki <i@lri.fr>
In-Reply-To: <1307532343.3961.9.camel@jlt3.sipsolutions.net> (sfid-20110608_132549_830215_50FA69C7)
References: <1307532343.3961.9.camel@jlt3.sipsolutions.net>
	 (sfid-20110608_132549_830215_50FA69C7)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 13:27:29 +0200
Message-ID: <1307532449.3961.12.camel@jlt3.sipsolutions.net> (sfid-20110608_132732_995888_E86E799F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Ignacy reports that sometimes after leaving an IBSS
joining a new one didn't work because there still
were stations on the list. He fixed it by flushing
stations when attempting to join a new IBSS, but
this shouldn't be happening in the first case. When
I looked into it I saw a race condition in teardown
that could cause stations to be added after flush,
and thus cause this situation. Ignacy confirms that
after applying my patch he hasn't seen this happen
again.

Reported-by: Ignacy Gawedzki <i@lri.fr>
Debugged-by: Ignacy Gawedzki <i@lri.fr>
Tested-by: Ignacy Gawedzki <i@lri.fr>
Cc: stable@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: cc stable

 net/mac80211/ibss.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/mac80211/ibss.c	2011-06-08 07:55:21.000000000 +0200
+++ b/net/mac80211/ibss.c	2011-06-08 13:16:20.000000000 +0200
@@ -965,6 +965,10 @@ int ieee80211_ibss_leave(struct ieee8021
 
 	mutex_lock(&sdata->u.ibss.mtx);
 
+	sdata->u.ibss.state = IEEE80211_IBSS_MLME_SEARCH;
+	memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
+	sdata->u.ibss.ssid_len = 0;
+
 	active_ibss = ieee80211_sta_active_ibss(sdata);
 
 	if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
@@ -999,8 +1003,6 @@ int ieee80211_ibss_leave(struct ieee8021
 	kfree_skb(skb);
 
 	skb_queue_purge(&sdata->skb_queue);
-	memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
-	sdata->u.ibss.ssid_len = 0;
 
 	del_timer_sync(&sdata->u.ibss.timer);
 


