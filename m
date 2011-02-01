Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:60789 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486Ab1BARcy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 12:32:54 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Feb 2011 09:32:34 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [RFC v2] mac80211: do not restart ps timer during scan or offchannel
Date: Tue, 1 Feb 2011 23:02:06 +0530
Message-ID: <1296581526-3004-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While leaving oper channel, STA informs sleep state to AP to
stop sending data. Till sending ack for the nullfunc, AP
continues to send the data to STA which restarts ps_timer that
is causing unnecessary nullfunc exchange on timer expiry
when the STA was already moved to offchannel. So don't restart ps_timer
on data reception during scan. This issue was identified by
the following warning.

WARNING: at net/mac80211/tx.c:661 invoke_tx_handlers+0xf07/0x1330 [mac80211]
wlan0: Dropped data frame as no usable bitrate found while scanning and
associated. Target station: 00:03:7f:0b:a6:1b on 5 GHz band
Call Trace:
  [<ffffffffa0413ba7>] invoke_tx_handlers+0xf07/0x1330 [mac80211]
  [<ffffffffa0414056>] ieee80211_tx+0x86/0x2c0 [mac80211]
  [<ffffffffa0414345>] ieee80211_xmit+0xb5/0x1d0 [mac80211]
  [<ffffffffa04037e0>] ieee80211_dynamic_ps_enable_work+0x0/0xb0 [mac80211]
  [<ffffffffa04158cf>] ieee80211_tx_skb+0x4f/0x60 [mac80211]
  [<ffffffffa04026e6>] ieee80211_send_nullfunc+0x46/0x60 [mac80211]
  [<ffffffffa0403885>] ieee80211_dynamic_ps_enable_work+0xa5/0xb0 [mac80211]

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
v2: handled offchannel case too
 net/mac80211/rx.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 7185c93..f88ca98 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1929,7 +1929,10 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 	dev->stats.rx_bytes += rx->skb->len;
 
 	if (local->ps_sdata && local->hw.conf.dynamic_ps_timeout > 0 &&
-	    !is_multicast_ether_addr(((struct ethhdr *)rx->skb->data)->h_dest)) {
+	    !is_multicast_ether_addr(
+		    ((struct ethhdr *)rx->skb->data)->h_dest) &&
+	    (!local->scanning &&
+	     !test_bit(SDATA_STATE_OFFCHANNEL, &sdata->state))) {
 			mod_timer(&local->dynamic_ps_timer, jiffies +
 			 msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 	}
-- 
1.7.4

