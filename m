Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbXHSSar convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:30:47 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446922ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:30:46 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 13/30] rt2x00: rt2x00_ring_free returns invalid length
Date: Sun, 19 Aug 2007 20:26:06 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192026.07053.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 038b4a505c82c91a84caaf7832967ffac2faf93b Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 13:03:32 +0200
Subject: [PATCH 13/30] rt2x00: rt2x00_ring_free returns invalid length

rt2x00_ring_free returned the incorrect number of available
entries because it accidently used ring->stats.len minus
the number of used entries. This always results in 0 available entries,
obviously this in turn would lead to problems regarding the
TX handling.

We can fix and optimize the code quite simply by
doing the limit - length

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00ring.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00ring.h b/drivers/net/wireless/rt2x00ring.h
index 2adc8e5..9c94d06 100644
--- a/drivers/net/wireless/rt2x00ring.h
+++ b/drivers/net/wireless/rt2x00ring.h
@@ -219,9 +219,7 @@ static inline int rt2x00_ring_full(struct data_ring *ring)
 
 static inline int rt2x00_ring_free(struct data_ring *ring)
 {
-	if (ring->index_done >= ring->index)
-		return ring->index_done - ring->index;
-	return ring->stats.len - (ring->index - ring->index_done);
+	return ring->stats.limit - ring->stats.len;
 }
 
 /*
-- 
1.5.3.rc5

