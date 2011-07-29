Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63916 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab1G2RWa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 13:22:30 -0400
Received: by fxh19 with SMTP id 19so2464952fxh.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jul 2011 10:22:29 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/2] mac80211: Fill in skb->protocol information for injected frames
Date: Fri, 29 Jul 2011 19:22:16 +0200
Message-Id: <1311960137-25420-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20110729_192236_673801_AAA0153D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers (ath9k for example) are using skb->protocol to treat EAPOL
frames somehow special (disallow aggregation for example).

When running in AP mode hostapd injects the EAPOL frames through a
monitor interface and thus skb->protocol isn't set at all. Hence, if the
injected frame is a data frame and carries a rfc1042 headaer update the
skb->protocol field accordingly.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/tx.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index b83de4e..939c3f0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1631,7 +1631,9 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	struct ieee80211_radiotap_header *prthdr =
 		(struct ieee80211_radiotap_header *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr;
 	u16 len_rthdr;
+	u8 *payload;
 
 	/*
 	 * Frame injection is not allowed if beaconing is not allowed
@@ -1682,6 +1684,24 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	skb_set_network_header(skb, len_rthdr);
 	skb_set_transport_header(skb, len_rthdr);
 
+	/*
+	 * Initialize skb->protocol if the injected frame is a data frame
+	 * carrying a rfc1042 header
+	 */
+	if (skb->len > len_rthdr + 2) {
+		hdr = (struct ieee80211_hdr *)(skb->data + len_rthdr);
+		if (ieee80211_is_data(hdr->frame_control) &&
+		    skb->len >= len_rthdr +
+				ieee80211_hdrlen(hdr->frame_control) +
+				sizeof(rfc1042_header) + 2) {
+			payload = (u8 *)hdr +
+				  ieee80211_hdrlen(hdr->frame_control);
+			if (compare_ether_addr(payload, rfc1042_header) == 0)
+				skb->protocol = ntohs((payload[6] << 8) |
+						       payload[7]);
+		}
+	}
+
 	memset(info, 0, sizeof(*info));
 
 	info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
-- 
1.7.3.4

