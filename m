Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33007 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab0FNUPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 16:15:07 -0400
Received: by mail-wy0-f174.google.com with SMTP id 40so4235810wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jun 2010 13:15:07 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/14] rt2x00: don't use TXDONE_FALLBACK as success indicator
Date: Mon, 14 Jun 2010 22:09:09 +0200
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006142208.31736.IvDoorn@gmail.com>
In-Reply-To: <201006142208.31736.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006142209.09943.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

TXDONE_FALLBACK doesn't express if the frame was sent successful or not. It
only tells us that the hw used fallback rates for retries. Hence, don't use
TXDONE_FALLBACK as success indicator.

Before this patch we reported success to the rate control algorithm which
was wrong in a number of cases and might have lead to improper tx rate
selections.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 0b8efe8..8faee4c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -236,8 +236,7 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	 */
 	success =
 	    test_bit(TXDONE_SUCCESS, &txdesc->flags) ||
-	    test_bit(TXDONE_UNKNOWN, &txdesc->flags) ||
-	    test_bit(TXDONE_FALLBACK, &txdesc->flags);
+	    test_bit(TXDONE_UNKNOWN, &txdesc->flags);
 
 	/*
 	 * Update TX statistics.
-- 
1.6.6.1

