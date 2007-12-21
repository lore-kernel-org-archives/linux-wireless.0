Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718AbXLUOML (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2007 09:12:11 -0500
From: Helmut Schaa <hschaa@suse.de>
To: linville@tuxdriver.com
Subject: [PATCH] mac80211: Restore rx.fc before every invocation of ieee80211_invoke_rx_handlers
Date: Fri, 21 Dec 2007 15:16:35 +0100
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200712211516.35731.hschaa@suse.de> (sfid-20071221_141215_108356_0F4BE6F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a problem with rx handling on multiple interfaces. Especially 
when using hardware-scanning and a wireless driver (i.e. iwlwifi) which is 
able to receive data while scanning.

The rx handlers can modify the skb and the frame control field (see 
ieee80211_rx_h_remove_qos_control) but since every interface gets its own 
copy of the skb each should get its own copy of rx.fc too.

In my case the wlan0-interface did not remove the qos-control from the frame 
because the corresponding flag in rx.fc was already removed while processing 
the frame on the master interface. Therefore somehow corrupted frames were 
passed to the userspace.

Signed-off-by: Helmut Schaa <hschaa@suse.de>
---
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 362e8e5..08a6905 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1723,6 +1723,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct 
sk_buff *skb,
 				       prev->dev->name);
 			continue;
 		}
+		rx.fc = le16_to_cpu(hdr->frame_control);
 		rx.skb = skb_new;
 		rx.dev = prev->dev;
 		rx.sdata = prev;
@@ -1731,6 +1732,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct 
sk_buff *skb,
 		prev = sdata;
 	}
 	if (prev) {
+		rx.fc = le16_to_cpu(hdr->frame_control);
 		rx.skb = skb;
 		rx.dev = prev->dev;
 		rx.sdata = prev;
