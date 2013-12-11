Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:37136 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3LKSju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 13:39:50 -0500
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: sw@simonwunderlich.de
Subject: [PATCH] mac80211: lock sdata in ieee80211_csa_connection_drop_work()
Date: Wed, 11 Dec 2013 20:39:46 +0200
Message-Id: <1386787186-6496-1-git-send-email-luciano.coelho@intel.com> (sfid-20131211_193953_161437_A386EC35)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We call ieee80211_ibss_disconnect(), which requires sdata to be
locked, so lock the sdata during ieee80211_csa_connection_drop_work().

Cc: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/ibss.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index df21e4f..94e5c76 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -753,12 +753,16 @@ static void ieee80211_csa_connection_drop_work(struct work_struct *work)
 		container_of(work, struct ieee80211_sub_if_data,
 			     u.ibss.csa_connection_drop_work);
 
+	sdata_lock(sdata);
+
 	ieee80211_ibss_disconnect(sdata);
 	synchronize_rcu();
 	skb_queue_purge(&sdata->skb_queue);
 
 	/* trigger a scan to find another IBSS network to join */
 	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+
+	sdata_unlock(sdata);
 }
 
 static void ieee80211_ibss_csa_mark_radar(struct ieee80211_sub_if_data *sdata)
-- 
1.8.5.1

