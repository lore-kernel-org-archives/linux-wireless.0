Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.191]:47462 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531AbXKLNtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2007 08:49:04 -0500
Received: by mu-out-0910.google.com with SMTP id i10so1450273mue
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2007 05:49:00 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/3] rt2x00: Allow rt61 to catch up after a missing tx report
Date: Mon, 12 Nov 2007 15:03:12 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200711121502.01953.IvDoorn@gmail.com>
In-Reply-To: <200711121502.01953.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200711121503.12709.IvDoorn@gmail.com> (sfid-20071112_134912_073495_A02319C1)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mattias Nissler <mattias.nissler@gmx.de>

Sometimes it happens in the tx path that an entry given to the hardware isn't
reported in the txdone handler. This ultimately led to the dreaded "non-free
entry in the non-full queue" message and the stopping of the tx queue. Work
around this issue by allowing the driver to also clear out previos entries in
the txdone handler.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index a6d4e10..c2b4509 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1708,6 +1708,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_ring *ring;
 	struct data_entry *entry;
+	struct data_entry *entry_done;
 	__le32 *txd;
 	u32 word;
 	u32 reg;
@@ -1761,6 +1762,18 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 		    !rt2x00_get_field32(word, TXD_W0_VALID))
 			return;
 
+		entry_done = rt2x00_get_data_entry_done(ring);
+		while (entry != entry_done) {
+			/* Catch up. Just report any entries we missed as
+			 * failed. */
+			WARNING(rt2x00dev,
+				"TX status report missed for entry %p\n",
+				entry_done);
+			rt2x00pci_txdone(rt2x00dev, entry_done, TX_FAIL_OTHER,
+					 0);
+			entry_done = rt2x00_get_data_entry_done(ring);
+		}
+
 		/*
 		 * Obtain the status about this packet.
 		 */
-- 
1.5.3.4

