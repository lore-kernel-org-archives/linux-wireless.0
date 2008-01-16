Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39542 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbYAPSlK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 13:41:10 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [RFC PATCH 08/12 v2] mac80211: A-MPDU Tx add delBA from recipient support
Date: Wed, 16 Jan 2008 20:40:56 +0200
Message-Id: <12005088641272-git-send-email-ron.rindjunsky@intel.com> (sfid-20080116_184120_113042_C242193B)
In-Reply-To: <1200508860699-git-send-email-ron.rindjunsky@intel.com>
References: <1200508860699-git-send-email-ron.rindjunsky@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the ability to handle delBA from recipient to initiator
during an A-MPDU session

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/ieee80211_sta.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index ab548f1..2e1ef9d 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1410,14 +1410,23 @@ static void ieee80211_sta_process_delba(struct net_device *dev,
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	if (net_ratelimit())
-		printk(KERN_DEBUG "delba from %s on tid %d reason code %d\n",
-			print_mac(mac, mgmt->sa), tid,
+		printk(KERN_DEBUG "delba from %s (%s) tid %d reason code %d\n",
+			print_mac(mac, mgmt->sa),
+			initiator ? "recipient" : "initiator", tid,
 			mgmt->u.action.u.delba.reason_code);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
 	if (initiator == WLAN_BACK_INITIATOR)
 		ieee80211_sta_stop_rx_ba_session(dev, sta->addr, tid,
 						 WLAN_BACK_INITIATOR, 0);
+	else { /* WLAN_BACK_RECIPIENT */
+		spin_lock_bh(&sta->ampdu_mlme.ampdu_tx);
+		sta->ampdu_mlme.tid_tx[tid].state =
+				HT_AGG_STATE_OPERATIONAL;
+		spin_unlock_bh(&sta->ampdu_mlme.ampdu_tx);
+		ieee80211_stop_tx_ba_session(&local->hw, sta->addr, tid,
+					     WLAN_BACK_RECIPIENT);
+	}
 	sta_info_put(sta);
 }
 
-- 
1.5.3.3

