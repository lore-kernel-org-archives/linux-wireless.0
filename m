Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58903 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbXH3OVL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 10:21:11 -0400
Subject: [PATCH] mac80211: don't send invalid QoS frames
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Kalle Valo <Kalle.Valo@nokia.com>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 16:22:12 +0200
Message-Id: <1188483732.3978.13.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo noticed that QoS frames are sent with an invalid QoS control
field; this is because we increase the header length but neither
initialise the space nor actually have enough space in the header
structure for the QoS control field.

This patch fixes it by treating the QoS field specially and appending it
explicitly, initialising it to zero.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
Kalle, please check if this fixes the weird frames you saw. I think it
will but would like to be sure. If it does, please say so and then we
should merge this patch to 2.6.24 and wireless-dev and I may make one
for -stable as well.

I think this is nicer than my previous patch because it explicitly
appends the QoS field and gives us a place to modify it should we ever
want.

 net/mac80211/tx.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- wireless-dev.orig/net/mac80211/tx.c	2007-08-30 14:35:21.152051253 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-08-30 16:16:17.595374680 +0200
@@ -1493,7 +1493,20 @@ int ieee80211_subif_start_xmit(struct sk
 		nh_pos += encaps_len;
 		h_pos += encaps_len;
 	}
-	memcpy(skb_push(skb, hdrlen), &hdr, hdrlen);
+
+	if (fc & IEEE80211_STYPE_QOS_DATA) {
+		__le16 *qos_control;
+
+		memcpy(skb_push(skb, hdrlen - 2), &hdr, hdrlen - 2);
+		qos_control = (__le16*) skb_push(skb, 2);
+		/*
+		 * Maybe we could actually set some fields here, for now just
+		 * initialise to zero to indicate no special operation.
+		 */
+		*qos_control = 0;
+	} else
+		memcpy(skb_push(skb, hdrlen), &hdr, hdrlen);
+
 	nh_pos += hdrlen;
 	h_pos += hdrlen;
 


