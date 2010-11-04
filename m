Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59008 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab0KDTnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 15:43:47 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so1320245eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 12:43:46 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 06/13] rt2x00: Optimize rt2x00debug_dump_frame when frame dumping is not active
Date: Thu, 4 Nov 2010 20:38:56 +0100
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
References: <201011042037.00178.IvDoorn@gmail.com> <201011042038.16312.IvDoorn@gmail.com> <201011042038.35919.IvDoorn@gmail.com>
In-Reply-To: <201011042038.35919.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011042038.57061.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

When rt2x00 is compiled with debugging but frame dumping is currently
not active we can avoid the call to do_gettimeofday. Furthermore,
frame dumping is not the default case, mark it as unlikely.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00debug.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index fcdb6b0..8296a9d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -162,11 +162,11 @@ void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
 	struct timeval timestamp;
 	u32 data_len;
 
-	do_gettimeofday(&timestamp);
-
-	if (!test_bit(FRAME_DUMP_FILE_OPEN, &intf->frame_dump_flags))
+	if (likely(!test_bit(FRAME_DUMP_FILE_OPEN, &intf->frame_dump_flags)))
 		return;
 
+	do_gettimeofday(&timestamp);
+
 	if (skb_queue_len(&intf->frame_dump_skbqueue) > 20) {
 		DEBUG(rt2x00dev, "txrx dump queue length exceeded.\n");
 		return;
-- 
1.7.2.3

