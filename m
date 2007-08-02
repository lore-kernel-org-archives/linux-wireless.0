Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:39921 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbXHBUs0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 16:48:26 -0400
Date: Thu, 02 Aug 2007 15:48:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx-mac80211: Provide information to allow  transmission rate decreases
Message-ID: <46b24304.DLuGdus4YPRFspUn%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In bcm43xx-mac80211, the mechanism for decreasing the transmit rate cannot
be triggered. This may be shown by walking away from the AP with a laptop.
At some distance, communications will be lost and never recovered because
the rate decreasing mechanism of rc80211_simple needs to see excessive_retries
set in the ieee80211_tx_status struct. With this patch, the transmit rate
will decrease until communications restart.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John and Michael,

This is based on the wireless-dev tree.

Larry

 bcm43xx_dma.c |    3 +++
 1 file changed, 3 insertions(+)

Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_dma.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_dma.c
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_dma.c
@@ -1311,6 +1311,9 @@ void bcm43xx_dma_handle_txstatus(struct 
 			 */
 			if (status->acked)
 				meta->txstat.flags |= IEEE80211_TX_STATUS_ACK;
+			else
+				if (!(meta->txstat.flags & IEEE80211_TXCTL_NO_ACK))
+					meta->txstat.excessive_retries = 1;
 			meta->txstat.retry_count = status->frame_count - 1;
 			ieee80211_tx_status_irqsafe(dev->wl->hw, meta->skb, &(meta->txstat));
 			/* skb is freed by ieee80211_tx_status_irqsafe() */
