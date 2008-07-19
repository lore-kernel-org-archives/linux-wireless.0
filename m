Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:14440 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbYGSODQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 10:03:16 -0400
Received: by nf-out-0910.google.com with SMTP id d3so250603nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2008 07:03:15 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 1/5] rt2x00: Remove duplicate declaration
Date: Sat, 19 Jul 2008 16:15:42 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807191615.22752.IvDoorn@gmail.com>
In-Reply-To: <200807191615.22752.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807191615.42755.IvDoorn@gmail.com> (sfid-20080719_160321_382046_EFE770CC)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00queue_free_skb() was declared twice.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00lib.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index f2c9b0e..c5fb3a7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -125,13 +125,6 @@ void rt2x00queue_unmap_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
 void rt2x00queue_free_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
 
 /**
- * rt2x00queue_free_skb - free a skb
- * @rt2x00dev: Pointer to &struct rt2x00_dev.
- * @skb: The skb to free.
- */
-void rt2x00queue_free_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb);
-
-/**
  * rt2x00queue_write_tx_frame - Write TX frame to hardware
  * @queue: Queue over which the frame should be send
  * @skb: The skb to send
-- 
1.5.6.1

