Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:42674 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756079AbXHBWjC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 18:39:02 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id 971B61804B256
	for <linux-wireless@vger.kernel.org>; Thu,  2 Aug 2007 23:39:00 +0100 (BST)
Received: from meerkat.home.warmcat.com (unknown [192.168.0.242])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id E4E67105FD
	for <linux-wireless@vger.kernel.org>; Thu,  2 Aug 2007 22:39:09 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by meerkat.home.warmcat.com (Postfix) with ESMTP id E25F518D1E0B
	for <linux-wireless@vger.kernel.org>; Thu,  2 Aug 2007 23:38:57 +0100 (BST)
From: warmcat <andy@warmcat.com>
Subject: [PATCH] mac80211: No echo TX pkt to Monitor interfaces for injection
To: linux-wireless@vger.kernel.org
Date: Thu, 02 Aug 2007 23:38:57 +0100
Message-ID: <20070802223857.19090.70108.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Block of code at the end of ieee80211_tx_status() seems to exist in order
to echo tx packets down Monitor mode interfaces with a synthesized
radiotap preamble describing the outcome of the transmission.

The effect it has with injected packets is that two copies of each
injected packet appears on the soft Monitor mode interface it was injected
down, one with a correct radiotap header reflecting what was injected,
and one with a bogus 0x0b length radiotap header.  This behaviour
was seen on iwl3945 and rt73usb.

This patch adds a new attribute to ieee80211_tx_control's flags field,
IEEE80211_TXCTL_NO_SOFT_MONITOR_ECHO, which is set for injected
packets.  The code to add a new radiotap header and echo the packet
down monitor mode interfaces is now conditional on this attribute not
being set.

Signed-off-by: Andy Green <andy@warmcat.com>
---

 include/net/mac80211.h   |    1 +
 net/mac80211/ieee80211.c |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 17a4dd7..6bf8f7b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -192,6 +192,7 @@ struct ieee80211_tx_control {
 #define IEEE80211_TXCTL_FIRST_FRAGMENT	(1<<8) /* this is a first fragment of
 						* the frame */
 #define IEEE80211_TXCTL_TKIP_NEW_PHASE1_KEY (1<<9)
+#define IEEE80211_TXCTL_NO_SOFT_MONITOR_ECHO (1<<10)
 	u32 flags;			       /* tx control flags defined
 						* above */
 	u8 retry_limit;		/* 1 = only first attempt, 2 = one retry, .. */
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 7dda339..b094274 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -1309,6 +1309,7 @@ __ieee80211_tx_prepare(struct ieee80211_txrx_data *tx,
 								TXRX_DROP) {
 			return TXRX_DROP;
 		}
+		control->flags |= IEEE80211_TXCTL_NO_SOFT_MONITOR_ECHO;
 		/*
 		 * we removed the radiotap header after this point,
 		 * we filled control with what we could use
@@ -4850,6 +4851,9 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 	rthdr->data_retries = status->retry_count;
 
+	if (status->control.flags & IEEE80211_TXCTL_NO_SOFT_MONITOR_ECHO)
+		goto out_no_echo;
+
 	read_lock(&local->sub_if_lock);
 	monitors = local->monitors;
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
@@ -4885,6 +4889,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
 	}
  out:
 	read_unlock(&local->sub_if_lock);
+ out_no_echo:
 	if (skb)
 		dev_kfree_skb(skb);
 }

