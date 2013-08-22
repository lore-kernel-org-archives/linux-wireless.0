Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37610 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab3HVSxd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Aug 2013 14:53:33 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3 1/2] rt2x00: rt2800lib: add rt2800_hw_beacon_base helper
Date: Thu, 22 Aug 2013 20:53:21 +0200
Message-Id: <1377197602-5567-1-git-send-email-juhosg@openwrt.org> (sfid-20130822_205345_713550_09680645)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The HW_BEACON_BASE() macro returns the base address
of a given beacon, however the returned values are
not usable on all chipsets. On devices which have
selectable shared memory parts, some beacon may be
located in the high part of the shared memory.

Instead of extending the already complicated macro,
add a new helper function and use that to get the
base address of a given beacon.

The actual patch contains no functional changes, the
helper function will be extended in a further patch
to handle different chipsets' requirements.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
Changes since v2:
  - separated from the 'rt2x00: fix beaconing on RT3593' patch-set
  - update commit log

Changes since v1: ---
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index aa6b6b0..38606e2 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -940,6 +940,12 @@ void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi)
 }
 EXPORT_SYMBOL_GPL(rt2800_txdone_entry);
 
+static unsigned int rt2800_hw_beacon_base(struct rt2x00_dev *rt2x00dev,
+					  unsigned int index)
+{
+	return HW_BEACON_BASE(index);
+}
+
 void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
@@ -992,7 +998,8 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 		return;
 	}
 
-	beacon_base = HW_BEACON_BASE(entry->entry_idx);
+	beacon_base = rt2800_hw_beacon_base(rt2x00dev, entry->entry_idx);
+
 	rt2800_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
 				   entry->skb->len + padding_len);
 
@@ -1017,7 +1024,7 @@ static inline void rt2800_clear_beacon_register(struct rt2x00_dev *rt2x00dev,
 	const int txwi_desc_size = rt2x00dev->bcn->winfo_size;
 	unsigned int beacon_base;
 
-	beacon_base = HW_BEACON_BASE(index);
+	beacon_base = rt2800_hw_beacon_base(rt2x00dev, index);
 
 	/*
 	 * For the Beacon base registers we only need to clear
-- 
1.7.10
