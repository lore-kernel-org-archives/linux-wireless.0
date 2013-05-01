Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:36243 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761480Ab3EAPRe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 11:17:34 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 4/7] rt2x00: rt2800usb: use rt2x00dev->rx->limit
Date: Wed,  1 May 2013 17:17:32 +0200
Message-Id: <1367421455-18463-5-git-send-email-juhosg@openwrt.org> (sfid-20130501_171801_923423_9F6E1638)
In-Reply-To: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
References: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The RX data queue is initialized already when
the rt2800_usb_enable_radio() function is called.

Fetch the number of the queue entries from that
instead of using the entry_num field of the data
queue descriptor.

The two values are the same, and the use of the
rt2x00dev->rx->limit value allows us to get rid
of a superfluous pointer dereference.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index ac854d7..c71a48d 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -327,7 +327,7 @@ static int rt2800usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 	 * this limit so reduce the number to prevent errors.
 	 */
 	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_LIMIT,
-			   ((rt2x00dev->ops->rx->entry_num * DATA_FRAME_SIZE)
+			   ((rt2x00dev->rx->limit * DATA_FRAME_SIZE)
 			    / 1024) - 3);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_EN, 1);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_TX_BULK_EN, 1);
-- 
1.7.10

