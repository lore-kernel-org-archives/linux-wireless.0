Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:57140 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbZK3RLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:11:12 -0500
Date: Mon, 30 Nov 2009 18:11:18 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 01/12] mwl8k: fix MCS bitmap size in SET_RATE command
Message-ID: <20091130171118.GD20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The MCS bitmaps in the SET_RATE command structure were of the wrong
size, due to use of the wrong define for the array length.  Just
hardcode the lengths as 16, and do the same for the MCS bitmaps in
other command structures.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 9e64dd4..7b136e7 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -634,7 +634,6 @@ struct ewc_ht_info {
 #define MWL8K_PEER_TYPE_ACCESSPOINT	2
 
 #define MWL8K_IEEE_LEGACY_DATA_RATES	13
-#define MWL8K_MCS_BITMAP_SIZE		16
 
 struct peer_capability_info {
 	/* Peer type - AP vs. STA.  */
@@ -655,7 +654,7 @@ struct peer_capability_info {
 	__u8	legacy_rates[MWL8K_IEEE_LEGACY_DATA_RATES];
 
 	/* HT rate table. Intersection of our rates and peer rates.  */
-	__u8	ht_rates[MWL8K_MCS_BITMAP_SIZE];
+	__u8	ht_rates[16];
 	__u8	pad[16];
 
 	/* If set, interoperability mode, no proprietary extensions.  */
@@ -2638,8 +2637,8 @@ struct mwl8k_cmd_update_rateset {
 	__u8	legacy_rates[MWL8K_RATE_INDEX_MAX_ARRAY];
 
 	/* Bitmap for supported MCS codes.  */
-	__u8	mcs_set[MWL8K_IEEE_LEGACY_DATA_RATES];
-	__u8	reserved[MWL8K_IEEE_LEGACY_DATA_RATES];
+	__u8	mcs_set[16];
+	__u8	reserved[16];
 } __attribute__((packed));
 
 static int mwl8k_update_rateset(struct ieee80211_hw *hw,
-- 
1.5.6.4
