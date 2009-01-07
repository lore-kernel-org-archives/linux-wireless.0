Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:34030 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522AbZAGL2J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 06:28:09 -0500
Message-Id: <20090107112658.959454673@atheros.com> (sfid-20090107_123903_167791_CE70A501)
References: <20090107112346.369581673@atheros.com>
Date: Wed, 07 Jan 2009 13:23:56 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 10/14] mac80211: 802.11w - Drop unprotected robust management frames if MFP is used
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use ieee80211_drop_unencrypted() to decide whether a received frame
should be dropped with management frames, too. If MFP is negotiated,
unprotected robust management frames will be dropped.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


---
 net/mac80211/rx.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- wireless-testing.orig/net/mac80211/rx.c	2009-01-07 13:07:59.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2009-01-07 13:08:03.000000000 +0200
@@ -1705,6 +1705,9 @@ ieee80211_rx_h_action(struct ieee80211_r
 	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 		return RX_DROP_MONITOR;
 
+	if (ieee80211_drop_unencrypted(rx, mgmt->frame_control))
+		return RX_DROP_MONITOR;
+
 	/* all categories we currently handle have action_code */
 	if (len < IEEE80211_MIN_ACTION_SIZE + 1)
 		return RX_DROP_MONITOR;
@@ -1790,10 +1793,14 @@ static ieee80211_rx_result debug_noinlin
 ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(rx->dev);
+	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
 
 	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 		return RX_DROP_MONITOR;
 
+	if (ieee80211_drop_unencrypted(rx, mgmt->frame_control))
+		return RX_DROP_MONITOR;
+
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		return ieee80211_mesh_rx_mgmt(sdata, rx->skb, rx->status);
 

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
