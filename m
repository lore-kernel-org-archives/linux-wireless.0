Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35260 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbYDBJFR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 05:05:17 -0400
Subject: RE: "Try to stop Tx aggregation on non active TID" messages
From: Johannes Berg <johannes@sipsolutions.net>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <D936D925018D154694D8A362EEB08920040FA21F@orsmsx416.amr.corp.intel.com>
References: <1206568750.22530.8.camel@johannes.berg>
	 <c85cb4470803280145j42bcf1b5kfcfd220b5b6cf76a@mail.gmail.com>
	 <c85cb4470803300456y75ced072ue89ea3f2dbbdce8b@mail.gmail.com>
	 (sfid-20080330_125632_683065_10482C70) <1206964750.5468.9.camel@johannes.berg>
	 <D936D925018D154694D8A362EEB08920040FA21F@orsmsx416.amr.corp.intel.com>
Content-Type: text/plain
Date: Tue, 01 Apr 2008 17:51:47 +0200
Message-Id: <1207065107.5143.117.camel@johannes.berg> (sfid-20080402_100532_237358_1F8204F7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > [1] as, incidentally, you can see in the current wireless tree from a
> > few days ago, iwlwifi with debugging doesn't even compile!
> 
> Could you please send the errors you see? The debug flags recently
> changed, so the following is needed:

It seems that this was before I updated to after the debug flags change,
everything seems fine now.

Unrelated, but while I was at it, I get a whole bunch of warnings that
are fixed by the patch below.

johannes

From: Johannes Berg <johannes@sipsolutions.net>
Subject: iwlwifi: fix warnings

This fixes all kinds of warnings in iwlwifi.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 6 files changed, 13 insertions(+), 13 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-4965.c	2008-04-01 17:38:21.311669543 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-4965.c	2008-04-01 17:43:17.931669482 +0200
@@ -3297,7 +3297,7 @@ static void iwl4965_add_radiotap(struct 
 	s8 noise = 0;
 	int rate = stats->rate_idx;
 	u64 tsf = stats->mactime;
-	__le16 phy_flags_hw = rx_start->phy_flags;
+	__le16 phy_flags_hw = rx_start->phy_flags, antenna;
 	struct iwl4965_rt_rx_hdr {
 		struct ieee80211_radiotap_header rt_hdr;
 		__le64 rt_tsf;		/* TSF */
@@ -3381,8 +3381,8 @@ static void iwl4965_add_radiotap(struct 
 	 * new 802.11n radiotap field "RX chains" that is defined
 	 * as a bitmask.
 	 */
-	iwl4965_rt->rt_antenna =
-		le16_to_cpu(phy_flags_hw & RX_RES_PHY_FLAGS_ANTENNA_MSK) >> 4;
+	antenna = phy_flags_hw & RX_RES_PHY_FLAGS_ANTENNA_MSK;
+	iwl4965_rt->rt_antenna = le16_to_cpu(antenna) >> 4;
 
 	/* set the preamble flag if appropriate */
 	if (phy_flags_hw & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
@@ -3972,7 +3972,7 @@ static void iwl4965_rx_reply_rx(struct i
 
 	IWL_DEBUG_STATS_LIMIT("Rssi %d, noise %d, qual %d, TSF %llu\n",
 			      rx_status.ssi, rx_status.noise, rx_status.signal,
-			      rx_status.mactime);
+			      (unsigned long long)rx_status.mactime);
 
 	network_packet = iwl4965_is_network_packet(priv, header);
 	if (network_packet) {
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-4965.h	2008-04-01 17:36:10.893796252 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-4965.h	2008-04-01 17:44:02.702794566 +0200
@@ -293,8 +293,8 @@ struct iwl4965_frame {
 
 #define SEQ_TO_QUEUE(x)  ((x >> 8) & 0xbf)
 #define QUEUE_TO_SEQ(x)  ((x & 0xbf) << 8)
-#define SEQ_TO_INDEX(x) (x & 0xff)
-#define INDEX_TO_SEQ(x) (x & 0xff)
+#define SEQ_TO_INDEX(x) ((u8)(x & 0xff))
+#define INDEX_TO_SEQ(x) ((u8)(x & 0xff))
 #define SEQ_HUGE_FRAME  (0x4000)
 #define SEQ_RX_FRAME    __constant_cpu_to_le16(0x8000)
 #define SEQ_TO_SN(seq) (((seq) & IEEE80211_SCTL_SEQ) >> 4)
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-3945.c	2008-04-01 17:42:39.875671121 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-3945.c	2008-04-01 17:42:55.953764661 +0200
@@ -524,7 +524,7 @@ static void iwl3945_add_radiotap(struct 
 	s8 noise = 0;
 	int rate = stats->rate_idx;
 	u64 tsf = stats->mactime;
-	__le16 phy_flags_hw = rx_hdr->phy_flags;
+	__le16 phy_flags_hw = rx_hdr->phy_flags, antenna;
 
 	struct iwl3945_rt_rx_hdr {
 		struct ieee80211_radiotap_header rt_hdr;
@@ -596,8 +596,8 @@ static void iwl3945_add_radiotap(struct 
 		iwl3945_rt->rt_rate = iwl3945_rates[rate].ieee;
 
 	/* antenna number */
-	iwl3945_rt->rt_antenna =
-		le16_to_cpu(phy_flags_hw & RX_RES_PHY_FLAGS_ANTENNA_MSK) >> 4;
+	antenna = phy_flags_hw & RX_RES_PHY_FLAGS_ANTENNA_MSK;
+	iwl3945_rt->rt_antenna = le16_to_cpu(antenna) >> 4;
 
 	/* set the preamble flag if we have it */
 	if (phy_flags_hw & RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK)
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-3945.h	2008-04-01 17:42:17.083795908 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-3945.h	2008-04-01 17:44:02.701795986 +0200
@@ -280,8 +280,8 @@ struct iwl3945_frame {
 
 #define SEQ_TO_QUEUE(x)  ((x >> 8) & 0xbf)
 #define QUEUE_TO_SEQ(x)  ((x & 0xbf) << 8)
-#define SEQ_TO_INDEX(x) (x & 0xff)
-#define INDEX_TO_SEQ(x) (x & 0xff)
+#define SEQ_TO_INDEX(x) ((u8)(x & 0xff))
+#define INDEX_TO_SEQ(x) ((u8)(x & 0xff))
 #define SEQ_HUGE_FRAME  (0x4000)
 #define SEQ_RX_FRAME    __constant_cpu_to_le16(0x8000)
 #define SEQ_TO_SN(seq) (((seq) & IEEE80211_SCTL_SEQ) >> 4)
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-debugfs.c	2008-04-01 17:43:44.900670090 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-debugfs.c	2008-04-01 17:43:55.875048052 +0200
@@ -243,7 +243,7 @@ static ssize_t iwl_dbgfs_stations_read(s
 						station->tid[j].agg.wait_for_ba);
 				pos += sprintf(buf+pos, "%u\t%llu\t%u\n",
 						station->tid[j].agg.start_idx,
-						station->tid[j].agg.bitmap,
+						(unsigned long long)station->tid[j].agg.bitmap,
 						station->tid[j].agg.rate_n_flags);
 			}
 			pos += sprintf(buf+pos, "\n");
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-04-01 17:43:25.884921531 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-04-01 17:43:33.955669481 +0200
@@ -3111,7 +3111,7 @@ static int iwl4965_tx_status_reply_tx(st
 		agg->rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
 		IWL_DEBUG_TX_REPLY("Frames %d start_idx=%d bitmap=0x%llx\n",
 				   agg->frame_count, agg->start_idx,
-				   agg->bitmap);
+				   (unsigned long long)agg->bitmap);
 
 		if (bitmap)
 			agg->wait_for_ba = 1;


