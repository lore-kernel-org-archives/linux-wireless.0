Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:34119 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbYLTKCT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 05:02:19 -0500
Received: by mail-ew0-f17.google.com with SMTP id 10so1457128ewy.13
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2008 02:02:18 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 13/15] rt2x00: Introduce RXDONE_SIGNAL_MASK mask
Date: Sat, 20 Dec 2008 10:59:55 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200812201052.00655.IvDoorn@gmail.com> <200812201059.02959.IvDoorn@gmail.com> <200812201059.30095.IvDoorn@gmail.com>
In-Reply-To: <200812201059.30095.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812201059.55767.IvDoorn@gmail.com> (sfid-20081220_110905_312311_11A785C6)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Improve error message reporting when a frame was received
with unknown rate. Instead of using the boolean check if
the frame is supposed to be a PLCP value or not, we should
add a new mask (RXDONE_SIGNAL_MASK) which returns the type
identification for a signal value (i.e. PLCP). At the moment
we only have 2 different types, but more will arrive when
support for 11n is added.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00queue.h |    8 ++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 841879d..ab8aa97 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -392,8 +392,8 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 
 	if (idx < 0) {
 		WARNING(rt2x00dev, "Frame received with unrecognized signal,"
-			"signal=0x%.2x, plcp=%d.\n", rxdesc.signal,
-			!!(rxdesc.dev_flags & RXDONE_SIGNAL_PLCP));
+			"signal=0x%.2x, type=%d.\n", rxdesc.signal,
+			(rxdesc.dev_flags & RXDONE_SIGNAL_MASK));
 		idx = 0;
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 1bd1a95..98209d2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -158,6 +158,14 @@ enum rxdone_entry_desc_flags {
 };
 
 /**
+ * RXDONE_SIGNAL_MASK - Define to mask off all &rxdone_entry_desc_flags flags
+ * except for the RXDONE_SIGNAL_* flags. This is useful to convert the dev_flags
+ * from &rxdone_entry_desc to a signal value type.
+ */
+#define RXDONE_SIGNAL_MASK \
+       ( RXDONE_SIGNAL_PLCP | RXDONE_SIGNAL_BITRATE )
+
+/**
  * struct rxdone_entry_desc: RX Entry descriptor
  *
  * Summary of information that has been read from the RX frame descriptor.
-- 
1.5.6.1

