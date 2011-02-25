Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117Ab1BYNqL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 08:46:11 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] mac80211: better fix for conn_mon_timer running after disassociate
Date: Fri, 25 Feb 2011 14:46:02 +0100
Message-Id: <1298641562-3805-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is still possible to schedule conn_mon_timer after disassociate from
ieee80211_sta_tx_notify() and ieee80211_offchannel_ps_disable().

Move disassociate check to ieee80211_sta_reset_conn_monitor() to cover
all these cases, and add unlikely since in most the time we call
ieee80211_sta_reset_conn_monitor() when associated.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/mlme.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index abb0116..cc984bd 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -145,6 +145,9 @@ void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
+	if (unlikely(!sdata->u.mgd.associated))
+		return;
+
 	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
 		return;
 
@@ -1083,12 +1086,6 @@ void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
 	if (is_multicast_ether_addr(hdr->addr1))
 		return;
 
-	/*
-	 * In case we receive frames after disassociation.
-	 */
-	if (!sdata->u.mgd.associated)
-		return;
-
 	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
-- 
1.7.1

