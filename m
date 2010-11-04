Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59008 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab0KDTnp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 15:43:45 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so1320245eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 12:43:45 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 05/13] rt2x00: Add unlikely to skb allocation failure check
Date: Thu, 4 Nov 2010 20:38:35 +0100
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
References: <201011042037.00178.IvDoorn@gmail.com> <201011042037.47939.IvDoorn@gmail.com> <201011042038.16312.IvDoorn@gmail.com>
In-Reply-To: <201011042038.16312.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011042038.35919.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

The skb allocation should really only fail under high memory pressure
or other uncommon situations. Hence, mark the allocation failure check
as unlikely.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 5ba79b9..a5c7a4f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -491,7 +491,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry)
 	 * received frame and reuse the existing buffer.
 	 */
 	skb = rt2x00queue_alloc_rxskb(entry);
-	if (!skb)
+	if (unlikely(!skb))
 		goto submit_entry;
 
 	/*
-- 
1.7.2.3

