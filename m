Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:52796 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab0ADUyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 15:54:43 -0500
Date: Mon, 4 Jan 2010 21:54:41 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 04/14] mwl8k: move struct peer_capability_info to its only user
Message-ID: <20100104205441.GD1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   91 ++++++++++++++++++++----------------------
 1 files changed, 43 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index eb9e71d..9fb62e9 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -598,54 +598,6 @@ static int mwl8k_load_firmware(struct ieee80211_hw *hw)
 }
 
 
-/*
- * Defines shared between transmission and reception.
- */
-/* HT control fields for firmware */
-struct ewc_ht_info {
-	__le16	control1;
-	__le16	control2;
-	__le16	control3;
-} __attribute__((packed));
-
-/* Firmware Station database operations */
-#define MWL8K_STA_DB_ADD_ENTRY		0
-#define MWL8K_STA_DB_MODIFY_ENTRY	1
-#define MWL8K_STA_DB_DEL_ENTRY		2
-#define MWL8K_STA_DB_FLUSH		3
-
-/* Peer Entry flags - used to define the type of the peer node */
-#define MWL8K_PEER_TYPE_ACCESSPOINT	2
-
-struct peer_capability_info {
-	/* Peer type - AP vs. STA.  */
-	__u8	peer_type;
-
-	/* Basic 802.11 capabilities from assoc resp.  */
-	__le16	basic_caps;
-
-	/* Set if peer supports 802.11n high throughput (HT).  */
-	__u8	ht_support;
-
-	/* Valid if HT is supported.  */
-	__le16	ht_caps;
-	__u8	extended_ht_caps;
-	struct ewc_ht_info	ewc_info;
-
-	/* Legacy rate table. Intersection of our rates and peer rates.  */
-	__u8	legacy_rates[12];
-
-	/* HT rate table. Intersection of our rates and peer rates.  */
-	__u8	ht_rates[16];
-	__u8	pad[16];
-
-	/* If set, interoperability mode, no proprietary extensions.  */
-	__u8	interop;
-	__u8	pad2;
-	__u8	station_id;
-	__le16	amsdu_enabled;
-} __attribute__((packed));
-
 /* DMA header used by firmware and hardware.  */
 struct mwl8k_dma_data {
 	__le16 fwlen;
@@ -2630,6 +2582,49 @@ static int mwl8k_cmd_set_rateadapt_mode(struct ieee80211_hw *hw, __u16 mode)
 /*
  * CMD_UPDATE_STADB.
  */
+#define MWL8K_STA_DB_ADD_ENTRY		0
+#define MWL8K_STA_DB_MODIFY_ENTRY	1
+#define MWL8K_STA_DB_DEL_ENTRY		2
+#define MWL8K_STA_DB_FLUSH		3
+
+/* Peer Entry flags - used to define the type of the peer node */
+#define MWL8K_PEER_TYPE_ACCESSPOINT	2
+
+struct ewc_ht_info {
+	__le16	control1;
+	__le16	control2;
+	__le16	control3;
+} __attribute__((packed));
+
+struct peer_capability_info {
+	/* Peer type - AP vs. STA.  */
+	__u8	peer_type;
+
+	/* Basic 802.11 capabilities from assoc resp.  */
+	__le16	basic_caps;
+
+	/* Set if peer supports 802.11n high throughput (HT).  */
+	__u8	ht_support;
+
+	/* Valid if HT is supported.  */
+	__le16	ht_caps;
+	__u8	extended_ht_caps;
+	struct ewc_ht_info	ewc_info;
+
+	/* Legacy rate table. Intersection of our rates and peer rates.  */
+	__u8	legacy_rates[12];
+
+	/* HT rate table. Intersection of our rates and peer rates.  */
+	__u8	ht_rates[16];
+	__u8	pad[16];
+
+	/* If set, interoperability mode, no proprietary extensions.  */
+	__u8	interop;
+	__u8	pad2;
+	__u8	station_id;
+	__le16	amsdu_enabled;
+} __attribute__((packed));
+
 struct mwl8k_cmd_update_stadb {
 	struct mwl8k_cmd_pkt header;
 
-- 
1.5.6.4
