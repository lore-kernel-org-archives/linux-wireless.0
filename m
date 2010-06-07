Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35568 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab0FGLDK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 07:03:10 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OLa6n-0007BX-BR
	for linux-wireless@vger.kernel.org; Mon, 07 Jun 2010 13:03:09 +0200
Message-Id: <20100607110200.443462200@sipsolutions.net>
Date: Mon, 07 Jun 2010 13:01:41 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 08/21] mac80211: move blockack stop due to fragmentation
References: <20100607110133.472649120@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's a corner case where we receive a fragmented
frame during a blockack session, in which case we
will terminate that session. To simplify future work
in this area that will culminate in allowing the
driver callbacks for aggregation to sleep, move the
processing of this case out of the RX path into the
interface work.

This will simplify future work because the new place
for this code doesn't require that the function will
always be atomic, which the RX path needs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c |   32 +++++++++++++++++++++++++++++++-
 net/mac80211/rx.c    |    5 ++---
 2 files changed, 33 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/mac80211/iface.c	2010-06-06 13:22:19.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-06-06 13:22:20.000000000 +0200
@@ -707,6 +707,7 @@ static void ieee80211_iface_work(struct
 		container_of(work, struct ieee80211_sub_if_data, work);
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
+	struct sta_info *sta;
 
 	if (!ieee80211_sdata_running(sdata))
 		return;
@@ -729,7 +730,6 @@ static void ieee80211_iface_work(struct
 		if (ieee80211_is_action(mgmt->frame_control) &&
 		    mgmt->u.action.category == WLAN_CATEGORY_BACK) {
 			int len = skb->len;
-			struct sta_info *sta;
 
 			rcu_read_lock();
 			sta = sta_info_get(sdata, mgmt->sa);
@@ -753,6 +753,36 @@ static void ieee80211_iface_work(struct
 				}
 			}
 			rcu_read_unlock();
+		} else if (ieee80211_is_data_qos(mgmt->frame_control)) {
+			struct ieee80211_hdr *hdr = (void *)mgmt;
+			/*
+			 * So the frame isn't mgmt, but frame_control
+			 * is at the right place anyway, of course, so
+			 * the if statement is correct.
+			 *
+			 * Warn if we have other data frame types here,
+			 * they must not get here.
+			 */
+			WARN_ON(hdr->frame_control &
+					cpu_to_le16(IEEE80211_STYPE_NULLFUNC));
+			WARN_ON(!(hdr->seq_ctrl &
+					cpu_to_le16(IEEE80211_SCTL_FRAG)));
+			/*
+			 * This was a fragment of a frame, received while
+			 * a block-ack session was active. That cannot be
+			 * right, so terminate the session.
+			 */
+			rcu_read_lock();
+			sta = sta_info_get(sdata, mgmt->sa);
+			if (sta) {
+				u16 tid = *ieee80211_get_qos_ctl(hdr) &
+						IEEE80211_QOS_CTL_TID_MASK;
+
+				__ieee80211_stop_rx_ba_session(
+					sta, tid, WLAN_BACK_RECIPIENT,
+					WLAN_REASON_QSTA_REQUIRE_SETUP);
+			}
+			rcu_read_unlock();
 		} else switch (sdata->vif.type) {
 		case NL80211_IFTYPE_STATION:
 			ieee80211_sta_rx_queued_mgmt(sdata, skb);
--- wireless-testing.orig/net/mac80211/rx.c	2010-06-06 13:22:19.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-06-06 13:22:20.000000000 +0200
@@ -741,9 +741,8 @@ static void ieee80211_rx_reorder_ampdu(s
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	if (sc & IEEE80211_SCTL_FRAG) {
 		spin_unlock(&sta->lock);
-		__ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_RECIPIENT,
-					       WLAN_REASON_QSTA_REQUIRE_SETUP);
-		dev_kfree_skb(skb);
+		skb_queue_tail(&rx->sdata->skb_queue, skb);
+		ieee80211_queue_work(&local->hw, &rx->sdata->work);
 		return;
 	}
 


