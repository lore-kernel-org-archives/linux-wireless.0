Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47095 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbYJJXqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 19:46:30 -0400
Subject: [PATCH] iwl3945: fix station stuff in RC algorithm
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 11 Oct 2008 01:46:25 +0200
Message-Id: <1223682385.29811.5.camel@johannes.berg> (sfid-20081011_014634_084295_30614A45)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Probably bugs I added.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-10-11 01:37:24.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-10-11 01:42:19.000000000 +0200
@@ -806,13 +806,12 @@ void iwl3945_rate_scale_init(struct ieee
 	rcu_read_lock();
 
 	sta = ieee80211_find_sta(hw, priv->stations[sta_id].sta.sta.addr);
-	psta = (void *) sta->drv_priv;
-	if (!sta || !psta) {
-		IWL_DEBUG_RATE("leave - no private rate data!\n");
+	if (!sta) {
 		rcu_read_unlock();
 		return;
 	}
 
+	psta = (void *) sta->drv_priv;
 	rs_sta = psta->rs_sta;
 
 	spin_lock_irqsave(&rs_sta->lock, flags);
@@ -836,7 +835,6 @@ void iwl3945_rate_scale_init(struct ieee
 		break;
 	}
 
-	rcu_read_unlock();
 	spin_unlock_irqrestore(&rs_sta->lock, flags);
 
 	rssi = priv->last_rx_rssi;
@@ -850,6 +848,7 @@ void iwl3945_rate_scale_init(struct ieee
 	IWL_DEBUG_RATE("leave: rssi %d assign rate index: "
 		       "%d (plcp 0x%x)\n", rssi, rs_sta->start_rate,
 		       iwl3945_rates[rs_sta->start_rate].plcp);
+	rcu_read_unlock();
 }
 
 int iwl3945_rate_control_register(void)


