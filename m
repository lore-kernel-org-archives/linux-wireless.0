Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44494 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab1D0TPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 15:15:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Nishant Sarmukadam <nishants@marvell.com>,
	Pradeep Nemavat <pnemavat@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [RFT/PATCH] mwl8k: replace rateinfo bitfields with mask and shift macros
Date: Wed, 27 Apr 2011 15:04:28 -0400
Message-Id: <1303931068-5922-1-git-send-email-linville@tuxdriver.com> (sfid-20110427_211552_389930_EDE79A20)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AFAICT, this driver is claiming that 24 bits of rate info fit into a
16-bit field in the Tx descriptor.  Anyway, the use of bitfields is
frowned-upon for a variety of well-documented reasons...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
These masks could be backwards -- someone with the hardware please let
me know if that is the case or if this version works?

 drivers/net/wireless/mwl8k.c |   25 +++++--------------------
 1 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index b8f2b12..8a1b262 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1562,24 +1562,11 @@ static int mwl8k_tid_queue_mapping(u8 tid)
 
 /* The firmware will fill in the rate information
  * for each packet that gets queued in the hardware
- * in this structure
+ * and these macros will interpret that info.
  */
 
-struct rateinfo {
-	__le16  format:1;
-	__le16  short_gi:1;
-	__le16  band_width:1;
-	__le16  rate_id_mcs:6;
-	__le16  adv_coding:2;
-	__le16  antenna:2;
-	__le16  act_sub_chan:2;
-	__le16  preamble_type:1;
-	__le16  power_id:4;
-	__le16  antenna2:1;
-	__le16  reserved:1;
-	__le16  tx_bf_frame:1;
-	__le16  green_field:1;
-} __packed;
+#define RI_FORMAT(a)		  (a & 0x0001)
+#define RI_RATE_ID_MCS(a)	 ((a & 0x01f8) >> 3)
 
 static int
 mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int limit, int force)
@@ -1600,7 +1587,6 @@ mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int limit, int force)
 		struct ieee80211_sta *sta;
 		struct mwl8k_sta *sta_info = NULL;
 		u16 rate_info;
-		struct rateinfo *rate;
 		struct ieee80211_hdr *wh;
 
 		tx = txq->head;
@@ -1643,14 +1629,13 @@ mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int limit, int force)
 				sta_info = MWL8K_STA(sta);
 				BUG_ON(sta_info == NULL);
 				rate_info = le16_to_cpu(tx_desc->rate_info);
-				rate = (struct rateinfo *)&rate_info;
 				/* If rate is < 6.5 Mpbs for an ht station
 				 * do not form an ampdu. If the station is a
 				 * legacy station (format = 0), do not form an
 				 * ampdu
 				 */
-				if (rate->rate_id_mcs < 1 ||
-				    rate->format == 0) {
+				if (RI_RATE_ID_MCS(rate_info) < 1 ||
+				    RI_FORMAT(rate_info) == 0) {
 					sta_info->is_ampdu_allowed = false;
 				} else {
 					sta_info->is_ampdu_allowed = true;
-- 
1.7.4.4

