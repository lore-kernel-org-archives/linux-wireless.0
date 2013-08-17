Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:53139 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018Ab3HQR4Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Aug 2013 13:56:25 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 4/6] rt2x00: rt2800lib: add rt2800_hw_beacon_base helper
Date: Sat, 17 Aug 2013 19:56:05 +0200
Message-Id: <1376762167-24583-5-git-send-email-juhosg@openwrt.org> (sfid-20130817_195628_921174_057AD99F)
In-Reply-To: <1376762167-24583-1-git-send-email-juhosg@openwrt.org>
References: <1376762167-24583-1-git-send-email-juhosg@openwrt.org>
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

Te helper function will be extended in a subsequent
patch to handle different chipsets' requirements,
the actual patch contains no functional changes.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index ee7eede..b44eccf 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -948,6 +948,12 @@ void rt2800_txdone_entry(struct queue_entry *entry, u32 status, __le32 *txwi)
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
@@ -1000,7 +1006,7 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 		return;
 	}
 
-	beacon_base = HW_BEACON_BASE(entry->entry_idx);
+	beacon_base = rt2800_hw_beacon_base(rt2x00dev, entry->entry_idx);
 
 	rt2800_shared_mem_lock(rt2x00dev);
 	rt2800_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
@@ -1028,7 +1034,7 @@ static inline void rt2800_clear_beacon_register(struct rt2x00_dev *rt2x00dev,
 	const int txwi_desc_size = rt2x00dev->bcn->winfo_size;
 	unsigned int beacon_base;
 
-	beacon_base = HW_BEACON_BASE(index);
+	beacon_base = rt2800_hw_beacon_base(rt2x00dev, index);
 
 	rt2800_shared_mem_lock(rt2x00dev);
 
-- 
1.7.10
