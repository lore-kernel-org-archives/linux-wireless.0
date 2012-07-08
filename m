Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:39940 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348Ab2GHRDH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 13:03:07 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.co
Cc: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	nbd@openwrt.org, jirislaby@gmail.com, mickflemm@gmail.com,
	ath5k-devel@lists.ath5k.org, sgruszka@redhat.com,
	johannes.berg@intel.com, wey-yi.w.guy@intel.com,
	ilw@linux.intel.com, buytenh@wantstofly.org,
	chunkeey@googlemail.com, IvDoorn@gmail.com, gwingerde@gmail.com,
	helmut.schaa@googlemail.com, users@rt2x00.serialmonkey.com,
	herton@canonical.com, htl10@users.sourceforge.net,
	stefano.brivio@polimi.it, b43-dev@lists.infradead.org,
	brudley@broadcom.com, rvossen@broadcom.com, arend@broadcom.com,
	frankyl@broadcom.com, kanyan@broadcom.com, pieterpg@broadcom.com,
	alwin@broadcom.com, brcm80211-dev-list@broadcom.com,
	dsd@gentoo.org, kune@deine-taler.de,
	thomas@net.t-labs.tu-berlin.de, x-alina@gmx.net
Subject: [PATCH] mac80211: Add transmit power control support (TPC)
Date: Sun,  8 Jul 2012 19:02:48 +0200
Message-Id: <1341766968-29570-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120708_190314_897831_DE794B3E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch creates an transmit power control (TPC) API within the mac80211
subsystem. It enables a per multi-rate-retry stage annotaion of a power-level
value in dBm for each data packet and a global power-level for acknowledgement
packets. Furthermore, necessary flags are defined to specify and map TPC
hardware capabilities of individual wireless cards. This TPC API is a
pre-requisite to implement any power control algorithm at mac80211. A new joint
rate and power control algorithm "Minstrel-Blues" is released soon.
This patch consists of the following 6 logical sections:

(1) structure ieee80211_tx_control is added to mac80211
It holds the STA structure to be able to remove info->control.sta from
struct ieee80211_tx_info (therefor out of the tx-path) and put it on the stack.

(2) restructuring of ieee80211_tx_info to add TPC annotation
Remove info->control.sta from struct ieee80211_tx_info to free up suitable
memory in SKB_CB. Make use of the freed space to extend the struct
ieee80211_tx_rate by u8 tpc[4]. This enables a per packet annotation of one
powerlevel in dBm per multi-rate-retry stage.

(3) add tpc hardware capability flags
To map different tpc hardware capabilities to mac80211, a new enum
ieee80211_tpc_support (type of transmit power control) support is added. Based
on these flags someone can specify transmit power control capabilities
to the stack.

@IEEE80211_TPC_NONE: No tpc beside a fixed global setting is available.
	This setting is used as the default case. Extended tpc capabilities
	need to be announced via flags within the individual hardware driver.
@IEEE80211_TPC_PER_DATA_PACKET: One power level per data packet can
	be set. Each data packet is send out with its individual power level.
@IEEE80211_TPC_PER_DATA_MRR: Multiple individual power levels per
	multi-rate-retry stage within a data packet are supported.
@IEEE80211_TPC_ACK_POWER_GLOBAL: One power level of ack packets is
	globaly adjustable.

(4) add support to change power-level of acknowledgement packets.
Add flag IEEE80211_CONF_CHANGE_ACK_POWER to ieee80211_conf_flags. This enables
to specify ack_power as global power level in dBm to use for all mac80211
acknowledgement packets.

(5) brcmsmac: restructure info->control.sta handling as it is goning to be removed.
brcmsmac uses info->control.sta while doing ampdu aggregation. The usage of the
structure info->control.sta is changed, as it is going to be removed from
struct ieee80211_tx_info.

(6) restructure tx-path of all effected drivers
Restructure tx-path of all effected drivers to respect new TPC support in
mac80211. TPC support is added to mac80211 by restructuring of struct
ieee80211_tx_info. Therfore the tx-path of all effected drivers is modified
to receive struct sta from the stack and respect the new ieee80211_tx_info
struct. List of modified driver:
ath9k
ath5k
iwl3954
iwl4965
iwl-agn
mwl8k
carl9170
ath9k-htc
p54
rt2x00
rtl8180
rtl8087
hwsim
b43
b43legacy
brcmsmac
zd1211rw

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |    3 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |    1 +
 drivers/net/wireless/ath/ath9k/htc.h               |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |    3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |    6 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |    3 +-
 drivers/net/wireless/ath/ath9k/main.c              |    5 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   10 ++-
 drivers/net/wireless/ath/carl9170/carl9170.h       |    4 +-
 drivers/net/wireless/ath/carl9170/tx.c             |   16 ++--
 drivers/net/wireless/b43/main.c                    |    3 +-
 drivers/net/wireless/b43legacy/main.c              |    1 +
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c    |   10 +--
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    6 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |    2 +-
 drivers/net/wireless/iwlegacy/3945-mac.c           |   12 ++-
 drivers/net/wireless/iwlegacy/4965-mac.c           |   25 ++++--
 drivers/net/wireless/iwlegacy/4965.h               |    8 +-
 drivers/net/wireless/iwlwifi/dvm/agn.h             |    4 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |    6 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c              |   15 ++--
 drivers/net/wireless/mac80211_hwsim.c              |   14 ++--
 drivers/net/wireless/mwl8k.c                       |   33 +++++---
 drivers/net/wireless/p54/lmac.h                    |    4 +-
 drivers/net/wireless/p54/main.c                    |    3 +-
 drivers/net/wireless/p54/txrx.c                    |   17 ++--
 drivers/net/wireless/rt2x00/rt2x00.h               |    4 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |    3 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |    4 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |   22 +++--
 drivers/net/wireless/rtl818x/rtl8180/dev.c         |    7 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c         |    7 +-
 drivers/net/wireless/zd1211rw/zd_mac.c             |    7 +-
 include/net/mac80211.h                             |   87 +++++++++++++++-----
 net/mac80211/driver-ops.h                          |    6 +-
 net/mac80211/ieee80211_i.h                         |    2 +
 net/mac80211/tx.c                                  |   13 +--
 37 files changed, 258 insertions(+), 119 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 22b80af..93a800f 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -55,7 +55,8 @@
 \********************/
 
 static void
-ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+ath5k_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
+	 struct sk_buff *skb)
 {
 	struct ath5k_hw *ah = hw->priv;
 	u16 qnum = skb_get_queue_mapping(skb);
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 79840d6..1de556c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -280,6 +280,7 @@ struct ath_tx_control {
 	struct ath_txq *txq;
 	struct ath_node *an;
 	u8 paprd;
+	struct ieee80211_tx_control control;
 };
 
 #define ATH_TX_ERROR        0x01
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 936e920..b0a6ad5 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -542,6 +542,7 @@ void ath9k_htc_stop_ani(struct ath9k_htc_priv *priv);
 
 int ath9k_tx_init(struct ath9k_htc_priv *priv);
 int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
+		       struct ieee80211_tx_control *control,
 		       struct sk_buff *skb, u8 slot, bool is_cab);
 void ath9k_tx_cleanup(struct ath9k_htc_priv *priv);
 bool ath9k_htc_txq_setup(struct ath9k_htc_priv *priv, int subtype);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 77d541f..5f07359 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -296,6 +296,7 @@ static void ath9k_htc_send_buffered(struct ath9k_htc_priv *priv,
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ieee80211_vif *vif;
 	struct sk_buff *skb;
+	struct ieee80211_tx_control control;
 	struct ieee80211_hdr *hdr;
 	int padpos, padsize, ret, tx_slot;
 
@@ -326,7 +327,7 @@ static void ath9k_htc_send_buffered(struct ath9k_htc_priv *priv,
 			goto next;
 		}
 
-		ret = ath9k_htc_tx_start(priv, skb, tx_slot, true);
+		ret = ath9k_htc_tx_start(priv, &control, skb, tx_slot, true);
 		if (ret != 0) {
 			ath9k_htc_tx_clear_slot(priv, tx_slot);
 			dev_kfree_skb_any(skb);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 374c32e..295f89a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -856,7 +856,9 @@ set_timer:
 /* mac80211 Callbacks */
 /**********************/
 
-static void ath9k_htc_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void ath9k_htc_tx(struct ieee80211_hw *hw,
+			 struct ieee80211_tx_control *control,
+			 struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr;
 	struct ath9k_htc_priv *priv = hw->priv;
@@ -883,7 +885,7 @@ static void ath9k_htc_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		goto fail_tx;
 	}
 
-	ret = ath9k_htc_tx_start(priv, skb, slot, false);
+	ret = ath9k_htc_tx_start(priv, control, skb, slot, false);
 	if (ret != 0) {
 		ath_dbg(common, XMIT, "Tx failed\n");
 		goto clear_slot;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 47e61d0..948a060 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -333,12 +333,13 @@ static void ath9k_htc_tx_data(struct ath9k_htc_priv *priv,
 }
 
 int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
+		       struct ieee80211_tx_control *control,
 		       struct sk_buff *skb,
 		       u8 slot, bool is_cab)
 {
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_sta *sta = tx_info->control.sta;
+	struct ieee80211_sta *sta = control->sta;
 	struct ieee80211_vif *vif = tx_info->control.vif;
 	struct ath9k_htc_sta *ista;
 	struct ath9k_htc_vif *avp = NULL;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 248e5b2..9673693c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -680,7 +680,9 @@ mutex_unlock:
 	return r;
 }
 
-static void ath9k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void ath9k_tx(struct ieee80211_hw *hw,
+		     struct ieee80211_tx_control *control,
+		     struct sk_buff *skb)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
@@ -740,6 +742,7 @@ static void ath9k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	memset(&txctl, 0, sizeof(struct ath_tx_control));
 	txctl.txq = sc->tx.txq_map[skb_get_queue_mapping(skb)];
+	memcpy(&txctl.control, control, sizeof(struct ieee80211_tx_control));
 
 	ath_dbg(common, XMIT, "transmitting packet, skb: %p\n", skb);
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index cafb4a0..bf5d390 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1771,11 +1771,13 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 	TX_STAT_INC(txq->axq_qnum, queued);
 }
 
-static void setup_frame_info(struct ieee80211_hw *hw, struct sk_buff *skb,
+static void setup_frame_info(struct ieee80211_hw *hw,
+			     struct ieee80211_tx_control *control,
+			     struct sk_buff *skb,
 			     int framelen)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_sta *sta = tx_info->control.sta;
+	struct ieee80211_sta *sta = control->sta;
 	struct ieee80211_key_conf *hw_key = tx_info->control.hw_key;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	const struct ieee80211_rate *rate;
@@ -1933,7 +1935,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_sta *sta = info->control.sta;
+	struct ieee80211_sta *sta = txctl->control.sta;
 	struct ieee80211_vif *vif = info->control.vif;
 	struct ath_softc *sc = hw->priv;
 	struct ath_txq *txq = txctl->txq;
@@ -1977,7 +1979,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	    !ieee80211_is_data(hdr->frame_control))
 		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
 
-	setup_frame_info(hw, skb, frmlen);
+	setup_frame_info(hw, &txctl->control, skb, frmlen);
 
 	/*
 	 * At this point, the vif, hw_key and sta pointers in the tx control
diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 0cea20e..5b48b43 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -566,7 +566,9 @@ void carl9170_rx(struct ar9170 *ar, void *buf, unsigned int len);
 void carl9170_handle_command_response(struct ar9170 *ar, void *buf, u32 len);
 
 /* TX */
-void carl9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
+void carl9170_op_tx(struct ieee80211_hw *hw,
+		    struct ieee80211_tx_control *control,
+		    struct sk_buff *skb);
 void carl9170_tx_janitor(struct work_struct *work);
 void carl9170_tx_process_status(struct ar9170 *ar,
 				const struct carl9170_rsp *cmd);
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index ede0b57..1aa9564 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -277,7 +277,7 @@ static void carl9170_tx_release(struct kref *ref)
 		return;
 
 	BUILD_BUG_ON(
-	    offsetof(struct ieee80211_tx_info, status.ack_signal) != 20);
+	    offsetof(struct ieee80211_tx_info, status.ack_signal) != 24);
 
 	memset(&txinfo->status.ack_signal, 0,
 	       sizeof(struct ieee80211_tx_info) -
@@ -826,7 +826,9 @@ static bool carl9170_tx_cts_check(struct ar9170 *ar,
 	return false;
 }
 
-static int carl9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
+static int carl9170_tx_prepare(struct ar9170 *ar,
+			       struct ieee80211_tx_control *control,
+			       struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr;
 	struct _carl9170_tx_superframe *txc;
@@ -869,7 +871,7 @@ static int carl9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 	else
 		cvif = NULL;
 
-	sta = info->control.sta;
+	sta = control->sta;
 
 	txc = (void *)skb_push(skb, sizeof(*txc));
 	memset(txc, 0, sizeof(*txc));
@@ -1394,7 +1396,9 @@ err_unlock_rcu:
 	return false;
 }
 
-void carl9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+void carl9170_op_tx(struct ieee80211_hw *hw,
+		    struct ieee80211_tx_control *control,
+		    struct sk_buff *skb)
 {
 	struct ar9170 *ar = hw->priv;
 	struct ieee80211_tx_info *info;
@@ -1405,9 +1409,9 @@ void carl9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		goto err_free;
 
 	info = IEEE80211_SKB_CB(skb);
-	sta = info->control.sta;
+	sta = control->sta;
 
-	if (unlikely(carl9170_tx_prepare(ar, skb)))
+	if (unlikely(carl9170_tx_prepare(ar, control, skb)))
 		goto err_free;
 
 	carl9170_tx_accounting(ar, skb);
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 1b988f2..b6fc409 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3409,7 +3409,8 @@ static void b43_tx_work(struct work_struct *work)
 }
 
 static void b43_op_tx(struct ieee80211_hw *hw,
-		     struct sk_buff *skb)
+		      struct ieee80211_tx_control *control,
+		      struct sk_buff *skb)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 8156135..74d4c20 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -2492,6 +2492,7 @@ static void b43legacy_tx_work(struct work_struct *work)
 }
 
 static void b43legacy_op_tx(struct ieee80211_hw *hw,
+			    struct ieee80211_tx_control *control,
 			    struct sk_buff *skb)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index 01b190a..d341c91 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -665,7 +665,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 			u8 plcp0, plcp3, is40, sgi;
 			struct ieee80211_sta *sta;
 
