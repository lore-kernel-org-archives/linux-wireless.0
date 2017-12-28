Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:40798 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932206AbdL1R6k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Dec 2017 12:58:40 -0500
Received: by mail-it0-f65.google.com with SMTP id f190so29410387ita.5
        for <linux-wireless@vger.kernel.org>; Thu, 28 Dec 2017 09:58:40 -0800 (PST)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [RFC 3/4] mac80211: Send control port frames over nl80211
Date: Thu, 28 Dec 2017 11:58:31 -0600
Message-Id: <20171228175832.3253-4-denkenz@gmail.com> (sfid-20171228_185857_499750_7D3F98A3)
In-Reply-To: <20171228175832.3253-1-denkenz@gmail.com>
References: <20171228175832.3253-1-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If userspace requested control port frames to go over 80211, then do so.
The control packets are intercepted just prior to delivery of the packet
to the underlying network device.

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 net/mac80211/rx.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b3cff69bfd66..13e786fe62a6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2326,16 +2326,42 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 	}
 #endif
 
-	if (skb) {
+	if (!skb)
+		goto try_xmit;
+
+	skb->protocol = eth_type_trans(skb, dev);
+	memset(skb->cb, 0, sizeof(skb->cb));
+
+	if (unlikely(skb->protocol == sdata->control_port_protocol &&
+		     sdata->control_port_over_nl80211)) {
+		struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+		bool noencrypt;
+
+		ehdr = eth_hdr(skb);
+
+		if (status->flag & RX_FLAG_DECRYPTED)
+			noencrypt = false;
+		else
+			noencrypt = true;
+
+		if (!cfg80211_rx_control_port(&sdata->wdev,
+					      skb->data,
+					      skb->len,
+					      ehdr->h_source,
+					      be16_to_cpu(skb->protocol),
+					      noencrypt)) {
+			dev_kfree_skb(skb);
+			skb = NULL;
+		}
+	} else {
 		/* deliver to local stack */
-		skb->protocol = eth_type_trans(skb, dev);
-		memset(skb->cb, 0, sizeof(skb->cb));
 		if (rx->napi)
 			napi_gro_receive(rx->napi, skb);
 		else
 			netif_receive_skb(skb);
 	}
 
+try_xmit:
 	if (xmit_skb) {
 		/*
 		 * Send to wireless media and increase priority by 256 to
-- 
2.13.5
