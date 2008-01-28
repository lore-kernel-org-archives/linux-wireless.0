Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22822 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877AbYA1MHi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 07:07:38 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 08/12 v2] mac80211: A-MPDU Tx add delBA from recipient support
Date: Mon, 28 Jan 2008 14:07:22 +0200
Message-Id: <1201522054994-git-send-email-ron.rindjunsky@intel.com> (sfid-20080128_120745_052373_A916568B)
In-Reply-To: <12015220461052-git-send-email-ron.rindjunsky@intel.com>
References: <12015220461052-git-send-email-ron.rindjunsky@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the ability to handle delBA from recipient to initiator
during an A-MPDU session

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/ieee80211_sta.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

Index: wl2_6_24_rc8_ev/net/mac80211/ieee80211_sta.c
===================================================================
--- wl2_6_24_rc8_ev.orig/net/mac80211/ieee80211_sta.c
+++ wl2_6_24_rc8_ev/net/mac80211/ieee80211_sta.c
@@ -1401,14 +1401,23 @@ static void ieee80211_sta_process_delba(
 
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
 
