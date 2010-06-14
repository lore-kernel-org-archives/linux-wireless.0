Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33007 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab0FNUPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 16:15:06 -0400
Received: by wyb40 with SMTP id 40so4235810wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jun 2010 13:15:04 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/14] rt2x00: clarify meaning of txdone flags
Date: Mon, 14 Jun 2010 22:08:30 +0200
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201006142208.31736.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Update the documentation of the available txdone flags to better express
how they should be used.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.h |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index f791708..55872c4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -213,9 +213,16 @@ struct rxdone_entry_desc {
 /**
  * enum txdone_entry_desc_flags: Flags for &struct txdone_entry_desc
  *
+ * Every txdone report has to contain the basic result of the
+ * transmission, either &TXDONE_UNKNOWN, &TXDONE_SUCCESS or
+ * &TXDONE_FAILURE. The flag &TXDONE_FALLBACK can be used in
+ * conjunction with all of these flags but should only be set
+ * if retires > 0. The flag &TXDONE_EXCESSIVE_RETRY can only be used
+ * in conjunction with &TXDONE_FAILURE.
+ *
  * @TXDONE_UNKNOWN: Hardware could not determine success of transmission.
  * @TXDONE_SUCCESS: Frame was successfully send
- * @TXDONE_FALLBACK: Frame was successfully send using a fallback rate.
+ * @TXDONE_FALLBACK: Hardware used fallback rates for retries
  * @TXDONE_FAILURE: Frame was not successfully send
  * @TXDONE_EXCESSIVE_RETRY: In addition to &TXDONE_FAILURE, the
  *	frame transmission failed due to excessive retries.
-- 
1.6.6.1

