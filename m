Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail0.scram.de ([78.47.204.202]:54101 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbYHHPox (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2008 11:44:53 -0400
Message-ID: <489C65B7.9020305@scram.de> (sfid-20080808_174457_545112_1B447A37)
Date: Fri, 08 Aug 2008 17:26:47 +0200
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: [PATCH] rt2x00: Fix txdone_entry_desc_flags
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

txdone_entry_desc_flags is used with __set_bit and test_bit which
bit-shift the values, so don't bit-shift the flags in the enum.
Also make sure flags are initialized before being used.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 drivers/net/wireless/rt2x00/rt2x00queue.h |    8 ++++----
 drivers/net/wireless/rt2x00/rt2x00usb.c   |    1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 01a6567..37f3f98 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -191,10 +191,10 @@ struct rxdone_entry_desc {
  *	frame transmission failed due to excessive retries.
  */
 enum txdone_entry_desc_flags {
-	TXDONE_UNKNOWN = 1 << 0,
-	TXDONE_SUCCESS = 1 << 1,
-	TXDONE_FAILURE = 1 << 2,
-	TXDONE_EXCESSIVE_RETRY = 1 << 3,
+	TXDONE_UNKNOWN,
+	TXDONE_SUCCESS,
+	TXDONE_FAILURE,
+	TXDONE_EXCESSIVE_RETRY,
 };

 /**
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 8d76bb2..2050227 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -181,6 +181,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	 * (Only indirectly by looking at the failed TX counters
 	 * in the register).
 	 */
+	txdesc.flags = 0;
 	if (!urb->status)
 		__set_bit(TXDONE_UNKNOWN, &txdesc.flags);
 	else
-- 
1.5.6.3

