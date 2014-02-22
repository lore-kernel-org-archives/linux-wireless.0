Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:46374 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751534AbaBVUga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Feb 2014 15:36:30 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@nbd.name, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 4/6] mac80211: move flag IEEE80211_TX_CTL_MORE_FRAMES into info->control.flags
Date: Sat, 22 Feb 2014 21:36:18 +0100
Message-Id: <1393101380-1646-5-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20140222_213658_857529_E55FD903)
In-Reply-To: <1393101380-1646-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1393101380-1646-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Flag IEEE80211_TX_CTL_MORE_FRAMES is only used within the tx path while
ieee80211_tx_info->control is valid. Therefore this patch moves this flag
from info->flags structure into the info->control.flags and renames it to
IEEE80211_TX_CTRL_MORE_FRAMES.

Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    2 +-
 include/net/mac80211.h                    |   41 +++++++++++++++--------------
 net/mac80211/tx.c                         |    2 +-
 3 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index bed86cc..076d44a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -473,7 +473,7 @@ static void rt2x00queue_create_tx_descriptor(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Check if more frames (!= fragments) are pending
 	 */
-	if (tx_info->flags & IEEE80211_TX_CTL_MORE_FRAMES)
+	if (tx_info->control.flags & IEEE80211_TX_CTRL_MORE_FRAMES)
 		__set_bit(ENTRY_TXD_BURST, &txdesc->flags);
 
 	/*
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 84b9c34..5112a61 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -413,10 +413,6 @@ struct ieee80211_bss_conf {
  *	used to indicate that a frame was already retried due to PS
  * @IEEE80211_TX_INTFL_DONT_ENCRYPT: completely internal to mac80211,
  *	used to indicate frame should not be encrypted
- * @IEEE80211_TX_CTL_MORE_FRAMES: More frames will be passed to the
- *	transmit function after the current frame, this can be used
- *	by drivers to kick the DMA queue only if unset or when the
- *	queue gets full.
  * @IEEE80211_TX_INTFL_RETRANSMISSION: This frame is being retransmitted
  *	after TX status because the destination was asleep, it must not
  *	be modified again (no seqno assignment, crypto, etc.)
@@ -472,22 +468,21 @@ enum mac80211_tx_info_flags {
 	IEEE80211_TX_INTFL_NEED_TXPROCESSING	= BIT(12),
 	IEEE80211_TX_INTFL_RETRIED		= BIT(13),
 	IEEE80211_TX_INTFL_DONT_ENCRYPT		= BIT(14),
-	IEEE80211_TX_CTL_MORE_FRAMES		= BIT(15),
-	IEEE80211_TX_INTFL_RETRANSMISSION	= BIT(16),
-	IEEE80211_TX_INTFL_MLME_CONN_TX		= BIT(17),
-	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(18),
-	IEEE80211_TX_CTL_LDPC			= BIT(19),
-	IEEE80211_TX_CTL_STBC			= BIT(20) | BIT(21),
-	IEEE80211_TX_CTL_TX_OFFCHAN		= BIT(22),
-	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(23),
-	IEEE80211_TX_CTL_NO_CCK_RATE		= BIT(24),
-	IEEE80211_TX_STATUS_EOSP		= BIT(25),
-	IEEE80211_TX_CTL_USE_MINRATE		= BIT(26),
-	IEEE80211_TX_CTL_DONTFRAG		= BIT(27),
-	IEEE80211_TX_CTL_PS_RESPONSE		= BIT(28),
+	IEEE80211_TX_INTFL_RETRANSMISSION	= BIT(15),
+	IEEE80211_TX_INTFL_MLME_CONN_TX		= BIT(16),
+	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(17),
+	IEEE80211_TX_CTL_LDPC			= BIT(18),
+	IEEE80211_TX_CTL_STBC			= BIT(19) | BIT(20),
+	IEEE80211_TX_CTL_TX_OFFCHAN		= BIT(21),
+	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(22),
+	IEEE80211_TX_CTL_NO_CCK_RATE		= BIT(23),
+	IEEE80211_TX_STATUS_EOSP		= BIT(24),
+	IEEE80211_TX_CTL_USE_MINRATE		= BIT(25),
+	IEEE80211_TX_CTL_DONTFRAG		= BIT(26),
+	IEEE80211_TX_CTL_PS_RESPONSE		= BIT(27),
 };
 
-#define IEEE80211_TX_CTL_STBC_SHIFT		20
+#define IEEE80211_TX_CTL_STBC_SHIFT		19
 
 /**
  * enum mac80211_tx_control_flags - flags to describe transmit control
@@ -507,6 +502,11 @@ enum mac80211_tx_info_flags {
  *	802.11-2007 7.1.3.4.1 paragraph 3. This flag will always be set for
  *	beacons and always be clear for frames without a sequence number field.
  *
+ * @IEEE80211_TX_CTRL_MORE_FRAMES: More frames will be passed to the
+ *	transmit function after the current frame, this can be used
+ *	by drivers to kick the DMA queue only if unset or when the
+ *	queue gets full.
+ *
  * These flags are used in tx_info->control.flags.
  */
 enum mac80211_tx_control_flags {
@@ -514,6 +514,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTRL_ASSIGN_SEQ		= BIT(1),
 	IEEE80211_TX_CTRL_FIRST_FRAGMENT        = BIT(3),
 	IEEE80211_TX_CTRL_NO_PS_BUFFER          = BIT(4),
+	IEEE80211_TX_CTRL_MORE_FRAMES           = BIT(5),
 };
 
 /*
@@ -526,7 +527,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_STAT_TX_FILTERED |	IEEE80211_TX_STAT_ACK |		      \
 	IEEE80211_TX_STAT_AMPDU | IEEE80211_TX_STAT_AMPDU_NO_BACK |	      \
 	IEEE80211_TX_CTL_RATE_CTRL_PROBE | IEEE80211_TX_CTL_STBC |	      \
-	IEEE80211_TX_CTL_MORE_FRAMES | IEEE80211_TX_CTL_LDPC)
+	IEEE80211_TX_CTL_LDPC)
 
 /*
  * This definition is used to clear all temporary flags, which are only used
@@ -534,7 +535,7 @@ enum mac80211_tx_control_flags {
  * info->control.flags is used.
  */
 #define IEEE80211_TX_TEMPORARY_CTRL_FLAGS (IEEE80211_TX_CTL_FIRST_FRAGMENT |  \
-	IEEE80211_TX_CTRL_NO_PS_BUFFER)
+	IEEE80211_TX_CTRL_NO_PS_BUFFER | IEEE80211_TX_CTRL_MORE_FRAMES)
 
 /**
  * enum mac80211_rate_control_flags - per-rate flags set by the
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 316b8d3..740eedd 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -861,7 +861,7 @@ static int ieee80211_fragment(struct ieee80211_tx_data *tx,
 		info->control.flags &= ~(IEEE80211_TX_CTRL_FIRST_FRAGMENT);
 
 		if (rem)
-			info->flags |= IEEE80211_TX_CTL_MORE_FRAMES;
+			info->control.flags |= IEEE80211_TX_CTRL_MORE_FRAMES;
 
 		skb_copy_queue_mapping(tmp, skb);
 		tmp->priority = skb->priority;
-- 
1.7.9.5

