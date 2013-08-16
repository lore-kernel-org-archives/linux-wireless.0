Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:51248 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab3HPWPy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 18:15:54 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/2] rt2x00: rt2800: rename HW_BEACON_OFFSET macro
Date: Sat, 17 Aug 2013 00:15:49 +0200
Message-Id: <1376691350-19851-1-git-send-email-juhosg@openwrt.org> (sfid-20130817_001601_126322_BA47CAEA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The name of the HW_BEACON_OFFSET macro is a
bit confusing. It returns with one of the
HW_BEACON_BASE* values, so rename the macro
to HW_BEACON_BASE to reflect that.

The patch contains no functional changes.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    2 +-
 drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index a313241..6e69b96 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2019,7 +2019,7 @@ struct mac_iveiv_entry {
 #define HW_BEACON_BASE6			0x5dc0
 #define HW_BEACON_BASE7			0x5bc0
 
-#define HW_BEACON_OFFSET(__index) \
+#define HW_BEACON_BASE(__index) \
 	(((__index) < 4) ? (HW_BEACON_BASE0 + (__index * 0x0200)) : \
 	  (((__index) < 6) ? (HW_BEACON_BASE4 + ((__index - 4) * 0x0200)) : \
 	  (HW_BEACON_BASE6 - ((__index - 6) * 0x0200))))
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index fb71ed6..a25862a 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -992,7 +992,7 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 		return;
 	}
 
-	beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
+	beacon_base = HW_BEACON_BASE(entry->entry_idx);
 	rt2800_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
 				   entry->skb->len + padding_len);
 
@@ -1042,7 +1042,7 @@ void rt2800_clear_beacon(struct queue_entry *entry)
 	 * Clear beacon.
 	 */
 	rt2800_clear_beacon_register(rt2x00dev,
-				     HW_BEACON_OFFSET(entry->entry_idx));
+				     HW_BEACON_BASE(entry->entry_idx));
 
 	/*
 	 * Enabled beaconing again.
-- 
1.7.10
