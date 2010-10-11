Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62576 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab0JKNke (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 09:40:34 -0400
Received: by mail-ew0-f46.google.com with SMTP id 20so574157ewy.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Oct 2010 06:40:33 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/7] rt2x00: Fix dead queue when skb allocation failed
Date: Mon, 11 Oct 2010 15:38:26 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201010111537.26584.IvDoorn@gmail.com> <201010111537.48587.IvDoorn@gmail.com> <201010111538.08677.IvDoorn@gmail.com>
In-Reply-To: <201010111538.08677.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010111538.27633.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the RX skb allocation failed, we should recycle
the previously allocated skbuffer. By calling return
we would kill the RX queue completely since the
entry would be invalidated.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index db25209..e5e8ba3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -491,7 +491,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry)
 	 */
 	skb = rt2x00queue_alloc_rxskb(entry);
 	if (!skb)
-		return;
+		goto submit_entry;
 
 	/*
 	 * Unmap the skb.
-- 
1.7.2.3

