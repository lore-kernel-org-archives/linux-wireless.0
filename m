Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43315 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751005AbdEOEm3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 May 2017 00:42:29 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2] mac80211: strictly check mesh address extension mode
Date: Sun, 14 May 2017 21:41:55 -0700
Message-ID: <1494823315-26575-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20170515_064234_357942_7823E1EB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh forwarding path checks for address extension mode to fetch
appropriate proxied address and MPP address. Existing condition
that looks for 6 address format is not strict enough so that
frames with improper values are processed and invalid entries
are added into MPP table. Fix that by adding a stricter check before
processing the packet.

Per IEEE Std 802.11s-2011 spec. Table 7-6g1 lists address extension
mode 0x3 as reserved one. And also Table Table 9-13 does not specify
0x3 as valid address field.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
v2: updated commit log and handled other AE cases

 net/mac80211/rx.c   |  3 ++-
 net/wireless/util.c | 10 ++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 35f4c7d7a500..1f75280ba26c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2492,7 +2492,8 @@ static bool ieee80211_frame_allowed(struct ieee80211_rx_data *rx, __le16 fc)
 		if (is_multicast_ether_addr(hdr->addr1)) {
 			mpp_addr = hdr->addr3;
 			proxied_addr = mesh_hdr->eaddr1;
-		} else if (mesh_hdr->flags & MESH_FLAGS_AE_A5_A6) {
+		} else if ((mesh_hdr->flags & MESH_FLAGS_AE) ==
+			    MESH_FLAGS_AE_A5_A6) {
 			/* has_a4 already checked in ieee80211_rx_mesh_check */
 			mpp_addr = hdr->addr4;
 			proxied_addr = mesh_hdr->eaddr2;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 7198373e2920..4992f1025c9d 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -454,6 +454,8 @@ int ieee80211_data_to_8023_exthdr(struct sk_buff *skb, struct ethhdr *ehdr,
 	if (iftype == NL80211_IFTYPE_MESH_POINT)
 		skb_copy_bits(skb, hdrlen, &mesh_flags, 1);
 
+	mesh_flags &= MESH_FLAGS_AE;
+
 	switch (hdr->frame_control &
 		cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
 	case cpu_to_le16(IEEE80211_FCTL_TODS):
@@ -469,9 +471,9 @@ int ieee80211_data_to_8023_exthdr(struct sk_buff *skb, struct ethhdr *ehdr,
 			     iftype != NL80211_IFTYPE_STATION))
 			return -1;
 		if (iftype == NL80211_IFTYPE_MESH_POINT) {
-			if (mesh_flags & MESH_FLAGS_AE_A4)
+			if (mesh_flags == MESH_FLAGS_AE_A4)
 				return -1;
-			if (mesh_flags & MESH_FLAGS_AE_A5_A6) {
+			if (mesh_flags == MESH_FLAGS_AE_A5_A6) {
 				skb_copy_bits(skb, hdrlen +
 					offsetof(struct ieee80211s_hdr, eaddr1),
 					tmp.h_dest, 2 * ETH_ALEN);
@@ -487,9 +489,9 @@ int ieee80211_data_to_8023_exthdr(struct sk_buff *skb, struct ethhdr *ehdr,
 		     ether_addr_equal(tmp.h_source, addr)))
 			return -1;
 		if (iftype == NL80211_IFTYPE_MESH_POINT) {
-			if (mesh_flags & MESH_FLAGS_AE_A5_A6)
+			if (mesh_flags == MESH_FLAGS_AE_A5_A6)
 				return -1;
-			if (mesh_flags & MESH_FLAGS_AE_A4)
+			if (mesh_flags == MESH_FLAGS_AE_A4)
 				skb_copy_bits(skb, hdrlen +
 					offsetof(struct ieee80211s_hdr, eaddr1),
 					tmp.h_source, ETH_ALEN);
-- 
1.9.1
