Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:45176 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757896AbcDEJeS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 05:34:18 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v2] mac80211: close the SP when we enqueue frames during the SP
Date: Tue,  5 Apr 2016 12:34:13 +0300
Message-Id: <1459848853-26977-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160405_113424_049874_4C5DE221)
In-Reply-To: <1458226302-6086-2-git-send-email-emmanuel.grumbach@intel.com>
References: <1458226302-6086-2-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we enqueued the frame that was supposed to be sent
during the SP, and that frame may very well cary the
IEEE80211_TX_STATUS_EOSP bit, we may never close the SP
(WLAN_STA_SP will never be cleared). If that happens, we
will not open any new SP and will never respond to any poll
frame from the client.
Clear WLAN_STA_SP manually if a frame that was polled during
the SP is queued because of a starting A-MPDU session. The
client may not see the EOSP bit, but it will at least be
able to poll new frames in another SP.

Reported-by: Alesya Shapira <alesya.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
v2: remove TODO comment
---
 net/mac80211/tx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 597c8fe..9fbc1b6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1116,6 +1116,12 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 			reset_agg_timer = true;
 		} else {
 			queued = true;
+			if (info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER) {
+				clear_sta_flag(tx->sta, WLAN_STA_SP);
+				ps_dbg(tx->sta->sdata,
+				       "STA %pM aid %d: SP frame queued, close the SP w/o telling the peer\n",
+				       tx->sta->sta.addr, tx->sta->sta.aid);
+			}
 			info->control.vif = &tx->sdata->vif;
 			info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
 			info->flags &= ~IEEE80211_TX_TEMPORARY_FLAGS |
-- 
2.5.0

