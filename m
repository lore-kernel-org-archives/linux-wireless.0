Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ocean.emcraft.com ([213.221.7.182]:42907 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab2IBJOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2012 05:14:40 -0400
Subject: Re: [rt2x00-users] [PATCH V2]: rt2800usb: Added rx packet length
 validity check
From: Sergei Poselenov <sposelenov@emcraft.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Sun, 02 Sep 2012 13:14:32 +0400
In-Reply-To: <70A1AEFB-59F7-4947-B2A0-A89C29C3108B@gmail.com>
References: <20120820205355.7ccc0450@emcraft.com>
	 <20120821114343.GB2380@redhat.com>
	 <CAOZOX0V5ehfSZKQ=tPpowH35ct230nBXk6wSBiTcb10UUbieCA@mail.gmail.com>
	 <20120821141842.GF2380@redhat.com>
	 <A1D107E0-1E78-4123-88C1-9550064DC9AC@gmail.com>
	 <20120822092715.GC4959@redhat.com>
	 <70A1AEFB-59F7-4947-B2A0-A89C29C3108B@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Message-ID: <1346577272.6409.5.camel@mehome> (sfid-20120902_111538_370495_6428541E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On our system (ARM Cortex-M3 SOC running linux-2.6.33)
frequent crashes were observed in the rt2800usb module
because of the invalid length of the received packet (3392,
46920...). This patch adds the sanity check on the packet
legth. Also, changed WARNING to ERROR in rt2x00lib_rxdone()
so that the bad packet condition would be noticed.

The fix was tested on the latest compat-wireless-3.5.1-1-snpc.

Cc: stable@vger.kernel.org
Signed-off-by: Sergei Poselenov <sposelenov@emcraft.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   10 +++++++++-
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index f8085b2..48df102 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -667,8 +667,16 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 	skb_pull(entry->skb, RXINFO_DESC_SIZE);
 
 	/*
-	 * FIXME: we need to check for rx_pkt_len validity
+	 * Check for rx_pkt_len validity. Return if invalid, leaving
+	 * rxdesc->size zeroed out by the upper level.
 	 */
+	if (unlikely(rx_pkt_len == 0 ||
+			rx_pkt_len > entry->queue->data_size)) {
+		ERROR(entry->queue->rt2x00dev,
+			"Bad frame size %d, forcing to 0\n", rx_pkt_len);
+		return;
+	}
+
 	rxd = (__le32 *)(entry->skb->data + rx_pkt_len);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index a59048f..10cf672 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -629,7 +629,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry, gfp_t gfp)
 	 */
 	if (unlikely(rxdesc.size == 0 ||
 		     rxdesc.size > entry->queue->data_size)) {
-		WARNING(rt2x00dev, "Wrong frame size %d max %d.\n",
+		ERROR(rt2x00dev, "Wrong frame size %d max %d.\n",
 			rxdesc.size, entry->queue->data_size);
 		dev_kfree_skb(entry->skb);
 		goto renew_skb;
-- 
1.7.4.4



