Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:34073 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab0AEIiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 03:38:08 -0500
Date: Tue, 5 Jan 2010 09:38:03 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: infinite transmit buffering issue in 2.6.32 mac80211
Message-ID: <20100105083803.GP1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

Since "mac80211: remove master netdev", mac80211 no longer propagates
TX queue full status (ieee80211_stop_queue et al) up.  While the
underlying hardware's TX queue is stopped, mac80211 buffers frames
internally (in ieee80211_tx), but there's no upper limit on the number
of frames it will buffer, leading to badness when there is heavy TX
traffic on the wireless interface:

* It breaks TCP's packet drop-induced rate control.  Instead, you'll
  end up with much of the same effects as tunneling TCP in TCP like
  some VPN apps do, where individual packets will see wildly varying
  RTTs and you'll end up adding retransmits to the TX queue while
  the original packet didn't even go out yet.

* If there is bulk data transfer going on, you end up with unbounded
  and highly variable RTTs for concurrent traffic (say, pings).

* On the kind of machines I typically work on (embedded access point
  type devices), more so than on big x86_64 machines, unbounded
  packet buffering will typically lead to OOM very quickly. :-)


Routing from a wired interface to wireless, and flooding the wired
interface with traffic to be routed, say with a traffic generator (for
performance testing) can trigger OOM and cripple the box in seconds,
but I think (but haven't verified) that even just simple non-forwarded
bulk TCP upload should be able to trigger OOM as well on sufficiently
constrained machines.


Something like this makes the OOM and jitter issues go away:

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index eaa4118..f7d9033 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1294,6 +1298,8 @@ static void ieee80211_tx(struct ieee80211_sub_if_data *sda
                        goto drop;
                /* fall through */
        case IEEE80211_TX_PENDING:
+               goto drop;
+
                skb = tx.skb;
 
                spin_lock_irqsave(&local->queue_stop_reason_lock, flags);


However, TX queue status feedback is still broken with this, which is
problematic as per:

	http://marc.info/?l=linux-netdev&m=121994203129939&w=2
	http://marc.info/?l=linux-netdev&m=122004613003333&w=2


Propagating the queue stop to the higher-level interface (as per the
somewhat broken patch below) is closer into the right direction, but
Johannes voiced concerns that this is inefficient (which is demonstrated
e.g. by the first email referenced above), but also, it creates a new
problem, which is that of head-of-line blocking -- a low-priority flow
can now cause the wlanX interface's main queue to be stopped, leading
to queueing of high-priority traffic in the stack while the hardware's
high-priority traffic queue sits empty.


The only way I see to solve all of these issues cleanly is to convert
the AP/STA/etc subinterfaces to be multiqueue interfaces, with the same
number of transmit queues as the hardware has, so that there are
independently stoppable/resumable virtual output queues all the way
from userland to the actual hardware, and then to stop/resume those
queues in response to the hardware DMA queues filling up and draining.

Before I go ahead and do this -- thoughts?


thanks,
Lennert





(broken -- doesn't deal properly with stops/wakes on multiple queues)


diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index dc76267..5ac558f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -296,8 +296,33 @@ void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
 
 void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
 {
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
+
 	ieee80211_wake_queue_by_reason(hw, queue,
 				       IEEE80211_QUEUE_STOP_REASON_DRIVER);
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		switch (sdata->vif.type) {
+		case __NL80211_IFTYPE_AFTER_LAST:
+		case NL80211_IFTYPE_UNSPECIFIED:
+		case NL80211_IFTYPE_MONITOR:
+		case NL80211_IFTYPE_AP_VLAN:
+			continue;
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_STATION:
+        	case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_WDS:
+		case NL80211_IFTYPE_MESH_POINT:
+			if (netif_running(sdata->dev))
+				netif_wake_queue(sdata->dev);
+			break;
+		}
+        }
+
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(ieee80211_wake_queue);
 
@@ -325,8 +350,33 @@ void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
 
 void ieee80211_stop_queue(struct ieee80211_hw *hw, int queue)
 {
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
+
 	ieee80211_stop_queue_by_reason(hw, queue,
 				       IEEE80211_QUEUE_STOP_REASON_DRIVER);
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		switch (sdata->vif.type) {
+		case __NL80211_IFTYPE_AFTER_LAST:
+		case NL80211_IFTYPE_UNSPECIFIED:
+		case NL80211_IFTYPE_MONITOR:
+		case NL80211_IFTYPE_AP_VLAN:
+			continue;
+		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_STATION:
+        	case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_WDS:
+		case NL80211_IFTYPE_MESH_POINT:
+			if (netif_running(sdata->dev))
+				netif_stop_queue(sdata->dev);
+			break;
+		}
+        }
+
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(ieee80211_stop_queue);
 
