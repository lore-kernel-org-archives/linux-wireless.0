Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:38346 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbXIPMHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 08:07:50 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1643781wah
        for <linux-wireless@vger.kernel.org>; Sun, 16 Sep 2007 05:07:49 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/24] rt2x00: Don't check for IEEE80211_TXCTL_REQ_TX_STATUS
Date: Sun, 16 Sep 2007 14:17:54 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709161403.11332.IvDoorn@gmail.com>
In-Reply-To: <200709161403.11332.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200709161417.55339.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As recommended by Johannes Berg, rt2x00 shouldn't check
for IEEE80211_TXCTL_REQ_TX_STATUS and always pass the frame
back to mac80211.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 8c24797..c4086f0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -333,16 +333,10 @@ void rt2x00lib_txdone(struct data_entry *entry,
 	}
 
 	/*
-	 * Check if mac80211 wants to be updated or not,
-	 * if it wants the update it will cleanup the skb structure,
-	 * else then we should cleanup the skb structure.
+	 * Send the tx_status to mac80211,
+	 * that method also cleans up the skb structure.
 	 */
-	if (tx_status->control.flags & IEEE80211_TXCTL_REQ_TX_STATUS)
-		ieee80211_tx_status_irqsafe(rt2x00dev->hw, entry->skb,
-					    tx_status);
-	else
-		dev_kfree_skb_any(entry->skb);
-
+	ieee80211_tx_status_irqsafe(rt2x00dev->hw, entry->skb, tx_status);
 	entry->skb = NULL;
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_txdone);
-- 
1.5.3
