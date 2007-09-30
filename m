Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:28704 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbXI3SlO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:41:14 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 24/26] at76_usb: Use ETH_P_802_2 in monitor mode
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:41:12 -0400
Message-ID: <20070930184112.23921.96075.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's used by most other wireless drivers, including mac80211.
ETH_P_80211_RAW is obsolete.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 1e3363e..f67dc8e 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -4937,7 +4937,7 @@ static void at76_rx_monitor_mode(struct at76_priv *priv)
 	skb->ip_summed = CHECKSUM_NONE;
 	skb_reset_mac_header(skb);
 	skb->pkt_type = PACKET_OTHERHOST;
-	skb->protocol = htons(ETH_P_80211_RAW);
+	skb->protocol = htons(ETH_P_802_2);
 
 	netdev->last_rx = jiffies;
 	netif_rx(skb);
