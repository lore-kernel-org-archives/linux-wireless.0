Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:14625 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbXJ0LZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 07:25:00 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1035411fkz
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2007 04:24:58 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 5/21] rt2x00: Remove rt2x00_clear_link
Date: Sat, 27 Oct 2007 13:37:25 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710271334.34192.IvDoorn@gmail.com>
In-Reply-To: <200710271334.34192.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710271337.25474.IvDoorn@gmail.com> (sfid-20071027_122512_311059_3161E9D0)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00_clear_link() was becoming too large for statically inline,
also it was used on a single location and shouldn't really be
used anywhere else. So move the entire code into the function
rt2x00lib_start_link_tuner()

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |   18 +++---------------
 drivers/net/wireless/rt2x00/rt2x00dev.c |   16 +++++++++++++++-
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index dcf7fd7..acf6f1c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -277,25 +277,13 @@ struct link {
 };
 
 /*
- * Clear all counters inside the link structure.
- */
-static inline void rt2x00_clear_link(struct link *link)
-{
-	link->count = 0;
-	memset(&link->qual, 0, sizeof(link->qual));
-	link->qual.rx_percentage = 50;
-	link->qual.tx_percentage = 50;
-}
-
-/*
  * Update the rssi using the walking average approach.
  */
 static inline void rt2x00_update_link_rssi(struct link *link, int rssi)
 {
-	if (!link->qual.avg_rssi)
-		link->qual.avg_rssi = rssi;
-	else
-		link->qual.avg_rssi = ((link->qual.avg_rssi * 7) + rssi) / 8;
+	if (link->qual.avg_rssi)
+		rssi = ((link->qual.avg_rssi * 7) + rssi) / 8;
+	link->qual.avg_rssi = rssi;
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index b2016f4..0f824b2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -67,7 +67,21 @@ EXPORT_SYMBOL_GPL(rt2x00lib_get_ring);
  */
 static void rt2x00lib_start_link_tuner(struct rt2x00_dev *rt2x00dev)
 {
-	rt2x00_clear_link(&rt2x00dev->link);
+	rt2x00dev->link.count = 0;
+	rt2x00dev->link.vgc_level = 0;
+
+	memset(&rt2x00dev->link.qual, 0, sizeof(rt2x00dev->link.qual));
+
+	/*
+	 * The RX and TX percentage should start at 50%
+	 * this will assure we will get at least get some
+	 * decent value when the link tuner starts.
+	 * The value will be dropped and overwritten with
+	 * the correct (measured )value anyway during the
+	 * first run of the link tuner.
+	 */
+	rt2x00dev->link.qual.rx_percentage = 50;
+	rt2x00dev->link.qual.tx_percentage = 50;
 
 	/*
 	 * Reset the link tuner.
-- 
1.5.3.4

