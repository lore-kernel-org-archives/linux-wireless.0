Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:57609 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757031Ab3FGSOZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 14:14:25 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, nbd@nbd.name,
	johannes@sipsolutions.net, bvahl@net.t-labs.tu-berlin.de
Subject: [PATCH 3/3] mac80211: move flag IEEE80211_TX_CTL_ASSIGN_SEQ from flag to flags2
Date: Fri,  7 Jun 2013 20:13:23 +0200
Message-Id: <1370628803-28785-4-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20130607_201440_432484_095B7C6E)
In-Reply-To: <1370628803-28785-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1370628803-28785-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Flag IEEE80211_TX_CTL_ASSIGN_SEQ at bit(1) in mac80211_tx_control_flags
is moved to ieee80211_tx_info->control.flags2 as it is only used in the
tx-path. This frees one bit in ieee80211_tx_info->flags.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
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
 include/net/mac80211.h                          |   25 ++++++++++++-----------
 net/mac80211/tx.c                               |    4 ++--
 16 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index fd1eeba..b768e3b 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -161,7 +161,7 @@ static struct ath_buf *ath9k_beacon_generate(struct ieee80211_hw *hw,
 	mgmt_hdr->u.beacon.timestamp = avp->tsf_adjust;
 
 	info = IEEE80211_SKB_CB(skb);
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+	if (info->control.flags2 & IEEE80211_TX_CTL_ASSIGN_SEQ) {
 		/*
 		 * TODO: make sure the seq# gets assigned properly (vs. other
 		 * TX frames)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index e0c03bd..7dc56e2 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -386,7 +386,7 @@ static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
 	mgmt->u.beacon.timestamp = avp->tsfadjust;
 
 	info = IEEE80211_SKB_CB(beacon);
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+	if (info->control.flags2 & IEEE80211_TX_CTL_ASSIGN_SEQ) {
 		struct ieee80211_hdr *hdr =
 			(struct ieee80211_hdr *) beacon->data;
 		avp->seq_no += 0x10;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index eab0fcb..15fdfa1 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1929,7 +1929,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * to be cleaned up to work better with Beacon transmission and virtual
 	 * BSSes.
 	 */
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+	if (info->control.flags2 & IEEE80211_TX_CTL_ASSIGN_SEQ) {
 		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 			sc->tx.seq_no += 0x10;
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 6ee8c26..23b02aa 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -921,7 +921,7 @@ static int carl9170_tx_prepare(struct ar9170 *ar,
 	if (unlikely(info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM))
 		txc->s.misc |= CARL9170_TX_SUPER_MISC_CAB;
 
-	if (unlikely(info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ))
+	if (unlikely(info->control.flags2 & IEEE80211_TX_CTL_ASSIGN_SEQ))
 		txc->s.misc |= CARL9170_TX_SUPER_MISC_ASSIGN_SEQ;
 
 	if (unlikely(ieee80211_is_probe_resp(hdr->frame_control)))
diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index 8cb206a..0771593 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -404,7 +404,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
 		mac_ctl |= B43_TXH_MAC_ACK;
 	/* use hardware sequence counter as the non-TID counter */
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+	if (info->control.flags2 & IEEE80211_TX_CTL_ASSIGN_SEQ)
 		mac_ctl |= B43_TXH_MAC_HWSEQ;
 	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 		mac_ctl |= B43_TXH_MAC_STMSDU;
diff --git a/drivers/net/wireless/b43legacy/xmit.c b/drivers/net/wireless/b43legacy/xmit.c
index 849a28c..6920d17 100644
--- a/drivers/net/wireless/b43legacy/xmit.c
+++ b/drivers/net/wireless/b43legacy/xmit.c
@@ -283,7 +283,7 @@ static int generate_txhdr_fw3(struct b43legacy_wldev *dev,
 	rates = info->control.rates;
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
 		mac_ctl |= B43legacy_TX4_MAC_ACK;
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+	if (info->control.flags2 & IEEE80211_TX_CTL_ASSIGN_SEQ)
 		mac_ctl |= B43legacy_TX4_MAC_HWSEQ;
 	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 		mac_ctl |= B43legacy_TX4_MAC_STMSDU;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 28e7aee..ed97e69 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -6327,7 +6327,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	memset(txh, 0, D11_TXH_LEN);
 
 	/* setup frameid */
-	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+	if (tx_info->control.flags2 & IEEE80211_TX_CTL_ASSIGN_SEQ) {
 		/* non-AP STA should never use BCMC queue */
 		if (queue == TX_BCMC_FIFO) {
 			brcms_err(wlc->hw->d11core,
diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 353a053..b659254 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -101,7 +101,7 @@ static void iwlagn_tx_cmd_build_basic(struct iwl_priv *priv,
 		tx_flags &= ~TX_CMD_FLG_SEQ_CTL_MSK;
 	} else {
 		tx_cmd->tid_tspec = IWL_TID_NON_QOS;
-		if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+		if (info->control.flags2 & IEEE80211_TX_CTL_ASSIGN_SEQ)
 			tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
 		else
 			tx_flags &= ~TX_CMD_FLG_SEQ_CTL_MSK;
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index f212f16..e5f4cbc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -107,7 +107,7 @@ static void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 		tx_flags &= ~TX_CMD_FLG_SEQ_CTL;
 	} else {
 		tx_cmd->tid_tspec = IWL_TID_NON_QOS;
-		if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+		if (info->control.flags2 & IEEE80211_TX_CTL_ASSIGN_SEQ)
 			tx_flags |= TX_CMD_FLG_SEQ_CTL;
 		else
 			tx_flags &= ~TX_CMD_FLG_SEQ_CTL;
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index a3707fd..46c20fd 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1921,7 +1921,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw,
 	tx_info = IEEE80211_SKB_CB(skb);
 	mwl8k_vif = MWL8K_VIF(tx_info->control.vif);
 
-	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+	if (tx_info->control.flags2 & IEEE80211_TX_CTL_ASSIGN_SEQ) {
 		wh->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
 		wh->seq_ctrl |= cpu_to_le16(mwl8k_vif->seqno);
 		mwl8k_vif->seqno += 0x10;
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index f95de0d..6053a48 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -692,7 +692,7 @@ static void p54_tx_80211_header(struct p54_common *priv, struct sk_buff *skb,
 	else
 		*burst_possible = false;
 
-	if (!(info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ))
+	if (!(info->control.flags2 & IEEE80211_TX_CTL_ASSIGN_SEQ))
 		*flags |= P54_HDR_FLAG_DATA_OUT_SEQNR;
 
 	if (info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER)
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 2c12311..87e6dba 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -221,7 +221,7 @@ static void rt2x00queue_create_tx_descriptor_seq(struct rt2x00_dev *rt2x00dev,
 	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
 	u16 seqno;
 
-	if (!(tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ))
+	if (!(tx_info->control.flags2 & IEEE80211_TX_CTL_ASSIGN_SEQ))
 		return;
 
 	__set_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags);
diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 91a04e2..fc47402 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -302,7 +302,7 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+	if (info->control.flags2 & IEEE80211_TX_CTL_ASSIGN_SEQ) {
 		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 			priv->seqno += 0x10;
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index f49220e..dcaec73 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -264,7 +264,7 @@ static void rtl8187_tx(struct ieee80211_hw *dev,
 		flags |= ieee80211_get_rts_cts_rate(dev, info)->hw_value << 19;
 	}
 
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+	if (info->control.flags2 & IEEE80211_TX_CTL_ASSIGN_SEQ) {
 		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 			priv->seqno += 0x10;
 		tx_hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6c31a92..c4816ab 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -374,17 +374,6 @@ struct ieee80211_bss_conf {
  *
  * These flags are used with the @flags member of &ieee80211_tx_info.
  *
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
@@ -469,8 +458,8 @@ enum mac80211_tx_control_flags {
 	/*
 	 * moved to flags2:
 	 * IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
+	 * IEEE80211_TX_CTL_ASSIGN_SEQ		= BIT(1),
 	 */
-	IEEE80211_TX_CTL_ASSIGN_SEQ		= BIT(1),
 	IEEE80211_TX_CTL_NO_ACK			= BIT(2),
 	IEEE80211_TX_CTL_CLEAR_PS_FILT		= BIT(3),
 	IEEE80211_TX_CTL_FIRST_FRAGMENT		= BIT(4),
@@ -509,9 +498,21 @@ enum mac80211_tx_control_flags {
  * and are only available within the tx path where tx_info->control is valid.
  *
  * @IEEE80211_TX_CTL_REQ_TX_STATUS: require TX status callback for this frame.
+ * @IEEE80211_TX_CTL_ASSIGN_SEQ: The driver has to assign a sequence
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
  */
 enum mac80211_tx_control_flags2 {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
+	IEEE80211_TX_CTL_ASSIGN_SEQ		= BIT(1),
 };
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index b1fe9b5..c3c58f0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -768,7 +768,7 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 	 */
 	if (!ieee80211_is_data_qos(hdr->frame_control)) {
 		/* driver should assign sequence number */
-		info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
+		info->control.flags2 |= IEEE80211_TX_CTL_ASSIGN_SEQ;
 		/* for pure STA mode without beacons, we can do it */
 		hdr->seq_ctrl = cpu_to_le16(tx->sdata->sequence_number);
 		tx->sdata->sequence_number += 0x10;
@@ -2447,8 +2447,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 	info->control.vif = vif;
 
 	info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT |
-			IEEE80211_TX_CTL_ASSIGN_SEQ |
 			IEEE80211_TX_CTL_FIRST_FRAGMENT;
+	info->control.flags2 |= IEEE80211_TX_CTL_ASSIGN_SEQ;
  out:
 	rcu_read_unlock();
 	return skb;
-- 
1.7.9.5

