Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:33860 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbbL3OGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 09:06:14 -0500
Received: by mail-wm0-f51.google.com with SMTP id u188so40392906wmu.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 06:06:13 -0800 (PST)
From: Sara Sharon <sarasharon1@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>
Subject: [PATCH v2] mac80211: pass block ack session timeout to to driver
Date: Wed, 30 Dec 2015 16:06:04 +0200
Message-Id: <1451484364-23565-1-git-send-email-sara.sharon@intel.com> (sfid-20151230_150623_338334_10B793AD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently mac80211 does not inform the driver of the session
block ack timeout when starting a rx aggregation session.
Drivers that manage the reorder buffer need to know this
parameter.
Seeing that there are now too many arguments for the
drv_ampdu_action() function, wrap them inside a structure.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
---
v2: fix all the users of the API
---
 drivers/net/wireless/ath/ath10k/mac.c              |  7 +--
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |  7 +--
 drivers/net/wireless/ath/ath9k/main.c              |  8 ++--
 drivers/net/wireless/ath/carl9170/main.c           |  8 ++--
 drivers/net/wireless/ath/wcn36xx/main.c            |  8 ++--
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  8 ++--
 drivers/net/wireless/cw1200/sta.c                  |  4 +-
 drivers/net/wireless/cw1200/sta.h                  |  4 +-
 drivers/net/wireless/iwlegacy/4965-mac.c           |  8 ++--
 drivers/net/wireless/iwlegacy/4965.h               |  4 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |  9 ++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        | 10 ++--
 drivers/net/wireless/mac80211_hwsim.c              |  8 ++--
 drivers/net/wireless/mediatek/mt7601u/main.c       |  8 ++--
 drivers/net/wireless/mwl8k.c                       | 10 ++--
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c   |  6 +--
 drivers/net/wireless/realtek/rtlwifi/core.c        |  8 ++--
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        | 19 +++-----
 drivers/net/wireless/rt2x00/rt2800lib.c            |  7 +--
 drivers/net/wireless/rt2x00/rt2800lib.h            |  4 +-
 drivers/net/wireless/ti/wlcore/main.c              |  8 ++--
 include/net/mac80211.h                             | 44 ++++++++++++------
 net/mac80211/agg-rx.c                              | 25 ++++++++--
 net/mac80211/agg-tx.c                              | 53 ++++++++++++++--------
 net/mac80211/driver-ops.c                          | 10 ++--
 net/mac80211/driver-ops.h                          |  4 +-
 net/mac80211/trace.h                               | 41 +++++++++--------
 27 files changed, 201 insertions(+), 139 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a7411fe..4f53576 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6348,12 +6348,13 @@ static u64 ath10k_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 static int ath10k_ampdu_action(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
-			       enum ieee80211_ampdu_mlme_action action,
-			       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			       u8 buf_size, bool amsdu)
+			       struct ieee80211_ampdu_params *params)
 {
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
 
 	ath10k_dbg(ar, ATH10K_DBG_MAC, "mac ampdu vdev_id %i sta %pM tid %hu action %d\n",
 		   arvif->vdev_id, sta->addr, tid, action);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index a680a97..e428143 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1657,13 +1657,14 @@ static void ath9k_htc_reset_tsf(struct ieee80211_hw *hw,
 
 static int ath9k_htc_ampdu_action(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif,
-				  enum ieee80211_ampdu_mlme_action action,
-				  struct ieee80211_sta *sta,
-				  u16 tid, u16 *ssn, u8 buf_size, bool amsdu)
+				  struct ieee80211_ampdu_params *params)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
 	struct ath9k_htc_sta *ista;
 	int ret = 0;
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
 
 	mutex_lock(&priv->mutex);
 	ath9k_htc_ps_wakeup(priv);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index d184e68..5cc0ddc 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1860,14 +1860,16 @@ static void ath9k_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
-			      enum ieee80211_ampdu_mlme_action action,
-			      struct ieee80211_sta *sta,
-			      u16 tid, u16 *ssn, u8 buf_size, bool amsdu)
+			      struct ieee80211_ampdu_params *params)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	bool flush = false;
 	int ret = 0;
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
+	u16 *ssn = &params->ssn;
 
 	mutex_lock(&sc->mutex);
 
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 19d3d64..4d1527a 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1413,10 +1413,12 @@ static void carl9170_ampdu_work(struct work_struct *work)
 
 static int carl9170_op_ampdu_action(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
-				    enum ieee80211_ampdu_mlme_action action,
-				    struct ieee80211_sta *sta,
-				    u16 tid, u16 *ssn, u8 buf_size, bool amsdu)
+				    struct ieee80211_ampdu_params *params)
 {
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
+	u16 *ssn = &params->ssn;
 	struct ar9170 *ar = hw->priv;
 	struct carl9170_sta_info *sta_info = (void *) sta->drv_priv;
 	struct carl9170_sta_tid *tid_info;
diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 7c169ab..a27279c 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -857,12 +857,14 @@ static int wcn36xx_resume(struct ieee80211_hw *hw)
 
 static int wcn36xx_ampdu_action(struct ieee80211_hw *hw,
 		    struct ieee80211_vif *vif,
-		    enum ieee80211_ampdu_mlme_action action,
-		    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-		    u8 buf_size, bool amsdu)
+		    struct ieee80211_ampdu_params *params)
 {
 	struct wcn36xx *wcn = hw->priv;
 	struct wcn36xx_sta *sta_priv = NULL;
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
+	u16 *ssn = &params->ssn;
 
 	wcn36xx_dbg(WCN36XX_DBG_MAC, "mac ampdu action action %d tid %d\n",
 		    action, tid);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index bec2dc1..61ae276 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -818,13 +818,15 @@ brcms_ops_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 static int
 brcms_ops_ampdu_action(struct ieee80211_hw *hw,
 		    struct ieee80211_vif *vif,
-		    enum ieee80211_ampdu_mlme_action action,
-		    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-		    u8 buf_size, bool amsdu)
+		    struct ieee80211_ampdu_params *params)
 {
 	struct brcms_info *wl = hw->priv;
 	struct scb *scb = &wl->wlc->pri_scb;
 	int status;
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
+	u8 buf_size = params->buf_size;
 
 	if (WARN_ON(scb->magic != SCB_MAGIC))
 		return -EIDRM;
diff --git a/drivers/net/wireless/cw1200/sta.c b/drivers/net/wireless/cw1200/sta.c
index 95a7fdb..c602a1e 100644
--- a/drivers/net/wireless/cw1200/sta.c
+++ b/drivers/net/wireless/cw1200/sta.c
@@ -2135,9 +2135,7 @@ void cw1200_mcast_timeout(unsigned long arg)
 
 int cw1200_ampdu_action(struct ieee80211_hw *hw,
 			struct ieee80211_vif *vif,
-			enum ieee80211_ampdu_mlme_action action,
-			struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			u8 buf_size, bool amsdu)
+			struct ieee80211_ampdu_params *params)
 {
 	/* Aggregation is implemented fully in firmware,
 	 * including block ack negotiation. Do not allow
diff --git a/drivers/net/wireless/cw1200/sta.h b/drivers/net/wireless/cw1200/sta.h
index bebb337..a0bacaa 100644
--- a/drivers/net/wireless/cw1200/sta.h
+++ b/drivers/net/wireless/cw1200/sta.h
@@ -109,9 +109,7 @@ void cw1200_bss_info_changed(struct ieee80211_hw *dev,
 			     u32 changed);
 int cw1200_ampdu_action(struct ieee80211_hw *hw,
 			struct ieee80211_vif *vif,
-			enum ieee80211_ampdu_mlme_action action,
-			struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			u8 buf_size, bool amsdu);
+			struct ieee80211_ampdu_params *params);
 
 void cw1200_suspend_resume(struct cw1200_common *priv,
 			  struct wsm_suspend_resume *arg);
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 6656215..04b0349 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5982,12 +5982,14 @@ il4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 int
 il4965_mac_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			enum ieee80211_ampdu_mlme_action action,
-			struct ieee80211_sta *sta, u16 tid, u16 * ssn,
-			u8 buf_size, bool amsdu)
+			struct ieee80211_ampdu_params *params)
 {
 	struct il_priv *il = hw->priv;
 	int ret = -EINVAL;
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
+	u16 *ssn = &params->ssn;
 
 	D_HT("A-MPDU action on addr %pM tid %d\n", sta->addr, tid);
 
diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index 8ab8706..e432715 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -182,9 +182,7 @@ void il4965_mac_update_tkip_key(struct ieee80211_hw *hw,
 				struct ieee80211_sta *sta, u32 iv32,
 				u16 *phase1key);
 int il4965_mac_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			    enum ieee80211_ampdu_mlme_action action,
-			    struct ieee80211_sta *sta, u16 tid, u16 * ssn,
-			    u8 buf_size, bool amsdu);
+			    struct ieee80211_ampdu_params *params);
 int il4965_mac_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta);
 void
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index b3ad34e..1eb1a82 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -729,12 +729,15 @@ static inline bool iwl_enable_tx_ampdu(const struct iwl_cfg *cfg)
 
 static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
-				   enum ieee80211_ampdu_mlme_action action,
-				   struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-				   u8 buf_size, bool amsdu)
+				   struct ieee80211_ampdu_params *params)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	int ret = -EINVAL;
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
+	u16 *ssn = &params->ssn;
+	u8 buf_size = params->buf_size;
 	struct iwl_station_priv *sta_priv = (void *) sta->drv_priv;
 
 	IWL_DEBUG_HT(priv, "A-MPDU action on addr %pM tid %d\n",
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 1fb6846..3b124cf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -826,13 +826,17 @@ iwl_mvm_ampdu_check_trigger(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
-				    enum ieee80211_ampdu_mlme_action action,
-				    struct ieee80211_sta *sta, u16 tid,
-				    u16 *ssn, u8 buf_size, bool amsdu)
+				    struct ieee80211_ampdu_params *params)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	int ret;
 	bool tx_agg_ref = false;
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
+	u16 *ssn = &params->ssn;
+	u8 buf_size = params->buf_size;
+	bool amsdu = params->amsdu;
 
 	IWL_DEBUG_HT(mvm, "A-MPDU action on addr %pM tid %d: action %d\n",
 		     sta->addr, tid, action);
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index c32889a..e31a94f 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1845,10 +1845,12 @@ static int mac80211_hwsim_testmode_cmd(struct ieee80211_hw *hw,
 
 static int mac80211_hwsim_ampdu_action(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
-				       enum ieee80211_ampdu_mlme_action action,
-				       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-				       u8 buf_size, bool amsdu)
+				       struct ieee80211_ampdu_params *params)
 {
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
+
 	switch (action) {
 	case IEEE80211_AMPDU_TX_START:
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
diff --git a/drivers/net/wireless/mediatek/mt7601u/main.c b/drivers/net/wireless/mediatek/mt7601u/main.c
index f715eee..e70dd95 100644
--- a/drivers/net/wireless/mediatek/mt7601u/main.c
+++ b/drivers/net/wireless/mediatek/mt7601u/main.c
@@ -334,11 +334,13 @@ static int mt7601u_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 
 static int
 mt76_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		  enum ieee80211_ampdu_mlme_action action,
-		  struct ieee80211_sta *sta, u16 tid, u16 *ssn, u8 buf_size,
-		  bool amsdu)
+		  struct ieee80211_ampdu_params *params)
 {
 	struct mt7601u_dev *dev = hw->priv;
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
+	u16 *ssn = &params->ssn;
 	struct mt76_sta *msta = (struct mt76_sta *) sta->drv_priv;
 
 	WARN_ON(msta->wcid.idx > GROUP_WCID(0));
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 30e3aaa..088429d 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -5421,11 +5421,13 @@ static int mwl8k_get_survey(struct ieee80211_hw *hw, int idx,
 
 static int
 mwl8k_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		   enum ieee80211_ampdu_mlme_action action,
-		   struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-		   u8 buf_size, bool amsdu)
+		   struct ieee80211_ampdu_params *params)
 {
-
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
+	u16 *ssn = &params->ssn;
+	u8 buf_size = params->buf_size;
 	int i, rc = 0;
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_ampdu_stream *stream;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 6aed923..7d820c3 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5375,13 +5375,13 @@ static int rtl8xxxu_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 static int
 rtl8xxxu_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		      enum ieee80211_ampdu_mlme_action action,
-		      struct ieee80211_sta *sta, u16 tid, u16 *ssn, u8 buf_size,
-		      bool amsdu)
+		      struct ieee80211_ampdu_params *params)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct device *dev = &priv->udev->dev;
 	u8 ampdu_factor, ampdu_density;
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
 
 	switch (action) {
 	case IEEE80211_AMPDU_TX_START:
diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index c925a4d..a452788 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -1371,11 +1371,13 @@ static void rtl_op_sta_notify(struct ieee80211_hw *hw,
 
 static int rtl_op_ampdu_action(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
-			       enum ieee80211_ampdu_mlme_action action,
-			       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			       u8 buf_size, bool amsdu)
+			       struct ieee80211_ampdu_params *params)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
+	u16 *ssn = &params->ssn;
 
 	switch (action) {
 	case IEEE80211_AMPDU_TX_START:
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index b5bcc93..4df992d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -659,29 +659,24 @@ static int rsi_mac80211_set_key(struct ieee80211_hw *hw,
  *				 informs the f/w regarding this.
  * @hw: Pointer to the ieee80211_hw structure.
  * @vif: Pointer to the ieee80211_vif structure.
- * @action: ieee80211_ampdu_mlme_action enum.
- * @sta: Pointer to the ieee80211_sta structure.
- * @tid: Traffic identifier.
- * @ssn: Pointer to ssn value.
- * @buf_size: Buffer size (for kernel version > 2.6.38).
- * @amsdu: is AMSDU in AMPDU allowed
+ * @params: Pointer to A-MPDU action parameters
  *
  * Return: status: 0 on success, negative error code on failure.
  */
 static int rsi_mac80211_ampdu_action(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
-				     enum ieee80211_ampdu_mlme_action action,
-				     struct ieee80211_sta *sta,
-				     unsigned short tid,
-				     unsigned short *ssn,
-				     unsigned char buf_size,
-				     bool amsdu)
+				     struct ieee80211_ampdu_params *params)
 {
 	int status = -EOPNOTSUPP;
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
 	u16 seq_no = 0;
 	u8 ii = 0;
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
+	u16 *ssn = &params->ssn;
+	u8 buf_size = params->buf_size;
 
 	for (ii = 0; ii < RSI_MAX_VIFS; ii++) {
 		if (vif == adapter->vifs[ii])
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 9733b31..69c1c09 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -7935,10 +7935,11 @@ u64 rt2800_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 EXPORT_SYMBOL_GPL(rt2800_get_tsf);
 
 int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			enum ieee80211_ampdu_mlme_action action,
-			struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			u8 buf_size, bool amsdu)
+			struct ieee80211_ampdu_params *params)
 {
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
 	struct rt2x00_sta *sta_priv = (struct rt2x00_sta *)sta->drv_priv;
 	int ret = 0;
 
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 440790b..83f1a44 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -218,9 +218,7 @@ int rt2800_conf_tx(struct ieee80211_hw *hw,
 		   const struct ieee80211_tx_queue_params *params);
 u64 rt2800_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			enum ieee80211_ampdu_mlme_action action,
-			struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			u8 buf_size, bool amsdu);
+			struct ieee80211_ampdu_params *params);
 int rt2800_get_survey(struct ieee80211_hw *hw, int idx,
 		      struct survey_info *survey);
 void rt2800_disable_wpdma(struct rt2x00_dev *rt2x00dev);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index ec7f6af..30165ea 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5261,14 +5261,16 @@ out:
 
 static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif,
