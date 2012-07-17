Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:50340 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755096Ab2GQULY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 16:11:24 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	ath5k-devel@lists.ath5k.org, ilw@linux.intel.com,
	users@rt2x00.serialmonkey.com, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com, chunkeey@googlemail.com,
	buytenh@wantstofly.org, dsd@gentoo.org, coelho@ti.com,
	johannes.berg@intel.com
Subject: [PATCH v2 0/0 2/2] mac80211: Remove control.sta from struct ieee80211_tx_info and restructure tx-path
Date: Tue, 17 Jul 2012 22:11:17 +0200
Message-Id: <1342555877-23563-3-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120717_221139_006366_BA67D35A)
In-Reply-To: <1342555877-23563-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1342555877-23563-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The pointer control.sta is removed from ieee80211_tx_info to free up
sufficient memory in SKB_CB on the tx-path to enable new annotations
per data packet e.g.support of upcoming Transmit Power Control (TPC).
Now the control.sta pointer is put on the stack where passed as
function parameter to the .tx equivalent (ieee80211_ops) of each
affected wireless driver.
Therefore a new structure ieee80211_tx_control is added to mac80211.h
which holds the sta structure instead. The tx-path of all affected
drivers is restructured to respect the chaneges.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
restructure this patch to respect logical API evolutions. thx to Johannes Berg
add missing drivers that are effected as well. thx to Xose Vazquez Perez
add missing drivers that are effected as well. thx to Johannes Berg
---
 drivers/net/wireless/adm8211.c                     |  4 +++-
 drivers/net/wireless/at76c50x-usb.c                |  4 +++-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |  3 ++-
 drivers/net/wireless/ath/ath9k/ath9k.h             |  1 +
 drivers/net/wireless/ath/ath9k/htc.h               |  1 +
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |  2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |  6 +++--
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |  2 +-
 drivers/net/wireless/ath/ath9k/main.c              |  5 ++++-
 drivers/net/wireless/ath/ath9k/xmit.c              |  9 ++++----
 drivers/net/wireless/ath/carl9170/carl9170.h       |  4 +++-
 drivers/net/wireless/ath/carl9170/tx.c             | 16 ++++++-------
 drivers/net/wireless/b43/main.c                    |  3 ++-
 drivers/net/wireless/b43legacy/main.c              |  1 +
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  6 +++--
 drivers/net/wireless/iwlegacy/3945-mac.c           | 12 ++++++----
 drivers/net/wireless/iwlegacy/4965-mac.c           | 26 +++++++++++++---------
 drivers/net/wireless/iwlegacy/4965.h               |  8 +++++--
 drivers/net/wireless/iwlwifi/dvm/agn.h             |  4 +++-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |  6 +++--
 drivers/net/wireless/iwlwifi/dvm/tx.c              | 16 +++++++------
 drivers/net/wireless/libertas_tf/main.c            |  4 +++-
 drivers/net/wireless/mac80211_hwsim.c              |  8 ++++---
 drivers/net/wireless/mwl8k.c                       | 17 ++++++++------
 drivers/net/wireless/p54/lmac.h                    |  4 +++-
 drivers/net/wireless/p54/main.c                    |  2 +-
 drivers/net/wireless/p54/txrx.c                    | 15 ++++++++-----
 drivers/net/wireless/rt2x00/rt2x00.h               |  4 +++-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |  2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |  4 +++-
 drivers/net/wireless/rt2x00/rt2x00queue.c          | 20 +++++++++--------
 drivers/net/wireless/rtl818x/rtl8180/dev.c         |  6 +++--
 drivers/net/wireless/rtl818x/rtl8187/dev.c         |  6 +++--
 drivers/net/wireless/rtlwifi/base.c                |  3 +--
 drivers/net/wireless/rtlwifi/core.c                |  8 ++++---
 drivers/net/wireless/rtlwifi/pci.c                 | 16 ++++++-------
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c       |  5 +++--
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h       |  1 +
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c       |  5 +++--
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.h       |  4 +++-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c       |  5 +++--
 drivers/net/wireless/rtlwifi/rtl8192de/trx.h       |  1 +
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c       |  5 +++--
 drivers/net/wireless/rtlwifi/rtl8192se/trx.h       |  1 +
 drivers/net/wireless/rtlwifi/usb.c                 | 15 ++++++++-----
 drivers/net/wireless/rtlwifi/wifi.h                | 13 +++++++----
 drivers/net/wireless/ti/wl1251/main.c              |  4 +++-
 drivers/net/wireless/ti/wlcore/main.c              |  6 +++--
 drivers/net/wireless/ti/wlcore/tx.c                | 19 +++++++++++-----
 drivers/net/wireless/zd1211rw/zd_mac.c             |  6 +++--
 drivers/staging/winbond/wbusb.c                    |  4 +++-
 include/net/mac80211.h                             | 20 ++++++++++++-----
 net/mac80211/driver-ops.h                          |  6 +++--
 net/mac80211/ieee80211_i.h                         |  2 ++
 net/mac80211/tx.c                                  | 13 ++++++-----
 55 files changed, 252 insertions(+), 141 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 0ac09a2..b661ce2 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1661,7 +1661,9 @@ static void adm8211_tx_raw(struct ieee80211_hw *dev, struct sk_buff *skb,
 }
 
 /* Put adm8211_tx_hdr on skb and transmit */
-static void adm8211_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
+static void adm8211_tx(struct ieee80211_hw *dev,
+		       struct ieee80211_tx_control *control,
+		       struct sk_buff *skb)
 {
 	struct adm8211_tx_hdr *txhdr;
 	size_t payload_len, hdrlen;
diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index efc162e..abb520d 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1726,7 +1726,9 @@ static void at76_mac80211_tx_callback(struct urb *urb)
 	ieee80211_wake_queues(priv->hw);
 }
 
