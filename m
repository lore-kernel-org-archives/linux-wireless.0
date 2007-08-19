Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22855 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616AbXHSSca convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:32:30 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446949ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:32:29 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 28/30] rt2x00: Always check if mac80211 requested TX status update
Date: Sun, 19 Aug 2007 20:36:37 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192036.37330.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From cbf01c4f3f1810f0ba98238aa7900a523a044e66 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 17:43:23 +0200
Subject: [PATCH 28/30] rt2x00: Always check if mac80211 requested TX status update

During txdone always check for the IEEE80211_TXCTL_REQ_TX_STATUS flag
to determine if ieee80211_tx_status_irqsafe should be called or not.
When the flag is not set, just cleanup the skb and don't bother
mac80211 with it.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 14968ef..75888ea 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -333,10 +333,14 @@ void rt2x00lib_txdone(struct data_entry *entry,
 	}
 
 	/*
-	 * Send the tx_status to mac80211,
-	 * that method also cleans up the skb structure.
+	 * Check if mac80211 wants to be updated or not,
+	 * if it wants the update it will cleanup the skb structure,
+	 * else then we should cleanup the skb structure.
 	 */
-	ieee80211_tx_status_irqsafe(rt2x00dev->hw, entry->skb, tx_status);
+	if (tx_status->control.flags & IEEE80211_TXCTL_REQ_TX_STATUS)
+		ieee80211_tx_status_irqsafe(rt2x00dev->hw, entry->skb, tx_status);
+	else
+		dev_kfree_skb_any(entry->skb);
 
 	entry->skb = NULL;
 }
-- 
1.5.3.rc5

