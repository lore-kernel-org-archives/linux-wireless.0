Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:44251 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbZHTSWD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 14:22:03 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH] p54: fix broadcast buffering in AP mode
Date: Thu, 20 Aug 2009 20:22:01 +0200
Cc: John Linville <linville@tuxdriver.com>
References: <200908172124.15399.chunkeey@web.de>
In-Reply-To: <200908172124.15399.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200908202022.01623.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "mac80211: fix PS-poll response race" somehow broke
broadcast buffering in a funny way.

During normal operation - stations are awake - the firmware refused
to transmit broadcast frames and reported P54_TX_PSM_CANCELLED.
But everything worked as soon as one station entered PSM.

The reason:
The stack sets IEEE80211_TX_CTL_SEND_AFTER_DTIM for outgoing
broadcast frames as soon as a station is marked as sleeping.
This flag triggers a path which will reroute these frames
into p54's "content after beacon" queue, which is designed
to cope with the demands for psm.

This patch restores the old behavior.

IEEE80211_TX_CTL_CLEAR_PS_FILT will once again be used to signalize
the firmware to ignore the ps canceling for certain frames.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 6fc0b61..b6dda2b 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -623,6 +623,9 @@ static void p54_tx_80211_header(struct p54_common *priv, struct sk_buff *skb,
 	if (info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE)
 		*flags |= P54_HDR_FLAG_DATA_OUT_NOCANCEL;
 
+	if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT)
+		*flags |= P54_HDR_FLAG_DATA_OUT_NOCANCEL;
+
 	*queue = skb_get_queue_mapping(skb) + P54_QUEUE_DATA;
 
 	switch (priv->mode) {
