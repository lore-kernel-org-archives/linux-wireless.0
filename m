Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59041 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab0INXkj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 19:40:39 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>
Subject: [PATCH v3 04/11] mac80211: add helper for reseting the connection monitor
Date: Tue, 14 Sep 2010 19:40:17 -0400
Message-Id: <1284507624-18176-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1284507624-18176-1-git-send-email-lrodriguez@atheros.com>
References: <1284507624-18176-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be used in another place later. The connection
monitor was added as of 2.6.35 so these fixes will be
applicable to >= 2.6.35.

Cc: stable@kernel.org
Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   15 ++++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4e635e2..737fd0f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1041,6 +1041,7 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				  struct sk_buff *skb);
+void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata);
 
 /* IBSS code */
 void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0cb822c..cfdafb7 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -124,6 +124,15 @@ static void mod_beacon_timer(struct ieee80211_sub_if_data *sdata)
 		  round_jiffies_up(jiffies + IEEE80211_BEACON_LOSS_TIME));
 }
 
+void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata)
+{
+	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
+		return;
+
+	mod_timer(&sdata->u.mgd.conn_mon_timer,
+		  round_jiffies_up(jiffies + IEEE80211_CONNECTION_IDLE_TIME));
+}
+
 static int ecw2cw(int ecw)
 {
 	return (1 << ecw) - 1;
@@ -1018,11 +1027,7 @@ void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
 	if (is_multicast_ether_addr(hdr->addr1))
 		return;
 
-	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
-		return;
-
-	mod_timer(&sdata->u.mgd.conn_mon_timer,
-		  round_jiffies_up(jiffies + IEEE80211_CONNECTION_IDLE_TIME));
+	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
 static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
-- 
1.7.0.4

