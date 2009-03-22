Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22184 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbZCVT5i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 15:57:38 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH v4 1/5] mac80211: decrease execution of the associated timer
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Date: Sun, 22 Mar 2009 21:57:06 +0200
Message-ID: <20090322195706.26460.76476.stgit@tikku> (sfid-20090322_205740_371062_892790B1)
In-Reply-To: <20090322195619.26460.48292.stgit@tikku>
References: <20090322195619.26460.48292.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Currently the timer is triggering every two seconds
(IEEE80211_MONITORING_INTERVAL). Decrease the timer to only trigger during
data idle periods to avoid waking up CPU unnecessary. The timer will
still trigger during idle periods, that needs to be fixed later.

There's also a functional change that probe requests are sent only when the
data path is idle, earlier they were sent also while there was activity
on the data path.

This is also preparation for the beacon filtering support. Thanks to
Johannes Berg for the idea.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/mlme.c        |   15 +++++++++++++++
 net/mac80211/rx.c          |    3 +++
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f69e84a..a7b13ea 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1084,6 +1084,8 @@ void ieee80211_dynamic_ps_timer(unsigned long data);
 void ieee80211_send_nullfunc(struct ieee80211_local *local,
 			     struct ieee80211_sub_if_data *sdata,
 			     int powersave);
+void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
+			     struct ieee80211_hdr *hdr);
 
 void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 				     enum queue_stop_reason reason);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b0808ef..ce1ad7c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -910,6 +910,21 @@ static void ieee80211_associate(struct ieee80211_sub_if_data *sdata)
 	mod_timer(&ifmgd->timer, jiffies + IEEE80211_ASSOC_TIMEOUT);
 }
 
+void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
+			     struct ieee80211_hdr *hdr)
+{
+	/*
+	 * We can postpone the mgd.timer whenever receiving unicast frames
+	 * from AP because we know that the connection is working both ways
+	 * at that time. But multicast frames (and hence also beacons) must
+	 * be ignored here, because we need to trigger the timer during
+	 * data idle periods for sending the periodical probe request to
+	 * the AP.
+	 */
+	if (!is_multicast_ether_addr(hdr->addr1))
+		mod_timer(&sdata->u.mgd.timer,
+			  jiffies + IEEE80211_MONITORING_INTERVAL);
+}
 
 static void ieee80211_associated(struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index fcc0a59..4298e86 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -856,6 +856,9 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 		return RX_CONTINUE;
 
+	if (rx->sdata->vif.type == NL80211_IFTYPE_STATION)
+		ieee80211_sta_rx_notify(rx->sdata, hdr);
+
 	sta->rx_fragments++;
 	sta->rx_bytes += rx->skb->len;
 	sta->last_signal = rx->status->signal;

