Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36386 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab0KDTnm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 15:43:42 -0400
Received: by ewy7 with SMTP id 7so1281902ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 12:43:41 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 03/13] rt2x00: Wait up to one second on rt2800 for WPDMA to be ready
Date: Thu, 4 Nov 2010 20:37:47 +0100
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
References: <201011042037.00178.IvDoorn@gmail.com> <201011042037.23442.IvDoorn@gmail.com>
In-Reply-To: <201011042037.23442.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011042037.47939.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

At least some devices need such a long time to inititalize WPDMA. This
only increases the maximum wait time and shouldn't affect devices that
have been working before.

Reported-by: Joshua Smith <jesmith@kaon.com>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index b1738bb..dcd3a89 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -277,13 +277,17 @@ int rt2800_wait_wpdma_ready(struct rt2x00_dev *rt2x00dev)
 	unsigned int i;
 	u32 reg;
 
+	/*
+	 * Some devices are really slow to respond here. Wait a whole second
+	 * before timing out.
+	 */
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
 		rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
 		if (!rt2x00_get_field32(reg, WPDMA_GLO_CFG_TX_DMA_BUSY) &&
 		    !rt2x00_get_field32(reg, WPDMA_GLO_CFG_RX_DMA_BUSY))
 			return 0;
 
-		msleep(1);
+		msleep(10);
 	}
 
 	ERROR(rt2x00dev, "WPDMA TX/RX busy, aborting.\n");
-- 
1.7.2.3

