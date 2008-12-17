Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:58318 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276AbYLQVzJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 16:55:09 -0500
Message-ID: <4949753B.9000505@lwfinger.net> (sfid-20081217_225513_653467_9B2F2518)
Date: Wed, 17 Dec 2008 15:55:07 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: p54usb problems
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian,

As you may have seen, one of my failed p54usb runs hit a WARN_ON in mac80211 due
to a faulty pkt_type in the skb. Johannes thinks this is most likely caused by
memory corruption. When I looked at the RX callback, I don't see any locking. Is
that correct?

On a different run, I had a failure to allocate a new skb because there was not
a free memory chunk of order(1). When I hit that, I remembered your suggestion
for reducing rx_mtu to keep the skb of order(0). What is your reaction to the
following patch? On my x86_64 system, the message that prints is "p54:
Calculated rx_mtu of 3240 reduced to 2356".

I have not hit the frame control patch you sent, at least not yet.

Larry


Index: wireless-testing/drivers/net/wireless/p54/p54common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54common.c
+++ wireless-testing/drivers/net/wireless/p54/p54common.c
@@ -195,6 +195,11 @@ int p54_parse_firmware(struct ieee80211_
 			else
 				priv->rx_mtu = (size_t)
 					0x620 - priv->tx_hdr_len;
+			if (priv->rx_mtu > 2356 && PAGE_SIZE == 4096) {
+				printk(KERN_INFO "p54: Calculated rx_mtu of %d"
+				       " reduced to 2356\n", priv->rx_mtu);
+				priv->rx_mtu = 2356;
+			}
 			break;
 			}
 		case BR_CODE_EXPOSED_IF:

