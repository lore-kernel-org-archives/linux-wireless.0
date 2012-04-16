Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41774 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717Ab2DPM5H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 08:57:07 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH] mac80211: fix truncated packets in cooked monitor rx
Date: Mon, 16 Apr 2012 14:56:48 +0200
Message-Id: <1334581008-22807-1-git-send-email-nbd@openwrt.org> (sfid-20120416_145711_625361_925CBBCF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cooked monitor rx was recently changed to use ieee80211_add_rx_radiotap_header
instead of generating only limited radiotap information.
ieee80211_add_rx_radiotap_header assumes that FCS info is still present if
the hardware supports receiving it, however when cooked monitor rx packets
are processed, FCS info has already been stripped.
Fix this by adding an extra flag indicating FCS presence.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rx.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 54a0491..7cbb4aa 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -103,7 +103,7 @@ static void
 ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 				 struct sk_buff *skb,
 				 struct ieee80211_rate *rate,
-				 int rtap_len)
+				 int rtap_len, bool has_fcs)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_radiotap_header *rthdr;
@@ -134,7 +134,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	}
 
 	/* IEEE80211_RADIOTAP_FLAGS */
-	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
+	if (has_fcs && (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS))
 		*pos |= IEEE80211_RADIOTAP_F_FCS;
 	if (status->flag & (RX_FLAG_FAILED_FCS_CRC | RX_FLAG_FAILED_PLCP_CRC))
 		*pos |= IEEE80211_RADIOTAP_F_BADFCS;
@@ -294,7 +294,8 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	}
 
 	/* prepend radiotap information */
-	ieee80211_add_rx_radiotap_header(local, skb, rate, needed_headroom);
+	ieee80211_add_rx_radiotap_header(local, skb, rate, needed_headroom,
+					 true);
 
 	skb_reset_mac_header(skb);
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -2567,7 +2568,8 @@ static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
 		goto out_free_skb;
 
 	/* prepend radiotap information */
-	ieee80211_add_rx_radiotap_header(local, skb, rate, needed_headroom);
+	ieee80211_add_rx_radiotap_header(local, skb, rate, needed_headroom,
+					 false);
 
 	skb_set_mac_header(skb, 0);
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
-- 
1.7.3.2