-			sta = tx_info->control.sta;
+			sta = tx_info->rate_driver_data[0];
 
 			if (rr) {
 				plcp0 = plcp[0];
@@ -1195,8 +1195,8 @@ static bool cb_del_ampdu_pkt(struct sk_buff *mpdu, void *arg_a)
 	bool rc;
 
 	rc = tx_info->flags & IEEE80211_TX_CTL_AMPDU ? true : false;
-	rc = rc && (tx_info->control.sta == NULL || ampdu_pars->sta == NULL ||
-		    tx_info->control.sta == ampdu_pars->sta);
+	rc = rc && (tx_info->rate_driver_data[0] == NULL || ampdu_pars->sta == NULL ||
+		    tx_info->rate_driver_data[0] == ampdu_pars->sta);
 	rc = rc && ((u8)(mpdu->priority) == ampdu_pars->tid);
 	return rc;
 }
@@ -1210,8 +1210,8 @@ static void dma_cb_fn_ampdu(void *txi, void *arg_a)
 	struct ieee80211_tx_info *tx_info = (struct ieee80211_tx_info *)txi;
 
 	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) &&
-	    (tx_info->control.sta == sta || sta == NULL))
-		tx_info->control.sta = NULL;
+	    (tx_info->rate_driver_data[0] == sta || sta == NULL))
+		tx_info->rate_driver_data[0] = NULL;
 }
 
 /*
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 2d5a404..d270c4f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -264,9 +264,12 @@ static void brcms_set_basic_rate(struct brcm_rateset *rs, u16 rate, bool is_br)
 	}
 }
 
-static void brcms_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void brcms_ops_tx(struct ieee80211_hw *hw,
+			 struct ieee80211_tx_control *control,
+			 struct sk_buff *skb)
 {
 	struct brcms_info *wl = hw->priv;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 
 	spin_lock_bh(&wl->lock);
 	if (!wl->pub->up) {
@@ -275,6 +278,7 @@ static void brcms_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		goto done;
 	}
 	brcms_c_sendpkt_mac80211(wl->wlc, skb, hw);
+	tx_info->rate_driver_data[0] = control->sta;
  done:
 	spin_unlock_bh(&wl->lock);
 }
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 8776fbc..28dd37e3 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -879,7 +879,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	tx_info = IEEE80211_SKB_CB(p);
 	h = (struct ieee80211_hdr *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
 
-	if (tx_info->control.sta)
+	if (tx_info->rate_driver_data[0])
 		scb = &wlc->pri_scb;
 
 	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index faec404..7efec7c 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -460,7 +460,9 @@ il3945_build_tx_cmd_basic(struct il_priv *il, struct il_device_cmd *cmd,
  * start C_TX command process
  */
 static int
