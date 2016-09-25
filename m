Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:42269 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965662AbcIYL2K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Sep 2016 07:28:10 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        Michael Braun <michael-dev@fami-braun.de>
Subject: [PATCHv2] mac80211: check A-MSDU inner frame source address on AP interfaces
Date: Sun, 25 Sep 2016 13:28:06 +0200
Message-Id: <1474802886-27220-1-git-send-email-michael-dev@fami-braun.de> (sfid-20160925_132814_009961_6C91AC39)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using WPA security, the station and thus the required key is
identified by its mac address when packets are received. So a
station usually cannot spoof its source mac address.

But when a station sends an A-MSDU frame, port control and crypto
is done using the outer mac address, while the packets delivered
and forwarded use the inner mac address.

IEEE 802.11-2012 mandates that the outer source mac address should
match the inner source address (section 8.3.2.2). For the
destination mac address, matching is not required (section 10.23.15).

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>

--
v2: fix typo inversed source mac address check

---
 net/wireless/util.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index b7d1592..86ca5d2 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -747,13 +747,13 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 	u16 ethertype;
 	u8 *payload;
 	int offset = 0, remaining, err;
-	struct ethhdr eth;
+	struct ethhdr eth, eth_80211;
 	bool reuse_frag = skb->head_frag && !skb_has_frag_list(skb);
 	bool reuse_skb = false;
 	bool last = false;
 
 	if (has_80211_header) {
-		err = __ieee80211_data_to_8023(skb, &eth, addr, iftype);
+		err = __ieee80211_data_to_8023(skb, &eth_80211, addr, iftype);
 		if (err)
 			goto out;
 	}
@@ -768,6 +768,13 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 		subframe_len = sizeof(struct ethhdr) + len;
 		padding = (4 - subframe_len) & 0x3;
 
+		if (unlikely(has_80211_header &&
+			     (iftype == NL80211_IFTYPE_AP ||
+			      iftype == NL80211_IFTYPE_AP_VLAN) &&
+			     !ether_addr_equal(eth_80211.h_source, eth.h_source)
+		   ))
+			goto purge;
+
 		/* the last MSDU has no padding */
 		remaining = skb->len - offset;
 		if (subframe_len > remaining)
-- 
2.1.4
