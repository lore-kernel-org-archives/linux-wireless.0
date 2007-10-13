Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:41958 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbXJMOKj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2007 10:10:39 -0400
Received: by ug-out-1314.google.com with SMTP id z38so715870ugc
        for <linux-wireless@vger.kernel.org>; Sat, 13 Oct 2007 07:10:38 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/11] rt2x00: Fix residual check in PLCP calculations.
Date: Sat, 13 Oct 2007 16:26:52 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710131621.05173.IvDoorn@gmail.com>
In-Reply-To: <200710131621.05173.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200710131626.52613.IvDoorn@gmail.com> (sfid-20071013_151054_588086_25DFFC7C)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mattias Nissler <mattias.nissler@gmx.de>

Because rt2x00 implements the residual calculation different from what the
legacy code does (i.e. scaled values), we need to adjust the residual check.
Again, we are only mimicking the behaviour of the ralink driver without
actually knowing what we do :-(

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 71b4a04..360f03a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -697,7 +697,7 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 			/*
 			 * Check if we need to set the Length Extension
 			 */
-			if (bitrate == 110 && residual <= 3)
+			if (bitrate == 110 && residual <= 30)
 				desc.service |= 0x80;
 		}
 
-- 
1.5.3.4

