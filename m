Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:46371 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751214AbaBVUga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Feb 2014 15:36:30 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@nbd.name, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 1/6] mac80211: move flag IEEE80211_TX_CTL_ASSIGN_SEQ into info->control.flags
Date: Sat, 22 Feb 2014 21:36:15 +0100
Message-Id: <1393101380-1646-2-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20140222_213708_781118_A00CBD5E)
In-Reply-To: <1393101380-1646-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1393101380-1646-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Flag IEEE80211_TX_CTL_ASSIGN_SEQ is only used within the tx path while
ieee80211_tx_info->control is valid. Therefore this patch moves this flag
from info->flags structure into the info->control.flags and renames it to
IEEE80211_TX_CTRL_ASSIGN_SEQ.

Signed-off-by: Benjamin Vahl <bvahl@net.t-labs.tu-berlin.de>
Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 drivers/net/wireless/ath/ath10k/mac.h           |    2 +-
 drivers/net/wireless/ath/ath9k/beacon.c         |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c           |    2 +-
 drivers/net/wireless/ath/carl9170/tx.c          |    2 +-
 drivers/net/wireless/b43/xmit.c                 |    2 +-
 drivers/net/wireless/b43legacy/xmit.c           |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c  |    2 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c           |    2 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c           |    2 +-
 drivers/net/wireless/mwl8k.c                    |    2 +-
 drivers/net/wireless/p54/txrx.c                 |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c       |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c      |    2 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c      |    2 +-
 include/net/mac80211.h                          |   85 ++++++++++++-----------
 net/mac80211/tx.c                               |    8 +--
 17 files changed, 62 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index ba10219..c0ad9c6 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -50,7 +50,7 @@ static inline void ath10k_tx_h_seq_no(struct sk_buff *skb)
 	struct ieee80211_vif *vif = info->control.vif;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
 
