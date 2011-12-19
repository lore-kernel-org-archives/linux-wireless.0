Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51611 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab1LSKDF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 05:03:05 -0500
Received: by faar15 with SMTP id r15so3241858faa.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 02:03:04 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: Fix frame classification in AP mode for relayed frames
Date: Mon, 19 Dec 2011 11:02:58 +0100
Message-Id: <1324288978-27162-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111219_110309_317828_EB1ECCB5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When mac80211 relays a frame from STA1 to STA2 in AP mode it will get
re-classified in the tx path. Unfortunately the frame protocol field
is always set to ETH_P_8023 while the classification only kicks in
for ETH_P_IP. Hence, a high priority frame from STA1 will be send to
STA2 as best effort.

To allow proper re-classification of received frames, set the
skb->protocol field to the correct value without using eth_type_trans
as that would pull of the ethernet header. Also, set the network
header position correctly as otherwise the classification code won't
find the IP header.

This means that every frame relayed by a mac80211 AP will be
re-classified and might change its traffic class when the associated
STA and mac80211 use different 802.1d <-> TID mappings.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

We could also reuse the TID used by the source STA but I guess we should
always classify frames according to our own mapping instead of relying
on the associated STAs to do the right thing.

 net/mac80211/rx.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bf07d08..8418f66 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1827,10 +1827,23 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 	}
 
 	if (xmit_skb) {
-		/* send to wireless media */
-		xmit_skb->protocol = htons(ETH_P_802_3);
-		skb_reset_network_header(xmit_skb);
+		/*
+		 * Send to wireless media
+		 *
+		 * Set protocol field according to the ethernet header
+		 * to allow reclassification of this frame in the tx path.
+		 *
+		 * Don't use eth_type_trans here since it will pull the
+		 * eth header and because we are sure to have an ethernet
+		 * header here.
+		 */
+		ehdr = (struct ethhdr *) xmit_skb->data;
+		if (ntohs(ehdr->h_proto) >= 1536)
+			xmit_skb->protocol = ehdr->h_proto;
+		else
+			xmit_skb->protocol = htons(ETH_P_802_3);
 		skb_reset_mac_header(xmit_skb);
+		skb_set_network_header(xmit_skb, sizeof(struct ethhdr));
 		dev_queue_xmit(xmit_skb);
 	}
 }
-- 
1.7.7

