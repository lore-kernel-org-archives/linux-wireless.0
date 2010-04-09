Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:27150 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080Ab0DIIuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 04:50:44 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Prevent dynamic ps for rx broadcast frames
Date: Fri,  9 Apr 2010 11:46:34 +0300
Message-Id: <1270802794-6869-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the dynamic ps timer is restarted for all non-multicast rx data
frames. Congested networks have lots of broadcast traffic, which will cause
the power save to remain disabled for much of the time, which causes trouble
for battery-powered devices.

Fix this by preventing rx broadcast data frames from restarting the
dynamic ps timer.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/mac80211/rx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index c0ad7e8..8cdcc4f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1786,6 +1786,7 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 
 	if (ieee80211_is_data(hdr->frame_control) &&
 	    !is_multicast_ether_addr(hdr->addr1) &&
+	    !is_broadcast_ether_addr(hdr->addr1) &&
 	    local->hw.conf.dynamic_ps_timeout > 0 && local->ps_sdata) {
 			mod_timer(&local->dynamic_ps_timer, jiffies +
 			 msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
-- 
1.6.3.3

