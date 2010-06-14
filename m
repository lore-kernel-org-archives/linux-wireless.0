Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33007 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab0FNUPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 16:15:12 -0400
Received: by mail-wy0-f174.google.com with SMTP id 40so4235810wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jun 2010 13:15:11 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/14] rt2x00: only set TXDONE_FALLBACK in rt2800pci if the frame was retried
Date: Mon, 14 Jun 2010 22:09:41 +0200
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006142208.31736.IvDoorn@gmail.com> <201006142209.09943.IvDoorn@gmail.com>
In-Reply-To: <201006142209.09943.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006142209.42709.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

TXDONE_FALLBACK expresses that fallback rates were used for retries. Hence,
it only makes sense to set the flag if retries > 0.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index b5a871e..eeecedb 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -903,8 +903,12 @@ static void rt2800pci_txdone(struct rt2x00_dev *rt2x00dev)
 			txdesc.retry = 7;
 		}
 
-		__set_bit(TXDONE_FALLBACK, &txdesc.flags);
-
+		/*
+		 * the frame was retried at least once
+		 * -> hw used fallback rates
+		 */
+		if (txdesc.retry)
+			__set_bit(TXDONE_FALLBACK, &txdesc.flags);
 
 		rt2x00pci_txdone(entry, &txdesc);
 	}
-- 
1.6.6.1

