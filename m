Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42289 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932709Ab1ERS0o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 14:26:44 -0400
Received: by eyx24 with SMTP id 24so530032eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 11:26:43 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/7] rt2x00: Interface sequence lock doesn't have to disable interrupts.
Date: Wed, 18 May 2011 20:25:42 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201105182022.20341.IvDoorn@gmail.com> <201105182022.40563.IvDoorn@gmail.com> <201105182023.04837.IvDoorn@gmail.com>
In-Reply-To: <201105182023.04837.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <201105182025.42692.IvDoorn@gmail.com> (sfid-20110518_202647_425202_2B3826B8)
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

This lock is only used in the TX path and thus in process context. Therefore
we can use a much lighter spinlock variant.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 56f9d0d..f1e1381 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -206,7 +206,6 @@ static void rt2x00queue_create_tx_descriptor_seq(struct queue_entry *entry,
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)entry->skb->data;
 	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
-	unsigned long irqflags;
 
 	if (!(tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ))
 		return;
@@ -227,14 +226,14 @@ static void rt2x00queue_create_tx_descriptor_seq(struct queue_entry *entry,
 	 * sequence counting per-frame, since those will override the
 	 * sequence counter given by mac80211.
 	 */
-	spin_lock_irqsave(&intf->seqlock, irqflags);
+	spin_lock(&intf->seqlock);
 
 	if (test_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags))
 		intf->seqno += 0x10;
 	hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
 	hdr->seq_ctrl |= cpu_to_le16(intf->seqno);
 
-	spin_unlock_irqrestore(&intf->seqlock, irqflags);
+	spin_unlock(&intf->seqlock);
 
 }
 
-- 
1.7.2.3

