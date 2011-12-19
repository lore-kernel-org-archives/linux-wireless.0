Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46316 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab1LSKkC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 05:40:02 -0500
Received: by wgbdr13 with SMTP id dr13so10458403wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 02:40:01 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: Remove superfluous ieee80211_rx_h_remove_qos_control
Date: Mon, 19 Dec 2011 11:39:54 +0100
Message-Id: <1324291194-28203-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111219_114005_860795_10268EE5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This seems to not serve any purpose anymore, at least all frame
processing afterwards seems to be able to deal with QoS frames. So,
let's save the expensive memmove and just leave the QoS header in the
802.11 frame for further processing.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

It wouldn't hurt if a second pair of eyes looks through the rx path
to see if there's any possible problem with QoS frames in later rx
handlers.

I tried AP and STA mode and couldn't see any problems yet.

Thanks,
Helmut

 net/mac80211/rx.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8418f66..0ff0481 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1576,25 +1576,6 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	return RX_CONTINUE;
 }
 
-static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_remove_qos_control(struct ieee80211_rx_data *rx)
-{
-	u8 *data = rx->skb->data;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)data;
-
-	if (!ieee80211_is_data_qos(hdr->frame_control))
-		return RX_CONTINUE;
-
-	/* remove the qos control field, update frame type and meta-data */
-	memmove(data + IEEE80211_QOS_CTL_LEN, data,
-		ieee80211_hdrlen(hdr->frame_control) - IEEE80211_QOS_CTL_LEN);
-	hdr = (struct ieee80211_hdr *)skb_pull(rx->skb, IEEE80211_QOS_CTL_LEN);
-	/* change frame type to non QOS */
-	hdr->frame_control &= ~cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
-
-	return RX_CONTINUE;
-}
-
 static int
 ieee80211_802_1x_port_control(struct ieee80211_rx_data *rx)
 {
@@ -2669,7 +2650,6 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx)
 		if (ieee80211_vif_is_mesh(&rx->sdata->vif))
 			CALL_RXH(ieee80211_rx_h_mesh_fwding);
 #endif
-		CALL_RXH(ieee80211_rx_h_remove_qos_control)
 		CALL_RXH(ieee80211_rx_h_amsdu)
 		CALL_RXH(ieee80211_rx_h_data)
 		CALL_RXH(ieee80211_rx_h_ctrl);
-- 
1.7.7

