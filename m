Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36783 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab0FNUPR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 16:15:17 -0400
Received: by wyb40 with SMTP id 40so4235972wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jun 2010 13:15:15 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/14] rt2x00: Fix TX_STA_FIFO handling
Date: Mon, 14 Jun 2010 22:11:09 +0200
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006142208.31736.IvDoorn@gmail.com> <201006142210.10378.IvDoorn@gmail.com> <201006142210.43525.IvDoorn@gmail.com>
In-Reply-To: <201006142210.43525.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006142211.09880.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Currently rt2800pci will read TX_STA_FIFO until the previously read value
matches the current value. However, it is obvious that TX_STA_FIFO only
contains values that can easily be the same for multiple consecutive frames
(especially when communicating with only one other STA). Hence, we often
ended up with reading only the first entry and ignoring the rest.

One result was that when the TX_STA_FIFO contained multiple entires, only
the first one was read and properly handled while the others remained in the
tx queue.

Thus, drop this check but introduce a maximum number of reads. All legacy
drivers use the size of the tx ring as limit but state that the TX_STA_FIFO
has only 16 entries. So, let's just stick with the tx ring size for now.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index eeecedb..afa30ea 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -813,29 +813,24 @@ static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 	struct txdone_entry_desc txdesc;
 	u32 word;
 	u32 reg;
-	u32 old_reg;
 	int wcid, ack, pid, tx_wcid, tx_ack, tx_pid;
 	u16 mcs, real_mcs;
+	int i;
 
 	/*
-	 * During each loop we will compare the freshly read
-	 * TX_STA_FIFO register value with the value read from
-	 * the previous loop. If the 2 values are equal then
-	 * we should stop processing because the chance it
-	 * quite big that the device has been unplugged and
-	 * we risk going into an endless loop.
+	 * TX_STA_FIFO is a stack of X entries, hence read TX_STA_FIFO
+	 * at most X times and also stop processing once the TX_STA_FIFO_VALID
+	 * flag is not set anymore.
+	 *
+	 * The legacy drivers use X=TX_RING_SIZE but state in a comment
+	 * that the TX_STA_FIFO stack has a size of 16. We stick to our
+	 * tx ring size for now.
 	 */
-	old_reg = 0;
-
-	while (1) {
+	for (i = 0; i < TX_ENTRIES; i++) {
 		rt2800_register_read(rt2x00dev, TX_STA_FIFO, &reg);
 		if (!rt2x00_get_field32(reg, TX_STA_FIFO_VALID))
 			break;
 
-		if (old_reg == reg)
-			break;
-		old_reg = reg;
-
 		wcid    = rt2x00_get_field32(reg, TX_STA_FIFO_WCID);
 		ack     = rt2x00_get_field32(reg, TX_STA_FIFO_TX_ACK_REQUIRED);
 		pid     = rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE);
-- 
1.6.6.1

