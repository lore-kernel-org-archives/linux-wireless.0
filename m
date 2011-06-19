Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:62910 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab1FSRoe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 13:44:34 -0400
Date: Sun, 19 Jun 2011 19:46:02 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 1/2] rt2x00: fix possible memory corruption in case of
 invalid rxdesc.size
Message-ID: <20110619174602.GB19934@localhost.localdomain> (sfid-20110619_194437_704202_D6DE456F)
References: <20110604144854.GA4865@localhost.localdomain>
 <20110604172940.GA10984@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110604172940.GA10984@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes rxdesc descriptor provided by hardware contains invalid
(random) data. For example rxdesc.size can be bigger than actual
size of the buffer. When this happen rt2x00crypto_rx_insert_iv()
corrupt memory doing memmove outside of buffer boundaries.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 939821b..0955c94 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -583,6 +583,18 @@ void rt2x00lib_rxdone(struct queue_entry *entry)
 	rt2x00dev->ops->lib->fill_rxdone(entry, &rxdesc);
 
 	/*
+	 * Check for valid size in case we get corrupted descriptor from
+	 * hardware.
+	 */
+	if (unlikely(rxdesc.size == 0 ||
+		     rxdesc.size > entry->queue->data_size)) {
+		WARNING(rt2x00dev, "Wrong frame size %d max %d.\n",
+			rxdesc.size, entry->queue->data_size);
+		dev_kfree_skb(entry->skb);
+		goto renew_skb;
+	}
+
+	/*
 	 * The data behind the ieee80211 header must be
 	 * aligned on a 4 byte boundary.
 	 */
@@ -642,6 +654,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry)
 
 	ieee80211_rx_ni(rt2x00dev->hw, entry->skb);
 
+renew_skb:
 	/*
 	 * Replace the skb with the freshly allocated one.
 	 */
-- 
1.7.4

