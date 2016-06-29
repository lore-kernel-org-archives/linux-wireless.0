Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57661 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbcF2Igv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 04:36:51 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] cfg80211: fix proto in ieee80211_data_to_8023 for frames without LLC header
Date: Wed, 29 Jun 2016 10:36:39 +0200
Message-Id: <20160629083639.81261-1-nbd@nbd.name> (sfid-20160629_103656_226890_BD7512E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The PDU length of incoming LLC frames is set to the total skb payload size
in __ieee80211_data_to_8023() of net/wireless/util.c which incorrectly
includes the length of the IEEE 802.11 header.

The resulting LLC frame header has a too large PDU length, causing the
llc_fixup_skb() function of net/llc/llc_input.c to reject the incoming
skb, effectively breaking STP.

Solve the problem by properly substracting the IEEE 802.11 frame header size
from the PDU length, allowing the LLC processor to pick up the incoming
control messages.

Special thanks to Gerry Rozema for tracking down the regression and proposing
a suitable patch.

Fixes: 2d1c304cb2d5 ("cfg80211: add function for 802.3 conversion with separate output buffer")
Cc: stable@vger.kernel.org
Reported-by: Gerry Rozema <gerryr@rozeware.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/wireless/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 4e809e9..2443ee3 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -509,7 +509,7 @@ static int __ieee80211_data_to_8023(struct sk_buff *skb, struct ethhdr *ehdr,
 		 * replace EtherType */
 		hdrlen += ETH_ALEN + 2;
 	else
-		tmp.h_proto = htons(skb->len);
+		tmp.h_proto = htons(skb->len - hdrlen);
 
 	pskb_pull(skb, hdrlen);
 
-- 
2.8.4

