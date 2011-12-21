Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.bufferbloat.net ([149.20.54.82]:40136 "EHLO
	huchra.bufferbloat.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab1LUIsm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 03:48:42 -0500
From: Dave Taht <dave.taht@bufferbloat.net>
To: linux-wireless@vger.kernel.org
Cc: Dave Taht <dave.taht@bufferbloat.net>
Subject: [PATCH 1/1] Treat IPv6 diffserv the same as ipv4 diffserv for 802.11e
Date: Wed, 21 Dec 2011 00:41:45 -0800
Message-Id: <1324456905-2628-2-git-send-email-dave.taht@bufferbloat.net> (sfid-20111221_094848_063798_3C98A904)
In-Reply-To: <1324456905-2628-1-git-send-email-dave.taht@bufferbloat.net>
References: <1324456905-2628-1-git-send-email-dave.taht@bufferbloat.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wireless will select a different hardware queue based on the
top 3 bits of the diffserv field, for ipv4. Extend that queue
selection mechanism to ipv6, and make the calls orthogonal.
---
 net/wireless/util.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index e77df75..2c0600c 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <net/cfg80211.h>
 #include <net/ip.h>
+#include <net/dsfield.h>
 #include "core.h"
 
 struct ieee80211_rate *
@@ -650,7 +651,10 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb)
 
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
-		dscp = ip_hdr(skb)->tos & 0xfc;
+		dscp = ipv4_get_dsfield(ip_hdr(skb)) & 0xfc;
+		break;
+	case htons(ETH_P_IPV6):
+		dscp = ipv6_get_dsfield(ipv6_hdr(skb)) & 0xfc;
 		break;
 	default:
 		return 0;
-- 
1.7.1

