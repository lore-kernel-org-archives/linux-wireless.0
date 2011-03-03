Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35605 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758687Ab1CCSs1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 13:48:27 -0500
Received: by mail-wy0-f174.google.com with SMTP id 36so1356532wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 10:48:27 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 05/19] rt2x00: Use unlikely for unexpected error condition in rt2x00_mac_tx
Date: Thu, 3 Mar 2011 19:41:03 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103031938.56423.IvDoorn@gmail.com> <201103031939.57117.IvDoorn@gmail.com> <201103031940.34167.IvDoorn@gmail.com>
In-Reply-To: <201103031940.34167.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103031941.04133.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

rt2x00queue_write_tx_frame is unlikely to fail. Tell the compiler.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 6715b77..9529d6f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -149,7 +149,7 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 			goto exit_fail;
 	}
 
-	if (rt2x00queue_write_tx_frame(queue, skb, false))
+	if (unlikely(rt2x00queue_write_tx_frame(queue, skb, false)))
 		goto exit_fail;
 
 	if (rt2x00queue_threshold(queue))
-- 
1.7.2.3

