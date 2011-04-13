Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60423 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758373Ab1DMT4z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 15:56:55 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH 2/5] ath: unshare struct ath_bus_ops between ath5k and ath9k
Date: Wed, 13 Apr 2011 21:56:43 +0200
Message-Id: <1302724606-10190-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1302724606-10190-1-git-send-email-nbd@openwrt.org>
References: <1302724606-10190-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This struct is not used in any common code, and moving it out of
the ath header makes it easier to add more driver specific ops.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath.h         |    9 +--------
 drivers/net/wireless/ath/ath5k/ath5k.h |    6 ++++++
 drivers/net/wireless/ath/ath9k/hw.h    |    8 ++++++++
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 6d7105b..7cf4317 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -123,14 +123,7 @@ struct ath_ops {
 };
 
 struct ath_common;
-
-struct ath_bus_ops {
-	enum ath_bus_type ath_bus_type;
-	void (*read_cachesize)(struct ath_common *common, int *csz);
-	bool (*eeprom_read)(struct ath_common *common, u32 off, u16 *data);
-	void (*bt_coex_prep)(struct ath_common *common);
-	void (*extn_synch_en)(struct ath_common *common);
-};
+struct ath_bus_ops;
 
 struct ath_common {
 	void *ah;
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index e303db7..266e548 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1155,6 +1155,12 @@ struct ath5k_hw {
 		struct ath5k_rx_status *);
 };
 
+struct ath_bus_ops {
+	enum ath_bus_type ath_bus_type;
+	void (*read_cachesize)(struct ath_common *common, int *csz);
+	bool (*eeprom_read)(struct ath_common *common, u32 off, u16 *data);
+};
+
 /*
  * Prototypes
  */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index a778b66..073bc9e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -846,6 +846,14 @@ struct ath_hw {
 	u32 ent_mode;
 };
 
+struct ath_bus_ops {
+	enum ath_bus_type ath_bus_type;
+	void (*read_cachesize)(struct ath_common *common, int *csz);
+	bool (*eeprom_read)(struct ath_common *common, u32 off, u16 *data);
+	void (*bt_coex_prep)(struct ath_common *common);
+	void (*extn_synch_en)(struct ath_common *common);
+};
+
 static inline struct ath_common *ath9k_hw_common(struct ath_hw *ah)
 {
 	return &ah->common;
-- 
1.7.3.2