-				  enum ieee80211_ampdu_mlme_action action,
-				  struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-				  u8 buf_size, bool amsdu)
+				  struct ieee80211_ampdu_params *params)
 {
 	struct wl1271 *wl = hw->priv;
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int ret;
 	u8 hlid, *ba_bitmap;
+	struct ieee80211_sta *sta = params->sta;
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	u16 tid = params->tid;
+	u16 *ssn = &params->ssn;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 ampdu action %d tid %d", action,
 		     tid);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9dd035c..cfeb298 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2684,6 +2684,33 @@ enum ieee80211_ampdu_mlme_action {
 };
 
 /**
+ * struct ieee80211_ampdu_params - AMPDU action parameters
+ *
+ * @action: the ampdu action, value from %ieee80211_ampdu_mlme_action.
+ * @sta: peer of this AMPDU session
+ * @tid: tid of the BA session
+ * @ssn: start sequence number of the session. TX/RX_STOP can pass 0. When
+ *	action is set to %IEEE80211_AMPDU_RX_START the driver passes back the
+ *	actual ssn value used to start the session and writes the value here.
+ * @buf_size: reorder buffer size  (number of subframes). Valid only when the
+ *	action is set to %IEEE80211_AMPDU_RX_START or
+ *	%IEEE80211_AMPDU_TX_OPERATIONAL
+ * @amsdu: indicates the peer's ability to receive A-MSDU within A-MPDU.
+ *	valid when the action is set to %IEEE80211_AMPDU_TX_OPERATIONAL
+ * @timeout: BA session timeout. Valid only when the action is set to
+ *	%IEEE80211_AMPDU_RX_START
+ */
+struct ieee80211_ampdu_params {
+	enum ieee80211_ampdu_mlme_action action;
+	struct ieee80211_sta *sta;
+	u16 tid;
+	u16 ssn;
+	u8 buf_size;
+	bool amsdu;
+	u16 timeout;
+};
+
+/**
  * enum ieee80211_frame_release_type - frame release reason
  * @IEEE80211_FRAME_RELEASE_PSPOLL: frame released for PS-Poll
  * @IEEE80211_FRAME_RELEASE_UAPSD: frame(s) released due to
@@ -3027,15 +3054,9 @@ enum ieee80211_reconfig_type {
  * @ampdu_action: Perform a certain A-MPDU action
  * 	The RA/TID combination determines the destination and TID we want
  * 	the ampdu action to be performed for. The action is defined through
- * 	ieee80211_ampdu_mlme_action. Starting sequence number (@ssn)
- * 	is the first frame we expect to perform the action on. Notice
- * 	that TX/RX_STOP can pass NULL for this parameter.
- *	The @buf_size parameter is valid only when the action is set to
- *	%IEEE80211_AMPDU_RX_START or %IEEE80211_AMPDU_TX_OPERATIONAL and
- *	indicates the reorder buffer size (number of subframes) for this
- *	session.
+ *	ieee80211_ampdu_mlme_action.
  *	When the action is set to %IEEE80211_AMPDU_TX_OPERATIONAL the driver
- *	may neither send aggregates containing more subframes than this
+ *	may neither send aggregates containing more subframes than @buf_size
  *	nor send aggregates in a way that lost frames would exceed the
  *	buffer size. If just limiting the aggregate size, this would be
  *	possible with a buf_size of 8:
@@ -3046,9 +3067,6 @@ enum ieee80211_reconfig_type {
  *	buffer size of 8. Correct ways to retransmit #1 would be:
  *	 - TX:       1 or 18 or 81
  *	Even "189" would be wrong since 1 could be lost again.
- *	The @amsdu parameter is valid when the action is set to
- *	%IEEE80211_AMPDU_TX_OPERATIONAL and indicates the peer's ability
- *	to receive A-MSDU within A-MPDU.
  *
  *	Returns a negative error code on failure.
  *	The callback can sleep.
@@ -3390,9 +3408,7 @@ struct ieee80211_ops {
 	int (*tx_last_beacon)(struct ieee80211_hw *hw);
 	int (*ampdu_action)(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
-			    enum ieee80211_ampdu_mlme_action action,
-			    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			    u8 buf_size, bool amsdu);
+			    struct ieee80211_ampdu_params *params);
 	int (*get_survey)(struct ieee80211_hw *hw, int idx,
 		struct survey_info *survey);
 	void (*rfkill_poll)(struct ieee80211_hw *hw);
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 7867273..ec80db7 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -7,6 +7,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2007-2010, Intel Corporation
+ * Copyright(c) 2015 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -61,6 +62,14 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 {
 	struct ieee80211_local *local = sta->local;
 	struct tid_ampdu_rx *tid_rx;
+	struct ieee80211_ampdu_params params = {
+		.sta = &sta->sta,
+		.action = IEEE80211_AMPDU_RX_STOP,
+		.tid = tid,
+		.amsdu = false,
+		.timeout = 0,
+		.ssn = 0,
+	};
 
 	lockdep_assert_held(&sta->ampdu_mlme.mtx);
 
@@ -78,8 +87,7 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 	       initiator == WLAN_BACK_RECIPIENT ? "recipient" : "inititator",
 	       (int)reason);
 
-	if (drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_STOP,
-			     &sta->sta, tid, NULL, 0, false))
+	if (drv_ampdu_action(local, sta->sdata, &params))
 		sdata_info(sta->sdata,
 			   "HW problem - can not stop rx aggregation for %pM tid %d\n",
 			   sta->sta.addr, tid);
@@ -237,6 +245,15 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 {
 	struct ieee80211_local *local = sta->sdata->local;
 	struct tid_ampdu_rx *tid_agg_rx;
+	struct ieee80211_ampdu_params params = {
+		.sta = &sta->sta,
+		.action = IEEE80211_AMPDU_RX_START,
+		.tid = tid,
+		.amsdu = false,
+		.timeout = timeout,
+		.ssn = start_seq_num,
+	};
+
 	int i, ret = -EOPNOTSUPP;
 	u16 status = WLAN_STATUS_REQUEST_DECLINED;
 
@@ -275,6 +292,7 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 	/* make sure the size doesn't exceed the maximum supported by the hw */
 	if (buf_size > local->hw.max_rx_aggregation_subframes)
 		buf_size = local->hw.max_rx_aggregation_subframes;
