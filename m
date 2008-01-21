Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13138 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758633AbYAULwf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 06:52:35 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 08/12] mac80211: A-MPDU Tx add delBA from recipient support
Date: Mon, 21 Jan 2008 13:52:08 +0200
Message-Id: <12009163392171-git-send-email-ron.rindjunsky@intel.com> (sfid-20080121_115427_860513_27F4DB19)
In-Reply-To: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
References: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the ability to handle delBA from recipient to initiator
during an A-MPDU session

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/ieee80211_sta.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 74fecac..28b5678 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1400,14 +1400,23 @@ static void ieee80211_sta_process_delba(struct net_device *dev,
 
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
1.5.3.7

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

