Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63150 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbYHGNVv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 09:21:51 -0400
Date: Thu, 07 Aug 2008 08:21:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>, chunkeey@web.de
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: Fix regression due to commit b19fa1f
Message-ID: <489af6ed.hkTX0XTOTIkENssK%Larry.Finger@lwfinger.net> (sfid-20080807_152154_878184_54C32769)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Christian Lamparter <chunkeey@web.de>

For p54pci and p54usb, skb_get_queue_mapping does not work correctly for
multiple queues.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
Acked by: Larry Finger <Larry.Finger@lwfinger.net>
CC: stable@kernel.org
---

Index: wireless-testing/drivers/net/wireless/p54/p54common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54common.c
+++ wireless-testing/drivers/net/wireless/p54/p54common.c
@@ -413,12 +413,12 @@ static void p54_rx_frame_sent(struct iee
 			last_addr = range->end_addr;
 			__skb_unlink(entry, &priv->tx_queue);
 			memset(&info->status, 0, sizeof(info->status));
-			priv->tx_stats[skb_get_queue_mapping(skb)].len--;
 			entry_hdr = (struct p54_control_hdr *) entry->data;
 			entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
 			if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) != 0)
 				pad = entry_data->align[0];
 
+			priv->tx_stats[le32_to_cpu(entry_data->frame_type - 4)].len--;
 			if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
 				if (!(payload->status & 0x01))
 					info->flags |= IEEE80211_TX_STAT_ACK;
