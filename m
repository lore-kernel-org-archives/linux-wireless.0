Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.178]:40650 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbYG1IB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 04:01:27 -0400
Received: by ik-out-1112.google.com with SMTP id c28so4022156ika.5
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 01:01:26 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 2/2] rt2x00: Sequence counter should be protected in irqsave
Date: Mon, 28 Jul 2008 10:21:16 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807281020.13080.IvDoorn@gmail.com>
In-Reply-To: <200807281020.13080.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807281021.16861.IvDoorn@gmail.com> (sfid-20080728_100130_586220_3742942E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The sequence counter can be accessed in IRQ context,
which means the lock protecting the counter should
be irqsave. To prevent making the entire intf->lock irqsave
without reason, create a new lock which only protects
the sequence counter.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
John. Please queue for 2.6.27. This fixes deplock warnings
under some circumstances when the interface is up.

 drivers/net/wireless/rt2x00/rt2x00.h      |    6 ++++++
 drivers/net/wireless/rt2x00/rt2x00mac.c   |    1 +
 drivers/net/wireless/rt2x00/rt2x00queue.c |    5 +++--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 37c9968..3952d2d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -368,6 +368,12 @@ struct rt2x00_intf {
 #define DELAYED_CONFIG_ERP		0x00000002
 #define DELAYED_LED_ASSOC		0x00000004
 
+	/*
+	 * Software sequence counter, this is only required
+	 * for hardware which doesn't support hardware
+	 * sequence counting.
+	 */
+	spinlock_t seqlock;
 	u16 seqno;
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index f7fd995..d1fe91a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -247,6 +247,7 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 		rt2x00dev->intf_sta_count++;
 
 	spin_lock_init(&intf->lock);
+	spin_lock_init(&intf->seqlock);
 	intf->beacon = entry;
 
 	if (conf->type == IEEE80211_IF_TYPE_AP)
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 3b27f6a..898cdd7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -128,6 +128,7 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	unsigned int data_length;
 	unsigned int duration;
 	unsigned int residual;
+	unsigned long irqflags;
 
 	memset(txdesc, 0, sizeof(*txdesc));
 
@@ -213,14 +214,14 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	 * sequence counter given by mac80211.
 	 */
 	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
-		spin_lock(&intf->lock);
+		spin_lock_irqsave(&intf->seqlock, irqflags);
 
 		if (test_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags))
 			intf->seqno += 0x10;
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
 		hdr->seq_ctrl |= cpu_to_le16(intf->seqno);
 
-		spin_unlock(&intf->lock);
+		spin_unlock_irqrestore(&intf->seqlock, irqflags);
 
 		__set_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags);
 	}
-- 
1.5.6.1