-static void at76_mac80211_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void at76_mac80211_tx(struct ieee80211_hw *hw,
+			     struct ieee80211_tx_control *control,
+			     struct sk_buff *skb)
 {
 	struct at76_priv *priv = hw->priv;
 	struct at76_tx_buffer *tx_buffer = priv->bulk_out_buffer;
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
index 54f0c9d0..9a08d9f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -280,6 +280,7 @@ struct ath_tx_control {
 	struct ath_txq *txq;
 	struct ath_node *an;
 	u8 paprd;
+	struct ieee80211_sta *sta;
 };
 
 #define ATH_TX_ERROR        0x01
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 936e920..b30596f 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -542,6 +542,7 @@ void ath9k_htc_stop_ani(struct ath9k_htc_priv *priv);
 
 int ath9k_tx_init(struct ath9k_htc_priv *priv);
 int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
+		       struct ieee80211_sta *sta,
 		       struct sk_buff *skb, u8 slot, bool is_cab);
 void ath9k_tx_cleanup(struct ath9k_htc_priv *priv);
 bool ath9k_htc_txq_setup(struct ath9k_htc_priv *priv, int subtype);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 77d541f..f42d2eb 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -326,7 +326,7 @@ static void ath9k_htc_send_buffered(struct ath9k_htc_priv *priv,
 			goto next;
 		}
 
-		ret = ath9k_htc_tx_start(priv, skb, tx_slot, true);
+		ret = ath9k_htc_tx_start(priv, NULL, skb, tx_slot, true);
 		if (ret != 0) {
 			ath9k_htc_tx_clear_slot(priv, tx_slot);
 			dev_kfree_skb_any(skb);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 374c32e..ee053b2 100644
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
+	ret = ath9k_htc_tx_start(priv, control->sta, skb, slot, false);
 	if (ret != 0) {
 		ath_dbg(common, XMIT, "Tx failed\n");
 		goto clear_slot;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 47e61d0..06cdcb7 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -333,12 +333,12 @@ static void ath9k_htc_tx_data(struct ath9k_htc_priv *priv,
 }
 
 int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
+		       struct ieee80211_sta *sta,
 		       struct sk_buff *skb,
 		       u8 slot, bool is_cab)
 {
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_sta *sta = tx_info->control.sta;
 	struct ieee80211_vif *vif = tx_info->control.vif;
 	struct ath9k_htc_sta *ista;
 	struct ath9k_htc_vif *avp = NULL;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 01a5f18..45a77ff 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -691,7 +691,9 @@ mutex_unlock:
 	return r;
 }
 
-static void ath9k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void ath9k_tx(struct ieee80211_hw *hw,
+		     struct ieee80211_tx_control *control,
+		     struct sk_buff *skb)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
@@ -751,6 +753,7 @@ static void ath9k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	memset(&txctl, 0, sizeof(struct ath_tx_control));
 	txctl.txq = sc->tx.txq_map[skb_get_queue_mapping(skb)];
+	txctl.sta = control->sta;
 
 	ath_dbg(common, XMIT, "transmitting packet, skb: %p\n", skb);
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index cafb4a0..4912214 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1771,11 +1771,12 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 	TX_STAT_INC(txq->axq_qnum, queued);
 }
 
-static void setup_frame_info(struct ieee80211_hw *hw, struct sk_buff *skb,
+static void setup_frame_info(struct ieee80211_hw *hw,
+			     struct ieee80211_sta *sta,
+			     struct sk_buff *skb,
 			     int framelen)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_sta *sta = tx_info->control.sta;
 	struct ieee80211_key_conf *hw_key = tx_info->control.hw_key;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	const struct ieee80211_rate *rate;
@@ -1933,7 +1934,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_sta *sta = info->control.sta;
+	struct ieee80211_sta *sta = txctl->sta;
 	struct ieee80211_vif *vif = info->control.vif;
 	struct ath_softc *sc = hw->priv;
 	struct ath_txq *txq = txctl->txq;
@@ -1977,7 +1978,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	    !ieee80211_is_data(hdr->frame_control))
 		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
 
-	setup_frame_info(hw, skb, frmlen);
+	setup_frame_info(hw, sta, skb, frmlen);
 
 	/*
 	 * At this point, the vif, hw_key and sta pointers in the tx control
diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 376be11..8f0cbc3 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -577,7 +577,9 @@ void carl9170_rx(struct ar9170 *ar, void *buf, unsigned int len);
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
index 6a86814..84377cf 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -867,14 +867,15 @@ static bool carl9170_tx_cts_check(struct ar9170 *ar,
 	return false;
 }
 
-static int carl9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
+static int carl9170_tx_prepare(struct ar9170 *ar,
+			       struct ieee80211_sta *sta,
+			       struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr;
 	struct _carl9170_tx_superframe *txc;
 	struct carl9170_vif_info *cvif;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_tx_rate *txrate;
-	struct ieee80211_sta *sta;
 	struct carl9170_tx_info *arinfo;
 	unsigned int hw_queue;
 	int i;
@@ -910,8 +911,6 @@ static int carl9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 	else
 		cvif = NULL;
 
-	sta = info->control.sta;
-
 	txc = (void *)skb_push(skb, sizeof(*txc));
 	memset(txc, 0, sizeof(*txc));
 
@@ -1457,20 +1456,21 @@ err_unlock_rcu:
 	return false;
 }
 
-void carl9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+void carl9170_op_tx(struct ieee80211_hw *hw,
+		    struct ieee80211_tx_control *control,
+		    struct sk_buff *skb)
 {
 	struct ar9170 *ar = hw->priv;
 	struct ieee80211_tx_info *info;
-	struct ieee80211_sta *sta;
+	struct ieee80211_sta *sta = control->sta;
 	bool run;
 
 	if (unlikely(!IS_STARTED(ar)))
 		goto err_free;
 
 	info = IEEE80211_SKB_CB(skb);
-	sta = info->control.sta;
 
-	if (unlikely(carl9170_tx_prepare(ar, skb)))
+	if (unlikely(carl9170_tx_prepare(ar, sta, skb)))
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
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 9e79d47..a7be68d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -264,7 +264,9 @@ static void brcms_set_basic_rate(struct brcm_rateset *rs, u16 rate, bool is_br)
 	}
 }
 
-static void brcms_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void brcms_ops_tx(struct ieee80211_hw *hw,
+			 struct ieee80211_tx_control *control,
+			 struct sk_buff *skb)
 {
 	struct brcms_info *wl = hw->priv;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
@@ -276,7 +278,7 @@ static void brcms_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		goto done;
 	}
 	brcms_c_sendpkt_mac80211(wl->wlc, skb, hw);
-	tx_info->rate_driver_data[0] = tx_info->control.sta;
+	tx_info->rate_driver_data[0] = control->sta;
  done:
 	spin_unlock_bh(&wl->lock);
 }
diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index faec404..e252acb 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -460,7 +460,9 @@ il3945_build_tx_cmd_basic(struct il_priv *il, struct il_device_cmd *cmd,
  * start C_TX command process
  */
 static int