-	if (info->flags  & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+	if (info->control.flags  & IEEE80211_TX_CTRL_ASSIGN_SEQ) {
 		if (arvif->tx_seq_no == 0)
 			arvif->tx_seq_no = 0x1000;
 
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 32d00e8..b9ad692 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -144,7 +144,7 @@ static struct ath_buf *ath9k_beacon_generate(struct ieee80211_hw *hw,
 	mgmt_hdr->u.beacon.timestamp = avp->tsf_adjust;
 
 	info = IEEE80211_SKB_CB(skb);
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+	if (info->control.flags & IEEE80211_TX_CTRL_ASSIGN_SEQ) {
 		/*
 		 * TODO: make sure the seq# gets assigned properly (vs. other
 		 * TX frames)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 8b57577..9817301 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -371,7 +371,7 @@ static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
 	mgmt->u.beacon.timestamp = avp->tsfadjust;
 
 	info = IEEE80211_SKB_CB(beacon);
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+	if (info->control.flags & IEEE80211_TX_CTRL_ASSIGN_SEQ) {
 		struct ieee80211_hdr *hdr =
 			(struct ieee80211_hdr *) beacon->data;
 		avp->seq_no += 0x10;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index a650704..6d197a5 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2121,7 +2121,7 @@ static int ath_tx_prepare(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * to be cleaned up to work better with Beacon transmission and virtual
 	 * BSSes.
 	 */
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+	if (info->control.flags & IEEE80211_TX_CTRL_ASSIGN_SEQ) {
 		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 			sc->tx.seq_no += 0x10;
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 4cadfd4..3c70cc0 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -1002,7 +1002,7 @@ static int carl9170_tx_prepare(struct ar9170 *ar,
 	if (unlikely(info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM))
 		txc->s.misc |= CARL9170_TX_SUPER_MISC_CAB;
 
-	if (unlikely(info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ))
+	if (unlikely(info->control.flags & IEEE80211_TX_CTRL_ASSIGN_SEQ))
 		txc->s.misc |= CARL9170_TX_SUPER_MISC_ASSIGN_SEQ;
 
 	if (unlikely(ieee80211_is_probe_resp(hdr->frame_control)))
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 218a0f3..42b2556 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -404,7 +404,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
 		mac_ctl |= B43_TXH_MAC_ACK;
 	/* use hardware sequence counter as the non-TID counter */
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+	if (info->control.flags & IEEE80211_TX_CTRL_ASSIGN_SEQ)
 		mac_ctl |= B43_TXH_MAC_HWSEQ;
 	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 		mac_ctl |= B43_TXH_MAC_STMSDU;
diff --git a/drivers/net/wireless/b43legacy/xmit.c b/drivers/net/wireless/b43legacy/xmit.c
index 86588c9..548b456 100644
--- a/drivers/net/wireless/b43legacy/xmit.c
+++ b/drivers/net/wireless/b43legacy/xmit.c
@@ -283,7 +283,7 @@ static int generate_txhdr_fw3(struct b43legacy_wldev *dev,
 	rates = info->control.rates;
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
 		mac_ctl |= B43legacy_TX4_MAC_ACK;
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+	if (info->control.flags & IEEE80211_TX_CTRL_ASSIGN_SEQ)
 		mac_ctl |= B43legacy_TX4_MAC_HWSEQ;
 	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 		mac_ctl |= B43legacy_TX4_MAC_STMSDU;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 9417cb5..0d48265 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -6316,7 +6316,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	memset(txh, 0, D11_TXH_LEN);
 
 	/* setup frameid */
-	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+	if (tx_info->control.flags & IEEE80211_TX_CTRL_ASSIGN_SEQ) {
 		/* non-AP STA should never use BCMC queue */
 		if (queue == TX_BCMC_FIFO) {
 			brcms_err(wlc->hw->d11core,
diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index a6839df..dbab1d5 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -100,7 +100,7 @@ static void iwlagn_tx_cmd_build_basic(struct iwl_priv *priv,
 		tx_flags &= ~TX_CMD_FLG_SEQ_CTL_MSK;
 	} else {
 		tx_cmd->tid_tspec = IWL_TID_NON_QOS;
-		if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+		if (info->control.flags & IEEE80211_TX_CTRL_ASSIGN_SEQ)
 			tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
 		else
 			tx_flags &= ~TX_CMD_FLG_SEQ_CTL_MSK;
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 74d60bf..75e15eb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -106,7 +106,7 @@ static void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 		tx_flags &= ~TX_CMD_FLG_SEQ_CTL;
 	} else {
 		tx_cmd->tid_tspec = IWL_TID_NON_QOS;
-		if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+		if (info->control.flags & IEEE80211_TX_CTRL_ASSIGN_SEQ)
 			tx_flags |= TX_CMD_FLG_SEQ_CTL;
 		else
 			tx_flags &= ~TX_CMD_FLG_SEQ_CTL;
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 4987c3f..473c4d1 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1920,7 +1920,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw,
 	tx_info = IEEE80211_SKB_CB(skb);
 	mwl8k_vif = MWL8K_VIF(tx_info->control.vif);
 
-	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+	if (tx_info->control.flags & IEEE80211_TX_CTRL_ASSIGN_SEQ) {
 		wh->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
 		wh->seq_ctrl |= cpu_to_le16(mwl8k_vif->seqno);
 		mwl8k_vif->seqno += 0x10;
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 153c615..1b1f0a2 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -691,7 +691,7 @@ static void p54_tx_80211_header(struct p54_common *priv, struct sk_buff *skb,
 	else
 		*burst_possible = false;
 
-	if (!(info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ))
+	if (!(info->control.flags & IEEE80211_TX_CTRL_ASSIGN_SEQ))
 		*flags |= P54_HDR_FLAG_DATA_OUT_SEQNR;
 
 	if (info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER)
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 5642ccc..1c7e4bc 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -219,7 +219,7 @@ static void rt2x00queue_create_tx_descriptor_seq(struct rt2x00_dev *rt2x00dev,
 	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
 	u16 seqno;
 
-	if (!(tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ))
+	if (!(tx_info->control.flags & IEEE80211_TX_CTRL_ASSIGN_SEQ))
 		return;
 
 	__set_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags);
diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 7980ab1..5b1f77d 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -318,7 +318,7 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+	if (info->control.flags & IEEE80211_TX_CTRL_ASSIGN_SEQ) {
 		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 			priv->seqno += 0x10;
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index c981bcf..5a2dd71 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -263,7 +263,7 @@ static void rtl8187_tx(struct ieee80211_hw *dev,
 		flags |= ieee80211_get_rts_cts_rate(dev, info)->hw_value << 19;
 	}
 
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+	if (info->control.flags & IEEE80211_TX_CTRL_ASSIGN_SEQ) {
 		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 			priv->seqno += 0x10;
 		tx_hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 86faa41..24bcf74 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -380,17 +380,6 @@ struct ieee80211_bss_conf {
  * These flags are used with the @flags member of &ieee80211_tx_info.
  *
  * @IEEE80211_TX_CTL_REQ_TX_STATUS: require TX status callback for this frame.
- * @IEEE80211_TX_CTL_ASSIGN_SEQ: The driver has to assign a sequence
- *	number to this frame, taking care of not overwriting the fragment
- *	number and increasing the sequence number only when the
- *	IEEE80211_TX_CTL_FIRST_FRAGMENT flag is set. mac80211 will properly
- *	assign sequence numbers to QoS-data frames but cannot do so correctly
- *	for non-QoS-data and management frames because beacons need them from
- *	that counter as well and mac80211 cannot guarantee proper sequencing.
- *	If this flag is set, the driver should instruct the hardware to
- *	assign a sequence number to the frame or assign one itself. Cf. IEEE
- *	802.11-2007 7.1.3.4.1 paragraph 3. This flag will always be set for
- *	beacons and always be clear for frames without a sequence number field.
  * @IEEE80211_TX_CTL_NO_ACK: tell the low level not to wait for an ack
  * @IEEE80211_TX_CTL_CLEAR_PS_FILT: clear powersave filter for destination
  *	station
@@ -473,39 +462,38 @@ struct ieee80211_bss_conf {
  */
 enum mac80211_tx_info_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
-	IEEE80211_TX_CTL_ASSIGN_SEQ		= BIT(1),
-	IEEE80211_TX_CTL_NO_ACK			= BIT(2),
-	IEEE80211_TX_CTL_CLEAR_PS_FILT		= BIT(3),
-	IEEE80211_TX_CTL_FIRST_FRAGMENT		= BIT(4),
-	IEEE80211_TX_CTL_SEND_AFTER_DTIM	= BIT(5),
-	IEEE80211_TX_CTL_AMPDU			= BIT(6),
-	IEEE80211_TX_CTL_INJECTED		= BIT(7),
-	IEEE80211_TX_STAT_TX_FILTERED		= BIT(8),
-	IEEE80211_TX_STAT_ACK			= BIT(9),
-	IEEE80211_TX_STAT_AMPDU			= BIT(10),
-	IEEE80211_TX_STAT_AMPDU_NO_BACK		= BIT(11),
-	IEEE80211_TX_CTL_RATE_CTRL_PROBE	= BIT(12),
-	IEEE80211_TX_INTFL_OFFCHAN_TX_OK	= BIT(13),
-	IEEE80211_TX_INTFL_NEED_TXPROCESSING	= BIT(14),
-	IEEE80211_TX_INTFL_RETRIED		= BIT(15),
-	IEEE80211_TX_INTFL_DONT_ENCRYPT		= BIT(16),
-	IEEE80211_TX_CTL_NO_PS_BUFFER		= BIT(17),
-	IEEE80211_TX_CTL_MORE_FRAMES		= BIT(18),
-	IEEE80211_TX_INTFL_RETRANSMISSION	= BIT(19),
-	IEEE80211_TX_INTFL_MLME_CONN_TX		= BIT(20),
-	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(21),
-	IEEE80211_TX_CTL_LDPC			= BIT(22),
-	IEEE80211_TX_CTL_STBC			= BIT(23) | BIT(24),
-	IEEE80211_TX_CTL_TX_OFFCHAN		= BIT(25),
-	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(26),
-	IEEE80211_TX_CTL_NO_CCK_RATE		= BIT(27),
-	IEEE80211_TX_STATUS_EOSP		= BIT(28),
-	IEEE80211_TX_CTL_USE_MINRATE		= BIT(29),
-	IEEE80211_TX_CTL_DONTFRAG		= BIT(30),
-	IEEE80211_TX_CTL_PS_RESPONSE		= BIT(31),
+	IEEE80211_TX_CTL_NO_ACK			= BIT(1),
+	IEEE80211_TX_CTL_CLEAR_PS_FILT		= BIT(2),
+	IEEE80211_TX_CTL_FIRST_FRAGMENT		= BIT(3),
+	IEEE80211_TX_CTL_SEND_AFTER_DTIM	= BIT(4),
+	IEEE80211_TX_CTL_AMPDU			= BIT(5),
+	IEEE80211_TX_CTL_INJECTED		= BIT(6),
+	IEEE80211_TX_STAT_TX_FILTERED		= BIT(7),
+	IEEE80211_TX_STAT_ACK			= BIT(8),
+	IEEE80211_TX_STAT_AMPDU			= BIT(9),
+	IEEE80211_TX_STAT_AMPDU_NO_BACK		= BIT(10),
+	IEEE80211_TX_CTL_RATE_CTRL_PROBE	= BIT(11),
+	IEEE80211_TX_INTFL_OFFCHAN_TX_OK	= BIT(12),
+	IEEE80211_TX_INTFL_NEED_TXPROCESSING	= BIT(13),
+	IEEE80211_TX_INTFL_RETRIED		= BIT(14),
+	IEEE80211_TX_INTFL_DONT_ENCRYPT		= BIT(15),
+	IEEE80211_TX_CTL_NO_PS_BUFFER		= BIT(16),
+	IEEE80211_TX_CTL_MORE_FRAMES		= BIT(17),
+	IEEE80211_TX_INTFL_RETRANSMISSION	= BIT(18),
+	IEEE80211_TX_INTFL_MLME_CONN_TX		= BIT(19),
+	IEEE80211_TX_INTFL_NL80211_FRAME_TX	= BIT(20),
+	IEEE80211_TX_CTL_LDPC			= BIT(21),
+	IEEE80211_TX_CTL_STBC			= BIT(22) | BIT(23),
+	IEEE80211_TX_CTL_TX_OFFCHAN		= BIT(24),
+	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(25),
+	IEEE80211_TX_CTL_NO_CCK_RATE		= BIT(26),
+	IEEE80211_TX_STATUS_EOSP		= BIT(27),
+	IEEE80211_TX_CTL_USE_MINRATE		= BIT(28),
+	IEEE80211_TX_CTL_DONTFRAG		= BIT(29),
+	IEEE80211_TX_CTL_PS_RESPONSE		= BIT(30),
 };
 
-#define IEEE80211_TX_CTL_STBC_SHIFT		23
+#define IEEE80211_TX_CTL_STBC_SHIFT		22
 
 /**
  * enum mac80211_tx_control_flags - flags to describe transmit control
@@ -513,10 +501,23 @@ enum mac80211_tx_info_flags {
  * @IEEE80211_TX_CTRL_PORT_CTRL_PROTO: this frame is a port control
  *	protocol frame (e.g. EAP)
  *
+ * @IEEE80211_TX_CTRL_ASSIGN_SEQ: The driver has to assign a sequence
+ *	number to this frame, taking care of not overwriting the fragment
+ *	number and increasing the sequence number only when the
+ *	IEEE80211_TX_CTL_FIRST_FRAGMENT flag is set. mac80211 will properly
+ *	assign sequence numbers to QoS-data frames but cannot do so correctly
+ *	for non-QoS-data and management frames because beacons need them from
+ *	that counter as well and mac80211 cannot guarantee proper sequencing.
+ *	If this flag is set, the driver should instruct the hardware to
+ *	assign a sequence number to the frame or assign one itself. Cf. IEEE
+ *	802.11-2007 7.1.3.4.1 paragraph 3. This flag will always be set for
+ *	beacons and always be clear for frames without a sequence number field.
+ *
  * These flags are used in tx_info->control.flags.
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTRL_PORT_CTRL_PROTO	= BIT(0),
+	IEEE80211_TX_CTRL_ASSIGN_SEQ		= BIT(1),
 };
 
 /*
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 722151f..cacd0d6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -789,7 +789,7 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 	if (!ieee80211_is_data_qos(hdr->frame_control) ||
 	    is_multicast_ether_addr(hdr->addr1)) {
 		/* driver should assign sequence number */
-		info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
+		info->control.flags |= IEEE80211_TX_CTRL_ASSIGN_SEQ;
 		/* for pure STA mode without beacons, we can do it */
 		hdr->seq_ctrl = cpu_to_le16(tx->sdata->sequence_number);
 		tx->sdata->sequence_number += 0x10;
@@ -798,7 +798,7 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 
 	/*
 	 * This should be true for injected/management frames only, for
-	 * management frames we have set the IEEE80211_TX_CTL_ASSIGN_SEQ
+	 * management frames we have set the IEEE80211_TX_CTRL_ASSIGN_SEQ
 	 * above since they are not QoS-data frames.
 	 */
 	if (!tx->sta)
@@ -2643,8 +2643,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 	info->control.vif = vif;
 
 	info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT |
-			IEEE80211_TX_CTL_ASSIGN_SEQ |
-			IEEE80211_TX_CTL_FIRST_FRAGMENT;
+		       IEEE80211_TX_CTL_FIRST_FRAGMENT;
+	info->control.flags |= IEEE80211_TX_CTRL_ASSIGN_SEQ;
  out:
 	rcu_read_unlock();
 	return skb;
-- 
1.7.9.5

