Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57261 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751AbXEQDNx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2007 23:13:53 -0400
Subject: [patch] mac80211: fix memory leak when defrag fragments
From: Hong Liu <hong.liu@intel.com>
To: linville@tuxdriver.com, jbenc@suse.cz
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Thu, 17 May 2007 11:13:44 +0800
Message-Id: <1179371624.25623.4.camel@napa-sdv1.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We forget to free all the fragments when defraging them into one packet.

Signed-off-by: Hong Liu <hong.liu@intel.com>

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 873ccb0..ed86804 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -3412,8 +3412,10 @@ ieee80211_rx_h_defragment(struct ieee80211_txrx_data *rx)
 			return TXRX_DROP;
 		}
 	}
-	while ((skb = __skb_dequeue(&entry->skb_list)))
+	while ((skb = __skb_dequeue(&entry->skb_list))) {
 		memcpy(skb_put(rx->skb, skb->len), skb->data, skb->len);
+		dev_kfree_skb(skb);
+	}
 
 	/* Complete frame has been reassembled - process it now */
 	rx->fragmented = 1;