+	params.buf_size = buf_size;
 
 	/* examine state machine */
 	mutex_lock(&sta->ampdu_mlme.mtx);
@@ -322,8 +340,7 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 	for (i = 0; i < buf_size; i++)
 		__skb_queue_head_init(&tid_agg_rx->reorder_buf[i]);
 
-	ret = drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_START,
-			       &sta->sta, tid, &start_seq_num, buf_size, false);
+	ret = drv_ampdu_action(local, sta->sdata, &params);
 	ht_dbg(sta->sdata, "Rx A-MPDU request on %pM tid %d result %d\n",
 	       sta->sta.addr, tid, ret);
 	if (ret) {
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index ff75718..4932e9f 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -7,6 +7,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2007-2010, Intel Corporation
+ * Copyright(c) 2015 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -295,7 +296,14 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 {
 	struct ieee80211_local *local = sta->local;
 	struct tid_ampdu_tx *tid_tx;
-	enum ieee80211_ampdu_mlme_action action;
+	struct ieee80211_ampdu_params params = {
+		.sta = &sta->sta,
+		.tid = tid,
+		.buf_size = 0,
+		.amsdu = false,
+		.timeout = 0,
+		.ssn = 0,
+	};
 	int ret;
 
 	lockdep_assert_held(&sta->ampdu_mlme.mtx);
@@ -304,10 +312,10 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 	case AGG_STOP_DECLINED:
 	case AGG_STOP_LOCAL_REQUEST:
 	case AGG_STOP_PEER_REQUEST:
-		action = IEEE80211_AMPDU_TX_STOP_CONT;
+		params.action = IEEE80211_AMPDU_TX_STOP_CONT;
 		break;
 	case AGG_STOP_DESTROY_STA:
-		action = IEEE80211_AMPDU_TX_STOP_FLUSH;
+		params.action = IEEE80211_AMPDU_TX_STOP_FLUSH;
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -330,9 +338,8 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 		spin_unlock_bh(&sta->lock);
 		if (reason != AGG_STOP_DESTROY_STA)
 			return -EALREADY;
-		ret = drv_ampdu_action(local, sta->sdata,
-				       IEEE80211_AMPDU_TX_STOP_FLUSH_CONT,
-				       &sta->sta, tid, NULL, 0, false);
+		params.action = IEEE80211_AMPDU_TX_STOP_FLUSH_CONT;
+		ret = drv_ampdu_action(local, sta->sdata, &params);
 		WARN_ON_ONCE(ret);
 		return 0;
 	}
@@ -381,8 +388,7 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 					WLAN_BACK_INITIATOR;
 	tid_tx->tx_stop = reason == AGG_STOP_LOCAL_REQUEST;
 
-	ret = drv_ampdu_action(local, sta->sdata, action,
-			       &sta->sta, tid, NULL, 0, false);
+	ret = drv_ampdu_action(local, sta->sdata, &params);
 
 	/* HW shall not deny going back to legacy */
 	if (WARN_ON(ret)) {
@@ -445,7 +451,14 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 	struct tid_ampdu_tx *tid_tx;
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	u16 start_seq_num;
+	struct ieee80211_ampdu_params params = {
+		.sta = &sta->sta,
+		.action = IEEE80211_AMPDU_TX_START,
+		.tid = tid,
+		.buf_size = 0,
+		.amsdu = false,
+		.timeout = 0,
+	};
 	int ret;
 
 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
@@ -467,10 +480,8 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 	 */
 	synchronize_net();
 
-	start_seq_num = sta->tid_seq[tid] >> 4;
-
-	ret = drv_ampdu_action(local, sdata, IEEE80211_AMPDU_TX_START,
-			       &sta->sta, tid, &start_seq_num, 0, false);
+	params.ssn = sta->tid_seq[tid] >> 4;
+	ret = drv_ampdu_action(local, sdata, &params);
 	if (ret) {
 		ht_dbg(sdata,
 		       "BA request denied - HW unavailable for %pM tid %d\n",
@@ -499,7 +510,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 
 	/* send AddBA request */
 	ieee80211_send_addba_request(sdata, sta->sta.addr, tid,
-				     tid_tx->dialog_token, start_seq_num,
+				     tid_tx->dialog_token, params.ssn,
 				     IEEE80211_MAX_AMPDU_BUF,
 				     tid_tx->timeout);
 }
@@ -684,18 +695,24 @@ static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
 					 struct sta_info *sta, u16 tid)
 {
 	struct tid_ampdu_tx *tid_tx;
+	struct ieee80211_ampdu_params params = {
+		.sta = &sta->sta,
+		.action = IEEE80211_AMPDU_TX_OPERATIONAL,
+		.tid = tid,
+		.timeout = 0,
+		.ssn = 0,
+	};
 
 	lockdep_assert_held(&sta->ampdu_mlme.mtx);
 
 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
+	params.buf_size = tid_tx->buf_size;
+	params.amsdu = tid_tx->amsdu;
 
 	ht_dbg(sta->sdata, "Aggregation is on for %pM tid %d\n",
 	       sta->sta.addr, tid);
 
-	drv_ampdu_action(local, sta->sdata,
-			 IEEE80211_AMPDU_TX_OPERATIONAL,
-			 &sta->sta, tid, NULL, tid_tx->buf_size,
-			 tid_tx->amsdu);
+	drv_ampdu_action(local, sta->sdata, &params);
 
 	/*
 	 * synchronize with TX path, while splicing the TX path
diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index ca1fe55..c258f10 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -284,9 +284,7 @@ int drv_switch_vif_chanctx(struct ieee80211_local *local,
 
 int drv_ampdu_action(struct ieee80211_local *local,
 		     struct ieee80211_sub_if_data *sdata,
-		     enum ieee80211_ampdu_mlme_action action,
-		     struct ieee80211_sta *sta, u16 tid,
-		     u16 *ssn, u8 buf_size, bool amsdu)
+		     struct ieee80211_ampdu_params *params)
 {
 	int ret = -EOPNOTSUPP;
 
@@ -296,12 +294,10 @@ int drv_ampdu_action(struct ieee80211_local *local,
 	if (!check_sdata_in_driver(sdata))
 		return -EIO;
 
-	trace_drv_ampdu_action(local, sdata, action, sta, tid,
-			       ssn, buf_size, amsdu);
+	trace_drv_ampdu_action(local, sdata, params);
 
 	if (local->ops->ampdu_action)
-		ret = local->ops->ampdu_action(&local->hw, &sdata->vif, action,
-					       sta, tid, ssn, buf_size, amsdu);
+		ret = local->ops->ampdu_action(&local->hw, &sdata->vif, params);
 
 	trace_drv_return_int(local, ret);
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 154ce4b..18b0d65 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -585,9 +585,7 @@ static inline int drv_tx_last_beacon(struct ieee80211_local *local)
 
 int drv_ampdu_action(struct ieee80211_local *local,
 		     struct ieee80211_sub_if_data *sdata,
-		     enum ieee80211_ampdu_mlme_action action,
-		     struct ieee80211_sta *sta, u16 tid,
-		     u16 *ssn, u8 buf_size, bool amsdu);
+		     struct ieee80211_ampdu_params *params);
 
 static inline int drv_get_survey(struct ieee80211_local *local, int idx,
 				struct survey_info *survey)
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index a6b4442..5a29bb0 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -80,7 +80,21 @@
 #define KEY_PR_FMT	" cipher:0x%x, flags=%#x, keyidx=%d, hw_key_idx=%d"
 #define KEY_PR_ARG	__entry->cipher, __entry->flags, __entry->keyidx, __entry->hw_key_idx
 
-
+#define AMPDU_ACTION_ENTRY	__field(enum ieee80211_ampdu_mlme_action, ieee80211_ampdu_mlme_action)	\
+				STA_ENTRY								\
+				__field(u16, tid)							\
+				__field(u16, ssn)							\
+				__field(u8, buf_size)							\
+				__field(bool, amsdu)							\
+				__field(u16, timeout)
+#define AMPDU_ACTION_ASSIGN	STA_NAMED_ASSIGN(params->sta);						\
+				__entry->tid = params->tid;						\
+				__entry->ssn = params->ssn;						\
+				__entry->buf_size = params->buf_size;					\
+				__entry->amsdu = params->amsdu;						\
+				__entry->timeout = params->timeout;
+#define AMPDU_ACTION_PR_FMT	STA_PR_FMT " tid %d, ssn %d, buf_size %u, amsdu %d, timeout %d"
+#define AMPDU_ACTION_PR_ARG	STA_PR_ARG, __entry->tid, __entry->ssn, __entry->buf_size, __entry->amsdu, __entry->timeout
 
 /*
  * Tracing for driver callbacks.
@@ -970,38 +984,25 @@ DEFINE_EVENT(local_only_evt, drv_tx_last_beacon,
 TRACE_EVENT(drv_ampdu_action,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
-		 enum ieee80211_ampdu_mlme_action action,
-		 struct ieee80211_sta *sta, u16 tid,
-		 u16 *ssn, u8 buf_size, bool amsdu),
+		 struct ieee80211_ampdu_params *params),
 
-	TP_ARGS(local, sdata, action, sta, tid, ssn, buf_size, amsdu),
+	TP_ARGS(local, sdata, params),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
-		STA_ENTRY
-		__field(u32, action)
-		__field(u16, tid)
-		__field(u16, ssn)
-		__field(u8, buf_size)
-		__field(bool, amsdu)
 		VIF_ENTRY
+		AMPDU_ACTION_ENTRY
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		VIF_ASSIGN;
-		STA_ASSIGN;
-		__entry->action = action;
-		__entry->tid = tid;
-		__entry->ssn = ssn ? *ssn : 0;
-		__entry->buf_size = buf_size;
-		__entry->amsdu = amsdu;
+		AMPDU_ACTION_ASSIGN;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT VIF_PR_FMT STA_PR_FMT " action:%d tid:%d buf:%d amsdu:%d",
-		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->action,
-		__entry->tid, __entry->buf_size, __entry->amsdu
+		LOCAL_PR_FMT VIF_PR_FMT AMPDU_ACTION_PR_FMT,
+		LOCAL_PR_ARG, VIF_PR_ARG, AMPDU_ACTION_PR_ARG
 	)
 );
 
-- 
1.9.0

