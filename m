Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64713 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab0BHMRM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 07:17:12 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2010 04:17:12 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	<stable@kernel.org>
Subject: [PATCH] mac80211: Reset dynamic ps timer in Rx path.
Date: Mon, 8 Feb 2010 17:47:01 +0530
Message-ID: <1265631421-2574-2-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1265631421-2574-1-git-send-email-vnatarajan@atheros.com>
References: <1265631421-2574-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current mac80211 implementation enables power save if there
is no Tx traffic for a specific timeout. Hence, PS is triggered
even if there is a continuous Rx only traffic(like UDP) going on.
This makes the drivers to wait on the tim bit in the next beacon
to awake which leads to redundant sleep-wake cycles.
Fix this by restarting the dynamic ps timer on receiving every
data packet.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
CC: stable@kernel.org
---
 net/mac80211/rx.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5709307..657ed66 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1719,6 +1719,7 @@ static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct ieee80211_local *local = rx->local;
 	struct net_device *dev = sdata->dev;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	__le16 fc = hdr->frame_control;
@@ -1750,6 +1751,13 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 	dev->stats.rx_packets++;
 	dev->stats.rx_bytes += rx->skb->len;
 
+	if (ieee80211_is_data(hdr->frame_control) &&
+	    !is_multicast_ether_addr(hdr->addr1) &&
+	    local->hw.conf.dynamic_ps_timeout > 0 && local->ps_sdata) {
+			mod_timer(&local->dynamic_ps_timer, jiffies +
+			 msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
+	}
+
 	ieee80211_deliver_skb(rx);
 
 	return RX_QUEUED;
-- 
1.6.6.1

