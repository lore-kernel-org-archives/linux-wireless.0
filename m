Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:46848 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755942AbYLaPmp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2008 10:42:45 -0500
Message-Id: <20081231154237.228873645@w1.fi> (sfid-20081231_170904_289071_5B6A0F9B)
References: <20081231153834.840526845@w1.fi>
Date: Wed, 31 Dec 2008 17:38:44 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [RFC 10/11] mac80211: 802.11w - Drop unprotected robust management frames if MFP is used
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use ieee80211_drop_unencrypted() to decide whether a received frame
should be dropped with management frames, too. If MFP is negotiated,
unprotected robust management frames will be dropped.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


---
 net/mac80211/rx.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- wireless-testing.orig/net/mac80211/rx.c	2008-12-31 17:17:04.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2008-12-31 17:20:37.000000000 +0200
@@ -1703,6 +1703,9 @@ ieee80211_rx_h_action(struct ieee80211_r
 	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 		return RX_DROP_MONITOR;
 
+	if (ieee80211_drop_unencrypted(rx, mgmt->frame_control))
+		return RX_DROP_MONITOR;
+
 	/* all categories we currently handle have action_code */
 	if (len < IEEE80211_MIN_ACTION_SIZE + 1)
 		return RX_DROP_MONITOR;
@@ -1773,10 +1776,14 @@ static ieee80211_rx_result debug_noinlin
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
