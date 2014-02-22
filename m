Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:46372 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751586AbaBVUga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Feb 2014 15:36:30 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@nbd.name, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 2/6] mac80211: move flag IEEE80211_TX_CTL_FIRST_FRAGMENT into info->control.flags
Date: Sat, 22 Feb 2014 21:36:16 +0100
Message-Id: <1393101380-1646-3-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20140222_213703_018192_A58D7B33)
In-Reply-To: <1393101380-1646-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1393101380-1646-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Flag IEEE80211_TX_CTL_MORE_FRAMES is only used within the tx path while
ieee80211_tx_info->control is valid. Therefore this patch moves this flag
from info->flags structure into the info->control.flags and renames it to
IEEE80211_TX_CTRL_FIRST_FRAGMENT. Define new IEEE80211_TX_TEMPORARY_CTRL_FLAGS
to clear all temporary flags that are shifted to info->control.flags.

Signed-off-by: Benjamin Vahl <bvahl@net.t-labs.tu-berlin.de>
Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 drivers/net/wireless/ath/ath10k/mac.h          |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c          |    2 +-
 drivers/net/wireless/b43/xmit.c                |    2 +-
 drivers/net/wireless/b43legacy/xmit.c          |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c      |    6 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c     |    2 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c     |    2 +-
 drivers/net/wireless/zd1211rw/zd_mac.c         |    2 +-
 include/net/mac80211.h                         |   71 +++++++++++++-----------
 net/mac80211/status.c                          |    1 +
 net/mac80211/tx.c                              |   12 ++--
 12 files changed, 57 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index c0ad9c6..7d3b3b7 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -54,7 +54,7 @@ static inline void ath10k_tx_h_seq_no(struct sk_buff *skb)
 		if (arvif->tx_seq_no == 0)
 			arvif->tx_seq_no = 0x1000;
 
