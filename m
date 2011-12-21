Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:53478 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138Ab1LUILt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 03:11:49 -0500
Received: by lahd3 with SMTP id d3so447264lah.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 00:11:48 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: Keep skb->piority for relayed frames in AP mode
Date: Wed, 21 Dec 2011 09:11:35 +0100
Message-Id: <1324455095-3888-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111221_091152_921809_29A5222C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When mac80211 relays a frame from STA1 to STA2 in AP mode it will get
re-classified in the tx path. Unfortunately the frame protocol field
is always set to ETH_P_8023 while the classification only kicks in
for ETH_P_IP. Hence, a high priority frame from STA1 will be send to
STA2 as best effort.

Instead of running classification on the frame just use the same
priority as STA1 did. Do this by adding 256 to the skb->priority
to allow cfg80211_classify8021d to shortcut frame classification.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/rx.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index cd689cf..c6ff3b6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1808,7 +1808,12 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 	}
 
 	if (xmit_skb) {
-		/* send to wireless media */
+		/*
+		 * Send to wireless media and increase priority by 256 to
+		 * keep the received priority instead of reclassifying
+		 * the frame (see cfg80211_classify8021d).
+		 */
+		xmit_skb->priority += 256; 
 		xmit_skb->protocol = htons(ETH_P_802_3);
 		skb_reset_network_header(xmit_skb);
 		skb_reset_mac_header(xmit_skb);
-- 
1.7.7

