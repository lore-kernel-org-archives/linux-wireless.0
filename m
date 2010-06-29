Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38403 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826Ab0F2TvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 15:51:19 -0400
Received: by mail-ww0-f46.google.com with SMTP id 18so547wwb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 12:51:19 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 19/21] rt2x00: Fix antenna initialization
Date: Tue, 29 Jun 2010 21:49:05 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006292138.13509.IvDoorn@gmail.com> <201006292148.07594.IvDoorn@gmail.com> <201006292148.38803.IvDoorn@gmail.com>
In-Reply-To: <201006292148.38803.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006292149.06304.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

Legacy driver indicates that BBP1_TX_ANTENNA must be set
to 0 for TXPATH values of 1 and 3. So the previous statement
that nothing should be done for TXPATH = 3, is false.

Furthermore, remove the false BBP3_RX_ANTENNA initialization
when TXPATH is 1 for PCI and SOC devices. This field will always
be overridden in the next switch statement, making this initialization
bogus. History of this line indicates it was there from the beginning,
and was once caught as typo. Instead of replacing the line with the
correct line, the correct line was added...

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 2d0a216..0cf7796 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -836,14 +836,12 @@ void rt2800_config_ant(struct rt2x00_dev *rt2x00dev, struct antenna_setup *ant)
 	switch ((int)ant->tx) {
 	case 1:
 		rt2x00_set_field8(&r1, BBP1_TX_ANTENNA, 0);
-		if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev))
-			rt2x00_set_field8(&r3, BBP3_RX_ANTENNA, 0);
 		break;
 	case 2:
 		rt2x00_set_field8(&r1, BBP1_TX_ANTENNA, 2);
 		break;
 	case 3:
-		/* Do nothing */
+		rt2x00_set_field8(&r1, BBP1_TX_ANTENNA, 0);
 		break;
 	}
 
-- 
1.6.6.1

