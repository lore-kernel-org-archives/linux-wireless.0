Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54690 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbYEGJN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 05:13:27 -0400
Subject: [PATCH v3] mac80211: fix wme code
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1209768249.3608.25.camel@johannes.berg> (sfid-20080503_004354_206661_FC39EF9A)
References: <1209767749.3608.23.camel@johannes.berg>
	 (sfid-20080503_003536_334347_3B50118C)  <1209768249.3608.25.camel@johannes.berg>
	 (sfid-20080503_004354_206661_FC39EF9A)
Content-Type: text/plain
Date: Wed, 07 May 2008 11:12:44 +0200
Message-Id: <1210151564.9305.42.camel@johannes.berg> (sfid-20080507_111234_934152_F42D0413)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 31ccc476b77234f6afb3 (mac80211: QoS related cleanups) I
accidentally changed a variable from int to u16 causing a warning
that a comparison for < 0 was always false. John thought this was
a missing deletion of code and removed the warning by deleting the
never executed branch of code in commit 13e5f0888caddf7a020dcd918
(wireless: fix warning introduced by "mac80211: QoS related cleanups")
but the problem really was my mistake of using a u16 variable for
the queue variable when that variable can also contain an error
code. This patch restores the original code and variable type.

Additionally, this patch fixes a (currently) harmless mistake from
the same patch in the declaration of two arrays in the internal
header file.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    4 ++--
 net/mac80211/wme.c         |   26 +++++++++++++++-----------
 2 files changed, 17 insertions(+), 13 deletions(-)

--- everything.orig/net/mac80211/wme.c	2008-05-03 00:29:07.000000000 +0200
+++ everything/net/mac80211/wme.c	2008-05-07 11:09:12.000000000 +0200
@@ -155,8 +155,7 @@ static int wme_qdiscop_enqueue(struct sk
 	unsigned short fc = le16_to_cpu(hdr->frame_control);
 	struct Qdisc *qdisc;
 	struct sta_info *sta;
-	int err;
-	u16 queue;
+	int err, queue;
 	u8 tid;
 
 	if (pkt_data->flags & IEEE80211_TXPD_REQUEUE) {
@@ -216,15 +215,20 @@ static int wme_qdiscop_enqueue(struct sk
 		rcu_read_unlock();
 	}
 
-	tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
-	pkt_data->queue = (unsigned int) queue;
-	qdisc = q->queues[queue];
-	err = qdisc->enqueue(skb, qdisc);
-	if (err == NET_XMIT_SUCCESS) {
-		qd->q.qlen++;
-		qd->bstats.bytes += skb->len;
-		qd->bstats.packets++;
-		return NET_XMIT_SUCCESS;
+	if (unlikely(queue < 0)) {
+			kfree_skb(skb);
+			err = NET_XMIT_DROP;
+	} else {
+		tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
+		pkt_data->queue = (unsigned int) queue;
+		qdisc = q->queues[queue];
+		err = qdisc->enqueue(skb, qdisc);
+		if (err == NET_XMIT_SUCCESS) {
+			qd->q.qlen++;
+			qd->bstats.bytes += skb->len;
+			qd->bstats.packets++;
+			return NET_XMIT_SUCCESS;
+		}
 	}
 	qd->qstats.drops++;
 	return err;
--- everything.orig/net/mac80211/ieee80211_i.h	2008-05-07 11:09:41.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-05-07 11:10:08.000000000 +0200
@@ -611,8 +611,8 @@ struct ieee80211_local {
 	struct sta_info *sta_hash[STA_HASH_SIZE];
 	struct timer_list sta_cleanup;
 
-	unsigned long state[IEEE80211_MAX_AMPDU_QUEUES + IEEE80211_MAX_AMPDU_QUEUES];
-	struct ieee80211_tx_stored_packet pending_packet[IEEE80211_MAX_AMPDU_QUEUES + IEEE80211_MAX_AMPDU_QUEUES];
+	unsigned long state[IEEE80211_MAX_QUEUES + IEEE80211_MAX_AMPDU_QUEUES];
+	struct ieee80211_tx_stored_packet pending_packet[IEEE80211_MAX_QUEUES + IEEE80211_MAX_AMPDU_QUEUES];
 	struct tasklet_struct tx_pending_tasklet;
 
 	/* number of interfaces with corresponding IFF_ flags */


