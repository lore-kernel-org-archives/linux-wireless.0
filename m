Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40010 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbZCNRPj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 13:15:39 -0400
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [RFC PATCH v2 1/4] mac80211: decrease execution of the associated
	timer
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sat, 14 Mar 2009 19:14:31 +0200
Message-ID: <20090314171431.11126.51242.stgit@tikku> (sfid-20090314_181540_659075_9CF54104)
In-Reply-To: <20090314171234.11126.21125.stgit@tikku>
References: <20090314171234.11126.21125.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the timer is triggering every two seconds
(IEEE80211_MONITORING_INTERVAL). Decrease the timer to only trigger when
nothing is received to avoid waking up CPU.

Now there's a functional change that probe requests are sent only when the
data path is idle, earlier they were sent also while there was activity
on the data path.

This is also preparation for beacon filtering support. Thanks to Johannes
Berg for the idea.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/mlme.c        |    8 ++++++++
 net/mac80211/rx.c          |    3 +++
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ecbc8e0..74c4e13 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1080,6 +1080,8 @@ void ieee80211_dynamic_ps_timer(unsigned long data);
 void ieee80211_send_nullfunc(struct ieee80211_local *local,
 			     struct ieee80211_sub_if_data *sdata,
 			     int powersave);
+void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
+			     struct ieee80211_hdr *hdr);
 
 void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 				     enum queue_stop_reason reason);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 391445c..397a2e7 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -911,6 +911,14 @@ static void ieee80211_associate(struct ieee80211_sub_if_data *sdata)
 	mod_timer(&ifmgd->timer, jiffies + IEEE80211_ASSOC_TIMEOUT);
 }
 
+void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
+			     struct ieee80211_hdr *hdr)
+{
+	/* timer triggers only when there is no unicast traffic */
+	if (!is_multicast_ether_addr(hdr->addr1))
+		mod_timer(&sdata->u.mgd.timer,
+			  jiffies + IEEE80211_MONITORING_INTERVAL);
+}
 
 static void ieee80211_associated(struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 66f7ecf..25982c0 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -855,6 +855,9 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 		return RX_CONTINUE;
 
+	if (rx->sdata->vif.type == NL80211_IFTYPE_STATION)
+		ieee80211_sta_rx_notify(rx->sdata, hdr);
+
 	sta->rx_fragments++;
 	sta->rx_bytes += rx->skb->len;
 	sta->last_signal = rx->status->signal;