-il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
+il3945_tx_skb(struct il_priv *il,
+	      struct ieee80211_sta *sta,
+	      struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -512,7 +514,7 @@ il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	hdr_len = ieee80211_hdrlen(fc);
 
 	/* Find idx into station table for destination station */
-	sta_id = il_sta_id_or_broadcast(il, info->control.sta);
+	sta_id = il_sta_id_or_broadcast(il, sta);
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
+	if (il3945_tx_skb(il, control->sta, skb))
 		dev_kfree_skb_any(skb);
 
 	D_MAC80211("leave\n");
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 34f61a0..eac4dc8 100644
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
+			 struct ieee80211_sta *sta,
+			 __le16 fc)
 {
 	const u8 rts_retry_limit = 60;
 	u32 rate_flags;
@@ -1561,9 +1564,7 @@ il4965_tx_cmd_build_rate(struct il_priv *il, struct il_tx_cmd *tx_cmd,
 	rate_idx = info->control.rates[0].idx;
 	if ((info->control.rates[0].flags & IEEE80211_TX_RC_MCS) || rate_idx < 0
 	    || rate_idx > RATE_COUNT_LEGACY)
-		rate_idx =
-		    rate_lowest_index(&il->bands[info->band],
-				      info->control.sta);
+		rate_idx = rate_lowest_index(&il->bands[info->band], sta);
 	/* For 5 GHZ band, remap mac80211 rate indices into driver indices */
 	if (info->band == IEEE80211_BAND_5GHZ)
 		rate_idx += IL_FIRST_OFDM_RATE;
@@ -1630,11 +1631,12 @@ il4965_tx_cmd_build_hwcrypto(struct il_priv *il, struct ieee80211_tx_info *info,
  * start C_TX command process
  */
 int
-il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
+il4965_tx_skb(struct il_priv *il,
+	      struct ieee80211_sta *sta,
+	      struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_sta *sta = info->control.sta;
 	struct il_station_priv *sta_priv = NULL;
 	struct il_tx_queue *txq;
 	struct il_queue *q;
@@ -1680,7 +1682,7 @@ il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 		sta_id = il->hw_params.bcast_id;
 	else {
 		/* Find idx into station table for destination station */
-		sta_id = il_sta_id_or_broadcast(il, info->control.sta);
+		sta_id = il_sta_id_or_broadcast(il, sta);
 
 		if (sta_id == IL_INVALID_STATION) {
 			D_DROP("Dropping - INVALID STATION: %pM\n", hdr->addr1);
@@ -1786,7 +1788,7 @@ il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	/* TODO need this for burst mode later on */
 	il4965_tx_cmd_build_basic(il, skb, tx_cmd, info, hdr, sta_id);
 
-	il4965_tx_cmd_build_rate(il, tx_cmd, info, fc);
+	il4965_tx_cmd_build_rate(il, tx_cmd, info, sta, fc);
 
 	il_update_stats(il, true, fc, len);
 	/*
@@ -5828,7 +5830,9 @@ il4965_mac_stop(struct ieee80211_hw *hw)
 }
 
 void
-il4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+il4965_mac_tx(struct ieee80211_hw *hw,
+	      struct ieee80211_tx_control *control,
+	      struct sk_buff *skb)
 {
 	struct il_priv *il = hw->priv;
 
@@ -5837,7 +5841,7 @@ il4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	D_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 	     ieee80211_get_tx_rate(hw, IEEE80211_SKB_CB(skb))->bitrate);
 
-	if (il4965_tx_skb(il, skb))
+	if (il4965_tx_skb(il, control->sta, skb))
 		dev_kfree_skb_any(skb);
 
 	D_MACDUMP("leave\n");
diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index 1db6776..2d092f3 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -78,7 +78,9 @@ int il4965_hw_txq_attach_buf_to_tfd(struct il_priv *il, struct il_tx_queue *txq,
 int il4965_hw_tx_queue_init(struct il_priv *il, struct il_tx_queue *txq);
 void il4965_hwrate_to_tx_control(struct il_priv *il, u32 rate_n_flags,
 				 struct ieee80211_tx_info *info);
-int il4965_tx_skb(struct il_priv *il, struct sk_buff *skb);
+int il4965_tx_skb(struct il_priv *il,
+		  struct ieee80211_sta *sta,
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
index 9bb16bd..f0b8c1f 100644
--- a/drivers/net/wireless/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/iwlwifi/dvm/agn.h
@@ -201,7 +201,9 @@ void iwl_chswitch_done(struct iwl_priv *priv, bool is_success);
 
 
 /* tx */
-int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb);
+int iwlagn_tx_skb(struct iwl_priv *priv,
+		  struct ieee80211_sta *sta,
+		  struct sk_buff *skb);
 int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn);
 int iwlagn_tx_agg_oper(struct iwl_priv *priv, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index a5f7bce..e64af60 100644
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
+	if (iwlagn_tx_skb(priv, control->sta, skb))
 		dev_kfree_skb_any(skb);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 5971a23..d17799b 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -127,6 +127,7 @@ static void iwlagn_tx_cmd_build_basic(struct iwl_priv *priv,
 static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 				     struct iwl_tx_cmd *tx_cmd,
 				     struct ieee80211_tx_info *info,
+				     struct ieee80211_sta *sta,
 				     __le16 fc)
 {
 	u32 rate_flags;
@@ -187,8 +188,7 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_MCS ||
 			(rate_idx < 0) || (rate_idx > IWL_RATE_COUNT_LEGACY))
 		rate_idx = rate_lowest_index(
-				&priv->eeprom_data->bands[info->band],
-				info->control.sta);
+				&priv->eeprom_data->bands[info->band], sta);
 	/* For 5 GHZ band, remap mac80211 rate indices into driver indices */
 	if (info->band == IEEE80211_BAND_5GHZ)
 		rate_idx += IWL_FIRST_OFDM_RATE;
@@ -291,7 +291,9 @@ static int iwl_sta_id_or_broadcast(struct iwl_rxon_context *context,
 /*
  * start REPLY_TX command process
  */
-int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
+int iwlagn_tx_skb(struct iwl_priv *priv,
+		  struct ieee80211_sta *sta,
+		  struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -345,7 +347,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		sta_id = ctx->bcast_sta_id;
 	else {
 		/* Find index into station table for destination station */
-		sta_id = iwl_sta_id_or_broadcast(ctx, info->control.sta);
+		sta_id = iwl_sta_id_or_broadcast(ctx, sta);
 		if (sta_id == IWL_INVALID_STATION) {
 			IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
 				       hdr->addr1);
@@ -355,8 +357,8 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	IWL_DEBUG_TX(priv, "station Id %d\n", sta_id);
 
-	if (info->control.sta)
-		sta_priv = (void *)info->control.sta->drv_priv;
+	if (sta)
+		sta_priv = (void *)sta->drv_priv;
 
 	if (sta_priv && sta_priv->asleep &&
 	    (info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER)) {
@@ -397,7 +399,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	/* TODO need this for burst mode later on */
 	iwlagn_tx_cmd_build_basic(priv, skb, tx_cmd, info, hdr, sta_id);
 
-	iwlagn_tx_cmd_build_rate(priv, tx_cmd, info, fc);
+	iwlagn_tx_cmd_build_rate(priv, tx_cmd, info, sta, fc);
 
 	memset(&info->status, 0, sizeof(info->status));
 
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index a034572..7001856 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -227,7 +227,9 @@ static void lbtf_free_adapter(struct lbtf_private *priv)
 	lbtf_deb_leave(LBTF_DEB_MAIN);
 }
 
-static void lbtf_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void lbtf_op_tx(struct ieee80211_hw *hw,
+		       struct ieee80211_tx_control *control,
+		       struct sk_buff *skb)
 {
 	struct lbtf_private *priv = hw->priv;
 
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 826ac7b..ff20dbb 100644
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
 
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 224e03a..5099e53 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1830,12 +1830,14 @@ static inline void mwl8k_tx_count_packet(struct ieee80211_sta *sta, u8 tid)
 }
 
 static void
-mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
+mwl8k_txq_xmit(struct ieee80211_hw *hw,
+	       int index,
+	       struct ieee80211_sta *sta,
+	       struct sk_buff *skb)
 {
 	struct mwl8k_priv *priv = hw->priv;
 	struct ieee80211_tx_info *tx_info;
 	struct mwl8k_vif *mwl8k_vif;
-	struct ieee80211_sta *sta;
 	struct ieee80211_hdr *wh;
 	struct mwl8k_tx_queue *txq;
 	struct mwl8k_tx_desc *tx;
@@ -1867,7 +1869,6 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	wh = &((struct mwl8k_dma_data *)skb->data)->wh;
 
 	tx_info = IEEE80211_SKB_CB(skb);
-	sta = tx_info->control.sta;
 	mwl8k_vif = MWL8K_VIF(tx_info->control.vif);
 
 	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
@@ -2019,8 +2020,8 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	tx->pkt_phys_addr = cpu_to_le32(dma);
 	tx->pkt_len = cpu_to_le16(skb->len);
 	tx->rate_info = 0;
-	if (!priv->ap_fw && tx_info->control.sta != NULL)
-		tx->peer_id = MWL8K_STA(tx_info->control.sta)->peer_id;
+	if (!priv->ap_fw && sta != NULL)
+		tx->peer_id = MWL8K_STA(sta)->peer_id;
 	else
 		tx->peer_id = 0;
 
@@ -4364,7 +4365,9 @@ static void mwl8k_rx_poll(unsigned long data)
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
@@ -4376,7 +4379,7 @@ static void mwl8k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		return;
 	}
 
-	mwl8k_txq_xmit(hw, index, skb);
+	mwl8k_txq_xmit(hw, index, control->sta, skb);
 }
 
 static int mwl8k_start(struct ieee80211_hw *hw)
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
index 7cffea7..5e91ad0 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -158,7 +158,7 @@ static int p54_beacon_update(struct p54_common *priv,
 	 * to cancel the old beacon template by hand, instead the firmware
 	 * will release the previous one through the feedback mechanism.
 	 */
-	p54_tx_80211(priv->hw, beacon);
+	p54_tx_80211(priv->hw, NULL, beacon);
 	priv->tsf_high32 = 0;
 	priv->tsf_low32 = 0;
 
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index f38786e..5861e13 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -676,8 +676,9 @@ int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb)
 EXPORT_SYMBOL_GPL(p54_rx);
 
 static void p54_tx_80211_header(struct p54_common *priv, struct sk_buff *skb,
-				struct ieee80211_tx_info *info, u8 *queue,
-				u32 *extra_len, u16 *flags, u16 *aid,
+				struct ieee80211_tx_info *info,
+				struct ieee80211_sta *sta,
+				u8 *queue, u32 *extra_len, u16 *flags, u16 *aid,
 				bool *burst_possible)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -746,8 +747,8 @@ static void p54_tx_80211_header(struct p54_common *priv, struct sk_buff *skb,
 			}
 		}
 
-		if (info->control.sta)
-			*aid = info->control.sta->aid;
+		if (sta)
+			*aid = sta->aid;
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
+	p54_tx_80211_header(priv, skb, info, control->sta, &queue, &extra_len,
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
index a6b88bd..a59048f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -194,7 +194,7 @@ static void rt2x00lib_bc_buffer_iter(void *data, u8 *mac,
 	 */
 	skb = ieee80211_get_buffered_bc(rt2x00dev->hw, vif);
 	while (skb) {
-		rt2x00mac_tx(rt2x00dev->hw, skb);
+		rt2x00mac_tx(rt2x00dev->hw, NULL, skb);
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
index f7e74a0..e488b94 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -315,6 +315,7 @@ static void rt2x00queue_create_tx_descriptor_plcp(struct rt2x00_dev *rt2x00dev,
 static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 						struct sk_buff *skb,
 						struct txentry_desc *txdesc,
+						struct ieee80211_sta *sta,
 						const struct rt2x00_rate *hwrate)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
@@ -322,11 +323,11 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct rt2x00_sta *sta_priv = NULL;
 
-	if (tx_info->control.sta) {
+	if (sta) {
 		txdesc->u.ht.mpdu_density =
-		    tx_info->control.sta->ht_cap.ampdu_density;
+		    sta->ht_cap.ampdu_density;
 
-		sta_priv = sta_to_rt2x00_sta(tx_info->control.sta);
+		sta_priv = sta_to_rt2x00_sta(sta);
 		txdesc->u.ht.wcid = sta_priv->wcid;
 	}
 
@@ -341,8 +342,8 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 		 * MIMO PS should be set to 1 for STA's using dynamic SM PS
 		 * when using more then one tx stream (>MCS7).
 		 */
-		if (tx_info->control.sta && txdesc->u.ht.mcs > 7 &&
-		    ((tx_info->control.sta->ht_cap.cap &
+		if (sta && txdesc->u.ht.mcs > 7 &&
+		    ((sta->ht_cap.cap &
 		      IEEE80211_HT_CAP_SM_PS) >>
 		     IEEE80211_HT_CAP_SM_PS_SHIFT) ==
 		    WLAN_HT_CAP_SM_PS_DYNAMIC)
@@ -409,7 +410,8 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 
 static void rt2x00queue_create_tx_descriptor(struct rt2x00_dev *rt2x00dev,
 					     struct sk_buff *skb,
-					     struct txentry_desc *txdesc)
+					     struct txentry_desc *txdesc,
+					     struct ieee80211_sta *sta)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -503,7 +505,7 @@ static void rt2x00queue_create_tx_descriptor(struct rt2x00_dev *rt2x00dev,
 
 	if (test_bit(REQUIRE_HT_TX_DESC, &rt2x00dev->cap_flags))
 		rt2x00queue_create_tx_descriptor_ht(rt2x00dev, skb, txdesc,
-						    hwrate);
+						   sta, hwrate);
 	else
 		rt2x00queue_create_tx_descriptor_plcp(rt2x00dev, skb, txdesc,
 						      hwrate);
@@ -595,7 +597,7 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	 * after that we are free to use the skb->cb array
 	 * for our information.
 	 */
-	rt2x00queue_create_tx_descriptor(queue->rt2x00dev, skb, &txdesc);
+	rt2x00queue_create_tx_descriptor(queue->rt2x00dev, skb, &txdesc, NULL);
 
 	/*
 	 * All information is retrieved from the skb->cb array,
@@ -740,7 +742,7 @@ int rt2x00queue_update_beacon_locked(struct rt2x00_dev *rt2x00dev,
 	 * after that we are free to use the skb->cb array
 	 * for our information.
 	 */
-	rt2x00queue_create_tx_descriptor(rt2x00dev, intf->beacon->skb, &txdesc);
+	rt2x00queue_create_tx_descriptor(rt2x00dev, intf->beacon->skb, &txdesc, NULL);
 
 	/*
 	 * Fill in skb descriptor
diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 3b50539..fd8fcbd 100644
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
@@ -710,7 +712,7 @@ static void rtl8180_beacon_work(struct work_struct *work)
 	/* TODO: use actual beacon queue */
 	skb_set_queue_mapping(skb, 0);
 
-	rtl8180_tx(dev, skb);
+	rtl8180_tx(dev, NULL, skb);
 
 resched:
 	/*
diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index 4fb1ca1..c7bfcf3 100644
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
@@ -1076,7 +1078,7 @@ static void rtl8187_beacon_work(struct work_struct *work)
 	/* TODO: use actual beacon queue */
 	skb_set_queue_mapping(skb, 0);
 
-	rtl8187_tx(dev, skb);
+	rtl8187_tx(dev, NULL, skb);
 
 resched:
 	/*
diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index 41f7f12..1b2ffdb 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -1341,9 +1341,8 @@ int rtl_send_smps_action(struct ieee80211_hw *hw,
 		rtlpriv->cfg->ops->update_rate_tbl(hw, sta, 0);
 
 		info->control.rates[0].idx = 0;
-		info->control.sta = sta;
 		info->band = hw->conf.channel->band;
-		rtlpriv->intf_ops->adapter_tx(hw, skb, &tcb_desc);
+		rtlpriv->intf_ops->adapter_tx(hw, sta, skb, &tcb_desc);
 	}
 err_free:
 	return 0;
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 278e9f9..db903fd 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -124,7 +124,9 @@ static void rtl_op_stop(struct ieee80211_hw *hw)
 	mutex_unlock(&rtlpriv->locks.conf_mutex);
 }
 
-static void rtl_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void rtl_op_tx(struct ieee80211_hw *hw,
+		      struct ieee80211_tx_control *control,
+		      struct sk_buff *skb)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -138,8 +140,8 @@ static void rtl_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (!test_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status))
 		goto err_free;
 
-	if (!rtlpriv->intf_ops->waitq_insert(hw, skb))
-		rtlpriv->intf_ops->adapter_tx(hw, skb, &tcb_desc);
+	if (!rtlpriv->intf_ops->waitq_insert(hw, control->sta, skb))
+		rtlpriv->intf_ops->adapter_tx(hw, control->sta, skb, &tcb_desc);
 
 	return;
 
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 2c6eb9e..0bde0ce 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -504,7 +504,7 @@ static void _rtl_pci_tx_chk_waitq(struct ieee80211_hw *hw)
 				_rtl_update_earlymode_info(hw, skb,
 							   &tcb_desc, tid);
 
-			rtlpriv->intf_ops->adapter_tx(hw, skb, &tcb_desc);
+			rtlpriv->intf_ops->adapter_tx(hw, NULL, skb, &tcb_desc);
 		}
 	}
 }
@@ -929,7 +929,7 @@ static void _rtl_pci_prepare_bcn_tasklet(struct ieee80211_hw *hw)
 	info = IEEE80211_SKB_CB(pskb);
 	pdesc = &ring->desc[0];
 	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, (u8 *) pdesc,
-		info, pskb, BEACON_QUEUE, &tcb_desc);
+		info, NULL, pskb, BEACON_QUEUE, &tcb_desc);
 
 	__skb_queue_tail(&ring->queue, pskb);
 
@@ -1305,11 +1305,10 @@ int rtl_pci_reset_trx_ring(struct ieee80211_hw *hw)
 }
 
 static bool rtl_pci_tx_chk_waitq_insert(struct ieee80211_hw *hw,
+					struct ieee80211_sta *sta,
 					struct sk_buff *skb)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_sta *sta = info->control.sta;
 	struct rtl_sta_info *sta_entry = NULL;
 	u8 tid = rtl_get_tid(skb);
 
@@ -1337,13 +1336,14 @@ static bool rtl_pci_tx_chk_waitq_insert(struct ieee80211_hw *hw,
 	return true;
 }
 
-static int rtl_pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
-		struct rtl_tcb_desc *ptcb_desc)
+static int rtl_pci_tx(struct ieee80211_hw *hw,
+		      struct ieee80211_sta *sta,
+		      struct sk_buff *skb,
+		      struct rtl_tcb_desc *ptcb_desc)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_sta_info *sta_entry = NULL;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_sta *sta = info->control.sta;
 	struct rtl8192_tx_ring *ring;
 	struct rtl_tx_desc *pdesc;
 	u8 idx;
@@ -1418,7 +1418,7 @@ static int rtl_pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		rtlpriv->cfg->ops->led_control(hw, LED_CTL_TX);
 
 	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, (u8 *)pdesc,
-			info, skb, hw_queue, ptcb_desc);
+			info, sta, skb, hw_queue, ptcb_desc);
 
 	__skb_queue_tail(&ring->queue, skb);
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
index 3af874e..1b13001 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -596,7 +596,9 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 
 void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
-			  struct ieee80211_tx_info *info, struct sk_buff *skb,
+			  struct ieee80211_tx_info *info,
+			  struct ieee80211_sta *sta,
+			  struct sk_buff *skb,
 			  u8 hw_queue, struct rtl_tcb_desc *tcb_desc)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -604,7 +606,6 @@ void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	bool defaultadapter = true;
-	struct ieee80211_sta *sta;
 	u8 *pdesc = (u8 *) pdesc_tx;
 	u16 seq_number;
 	__le16 fc = hdr->frame_control;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
index c4adb97..a7cdd51 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
@@ -713,6 +713,7 @@ struct rx_desc_92c {
 void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr,
 			  u8 *pdesc, struct ieee80211_tx_info *info,
+			  struct ieee80211_sta *sta,
 			  struct sk_buff *skb, u8 hw_queue,
 			  struct rtl_tcb_desc *ptcb_desc);
 bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index 21bc827..bb528a7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -496,7 +496,9 @@ static void _rtl_tx_desc_checksum(u8 *txdesc)
 
 void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
-			  struct ieee80211_tx_info *info, struct sk_buff *skb,
+			  struct ieee80211_tx_info *info,
+			  struct ieee80211_sta *sta,
+			  struct sk_buff *skb,
 			  u8 queue_index,
 			  struct rtl_tcb_desc *tcb_desc)
 {
@@ -504,7 +506,6 @@ void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	bool defaultadapter = true;
-	struct ieee80211_sta *sta = info->control.sta = info->control.sta;
 	u8 *qc = ieee80211_get_qos_ctl(hdr);
 	u8 tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
 	u16 seq_number;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
index 332b06e..725c53a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
@@ -420,7 +420,9 @@ struct sk_buff *rtl8192c_tx_aggregate_hdl(struct ieee80211_hw *,
 					   struct sk_buff_head *);
 void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
-			  struct ieee80211_tx_info *info, struct sk_buff *skb,
+			  struct ieee80211_tx_info *info,
+			  struct ieee80211_sta *sta,
+			  struct sk_buff *skb,
 			  u8 queue_index,
 			  struct rtl_tcb_desc *tcb_desc);
 void rtl92cu_fill_fake_txdesc(struct ieee80211_hw *hw, u8 * pDesc,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
index 1666ef7..323450e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
@@ -551,7 +551,9 @@ static void _rtl92de_insert_emcontent(struct rtl_tcb_desc *ptcb_desc,
 
 void rtl92de_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr, u8 *pdesc_tx,
-			  struct ieee80211_tx_info *info, struct sk_buff *skb,
+			  struct ieee80211_tx_info *info,
+			  struct ieee80211_sta *sta,
+			  struct sk_buff *skb,
 			  u8 hw_queue, struct rtl_tcb_desc *ptcb_desc)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -559,7 +561,6 @@ void rtl92de_tx_fill_desc(struct ieee80211_hw *hw,
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	struct ieee80211_sta *sta = info->control.sta;
 	u8 *pdesc = (u8 *) pdesc_tx;
 	u16 seq_number;
 	__le16 fc = hdr->frame_control;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/trx.h b/drivers/net/wireless/rtlwifi/rtl8192de/trx.h
index 057a524..c1b5dfb 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/trx.h
@@ -730,6 +730,7 @@ struct rx_desc_92d {
 void rtl92de_tx_fill_desc(struct ieee80211_hw *hw,
 			  struct ieee80211_hdr *hdr,
 			  u8 *pdesc, struct ieee80211_tx_info *info,
+			  struct ieee80211_sta *sta,
 			  struct sk_buff *skb, u8 hw_queue,
 			  struct rtl_tcb_desc *ptcb_desc);
 bool rtl92de_rx_query_desc(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index 812b585..55cb73f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -591,14 +591,15 @@ bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 
 void rtl92se_tx_fill_desc(struct ieee80211_hw *hw,
 		struct ieee80211_hdr *hdr, u8 *pdesc_tx,
-		struct ieee80211_tx_info *info, struct sk_buff *skb,
+		struct ieee80211_tx_info *info,
+		struct ieee80211_sta *sta,
+		struct sk_buff *skb,
 		u8 hw_queue, struct rtl_tcb_desc *ptcb_desc)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	struct ieee80211_sta *sta = info->control.sta;
 	u8 *pdesc = (u8 *) pdesc_tx;
 	u16 seq_number;
 	__le16 fc = hdr->frame_control;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.h b/drivers/net/wireless/rtlwifi/rtl8192se/trx.h
index 011e7b0..64dd66f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.h
@@ -31,6 +31,7 @@
 
 void rtl92se_tx_fill_desc(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
 			  u8 *pdesc, struct ieee80211_tx_info *info,
+			  struct ieee80211_sta *sta,
 			  struct sk_buff *skb, u8 hw_queue,
 			  struct rtl_tcb_desc *ptcb_desc);
 void rtl92se_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc, bool firstseg,
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index aa970fc..9140469 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -848,8 +848,10 @@ static void _rtl_usb_transmit(struct ieee80211_hw *hw, struct sk_buff *skb,
 	_rtl_submit_tx_urb(hw, _urb);
 }
 
-static void _rtl_usb_tx_preprocess(struct ieee80211_hw *hw, struct sk_buff *skb,
-			    u16 hw_queue)
+static void _rtl_usb_tx_preprocess(struct ieee80211_hw *hw,
+				   struct ieee80211_sta *sta,
+				   struct sk_buff *skb,
+				   u16 hw_queue)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
@@ -891,7 +893,7 @@ static void _rtl_usb_tx_preprocess(struct ieee80211_hw *hw, struct sk_buff *skb,
 		seq_number += 1;
 		seq_number <<= 4;
 	}
-	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, (u8 *)pdesc, info, skb,
+	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, (u8 *)pdesc, info, sta, skb,
 					hw_queue, &tcb_desc);
 	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		if (qc)
@@ -901,7 +903,9 @@ static void _rtl_usb_tx_preprocess(struct ieee80211_hw *hw, struct sk_buff *skb,
 		rtlpriv->cfg->ops->led_control(hw, LED_CTL_TX);
 }
 
-static int rtl_usb_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
+static int rtl_usb_tx(struct ieee80211_hw *hw,
+		      struct ieee80211_sta *sta,
+		      struct sk_buff *skb,
 		      struct rtl_tcb_desc *dummy)
 {
 	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
@@ -913,7 +917,7 @@ static int rtl_usb_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	if (unlikely(is_hal_stop(rtlhal)))
 		goto err_free;
 	hw_queue = rtlusb->usb_mq_to_hwq(fc, skb_get_queue_mapping(skb));
-	_rtl_usb_tx_preprocess(hw, skb, hw_queue);
+	_rtl_usb_tx_preprocess(hw, sta, skb, hw_queue);
 	_rtl_usb_transmit(hw, skb, hw_queue);
 	return NETDEV_TX_OK;
 
@@ -923,6 +927,7 @@ err_free:
 }
 
 static bool rtl_usb_tx_chk_waitq_insert(struct ieee80211_hw *hw,
+					struct ieee80211_sta *sta,
 					struct sk_buff *skb)
 {
 	return false;
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index cdaa21f..40153e7 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -122,7 +122,7 @@ enum rt_eeprom_type {
 	EEPROM_BOOT_EFUSE,
 };
 
-enum rtl_status {
+enum ttl_status {
 	RTL_STATUS_INTERFACE_START = 0,
 };
 
@@ -1418,6 +1418,7 @@ struct rtl_hal_ops {
 	void (*fill_tx_desc) (struct ieee80211_hw *hw,
 			      struct ieee80211_hdr *hdr, u8 *pdesc_tx,
 			      struct ieee80211_tx_info *info,
+			      struct ieee80211_sta *sta,
 			      struct sk_buff *skb, u8 hw_queue,
 			      struct rtl_tcb_desc *ptcb_desc);
 	void (*fill_fake_txdesc) (struct ieee80211_hw *hw, u8 *pDesc,
@@ -1475,11 +1476,15 @@ struct rtl_intf_ops {
 	int (*adapter_start) (struct ieee80211_hw *hw);
 	void (*adapter_stop) (struct ieee80211_hw *hw);
 
-	int (*adapter_tx) (struct ieee80211_hw *hw, struct sk_buff *skb,
-			struct rtl_tcb_desc *ptcb_desc);
+	int (*adapter_tx) (struct ieee80211_hw *hw,
+			   struct ieee80211_sta *sta,
+			   struct sk_buff *skb,
+			   struct rtl_tcb_desc *ptcb_desc);
 	void (*flush)(struct ieee80211_hw *hw, bool drop);
 	int (*reset_trx_ring) (struct ieee80211_hw *hw);
-	bool (*waitq_insert) (struct ieee80211_hw *hw, struct sk_buff *skb);
+	bool (*waitq_insert) (struct ieee80211_hw *hw,
+			      struct ieee80211_sta *sta,
+			      struct sk_buff *skb);
 
 	/*pci */
 	void (*disable_aspm) (struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 3118c42..441cbcc 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -354,7 +354,9 @@ out:
 	return ret;
 }
 
-static void wl1251_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void wl1251_op_tx(struct ieee80211_hw *hw,
+			 struct ieee80211_tx_control *control,
+			 struct sk_buff *skb)
 {
 	struct wl1251 *wl = hw->priv;
 	unsigned long flags;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 9f04b64..cbce2ea 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1166,7 +1166,9 @@ out:
 	return ret;
 }
 
-static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static void wl1271_op_tx(struct ieee80211_hw *hw,
+			 struct ieee80211_tx_control *control,
+			 struct sk_buff *skb)
 {
 	struct wl1271 *wl = hw->priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1182,7 +1184,7 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	mapping = skb_get_queue_mapping(skb);
 	q = wl1271_tx_get_queue(mapping);
 
-	hlid = wl12xx_tx_get_hlid(wl, wlvif, skb);
+	hlid = wl12xx_tx_get_hlid(wl, wlvif, sta, skb);
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
 
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 6a28aee..2027d70 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -131,15 +131,15 @@ bool wl12xx_is_dummy_packet(struct wl1271 *wl, struct sk_buff *skb)
 EXPORT_SYMBOL(wl12xx_is_dummy_packet);
 
 u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-			 struct sk_buff *skb)
+			 struct ieee80211_sta *sta, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *control = IEEE80211_SKB_CB(skb);
 
-	if (control->control.sta) {
+	if (sta) {
 		struct wl1271_station *wl_sta;
 
 		wl_sta = (struct wl1271_station *)
-				control->control.sta->drv_priv;
+				sta->drv_priv;
 		return wl_sta->hlid;
 	} else {
 		struct ieee80211_hdr *hdr;
@@ -164,7 +164,7 @@ u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		return wl->system_hlid;
 
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
-		return wl12xx_tx_get_hlid_ap(wl, wlvif, skb);
+		return wl12xx_tx_get_hlid_ap(wl, wlvif, sta, skb);
 
 	if ((test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags) ||
 	     test_bit(WLVIF_FLAG_IBSS_JOINED, &wlvif->flags)) &&
@@ -256,7 +256,9 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	__le16 frame_control;
 	struct ieee80211_hdr *hdr;
 	u8 *frame_start;
-	bool is_dummy;
+	bool is_dummy;i
+	struct ieee80211_sta *sta,
+	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 
 	desc = (struct wl1271_tx_hw_descr *) skb->data;
 	frame_start = (u8 *)(desc + 1);
@@ -310,14 +312,19 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		 * send them with AP rate policies (EAPOLs are an exception),
 		 * otherwise use default basic rates
 		 */
+
+		rcu_read_lock();
+		sta = ieee80211_find_sta(vif, wl->links[hlid].addr);
+
 		if (control->flags & IEEE80211_TX_CTL_NO_CCK_RATE)
 			rate_idx = wlvif->sta.p2p_rate_idx;
 		else if (skb->protocol == cpu_to_be16(ETH_P_PAE))
 			rate_idx = wlvif->sta.basic_rate_idx;
-		else if (control->control.sta)
+		else if (sta)
 			rate_idx = wlvif->sta.ap_rate_idx;
 		else
 			rate_idx = wlvif->sta.basic_rate_idx;
+		rcu_read_unlock();
 	} else {
 		if (hlid == wlvif->ap.global_hlid)
 			rate_idx = wlvif->ap.mgmt_rate_idx;
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index c9e2660..4598801 100644
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
@@ -1176,7 +1178,7 @@ static void zd_beacon_done(struct zd_mac *mac)
 		skb = ieee80211_get_buffered_bc(mac->hw, mac->vif);
 		if (!skb)
 			break;
-		zd_op_tx(mac->hw, skb);
+		zd_op_tx(mac->hw, NULL, skb);
 	}
 
 	/*
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index c3751a7..c6566e5 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -119,7 +119,9 @@ static void wbsoft_configure_filter(struct ieee80211_hw *dev,
 	*total_flags = new_flags;
 }
 
-static void wbsoft_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
+static void wbsoft_tx(struct ieee80211_hw *dev,
+		      struct ieee80211_tx_control *control,
+		      struct sk_buff *skb)
 {
 	struct wbsoft_priv *priv = dev->priv;
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index bb86aa6..4309d8a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -522,9 +522,6 @@ struct ieee80211_tx_rate {
  *  (2) driver internal use (if applicable)
  *  (3) TX status information - driver tells mac80211 what happened
  *
- * The TX control's sta pointer is only valid during the ->tx call,
- * it may be NULL.
- *
  * @flags: transmit info flags, defined above
  * @band: the band to transmit on (use for checking for races)
  * @hw_queue: HW queue to put the frame on, skb_get_queue_mapping() gives the AC
@@ -555,6 +552,7 @@ struct ieee80211_tx_info {
 					struct ieee80211_tx_rate rates[
 						IEEE80211_TX_MAX_RATES];
 					s8 rts_cts_rate_idx;
+					/* 3 bytes free */
 				};
 				/* only needed before rate control */
 				unsigned long jiffies;
@@ -562,7 +560,7 @@ struct ieee80211_tx_info {
 			/* NB: vif can be NULL for injected frames */
 			struct ieee80211_vif *vif;
 			struct ieee80211_key_conf *hw_key;
-			struct ieee80211_sta *sta;
+			/* 8 bytes free */
 		} control;
 		struct {
 			struct ieee80211_tx_rate rates[IEEE80211_TX_MAX_RATES];
@@ -1074,6 +1072,16 @@ enum sta_notify_cmd {
 };
 
 /**
+ * struct ieee80211_tx_control - TX control data
+ *
+ * @sta: station table entry, this sta pointer may be NULL and
+ * 	it is not allowed to copy the pointer, due to RCU.
+ */
+struct ieee80211_tx_control {
+	struct ieee80211_sta *sta;
+};
+
+/**
  * enum ieee80211_hw_flags - hardware flags
  *
  * These flags are used to indicate hardware capabilities to
@@ -2264,7 +2272,9 @@ enum ieee80211_rate_control_changed {
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
index 7998513..6258da6 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -196,6 +196,8 @@ struct ieee80211_tx_data {
 	struct ieee80211_channel *channel;
 
 	unsigned int flags;
+
+	struct ieee80211_tx_control control;
 };
 
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index acf712f..7706f01 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1201,6 +1201,7 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 static bool ieee80211_tx_frags(struct ieee80211_local *local,
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_sta *sta,
+			       struct ieee80211_tx_control *control,
 			       struct sk_buff_head *skbs,
 			       bool txpending)
 {
@@ -1240,10 +1241,10 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
 		info->control.vif = vif;
-		info->control.sta = sta;
+		control->sta = sta;
 
 		__skb_unlink(skb, skbs);
-		drv_tx(local, skb);
+		drv_tx(local, control, skb);
 	}
 
 	return true;
@@ -1253,6 +1254,7 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
  * Returns false if the frame couldn't be transmitted but was queued instead.
  */
 static bool __ieee80211_tx(struct ieee80211_local *local,
+			   struct ieee80211_tx_control *control,
 			   struct sk_buff_head *skbs, int led_len,
 			   struct sta_info *sta, bool txpending)
 {
@@ -1301,7 +1303,7 @@ static bool __ieee80211_tx(struct ieee80211_local *local,
 		break;
 	}
 
-	result = ieee80211_tx_frags(local, vif, pubsta, skbs,
+	result = ieee80211_tx_frags(local, vif, pubsta, control, skbs,
 				    txpending);
 
 	ieee80211_tpt_led_trig_tx(local, fc, led_len);
@@ -1409,7 +1411,7 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 			sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
 
 	if (!invoke_tx_handlers(&tx))
-		result = __ieee80211_tx(local, &tx.skbs, led_len,
+		result = __ieee80211_tx(local, &tx.control, &tx.skbs, led_len,
 					tx.sta, txpending);
  out:
 	rcu_read_unlock();
@@ -2154,6 +2156,7 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	struct ieee80211_hdr *hdr;
+	struct ieee80211_tx_control control;
 	bool result;
 
 	sdata = vif_to_sdata(info->control.vif);
@@ -2169,7 +2172,7 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 		hdr = (struct ieee80211_hdr *)skb->data;
 		sta = sta_info_get(sdata, hdr->addr1);
 
-		result = __ieee80211_tx(local, &skbs, skb->len, sta, true);
+		result = __ieee80211_tx(local, &control, &skbs, skb->len, sta, true);
 	}
 
 	return result;
-- 
1.7.11.1