-il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
+il3945_tx_skb(struct il_priv *il,
+	       struct ieee80211_tx_control *control,
+	       struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -512,7 +514,7 @@ il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	hdr_len = ieee80211_hdrlen(fc);
 
 	/* Find idx into station table for destination station */
-	sta_id = il_sta_id_or_broadcast(il, info->control.sta);
+	sta_id = il_sta_id_or_broadcast(il, control->sta);
 	if (sta_id == IL_INVALID_STATION) {
 		D_DROP("Dropping - INVALID STATION: %pM\n", hdr->addr1);
 		goto drop;
@@ -2859,7 +2861,9 @@ il3945_mac_stop(struct ieee80211_hw *hw)
 }
 
 static void
-il3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+il3945_mac_tx(struct ieee80211_hw *hw,
+	       struct ieee80211_tx_control *control,
+	       struct sk_buff *skb)
 {
 	struct il_priv *il = hw->priv;
 
@@ -2868,7 +2872,7 @@ il3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	D_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 	     ieee80211_get_tx_rate(hw, IEEE80211_SKB_CB(skb))->bitrate);
 
-	if (il3945_tx_skb(il, skb))
+	if (il3945_tx_skb(il, control, skb))
 		dev_kfree_skb_any(skb);
 
 	D_MAC80211("leave\n");
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 34f61a0..95e3b34 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -1526,8 +1526,11 @@ il4965_tx_cmd_build_basic(struct il_priv *il, struct sk_buff *skb,
 }
 
 static void
-il4965_tx_cmd_build_rate(struct il_priv *il, struct il_tx_cmd *tx_cmd,
-			 struct ieee80211_tx_info *info, __le16 fc)
+il4965_tx_cmd_build_rate(struct il_priv *il,
+			 struct il_tx_cmd *tx_cmd,
+			 struct ieee80211_tx_info *info,
+			 struct ieee80211_tx_control *control,
+			 __le16 fc)
 {
 	const u8 rts_retry_limit = 60;
 	u32 rate_flags;
@@ -1563,7 +1566,7 @@ il4965_tx_cmd_build_rate(struct il_priv *il, struct il_tx_cmd *tx_cmd,
 	    || rate_idx > RATE_COUNT_LEGACY)
 		rate_idx =
 		    rate_lowest_index(&il->bands[info->band],
-				      info->control.sta);
+				      control->sta);
 	/* For 5 GHZ band, remap mac80211 rate indices into driver indices */
 	if (info->band == IEEE80211_BAND_5GHZ)
 		rate_idx += IL_FIRST_OFDM_RATE;
@@ -1630,11 +1633,13 @@ il4965_tx_cmd_build_hwcrypto(struct il_priv *il, struct ieee80211_tx_info *info,
  * start C_TX command process
  */
 int
-il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
+il4965_tx_skb(struct il_priv *il,
+	      struct ieee80211_tx_control *control,
+	      struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_sta *sta = info->control.sta;
+	struct ieee80211_sta *sta = control->sta;
 	struct il_station_priv *sta_priv = NULL;
 	struct il_tx_queue *txq;
 	struct il_queue *q;
@@ -1680,7 +1685,7 @@ il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 		sta_id = il->hw_params.bcast_id;
 	else {
 		/* Find idx into station table for destination station */
-		sta_id = il_sta_id_or_broadcast(il, info->control.sta);
+		sta_id = il_sta_id_or_broadcast(il, control->sta);
 
 		if (sta_id == IL_INVALID_STATION) {
 			D_DROP("Dropping - INVALID STATION: %pM\n", hdr->addr1);
@@ -1786,7 +1791,7 @@ il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	/* TODO need this for burst mode later on */
 	il4965_tx_cmd_build_basic(il, skb, tx_cmd, info, hdr, sta_id);
 
-	il4965_tx_cmd_build_rate(il, tx_cmd, info, fc);
+	il4965_tx_cmd_build_rate(il, tx_cmd, info, control, fc);
 
 	il_update_stats(il, true, fc, len);
 	/*
@@ -5828,7 +5833,9 @@ il4965_mac_stop(struct ieee80211_hw *hw)
 }
 
 void
-il4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+il4965_mac_tx(struct ieee80211_hw *hw,
+	      struct ieee80211_tx_control *control,
+	      struct sk_buff *skb)
 {
 	struct il_priv *il = hw->priv;
 
@@ -5837,7 +5844,7 @@ il4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	D_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 	     ieee80211_get_tx_rate(hw, IEEE80211_SKB_CB(skb))->bitrate);
 
-	if (il4965_tx_skb(il, skb))
+	if (il4965_tx_skb(il, control, skb))
 		dev_kfree_skb_any(skb);
 
 	D_MACDUMP("leave\n");
diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index 1db6776..29e77bf 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -78,7 +78,9 @@ int il4965_hw_txq_attach_buf_to_tfd(struct il_priv *il, struct il_tx_queue *txq,
 int il4965_hw_tx_queue_init(struct il_priv *il, struct il_tx_queue *txq);
 void il4965_hwrate_to_tx_control(struct il_priv *il, u32 rate_n_flags,
 				 struct ieee80211_tx_info *info);
-int il4965_tx_skb(struct il_priv *il, struct sk_buff *skb);
+int il4965_tx_skb(struct il_priv *il,
+		  struct ieee80211_tx_control *control,
+		  struct sk_buff *skb);
 int il4965_tx_agg_start(struct il_priv *il, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid, u16 * ssn);
 int il4965_tx_agg_stop(struct il_priv *il, struct ieee80211_vif *vif,
@@ -163,7 +165,9 @@ void il4965_eeprom_release_semaphore(struct il_priv *il);
 int il4965_eeprom_check_version(struct il_priv *il);
 
 /* mac80211 handlers (for 4965) */
-void il4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
+void il4965_mac_tx(struct ieee80211_hw *hw,
+		   struct ieee80211_tx_control *control,
+		   struct sk_buff *skb);
 int il4965_mac_start(struct ieee80211_hw *hw);
 void il4965_mac_stop(struct ieee80211_hw *hw);
 void il4965_configure_filter(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/iwlwifi/dvm/agn.h b/drivers/net/wireless/iwlwifi/dvm/agn.h
index 9bb16bd..a02d843 100644
--- a/drivers/net/wireless/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/iwlwifi/dvm/agn.h
@@ -201,7 +201,9 @@ void iwl_chswitch_done(struct iwl_priv *priv, bool is_success);
 
 
 /* tx */
-int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb);
+int iwlagn_tx_skb(struct iwl_priv *priv,
+		  struct ieee80211_tx_control *control,
+		  struct sk_buff *skb);
 int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn);
 int iwlagn_tx_agg_oper(struct iwl_priv *priv, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index a5f7bce..6bc03a3 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -511,14 +511,16 @@ static void iwlagn_mac_set_wakeup(struct ieee80211_hw *hw, bool enabled)
 }
 #endif
 
-static void iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void iwlagn_mac_tx(struct ieee80211_hw *hw,
+			  struct ieee80211_tx_control *control,
+			  struct sk_buff *skb)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
 	IWL_DEBUG_TX(priv, "dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 		     ieee80211_get_tx_rate(hw, IEEE80211_SKB_CB(skb))->bitrate);
 
-	if (iwlagn_tx_skb(priv, skb))
+	if (iwlagn_tx_skb(priv, control, skb))
 		dev_kfree_skb_any(skb);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 5971a23..fc386dc 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -127,6 +127,7 @@ static void iwlagn_tx_cmd_build_basic(struct iwl_priv *priv,
 static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 				     struct iwl_tx_cmd *tx_cmd,
 				     struct ieee80211_tx_info *info,
+				     struct ieee80211_tx_control *control,
 				     __le16 fc)
 {
 	u32 rate_flags;
@@ -188,7 +189,7 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 			(rate_idx < 0) || (rate_idx > IWL_RATE_COUNT_LEGACY))
 		rate_idx = rate_lowest_index(
 				&priv->eeprom_data->bands[info->band],
-				info->control.sta);
+				control->sta);
 	/* For 5 GHZ band, remap mac80211 rate indices into driver indices */
 	if (info->band == IEEE80211_BAND_5GHZ)
 		rate_idx += IWL_FIRST_OFDM_RATE;
@@ -291,7 +292,9 @@ static int iwl_sta_id_or_broadcast(struct iwl_rxon_context *context,
 /*
  * start REPLY_TX command process
  */
-int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
+int iwlagn_tx_skb(struct iwl_priv *priv,
+		  struct ieee80211_tx_control *control,
+		  struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -345,7 +348,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		sta_id = ctx->bcast_sta_id;
 	else {
 		/* Find index into station table for destination station */
-		sta_id = iwl_sta_id_or_broadcast(ctx, info->control.sta);
+		sta_id = iwl_sta_id_or_broadcast(ctx, control->sta);
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
 				       hdr->addr1);
@@ -355,8 +358,8 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	IWL_DEBUG_TX(priv, "station Id %d\n", sta_id);
 
-	if (info->control.sta)
-		sta_priv = (void *)info->control.sta->drv_priv;
+	if (control->sta)
+		sta_priv = (void *)control->sta->drv_priv;
 
 	if (sta_priv && sta_priv->asleep &&
 	    (info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER)) {
@@ -397,7 +400,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	/* TODO need this for burst mode later on */
 	iwlagn_tx_cmd_build_basic(priv, skb, tx_cmd, info, hdr, sta_id);
 
-	iwlagn_tx_cmd_build_rate(priv, tx_cmd, info, fc);
+	iwlagn_tx_cmd_build_rate(priv, tx_cmd, info, control, fc);
 
 	memset(&info->status, 0, sizeof(info->status));
 
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 3f38d84..a55c70b 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -709,7 +709,9 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 	return ack;
 }
 
-static void mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
+			      struct ieee80211_tx_control *control,
+			      struct sk_buff *skb)
 {
 	bool ack;
 	struct ieee80211_tx_info *txi;
@@ -741,8 +743,8 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	if (txi->control.vif)
 		hwsim_check_magic(txi->control.vif);
-	if (txi->control.sta)
-		hwsim_check_sta_magic(txi->control.sta);
+	if (control->sta)
+		hwsim_check_sta_magic(control->sta);
 
 	ieee80211_tx_info_clear_status(txi);
 
@@ -1495,6 +1497,8 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	struct hwsim_tx_rate *tx_attempts;
 	unsigned long ret_skb_ptr;
 	struct sk_buff *skb, *tmp;
+	struct ieee80211_tx_control control;
+	struct ieee80211_sta *sta = control.sta;
 	struct mac_address *src;
 	unsigned int hwsim_flags;
 
@@ -1542,8 +1546,8 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 
 	if (txi->control.vif)
 		hwsim_check_magic(txi->control.vif);
-	if (txi->control.sta)
-		hwsim_check_sta_magic(txi->control.sta);
+	if (sta)
+		hwsim_check_sta_magic(sta);
 
 	ieee80211_tx_info_clear_status(txi);
 
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 1404373..af669a2 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1610,7 +1610,9 @@ static int mwl8k_tid_queue_mapping(u8 tid)
 #define RI_RATE_ID_MCS(a)	 ((a & 0x01f8) >> 3)
 
 static int
-mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int limit, int force)
+mwl8k_txq_reclaim(struct ieee80211_hw *hw,
+		  struct ieee80211_tx_control *control,
+		  int index, int limit, int force)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_tx_queue *txq = priv->txq + index;
@@ -1708,12 +1710,13 @@ mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int limit, int force)
 static void mwl8k_txq_deinit(struct ieee80211_hw *hw, int index)
 {
 	struct mwl8k_priv *priv = hw->priv;
+	struct ieee80211_tx_control control;
 	struct mwl8k_tx_queue *txq = priv->txq + index;
 
 	if (txq->txd == NULL)
 		return;
 
-	mwl8k_txq_reclaim(hw, index, INT_MAX, 1);
+	mwl8k_txq_reclaim(hw, &control, index, INT_MAX, 1);
 
 	kfree(txq->skb);
 	txq->skb = NULL;
@@ -1828,7 +1831,10 @@ static inline void mwl8k_tx_count_packet(struct ieee80211_sta *sta, u8 tid)
 }
 
 static void
-mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
+mwl8k_txq_xmit(struct ieee80211_hw *hw,
+	       int index,
+	       struct ieee80211_tx_control *control,
+	       struct sk_buff *skb)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	struct ieee80211_tx_info *tx_info;
@@ -1865,7 +1871,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	wh = &((struct mwl8k_dma_data *)skb->data)->wh;
 
 	tx_info = IEEE80211_SKB_CB(skb);
-	sta = tx_info->control.sta;
+	sta = control->sta;
 	mwl8k_vif = MWL8K_VIF(tx_info->control.vif);
 
 	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
@@ -2017,8 +2023,8 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	tx->pkt_phys_addr = cpu_to_le32(dma);
 	tx->pkt_len = cpu_to_le16(skb->len);
 	tx->rate_info = 0;
-	if (!priv->ap_fw && tx_info->control.sta != NULL)
-		tx->peer_id = MWL8K_STA(tx_info->control.sta)->peer_id;
+	if (!priv->ap_fw && control->sta != NULL)
+		tx->peer_id = MWL8K_STA(control->sta)->peer_id;
 	else
 		tx->peer_id = 0;
 
@@ -4315,6 +4321,7 @@ static void mwl8k_tx_poll(unsigned long data)
 {
 	struct ieee80211_hw *hw = (struct ieee80211_hw *)data;
 	struct mwl8k_priv *priv = hw->priv;
+	struct ieee80211_tx_control control;
 	int limit;
 	int i;
 
@@ -4323,7 +4330,7 @@ static void mwl8k_tx_poll(unsigned long data)
 	spin_lock_bh(&priv->tx_lock);
 
 	for (i = 0; i < mwl8k_tx_queues(priv); i++)
-		limit -= mwl8k_txq_reclaim(hw, i, limit, 0);
+		limit -= mwl8k_txq_reclaim(hw, &control, i, limit, 0);
 
 	if (!priv->pending_tx_pkts && priv->tx_wait != NULL) {
 		complete(priv->tx_wait);
@@ -4362,7 +4369,9 @@ static void mwl8k_rx_poll(unsigned long data)
 /*
  * Core driver operations.
  */
-static void mwl8k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void mwl8k_tx(struct ieee80211_hw *hw,
+		     struct ieee80211_tx_control *control,
+		     struct sk_buff *skb)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	int index = skb_get_queue_mapping(skb);
@@ -4374,7 +4383,7 @@ static void mwl8k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		return;
 	}
 
-	mwl8k_txq_xmit(hw, index, skb);
+	mwl8k_txq_xmit(hw, index, control, skb);
 }
 
 static int mwl8k_start(struct ieee80211_hw *hw)
@@ -4439,6 +4448,7 @@ static int mwl8k_start(struct ieee80211_hw *hw)
 static void mwl8k_stop(struct ieee80211_hw *hw)
 {
 	struct mwl8k_priv *priv = hw->priv;
+	struct ieee80211_tx_control control;
 	int i;
 
 	if (!priv->hw_restart_in_progress)
@@ -4465,7 +4475,7 @@ static void mwl8k_stop(struct ieee80211_hw *hw)
 
 	/* Return all skbs to mac80211 */
 	for (i = 0; i < mwl8k_tx_queues(priv); i++)
-		mwl8k_txq_reclaim(hw, i, INT_MAX, 1);
+		mwl8k_txq_reclaim(hw, &control, i, INT_MAX, 1);
 }
 
 static int mwl8k_reload_firmware(struct ieee80211_hw *hw, char *fw_image);
@@ -5841,6 +5851,7 @@ static void __devexit mwl8k_shutdown(struct pci_dev *pdev)
 static void __devexit mwl8k_remove(struct pci_dev *pdev)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct ieee80211_tx_control control;
 	struct mwl8k_priv *priv;
 	int i;
 
@@ -5868,7 +5879,7 @@ static void __devexit mwl8k_remove(struct pci_dev *pdev)
 
 	/* Return all skbs to mac80211 */
 	for (i = 0; i < mwl8k_tx_queues(priv); i++)
-		mwl8k_txq_reclaim(hw, i, INT_MAX, 1);
+		mwl8k_txq_reclaim(hw, &control, i, INT_MAX, 1);
 
 	for (i = 0; i < mwl8k_tx_queues(priv); i++)
 		mwl8k_txq_deinit(hw, i);
diff --git a/drivers/net/wireless/p54/lmac.h b/drivers/net/wireless/p54/lmac.h
index 3d8d622..de1d46b 100644
--- a/drivers/net/wireless/p54/lmac.h
+++ b/drivers/net/wireless/p54/lmac.h
@@ -526,7 +526,9 @@ int p54_init_leds(struct p54_common *priv);
 void p54_unregister_leds(struct p54_common *priv);
 
 /* xmit functions */
-void p54_tx_80211(struct ieee80211_hw *dev, struct sk_buff *skb);
+void p54_tx_80211(struct ieee80211_hw *dev,
+		  struct ieee80211_tx_control *control,
+		  struct sk_buff *skb);
 int p54_tx_cancel(struct p54_common *priv, __le32 req_id);
 void p54_tx(struct p54_common *priv, struct sk_buff *skb);
 
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 7cffea7..9c8ce8e 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -140,6 +140,7 @@ static int p54_beacon_update(struct p54_common *priv,
 			struct ieee80211_vif *vif)
 {
 	struct sk_buff *beacon;
+	struct ieee80211_tx_control control;
 	int ret;
 
 	beacon = ieee80211_beacon_get(priv->hw, vif);
@@ -158,7 +159,7 @@ static int p54_beacon_update(struct p54_common *priv,
 	 * to cancel the old beacon template by hand, instead the firmware
 	 * will release the previous one through the feedback mechanism.
 	 */
-	p54_tx_80211(priv->hw, beacon);
+	p54_tx_80211(priv->hw, &control, beacon);
 	priv->tsf_high32 = 0;
 	priv->tsf_low32 = 0;
 
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index f38786e..edec732 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -426,7 +426,7 @@ static void p54_rx_frame_sent(struct p54_common *priv, struct sk_buff *skb)
 	       sizeof(struct ieee80211_tx_info) -
 	       offsetof(struct ieee80211_tx_info, status.ack_signal));
 	BUILD_BUG_ON(offsetof(struct ieee80211_tx_info,
-			      status.ack_signal) != 20);
+			      status.ack_signal) != 24);
 
 	if (entry_hdr->flags & cpu_to_le16(P54_HDR_FLAG_DATA_ALIGN))
 		pad = entry_data->align[0];
@@ -676,8 +676,9 @@ int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb)
 EXPORT_SYMBOL_GPL(p54_rx);
 
 static void p54_tx_80211_header(struct p54_common *priv, struct sk_buff *skb,
-				struct ieee80211_tx_info *info, u8 *queue,
-				u32 *extra_len, u16 *flags, u16 *aid,
+				struct ieee80211_tx_info *info,
+				struct ieee80211_tx_control *control,
+				u8 *queue, u32 *extra_len, u16 *flags, u16 *aid,
 				bool *burst_possible)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -746,8 +747,8 @@ static void p54_tx_80211_header(struct p54_common *priv, struct sk_buff *skb,
 			}
 		}
 
-		if (info->control.sta)
-			*aid = info->control.sta->aid;
+		if (control->sta)
+			*aid = control->sta->aid;
 		break;
 	}
 }
