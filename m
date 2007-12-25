Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28918 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbXLYPAu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2007 10:00:50 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 4/8 v3] mac80211: A-MPDU Rx MLME data initialization
Date: Tue, 25 Dec 2007 17:00:34 +0200
Message-Id: <11985948451019-git-send-email-ron.rindjunsky@intel.com> (sfid-20071225_150102_890038_FAA173E8)
In-Reply-To: <11985948383801-git-send-email-ron.rindjunsky@intel.com>
References: <11985948383801-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch initialize A-MPDU MLME data for Rx sessions.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/sta_info.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index cc28e82..c03a714 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -135,6 +135,7 @@ struct sta_info * sta_info_add(struct ieee80211_local *local,
 			       struct net_device *dev, u8 *addr, gfp_t gfp)
 {
 	struct sta_info *sta;
+	int i;
 	DECLARE_MAC_BUF(mac);
 
 	sta = kzalloc(sizeof(*sta), gfp);
@@ -154,6 +155,19 @@ struct sta_info * sta_info_add(struct ieee80211_local *local,
 	memcpy(sta->addr, addr, ETH_ALEN);
 	sta->local = local;
 	sta->dev = dev;
+	spin_lock_init(&sta->ampdu_mlme.ampdu_rx);
+	for (i = 0; i < STA_TID_NUM; i++) {
+		/* timer_to_tid must be initialized with identity mapping to
+		 * enable session_timer's data differentiation. refer to
+		 * sta_rx_agg_session_timer_expired for useage */
+		sta->timer_to_tid[i] = i;
+		/* rx timers */
+		sta->ampdu_mlme.tid_rx[i].session_timer.function =
+			sta_rx_agg_session_timer_expired;
+		sta->ampdu_mlme.tid_rx[i].session_timer.data =
+			(unsigned long)&sta->timer_to_tid[i];
+		init_timer(&sta->ampdu_mlme.tid_rx[i].session_timer);
+	}
 	skb_queue_head_init(&sta->ps_tx_buf);
 	skb_queue_head_init(&sta->tx_filtered);
 	__sta_info_get(sta);	/* sta used by caller, decremented by
-- 
1.5.3.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