-		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+		if (info->control.flags & IEEE80211_TX_CTRL_FIRST_FRAGMENT)
 			arvif->tx_seq_no += 0x10;
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
 		hdr->seq_ctrl |= cpu_to_le16(arvif->tx_seq_no);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 6d197a5..e4b8dba 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2122,7 +2122,7 @@ static int ath_tx_prepare(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * BSSes.
 	 */
 	if (info->control.flags & IEEE80211_TX_CTRL_ASSIGN_SEQ) {
-		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+		if (info->control.flags & IEEE80211_TX_CTRL_FIRST_FRAGMENT)
 			sc->tx.seq_no += 0x10;
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
 		hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 42b2556..35dd486 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -406,7 +406,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 	/* use hardware sequence counter as the non-TID counter */
 	if (info->control.flags & IEEE80211_TX_CTRL_ASSIGN_SEQ)
 		mac_ctl |= B43_TXH_MAC_HWSEQ;
-	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+	if (info->control.flags & IEEE80211_TX_CTRL_FIRST_FRAGMENT)
 		mac_ctl |= B43_TXH_MAC_STMSDU;
 	if (phy->type == B43_PHYTYPE_A)
 		mac_ctl |= B43_TXH_MAC_5GHZ;
diff --git a/drivers/net/wireless/b43legacy/xmit.c b/drivers/net/wireless/b43legacy/xmit.c
index 548b456..b3b0bc5 100644
--- a/drivers/net/wireless/b43legacy/xmit.c
+++ b/drivers/net/wireless/b43legacy/xmit.c
@@ -285,7 +285,7 @@ static int generate_txhdr_fw3(struct b43legacy_wldev *dev,
 		mac_ctl |= B43legacy_TX4_MAC_ACK;
 	if (info->control.flags & IEEE80211_TX_CTRL_ASSIGN_SEQ)
 		mac_ctl |= B43legacy_TX4_MAC_HWSEQ;
-	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+	if (info->control.flags & IEEE80211_TX_CTRL_FIRST_FRAGMENT)
 		mac_ctl |= B43legacy_TX4_MAC_STMSDU;
 	if (rate_fb_ofdm)
 		mac_ctl |= B43legacy_TX4_MAC_FALLBACKOFDM;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 0d48265..28a501e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -6325,7 +6325,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 			frameid = bcmc_fid_generate(wlc, NULL, txh);
 		} else {
 			/* Increment the counter for first fragment */
-			if (tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+			if (tx_info->control.flags & IEEE80211_TX_CTRL_FIRST_FRAGMENT)
 				scb->seqnum[p->priority]++;
 
 			/* extract fragment number from frame first */
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 1c7e4bc..bed86cc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -362,7 +362,7 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 	}
 
 	if (test_bit(CONFIG_HT_DISABLED, &rt2x00dev->flags)) {
-		if (!(tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT))
+		if (!(tx_info->control.flags & IEEE80211_TX_CTRL_FIRST_FRAGMENT))
 			txdesc->u.ht.txop = TXOP_SIFS;
 		else
 			txdesc->u.ht.txop = TXOP_BACKOFF;
@@ -409,7 +409,7 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 	if (ieee80211_is_mgmt(hdr->frame_control) &&
 	    !ieee80211_is_beacon(hdr->frame_control))
 		txdesc->u.ht.txop = TXOP_BACKOFF;
-	else if (!(tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT))
+	else if (!(tx_info->control.flags & IEEE80211_TX_CTRL_FIRST_FRAGMENT))
 		txdesc->u.ht.txop = TXOP_SIFS;
 	else
 		txdesc->u.ht.txop = TXOP_HTTXOP;
@@ -484,7 +484,7 @@ static void rt2x00queue_create_tx_descriptor(struct rt2x00_dev *rt2x00dev,
 	    ieee80211_is_probe_resp(hdr->frame_control))
 		__set_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc->flags);
 
-	if ((tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT) &&
+	if ((tx_info->control.flags & IEEE80211_TX_CTRL_FIRST_FRAGMENT) &&
 	    !test_bit(ENTRY_TXD_RTS_FRAME, &txdesc->flags))
 		__set_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags);
 
diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 5b1f77d..5712b5c 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -319,7 +319,7 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
 	spin_lock_irqsave(&priv->lock, flags);
 
 	if (info->control.flags & IEEE80211_TX_CTRL_ASSIGN_SEQ) {
-		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+		if (info->control.flags & IEEE80211_TX_CTRL_FIRST_FRAGMENT)
 			priv->seqno += 0x10;
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
 		hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index 5a2dd71..61af53c 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -264,7 +264,7 @@ static void rtl8187_tx(struct ieee80211_hw *dev,
 	}
 
 	if (info->control.flags & IEEE80211_TX_CTRL_ASSIGN_SEQ) {
-		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+		if (info->control.flags & IEEE80211_TX_CTRL_FIRST_FRAGMENT)
 			priv->seqno += 0x10;
 		tx_hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
 		tx_hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index e7af261..14e2369 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -666,7 +666,7 @@ static void cs_set_control(struct zd_mac *mac, struct zd_ctrlset *cs,
 	cs->control = 0;
 
 	/* First fragment */
-	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+	if (info->control.flags & IEEE80211_TX_CTRL_FIRST_FRAGMENT)
 		cs->control |= ZD_CS_NEED_RANDOM_BACKOFF;
 
 	/* No ACK expected (multicast, etc.) */
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 24bcf74..f5b71f2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -383,7 +383,6 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_NO_ACK: tell the low level not to wait for an ack
  * @IEEE80211_TX_CTL_CLEAR_PS_FILT: clear powersave filter for destination
  *	station
- * @IEEE80211_TX_CTL_FIRST_FRAGMENT: this is a first fragment of the frame
  * @IEEE80211_TX_CTL_SEND_AFTER_DTIM: send this frame after DTIM beacon
  * @IEEE80211_TX_CTL_AMPDU: this frame should be sent as part of an A-MPDU
  * @IEEE80211_TX_CTL_INJECTED: Frame was injected, internal to mac80211.
@@ -464,36 +463,35 @@ enum mac80211_tx_info_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
 	IEEE80211_TX_CTL_NO_ACK			= BIT(1),
 	IEEE80211_TX_CTL_CLEAR_PS_FILT		= BIT(2),
-	IEEE80211_TX_CTL_FIRST_FRAGMENT		= BIT(3),
-	IEEE80211_TX_CTL_SEND_AFTER_DTIM	= BIT(4),
-	IEEE80211_TX_CTL_AMPDU			= BIT(5),
-	IEEE80211_TX_CTL_INJECTED		= BIT(6),
-	IEEE80211_TX_STAT_TX_FILTERED		= BIT(7),
-	IEEE80211_TX_STAT_ACK			= BIT(8),
-	IEEE80211_TX_STAT_AMPDU			= BIT(9),
-	IEEE80211_TX_STAT_AMPDU_NO_BACK		= BIT(10),
-	IEEE80211_TX_CTL_RATE_CTRL_PROBE	= BIT(11),
-	IEEE80211_TX_INTFL_OFFCHAN_TX_OK	= BIT(12),
-	IEEE80211_TX_INTFL_NEED_TXPROCESSING	= BIT(13),
-	IEEE80211_TX_INTFL_RETRIED		= BIT(14),
-	IEEE80211_TX_INTFL_DONT_ENCRYPT		= BIT(15),
-	IEEE80211_TX_CTL_NO_PS_BUFFER		= BIT(16),
-	IEEE80211_TX_CTL_MORE_FRAMES		= BIT(17),
-	IEEE80211_TX_INTFL_RETRANSMISSION	= BIT(18),
-	IEEE80211_TX_INTFL_MLME_CONN_TX		= BIT(19),
-	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(20),
-	IEEE80211_TX_CTL_LDPC			= BIT(21),
-	IEEE80211_TX_CTL_STBC			= BIT(22) | BIT(23),
-	IEEE80211_TX_CTL_TX_OFFCHAN		= BIT(24),
-	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(25),
-	IEEE80211_TX_CTL_NO_CCK_RATE		= BIT(26),
-	IEEE80211_TX_STATUS_EOSP		= BIT(27),
-	IEEE80211_TX_CTL_USE_MINRATE		= BIT(28),
-	IEEE80211_TX_CTL_DONTFRAG		= BIT(29),
-	IEEE80211_TX_CTL_PS_RESPONSE		= BIT(30),
+	IEEE80211_TX_CTL_SEND_AFTER_DTIM	= BIT(3),
+	IEEE80211_TX_CTL_AMPDU			= BIT(4),
+	IEEE80211_TX_CTL_INJECTED		= BIT(5),
+	IEEE80211_TX_STAT_TX_FILTERED		= BIT(6),
+	IEEE80211_TX_STAT_ACK			= BIT(7),
+	IEEE80211_TX_STAT_AMPDU			= BIT(8),
+	IEEE80211_TX_STAT_AMPDU_NO_BACK		= BIT(9),
+	IEEE80211_TX_CTL_RATE_CTRL_PROBE	= BIT(10),
+	IEEE80211_TX_INTFL_OFFCHAN_TX_OK	= BIT(11),
+	IEEE80211_TX_INTFL_NEED_TXPROCESSING	= BIT(12),
+	IEEE80211_TX_INTFL_RETRIED		= BIT(13),
+	IEEE80211_TX_INTFL_DONT_ENCRYPT		= BIT(14),
+	IEEE80211_TX_CTL_NO_PS_BUFFER		= BIT(15),
+	IEEE80211_TX_CTL_MORE_FRAMES		= BIT(16),
+	IEEE80211_TX_INTFL_RETRANSMISSION	= BIT(17),
+	IEEE80211_TX_INTFL_MLME_CONN_TX		= BIT(18),
+	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(19),
+	IEEE80211_TX_CTL_LDPC			= BIT(20),
+	IEEE80211_TX_CTL_STBC			= BIT(21) | BIT(22),
+	IEEE80211_TX_CTL_TX_OFFCHAN		= BIT(23),
+	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(24),
+	IEEE80211_TX_CTL_NO_CCK_RATE		= BIT(25),
+	IEEE80211_TX_STATUS_EOSP		= BIT(26),
+	IEEE80211_TX_CTL_USE_MINRATE		= BIT(27),
+	IEEE80211_TX_CTL_DONTFRAG		= BIT(28),
+	IEEE80211_TX_CTL_PS_RESPONSE		= BIT(29),
 };
 
-#define IEEE80211_TX_CTL_STBC_SHIFT		22
+#define IEEE80211_TX_CTL_STBC_SHIFT		21
 
 /**
  * enum mac80211_tx_control_flags - flags to describe transmit control
@@ -504,7 +502,7 @@ enum mac80211_tx_info_flags {
  * @IEEE80211_TX_CTRL_ASSIGN_SEQ: The driver has to assign a sequence
  *	number to this frame, taking care of not overwriting the fragment
  *	number and increasing the sequence number only when the
- *	IEEE80211_TX_CTL_FIRST_FRAGMENT flag is set. mac80211 will properly
+ *	IEEE80211_TX_CTRL_FIRST_FRAGMENT flag is set. mac80211 will properly
  *	assign sequence numbers to QoS-data frames but cannot do so correctly
  *	for non-QoS-data and management frames because beacons need them from
  *	that counter as well and mac80211 cannot guarantee proper sequencing.
@@ -518,6 +516,7 @@ enum mac80211_tx_info_flags {
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTRL_PORT_CTRL_PROTO	= BIT(0),
 	IEEE80211_TX_CTRL_ASSIGN_SEQ		= BIT(1),
+	IEEE80211_TX_CTRL_FIRST_FRAGMENT        = BIT(3),
 };
 
 /*
@@ -525,13 +524,21 @@ enum mac80211_tx_control_flags {
  * set by the tx handlers for each transmission attempt by the mac80211 stack.
  */
 #define IEEE80211_TX_TEMPORARY_FLAGS (IEEE80211_TX_CTL_NO_ACK |		      \
-	IEEE80211_TX_CTL_CLEAR_PS_FILT | IEEE80211_TX_CTL_FIRST_FRAGMENT |    \
+	IEEE80211_TX_CTL_CLEAR_PS_FILT | IEEE80211_TX_STATUS_EOSP |	      \
 	IEEE80211_TX_CTL_SEND_AFTER_DTIM | IEEE80211_TX_CTL_AMPDU |	      \
 	IEEE80211_TX_STAT_TX_FILTERED |	IEEE80211_TX_STAT_ACK |		      \
 	IEEE80211_TX_STAT_AMPDU | IEEE80211_TX_STAT_AMPDU_NO_BACK |	      \
 	IEEE80211_TX_CTL_RATE_CTRL_PROBE | IEEE80211_TX_CTL_NO_PS_BUFFER |    \
 	IEEE80211_TX_CTL_MORE_FRAMES | IEEE80211_TX_CTL_LDPC |		      \
-	IEEE80211_TX_CTL_STBC | IEEE80211_TX_STATUS_EOSP)
+	IEEE80211_TX_CTL_STBC)
+
+/*
+ * This definition is used to clear all temporary flags, which are only used
+ * within the tx path as long as ieee80211_tx_info control is valid and 
+ * info->control.flags is used.
+ */
+#define IEEE80211_TX_TEMPORARY_CTRL_FLAGS (IEEE80211_TX_CTL_FIRST_FRAGMENT)
+
 
 /**
  * enum mac80211_rate_control_flags - per-rate flags set by the
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index e6e574a..c9f7fdb 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -66,6 +66,7 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 	info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING |
 		       IEEE80211_TX_INTFL_RETRANSMISSION;
 	info->flags &= ~IEEE80211_TX_TEMPORARY_FLAGS;
+	info->control.flags &= ~IEEE80211_TX_TEMPORARY_CTRL_FLAGS;
 
 	sta->tx_filtered_count++;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index cacd0d6..2309be9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -856,8 +856,8 @@ static int ieee80211_fragment(struct ieee80211_tx_data *tx,
 		memcpy(tmp->cb, skb->cb, sizeof(tmp->cb));
 
 		info = IEEE80211_SKB_CB(tmp);
-		info->flags &= ~(IEEE80211_TX_CTL_CLEAR_PS_FILT |
-				 IEEE80211_TX_CTL_FIRST_FRAGMENT);
+		info->flags &= ~(IEEE80211_TX_CTL_CLEAR_PS_FILT);
+		info->control.flags &= ~(IEEE80211_TX_CTRL_FIRST_FRAGMENT);
 
 		if (rem)
 			info->flags |= IEEE80211_TX_CTL_MORE_FRAMES;
@@ -1171,7 +1171,7 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 	else if (test_and_clear_sta_flag(tx->sta, WLAN_STA_CLEAR_PS_FILT))
 		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
 
-	info->flags |= IEEE80211_TX_CTL_FIRST_FRAGMENT;
+	info->control.flags |= IEEE80211_TX_CTRL_FIRST_FRAGMENT;
 
 	return TX_CONTINUE;
 }
@@ -2642,9 +2642,9 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 
 	info->control.vif = vif;
 
-	info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT |
-		       IEEE80211_TX_CTL_FIRST_FRAGMENT;
-	info->control.flags |= IEEE80211_TX_CTRL_ASSIGN_SEQ;
+	info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
+	info->control.flags |= IEEE80211_TX_CTRL_ASSIGN_SEQ |
+			       IEEE80211_TX_CTL_FIRST_FRAGMENT;
  out:
 	rcu_read_unlock();
 	return skb;
-- 
1.7.9.5

