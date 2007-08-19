Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:46211 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbXHSScQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:32:16 -0400
Received: by nf-out-0910.google.com with SMTP id g13so508965nfb
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:32:14 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 25/30] rt2x00: Fix PLCP setup
Date: Sun, 19 Aug 2007 20:35:41 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192035.41296.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From b545a9a3b8ff04a2c6f62923cf01043aeb9ec599 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 16:09:25 +0200
Subject: [PATCH 25/30] rt2x00: Fix PLCP setup

The Length extension bit should only be set when using
the 11Mbs rate and when the residual is <= 3. (value comes
from zd1211rw, ralink legacy driver was unclear)

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   36 +++++++++++++++++-------------
 1 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 36b522b..a0fcd05 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -480,14 +480,15 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 		desc.ifs = IFS_BACKOFF;
 
 	/*
-	 * How the length should be processed depends
-	 * on if we are working with OFDM rates or not.
+	 * PLCP setup
+	 * Length calculation depends on OFDM/CCK rate.
 	 */
+	desc.signal = DEVICE_GET_RATE_FIELD(tx_rate, PLCP);
+	desc.service = 0x04;
+
 	if (test_bit(ENTRY_TXD_OFDM_RATE, &entry->flags)) {
-		residual = 0;
 		desc.length_high = ((length + FCS_LEN) >> 6) & 0x3f;
 		desc.length_low = ((length + FCS_LEN) & 0x3f);
-
 	} else {
 		bitrate = DEVICE_GET_RATE_FIELD(tx_rate, RATE);
 
@@ -497,23 +498,26 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 		residual = get_duration_res(length + FCS_LEN, bitrate);
 		duration = get_duration(length + FCS_LEN, bitrate);
 
-		if (residual != 0)
+		if (residual != 0) {
 			duration++;
 
+			/*
+			 * Check if we need to set the Length Extension
+			 */
+			if (bitrate == 110 && residual <= 3)
+				desc.service |= 0x80;
+		}
+
 		desc.length_high = (duration >> 8) & 0xff;
 		desc.length_low = duration & 0xff;
-	}
 
-	/*
-	 * Create the signal and service values.
-	 */
-	desc.signal = DEVICE_GET_RATE_FIELD(tx_rate, PLCP);
-	if (DEVICE_GET_RATE_FIELD(tx_rate, PREAMBLE))
-		desc.signal |= 0x08;
-
-	desc.service = 0x04;
-	if (residual <= (8 % 11))
-		desc.service |= 0x80;
+		/*
+		 * When preamble is enabled we should set the
+		 * preamble bit for the signal.
+		 */
+		if (DEVICE_GET_RATE_FIELD(tx_rate, PREAMBLE))
+			desc.signal |= 0x08;
+	}
 
 	rt2x00dev->ops->lib->write_tx_desc(rt2x00dev, entry, txd, &desc,
 					   ieee80211hdr, length, control);
-- 
1.5.3.rc5

