Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:49407 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab0FNUPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 16:15:25 -0400
Received: by mail-ww0-f46.google.com with SMTP id 18so4215976wwb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jun 2010 13:15:24 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 12/14] rt2x00: Limit TX done looping to number of TX ring entries
Date: Mon, 14 Jun 2010 22:13:37 +0200
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006142208.31736.IvDoorn@gmail.com> <201006142212.55156.IvDoorn@gmail.com> <201006142213.16315.IvDoorn@gmail.com>
In-Reply-To: <201006142213.16315.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006142213.38654.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

Similar to rt2800pci, remove the check for duplicate
register reading, and instead limit the for-loop to
the maximum number of TX entries inside a queue.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index d127011..f7ee31e 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2052,29 +2052,24 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 	struct txdone_entry_desc txdesc;
 	u32 word;
 	u32 reg;
-	u32 old_reg;
 	int type;
 	int index;
+	int i;
 
 	/*
-	 * During each loop we will compare the freshly read
-	 * STA_CSR4 register value with the value read from
-	 * the previous loop. If the 2 values are equal then
-	 * we should stop processing because the chance is
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
 		rt2x00pci_register_read(rt2x00dev, STA_CSR4, &reg);
 		if (!rt2x00_get_field32(reg, STA_CSR4_VALID))
 			break;
 
-		if (old_reg == reg)
-			break;
-		old_reg = reg;
-
 		/*
 		 * Skip this entry when it contains an invalid
 		 * queue identication number.
-- 
1.6.6.1

