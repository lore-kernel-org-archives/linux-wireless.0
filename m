Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:2192 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbYFCS0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 14:26:13 -0400
Received: by nf-out-0910.google.com with SMTP id d3so644294nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jun 2008 11:26:13 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/11] rt2x00: Remove CTS/RTS check in tx()
Date: Tue, 3 Jun 2008 20:29:57 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200806032024.52931.IvDoorn@gmail.com> <200806032027.27540.IvDoorn@gmail.com> <200806032027.47342.IvDoorn@gmail.com>
In-Reply-To: <200806032027.47342.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200806032029.57962.IvDoorn@gmail.com> (sfid-20080603_202623_326574_BD532BB4)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 38a62373d637d6e4915136033c628143061049f4 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Tue, 3 Jun 2008 18:52:52 +0200
Subject: [PATCH] rt2x00: Remove CTS/RTS check in tx()

mac80211 doesn't send RTS or CTS-to-self frames through
the tx() callback functions so we don't need to check it.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index b02dbc8..97d9095 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -135,18 +135,16 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 
 	/*
-	 * If CTS/RTS is required. and this frame is not CTS or RTS,
-	 * create and queue that frame first. But make sure we have
-	 * at least enough entries available to send this CTS/RTS
-	 * frame as well as the data frame.
+	 * If CTS/RTS is required. create and queue that frame first.
+	 * Make sure we have at least enough entries available to send
+	 * this CTS/RTS frame as well as the data frame.
 	 * Note that when the driver has set the set_rts_threshold()
 	 * callback function it doesn't need software generation of
-	 * neither RTS or CTS-to-self frames and handles everything
+	 * either RTS or CTS-to-self frame and handles everything
 	 * inside the hardware.
 	 */
 	frame_control = le16_to_cpu(ieee80211hdr->frame_control);
-	if (!is_rts_frame(frame_control) && !is_cts_frame(frame_control) &&
-	    (tx_info->flags & (IEEE80211_TX_CTL_USE_RTS_CTS |
+	if ((tx_info->flags & (IEEE80211_TX_CTL_USE_RTS_CTS |
 			       IEEE80211_TX_CTL_USE_CTS_PROTECT)) &&
 	    !rt2x00dev->ops->hw->set_rts_threshold) {
 		if (rt2x00queue_available(queue) <= 1) {
-- 
1.5.5.3

