Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ocean.emcraft.com ([213.221.7.182]:42332 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458Ab2HTQyG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 12:54:06 -0400
Date: Mon, 20 Aug 2012 20:53:55 +0400
From: Sergei Poselenov <sposelenov@emcraft.com>
To: users@rt2x00.serialmonkey.com
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] compat-wireless:rt2800usb: Added rx packet length validity
 check
Message-ID: <20120820205355.7ccc0450@emcraft.com> (sfid-20120820_185423_193652_D2AAC31A)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On our system (ARM Cortex-M3 SOC running linux-2.6.33 with
compat-wireless-3.4-rc3-1 modules configured for rt2x00) frequent
crashes were observed in rt2800usb module because of the invalid
length of the received packet (3392, 46920...). This patch adds
the sanity check on the packet legth. In case of the bad length,
mark the packet as with CRC error.

The fix was also tested on the latest
compat-wireless-3.5.1-1-snpc.tar.bz2, applies cleanly.

Cc: stable@vger.kernel.org
Signed-off-by: Sergei Poselenov <sposelenov@emcraft.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/usbwifi/compat-wireless-3.4-rc3-1/drivers/net/wireless/rt2x00/rt2800usb.c b/usbwifi/compat-wireless-3.4-rc3-1/drivers/net/wireless/rt2x00/rt2800usb.c
index 001735f..6776ec8 100644
--- a/usbwifi/compat-wireless-3.4-rc3-1/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/usbwifi/compat-wireless-3.4-rc3-1/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -662,13 +662,18 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 	rx_pkt_len = rt2x00_get_field32(word, RXINFO_W0_USB_DMA_RX_PKT_LEN);
 
 	/*
-	 * Remove the RXINFO structure from the sbk.
+	 * Remove the RXINFO structure from the skb.
 	 */
 	skb_pull(entry->skb, RXINFO_DESC_SIZE);
 
 	/*
-	 * FIXME: we need to check for rx_pkt_len validity
+	 * Check for rx_pkt_len validity, mark as failed.
 	 */
+	if (rx_pkt_len > entry->skb->len) {
+		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
+		goto procrxwi;
+	}
+
 	rxd = (__le32 *)(entry->skb->data + rx_pkt_len);
 
 	/*
@@ -713,6 +718,7 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 	 */
 	skb_trim(entry->skb, rx_pkt_len);
 
+procrxwi:
 	/*
 	 * Process the RXWI structure.
 	 */
