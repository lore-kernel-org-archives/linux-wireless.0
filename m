Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:54766 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729AbXGYUsa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 16:48:30 -0400
Received: by ug-out-1314.google.com with SMTP id j3so420027ugf
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jul 2007 13:48:29 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/11] rt2x00: Use rts_cts_rate for CTS frames
Date: Wed, 25 Jul 2007 22:50:01 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707252250.02048.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 5588e3ac82b678e07bb22be113b98469b4f62de9 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Fri, 20 Jul 2007 23:24:08 +0200
Subject: [PATCH 02/11] rt2x00: Use rts_cts_rate for CTS frames

The rts_cts_rate should be used for
outgoing CTS frames.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c b/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
index 0e7f0d2..375645a 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
@@ -905,10 +905,11 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	tx_rate = control->tx_rate;
 
 	/*
-	 * Check if this is a rts frame
+	 * Check if this is a RTS/CTS frame
 	 */
-	if (is_rts_frame(frame_control)) {
-		__set_bit(ENTRY_TXD_RTS_FRAME, &entry->flags);
+	if (is_rts_frame(frame_control) || is_cts_frame(frame_control)) {
+		if (is_rts_frame(frame_control))
+			__set_bit(ENTRY_TXD_RTS_FRAME, &entry->flags);
 		if (control->rts_cts_rate)
 			tx_rate = control->rts_cts_rate;
 	}
-- 
1.5.2.2

