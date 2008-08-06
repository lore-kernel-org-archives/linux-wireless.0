Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:43290 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758086AbYHFWyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 18:54:20 -0400
From: Chr <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>, davem@davemloft.net
Subject: Re: [PATCH] p54: Fix regression due to commit b19fa1f
Date: Thu, 7 Aug 2008 00:57:00 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <4897714b.z7H23Rca9Z4lOo4Q%Larry.Finger@lwfinger.net>
In-Reply-To: <4897714b.z7H23Rca9Z4lOo4Q%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_9wimIqhMolesfXm"
Message-Id: <200808070057.01952.chunkeey@web.de> (sfid-20080807_005425_823101_752B9B72)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_9wimIqhMolesfXm
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 04 August 2008 23:14:51 Larry Finger wrote:
> In commit b19fa1fa91845234961c64dbd564671aa7c0fd27, the configuration
> parameter NETDEVICES_MULTIQUEUE was eliminated making multiple TX queues
> the normal behavior. For p54usb, enabling multiple queues broke the driver.
>
> The real failure is not known, but a temporary hack that forces only one
> queue is presented here.
>

The real problem seems to be that skb_get_queue_mapping doesn't
work the way it should when we process the firmwares callback. It's
always "0" and unfortunately also when it should be something else like
queue 1, 2 or 3..... problem solved? 

However someone should really take a closer look at the multiqueue thing,
especially why it has to BLOCK/SPIN (uninterruptible?) when a queue is stopped 
and tx returns therefore NETDEV_BUSY. 
The is assumption that "a queue is in any case going to become free again" is
well-intentioned, but as my devices are crashing left & right on a daily basis 
it's even dangerous for my RAID ;-).
 
(BTW: patch is diffed against 2.6.27-rc2)

Signed-off-by: Christian Lamparter <chunkeey@web.de>

--Boundary-00=_9wimIqhMolesfXm
Content-Type: text/x-patch;
  charset="iso-8859-1";
  name="p54-multiscrew.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54-multiscrew.diff"

--- a/drivers/net/wireless/p54/p54common.c.orig	2008-08-07 00:27:35.000000000 +0200
+++ b/drivers/net/wireless/p54/p54common.c	2008-08-07 00:30:38.000000000 +0200
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

--Boundary-00=_9wimIqhMolesfXm--