@@ -767,7 +768,9 @@ static u8 p54_convert_algo(u32 cipher)
 	}
 }
 
-void p54_tx_80211(struct ieee80211_hw *dev, struct sk_buff *skb)
+void p54_tx_80211(struct ieee80211_hw *dev,
+		  struct ieee80211_tx_control *control,
+		  struct sk_buff *skb)
 {
 	struct p54_common *priv = dev->priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -784,7 +787,7 @@ void p54_tx_80211(struct ieee80211_hw *dev, struct sk_buff *skb)
 	u8 nrates = 0, nremaining = 8;
 	bool burst_allowed = false;
 
-	p54_tx_80211_header(priv, skb, info, &queue, &extra_len,
+	p54_tx_80211_header(priv, skb, info, control, &queue, &extra_len,
 			    &hdr_flags, &aid, &burst_allowed);
 
 	if (p54_tx_qos_accounting_alloc(priv, skb, queue)) {
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 8afb546..f991e8b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1287,7 +1287,9 @@ void rt2x00lib_rxdone(struct queue_entry *entry, gfp_t gfp);
 /*
  * mac80211 handlers.
  */
-void rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
+void rt2x00mac_tx(struct ieee80211_hw *hw,
+		  struct ieee80211_tx_control *control,
+		  struct sk_buff *skb);
 int rt2x00mac_start(struct ieee80211_hw *hw);
 void rt2x00mac_stop(struct ieee80211_hw *hw);
 int rt2x00mac_add_interface(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index a6b88bd..87e335a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -181,6 +181,7 @@ static void rt2x00lib_bc_buffer_iter(void *data, u8 *mac,
 				     struct ieee80211_vif *vif)
 {
 	struct rt2x00_dev *rt2x00dev = data;
+	struct ieee80211_tx_control control;
 	struct sk_buff *skb;
 
 	/*
@@ -194,7 +195,7 @@ static void rt2x00lib_bc_buffer_iter(void *data, u8 *mac,
 	 */
 	skb = ieee80211_get_buffered_bc(rt2x00dev->hw, vif);
 	while (skb) {
-		rt2x00mac_tx(rt2x00dev->hw, skb);
+		rt2x00mac_tx(rt2x00dev->hw, &control, skb);
 		skb = ieee80211_get_buffered_bc(rt2x00dev->hw, vif);
 	}
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 4ff26c2..c3d0f2f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -99,7 +99,9 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 	return retval;
 }
 
-void rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+void rt2x00mac_tx(struct ieee80211_hw *hw,
+		  struct ieee80211_tx_control *control,
+		  struct sk_buff *skb)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 2fd8301..d80118d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -315,6 +315,7 @@ static void rt2x00queue_create_tx_descriptor_plcp(struct rt2x00_dev *rt2x00dev,
 static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 						struct sk_buff *skb,
 						struct txentry_desc *txdesc,
+						struct ieee80211_tx_control *control,
 						const struct rt2x00_rate *hwrate)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
@@ -322,11 +323,11 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct rt2x00_sta *sta_priv = NULL;
 
-	if (tx_info->control.sta) {
+	if (control->sta) {
 		txdesc->u.ht.mpdu_density =
-		    tx_info->control.sta->ht_cap.ampdu_density;
+		    control->sta->ht_cap.ampdu_density;
 
-		sta_priv = sta_to_rt2x00_sta(tx_info->control.sta);
+		sta_priv = sta_to_rt2x00_sta(control->sta);
 		txdesc->u.ht.wcid = sta_priv->wcid;
 	}
 
@@ -341,8 +342,8 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 		 * MIMO PS should be set to 1 for STA's using dynamic SM PS
 		 * when using more then one tx stream (>MCS7).
 		 */
-		if (tx_info->control.sta && txdesc->u.ht.mcs > 7 &&
-		    ((tx_info->control.sta->ht_cap.cap &
+		if (control->sta && txdesc->u.ht.mcs > 7 &&
+		    ((control->sta->ht_cap.cap &
 		      IEEE80211_HT_CAP_SM_PS) >>
 		     IEEE80211_HT_CAP_SM_PS_SHIFT) ==
 		    WLAN_HT_CAP_SM_PS_DYNAMIC)
@@ -409,7 +410,8 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 
 static void rt2x00queue_create_tx_descriptor(struct rt2x00_dev *rt2x00dev,
 					     struct sk_buff *skb,
-					     struct txentry_desc *txdesc)
+					     struct txentry_desc *txdesc,
+					     struct ieee80211_tx_control *control)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -503,7 +505,7 @@ static void rt2x00queue_create_tx_descriptor(struct rt2x00_dev *rt2x00dev,
 
 	if (test_bit(REQUIRE_HT_TX_DESC, &rt2x00dev->cap_flags))
 		rt2x00queue_create_tx_descriptor_ht(rt2x00dev, skb, txdesc,
-						    hwrate);
+						   control, hwrate);
 	else
 		rt2x00queue_create_tx_descriptor_plcp(rt2x00dev, skb, txdesc,
 						      hwrate);
@@ -587,6 +589,7 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	struct queue_entry *entry;
 	struct txentry_desc txdesc;
 	struct skb_frame_desc *skbdesc;
+	struct ieee80211_tx_control control;
 	u8 rate_idx, rate_flags;
 	int ret = 0;
 
@@ -595,7 +598,7 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	 * after that we are free to use the skb->cb array
 	 * for our information.
 	 */
-	rt2x00queue_create_tx_descriptor(queue->rt2x00dev, skb, &txdesc);
+	rt2x00queue_create_tx_descriptor(queue->rt2x00dev, skb, &txdesc, &control);
 
 	/*
 	 * All information is retrieved from the skb->cb array,
@@ -722,6 +725,7 @@ int rt2x00queue_update_beacon_locked(struct rt2x00_dev *rt2x00dev,
 	struct rt2x00_intf *intf = vif_to_intf(vif);
 	struct skb_frame_desc *skbdesc;
 	struct txentry_desc txdesc;
+	struct ieee80211_tx_control control;
 
 	if (unlikely(!intf->beacon))
 		return -ENOBUFS;
@@ -740,7 +744,7 @@ int rt2x00queue_update_beacon_locked(struct rt2x00_dev *rt2x00dev,
 	 * after that we are free to use the skb->cb array
 	 * for our information.
 	 */
-	rt2x00queue_create_tx_descriptor(rt2x00dev, intf->beacon->skb, &txdesc);
+	rt2x00queue_create_tx_descriptor(rt2x00dev, intf->beacon->skb, &txdesc, &control);
 
 	/*
 	 * Fill in skb descriptor
diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 3b50539..69963f3 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -244,7 +244,9 @@ static irqreturn_t rtl8180_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static void rtl8180_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
+static void rtl8180_tx(struct ieee80211_hw *dev,
+		       struct ieee80211_tx_control *control,
+		       struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -689,6 +691,7 @@ static void rtl8180_beacon_work(struct work_struct *work)
 		container_of((void *)vif_priv, struct ieee80211_vif, drv_priv);
 	struct ieee80211_hw *dev = vif_priv->dev;
 	struct ieee80211_mgmt *mgmt;
+	struct ieee80211_tx_control control;
 	struct sk_buff *skb;
 
 	/* don't overflow the tx ring */
@@ -710,7 +713,7 @@ static void rtl8180_beacon_work(struct work_struct *work)
 	/* TODO: use actual beacon queue */
 	skb_set_queue_mapping(skb, 0);
 
-	rtl8180_tx(dev, skb);
+	rtl8180_tx(dev, &control, skb);
 
 resched:
 	/*
diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index 4fb1ca1..5c4bd11 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -228,7 +228,9 @@ static void rtl8187_tx_cb(struct urb *urb)
 	}
 }
 
-static void rtl8187_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
+static void rtl8187_tx(struct ieee80211_hw *dev,
+		       struct ieee80211_tx_control *control,
+		       struct sk_buff *skb)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1055,6 +1057,7 @@ static void rtl8187_beacon_work(struct work_struct *work)
 		container_of((void *)vif_priv, struct ieee80211_vif, drv_priv);
 	struct ieee80211_hw *dev = vif_priv->dev;
 	struct ieee80211_mgmt *mgmt;
+	struct ieee80211_tx_control control;
 	struct sk_buff *skb;
 
 	/* don't overflow the tx ring */
@@ -1076,7 +1079,7 @@ static void rtl8187_beacon_work(struct work_struct *work)
 	/* TODO: use actual beacon queue */
 	skb_set_queue_mapping(skb, 0);
 
-	rtl8187_tx(dev, skb);
+	rtl8187_tx(dev, &control, skb);
 
 resched:
 	/*
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index c9e2660..4b05427 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -937,7 +937,9 @@ static int fill_ctrlset(struct zd_mac *mac,
  * control block of the skbuff will be initialized. If necessary the incoming
  * mac80211 queues will be stopped.
  */
-static void zd_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void zd_op_tx(struct ieee80211_hw *hw,
+		     struct ieee80211_tx_control *control,
+		     struct sk_buff *skb)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1162,6 +1164,7 @@ static int zd_op_config(struct ieee80211_hw *hw, u32 changed)
 
 static void zd_beacon_done(struct zd_mac *mac)
 {
+	struct ieee80211_tx_control control;
 	struct sk_buff *skb, *beacon;
 
 	if (!test_bit(ZD_DEVICE_RUNNING, &mac->flags))
@@ -1176,7 +1179,7 @@ static void zd_beacon_done(struct zd_mac *mac)
 		skb = ieee80211_get_buffered_bc(mac->hw, mac->vif);
 		if (!skb)
 			break;
-		zd_op_tx(mac->hw, skb);
+		zd_op_tx(mac->hw, &control, skb);
 	}
 
 	/*
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e3fa90c..a5b8ce5 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -483,32 +483,35 @@ enum mac80211_rate_control_flags {
  * @idx: rate index to attempt to send with
  * @flags: rate control flags (&enum mac80211_rate_control_flags)
  * @count: number of tries in this rate before going to the next rate
+ * @tpc: transmit power level in dBm per packet multi-rate-retry (mrr) stage
  *
  * A value of -1 for @idx indicates an invalid rate and, if used
  * in an array of retry rates, that no more rates should be tried.
  *
  * When used for transmit status reporting, the driver should
- * always report the rate along with the flags it used.
+ * always report the rate  and power along with the flags it used.
  *
  * &struct ieee80211_tx_info contains an array of these structs
- * in the control information, and it will be filled by the rate
- * control algorithm according to what should be sent. For example,
- * if this array contains, in the format { <idx>, <count> } the
+ * in the control information, and it will be filled by the joint rate-
+ * power control algorithm according to what should be sent. For example,
+ * if this array contains, in the format { <idx>, <count>, <tpc> } the
  * information
- *    { 3, 2 }, { 2, 2 }, { 1, 4 }, { -1, 0 }, { -1, 0 }
+ *    { 3, 2, 16 }, { 2, 2, 10 }, { 1, 4, 5 }, { -1, 0, 0 }
  * then this means that the frame should be transmitted
- * up to twice at rate 3, up to twice at rate 2, and up to four
- * times at rate 1 if it doesn't get acknowledged. Say it gets
- * acknowledged by the peer after the fifth attempt, the status
+ * up to twice at rate 3 with 16 dBm, up to twice at rate 2 with 10 dBm,
+ * and up to four times at rate 1 with 5 dBm if it doesn't get acknowledged.
+ * Say it gets acknowledged by the peer after the fifth attempt, the status
  * information should then contain
- *   { 3, 2 }, { 2, 2 }, { 1, 1 }, { -1, 0 } ...
- * since it was transmitted twice at rate 3, twice at rate 2
- * and once at rate 1 after which we received an acknowledgement.
+ *   { 3, 2, 16 }, { 2, 2, 10 }, { 1, 1, 5 }, { -1, 0, 0 }
+ * since it was transmitted twice at rate 3 with 16 dBm, twice at rate 2 with
+ * 10 dBm and once at rate 1 with 5 dBm after which we received an
+ * acknowledgement.
  */
 struct ieee80211_tx_rate {
 	s8 idx;
 	u8 count;
 	u8 flags;
+	u8 tpc;
 } __packed;
 
 /**
@@ -519,9 +522,6 @@ struct ieee80211_tx_rate {
  *  (2) driver internal use (if applicable)
  *  (3) TX status information - driver tells mac80211 what happened
  *
- * The TX control's sta pointer is only valid during the ->tx call,
- * it may be NULL.
- *
  * @flags: transmit info flags, defined above
  * @band: the band to transmit on (use for checking for races)
  * @hw_queue: HW queue to put the frame on, skb_get_queue_mapping() gives the AC
@@ -529,11 +529,11 @@ struct ieee80211_tx_rate {
  * @control: union for control data
  * @status: union for status data
  * @driver_data: array of driver_data pointers
+ * @ack_signal: signal strength of the ACK frame
  * @ampdu_ack_len: number of acked aggregated frames.
  * 	relevant only if IEEE80211_TX_STAT_AMPDU was set.
  * @ampdu_len: number of aggregated frames.
  * 	relevant only if IEEE80211_TX_STAT_AMPDU was set.
- * @ack_signal: signal strength of the ACK frame
  */
 struct ieee80211_tx_info {
 	/* common information */
@@ -547,7 +547,7 @@ struct ieee80211_tx_info {
 	union {
 		struct {
 			union {
-				/* rate control */
+				/* rate control and transmit power control */
 				struct {
 					struct ieee80211_tx_rate rates[
 						IEEE80211_TX_MAX_RATES];
@@ -559,7 +559,6 @@ struct ieee80211_tx_info {
 			/* NB: vif can be NULL for injected frames */
 			struct ieee80211_vif *vif;
 			struct ieee80211_key_conf *hw_key;
-			struct ieee80211_sta *sta;
 		} control;
 		struct {
 			struct ieee80211_tx_rate rates[IEEE80211_TX_MAX_RATES];
@@ -567,7 +566,7 @@ struct ieee80211_tx_info {
 			u8 ampdu_ack_len;
 			u8 ampdu_len;
 			u8 antenna;
-			/* 21 bytes free */
+			/* 17 bytes free */
 		} status;
 		struct {
 			struct ieee80211_tx_rate driver_rates[
@@ -634,7 +633,7 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
 		info->status.rates[i].count = 0;
 
 	BUILD_BUG_ON(
-	    offsetof(struct ieee80211_tx_info, status.ack_signal) != 20);
+	    offsetof(struct ieee80211_tx_info, status.ack_signal) != 24);
 	memset(&info->status.ampdu_ack_len, 0,
 	       sizeof(struct ieee80211_tx_info) -
 	       offsetof(struct ieee80211_tx_info, status.ampdu_ack_len));
@@ -760,6 +759,7 @@ enum ieee80211_conf_flags {
  * @IEEE80211_CONF_CHANGE_RETRY_LIMITS: retry limits changed
  * @IEEE80211_CONF_CHANGE_IDLE: Idle flag changed
  * @IEEE80211_CONF_CHANGE_SMPS: Spatial multiplexing powersave mode changed
+ * @IEEE80211_CONF_CHANGE_ACK_POWER: Global ACK power level (in dBm) changed
  */
 enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_SMPS		= BIT(1),
@@ -770,6 +770,7 @@ enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(6),
 	IEEE80211_CONF_CHANGE_RETRY_LIMITS	= BIT(7),
 	IEEE80211_CONF_CHANGE_IDLE		= BIT(8),
+	IEEE80211_CONF_CHANGE_ACK_POWER		= BIT(9),
 };
 
 /**
@@ -826,6 +827,8 @@ enum ieee80211_smps_mode {
  * @smps_mode: spatial multiplexing powersave mode; note that
  *	%IEEE80211_SMPS_STATIC is used when the device is not
  *	configured for an HT channel
+ * @ack_power: global power level in dBm to use for all
+ * 	mac80211 acknowledgement_packets 
  */
 struct ieee80211_conf {
 	u32 flags;
@@ -840,6 +843,8 @@ struct ieee80211_conf {
 	struct ieee80211_channel *channel;
 	enum nl80211_channel_type channel_type;
 	enum ieee80211_smps_mode smps_mode;
+
+	u8 ack_power;
 };
 
 /**
@@ -1068,6 +1073,15 @@ enum sta_notify_cmd {
 };
 
 /**
+ * struct ieee80211_tx_control - TX control data
+ *
+ * @sta: station table entry
+  */
+struct ieee80211_tx_control {
+	struct ieee80211_sta *sta;
+};
+
+/**
  * enum ieee80211_hw_flags - hardware flags
  *
  * These flags are used to indicate hardware capabilities to
@@ -1227,6 +1241,35 @@ enum ieee80211_hw_flags {
 };
 
 /**
+ * enum ieee80211_tpc_support - type of transmit power control support
+ *
+ * These flags are used to indicate transmit power control capabilities
+ * to the stack. Generally, flags here should have their meaning
+ * done in a way that the simplest hardware doesn't need setting
+ * any particular flags. There are some exceptions to this rule,
+ * however, so you are advised to review these flags carefully.
+ *
+ * @IEEE80211_TPC_NONE: No tpc beside a fixed global setting is available.
+ * This setting is used as the default case. Extended tpc capabilities
+ * need to be announced via flags within the individual hardware driver.
+ *
+ * @IEEE80211_TPC_PER_DATA_PACKET: One power level per data packet can
+ * be set. Each data packet is send out with its individual power level.
+ *
+ * @IEEE80211_TPC_PER_DATA_MRR: Multiple individual power levels per
+ * multi-rate-retry stage within a data packet are supported.
+ *
+ * @IEEE80211_TPC_ACK_POWER_GLOBAL: One power level of ack packets is
+ * globaly adjustable.
+ */
+enum ieee80211_tpc_support {
+	IEEE80211_TPC_NONE				=1<<0,
+	IEEE80211_TPC_PER_DATA_PACKET			=1<<1,
+	IEEE80211_TPC_PER_DATA_MRR			=1<<2,
+	IEEE80211_TPC_ACK_POWER_GLOBAL			=1<<3,
+};
+
+/**
  * struct ieee80211_hw - hardware information and state
  *
  * This structure contains the configuration and hardware
@@ -1274,6 +1317,7 @@ enum ieee80211_hw_flags {
  * @max_report_rates: maximum number of alternate rate retry stages
  *	the hw can report back.
  * @max_rate_tries: maximum number of tries for each stage
+ * @tpc_support: indicates the type of transmit power control support
  *
  * @napi_weight: weight used for NAPI polling.  You must specify an
  *	appropriate value here if a napi_poll operation is provided
@@ -1319,6 +1363,7 @@ struct ieee80211_hw {
 	u8 max_rates;
 	u8 max_report_rates;
 	u8 max_rate_tries;
+	u8 tpc_support;
 	u8 max_rx_aggregation_subframes;
 	u8 max_tx_aggregation_subframes;
 	u8 offchannel_tx_hw_queue;
@@ -2258,7 +2303,9 @@ enum ieee80211_rate_control_changed {
  *	The callback is optional and can (should!) sleep.
  */
 struct ieee80211_ops {
-	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
+	void (*tx)(struct ieee80211_hw *hw,
+		   struct ieee80211_tx_control *control,
+		   struct sk_buff *skb);
 	int (*start)(struct ieee80211_hw *hw);
 	void (*stop)(struct ieee80211_hw *hw);
 #ifdef CONFIG_PM
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index df92031..a81117a 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -22,9 +22,11 @@ get_bss_sdata(struct ieee80211_sub_if_data *sdata)
 	return sdata;
 }
 
-static inline void drv_tx(struct ieee80211_local *local, struct sk_buff *skb)
+static inline void drv_tx(struct ieee80211_local *local,
+			  struct ieee80211_tx_control *control,
+			  struct sk_buff *skb)
 {
-	local->ops->tx(&local->hw, skb);
+	local->ops->tx(&local->hw, control, skb);
 }
 
 static inline void drv_get_et_strings(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e0423f8..d3c69db 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -194,6 +194,8 @@ struct ieee80211_tx_data {
 	struct ieee80211_channel *channel;
 
 	unsigned int flags;
+
+	struct ieee80211_tx_control control;
 };
 
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c9d2175..94c362d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1194,6 +1194,7 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 static bool ieee80211_tx_frags(struct ieee80211_local *local,
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_sta *sta,
+			       struct ieee80211_tx_control *control,
 			       struct sk_buff_head *skbs,
 			       bool txpending)
 {
@@ -1233,10 +1234,10 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
 		info->control.vif = vif;
-		info->control.sta = sta;
+		control->sta = sta;
 
 		__skb_unlink(skb, skbs);
-		drv_tx(local, skb);
+		drv_tx(local, control, skb);
 	}
 
 	return true;
@@ -1246,6 +1247,7 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
  * Returns false if the frame couldn't be transmitted but was queued instead.
  */
 static bool __ieee80211_tx(struct ieee80211_local *local,
+			   struct ieee80211_tx_control *control,
 			   struct sk_buff_head *skbs, int led_len,
 			   struct sta_info *sta, bool txpending)
 {
@@ -1294,7 +1296,7 @@ static bool __ieee80211_tx(struct ieee80211_local *local,
 		break;
 	}
 
-	result = ieee80211_tx_frags(local, vif, pubsta, skbs,
+	result = ieee80211_tx_frags(local, vif, pubsta, control, skbs,
 				    txpending);
 
 	ieee80211_tpt_led_trig_tx(local, fc, led_len);
@@ -1402,7 +1404,7 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 			sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
 
 	if (!invoke_tx_handlers(&tx))
-		result = __ieee80211_tx(local, &tx.skbs, led_len,
+		result = __ieee80211_tx(local, &tx.control, &tx.skbs, led_len,
 					tx.sta, txpending);
  out:
 	rcu_read_unlock();
@@ -2144,6 +2146,7 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	struct ieee80211_hdr *hdr;
+	struct ieee80211_tx_control control;
 	bool result;
 
 	sdata = vif_to_sdata(info->control.vif);
@@ -2159,7 +2162,7 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 		hdr = (struct ieee80211_hdr *)skb->data;
 		sta = sta_info_get(sdata, hdr->addr1);
 
-		result = __ieee80211_tx(local, &skbs, skb->len, sta, true);
+		result = __ieee80211_tx(local, &control, &skbs, skb->len, sta, true);
 	}
 
 	return result;
-- 
1.7.10.4

