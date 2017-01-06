Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48310 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033951AbdAFNKE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 08:10:04 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>
Subject: [PATCH 8/9] rt2x00: do not flush empty queue
Date: Fri,  6 Jan 2017 14:05:17 +0100
Message-Id: <1483707918-31480-9-git-send-email-sgruszka@redhat.com> (sfid-20170106_141131_754421_68121DD6)
In-Reply-To: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
References: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
index 3cc1384..ecc9631 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
@@ -743,7 +743,8 @@ void rt2x00mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		return;
 
 	tx_queue_for_each(rt2x00dev, queue)
-		rt2x00queue_flush_queue(queue, drop);
+		if (!rt2x00queue_empty(queue))
+			rt2x00queue_flush_queue(queue, drop);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_flush);
 
-- 
2.7.4
