Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38012 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab0F2TvM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:51:12 -0400
Received: by mail-wy0-f174.google.com with SMTP id 38so2999610wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 12:51:11 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 14/21] rt2x00: Fix beacon updates in rt2800pci
Date: Tue, 29 Jun 2010 21:46:43 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006292138.13509.IvDoorn@gmail.com> <201006292144.51636.IvDoorn@gmail.com> <201006292145.32554.IvDoorn@gmail.com>
In-Reply-To: <201006292145.32554.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006292146.44952.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

rt2800pci didn't update the beacon template after each beacon interval,
resulting in the DTIM count being incorrect (if DTIM period > 1). Fix this
by calling rt2x00lib_beacondone after the current beacon was sent out.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index b48b949..6f11760 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -953,6 +953,12 @@ static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TX_FIFO_STATUS))
 		rt2800pci_txdone(rt2x00dev);
 
+	/*
+	 * Current beacon was sent out, fetch the next one
+	 */
+	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_TBTT))
+		rt2x00lib_beacondone(rt2x00dev);
+
 	if (rt2x00_get_field32(reg, INT_SOURCE_CSR_AUTO_WAKEUP))
 		rt2800pci_wakeup(rt2x00dev);
 
-- 
1.6.6.1

