Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:31329 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbbHPINc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2015 04:13:32 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v2 7/9] mac80211: allow to transmit A-MSDU within A-MPDU
Date: Sun, 16 Aug 2015 11:13:22 +0300
Message-Id: <1439712802-2404-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150816_101351_429831_584B26AA)
In-Reply-To: <1439667594-13632-8-git-send-email-emmanuel.grumbach@intel.com>
References: <1439667594-13632-8-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Advertise the capability to send A-MSDU within A-MPDU
in the AddBA request sent by mac80211. Let the driver
know about the peer's capabilities.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/ath/ath10k/mac.c                 |  2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c         |  2 +-
 drivers/net/wireless/ath/ath9k/main.c                 |  2 +-
 drivers/net/wireless/ath/carl9170/main.c              |  2 +-
 drivers/net/wireless/ath/wcn36xx/main.c               |  2 +-
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |  2 +-
 drivers/net/wireless/cw1200/sta.c                     |  2 +-
 drivers/net/wireless/cw1200/sta.h                     |  2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c              |  2 +-
 drivers/net/wireless/iwlegacy/4965.h                  |  2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c           |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c           |  2 +-
 drivers/net/wireless/mac80211_hwsim.c                 |  2 +-
 drivers/net/wireless/mediatek/mt7601u/main.c          |  3 ++-
 drivers/net/wireless/mwl8k.c                          |  2 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c           |  4 +++-
 drivers/net/wireless/rt2x00/rt2800lib.c               |  2 +-
 drivers/net/wireless/rt2x00/rt2800lib.h               |  2 +-
 drivers/net/wireless/rtlwifi/core.c                   |  2 +-
 drivers/net/wireless/ti/wlcore/main.c                 |  2 +-
 include/linux/ieee80211.h                             |  1 +
 include/net/mac80211.h                                |  5 ++++-
 net/mac80211/agg-rx.c                                 |  4 ++--
 net/mac80211/agg-tx.c                                 | 15 ++++++++++-----
 net/mac80211/driver-ops.h                             |  7 ++++---
 net/mac80211/sta_info.h                               |  2 ++
 net/mac80211/trace.h                                  | 10 ++++++----
 27 files changed, 52 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 218b6af..e163904 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6037,7 +6037,7 @@ static int ath10k_ampdu_action(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       enum ieee80211_ampdu_mlme_action action,
 			       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			       u8 buf_size)
+			       u8 buf_size, bool amsdu)
 {
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index dab1323..7d95683 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1652,7 +1652,7 @@ static int ath9k_htc_ampdu_action(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif,
 				  enum ieee80211_ampdu_mlme_action action,
 				  struct ieee80211_sta *sta,
-				  u16 tid, u16 *ssn, u8 buf_size)
+				  u16 tid, u16 *ssn, u8 buf_size, bool amsdu)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
 	struct ath9k_htc_sta *ista;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index cfd45cb..e896929 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1851,7 +1851,7 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
 			      enum ieee80211_ampdu_mlme_action action,
 			      struct ieee80211_sta *sta,
-			      u16 tid, u16 *ssn, u8 buf_size)
+			      u16 tid, u16 *ssn, u8 buf_size, bool amsdu)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 170c209..19d3d64 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1415,7 +1415,7 @@ static int carl9170_op_ampdu_action(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
 				    enum ieee80211_ampdu_mlme_action action,
 				    struct ieee80211_sta *sta,
-				    u16 tid, u16 *ssn, u8 buf_size)
+				    u16 tid, u16 *ssn, u8 buf_size, bool amsdu)
 {
 	struct ar9170 *ar = hw->priv;
 	struct carl9170_sta_info *sta_info = (void *) sta->drv_priv;
diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 900e72a..7c169ab 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -859,7 +859,7 @@ static int wcn36xx_ampdu_action(struct ieee80211_hw *hw,
 		    struct ieee80211_vif *vif,
 		    enum ieee80211_ampdu_mlme_action action,
 		    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-		    u8 buf_size)
+		    u8 buf_size, bool amsdu)
 {
 	struct wcn36xx *wcn = hw->priv;
 	struct wcn36xx_sta *sta_priv = NULL;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index ab775a5..ccb6d050 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -820,7 +820,7 @@ brcms_ops_ampdu_action(struct ieee80211_hw *hw,
 		    struct ieee80211_vif *vif,
 		    enum ieee80211_ampdu_mlme_action action,
 		    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-		    u8 buf_size)
+		    u8 buf_size, bool amsdu)
 {
 	struct brcms_info *wl = hw->priv;
 	struct scb *scb = &wl->wlc->pri_scb;
diff --git a/drivers/net/wireless/cw1200/sta.c b/drivers/net/wireless/cw1200/sta.c
index b86500b..95a7fdb 100644
--- a/drivers/net/wireless/cw1200/sta.c
+++ b/drivers/net/wireless/cw1200/sta.c
@@ -2137,7 +2137,7 @@ int cw1200_ampdu_action(struct ieee80211_hw *hw,
 			struct ieee80211_vif *vif,
 			enum ieee80211_ampdu_mlme_action action,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			u8 buf_size)
+			u8 buf_size, bool amsdu)
 {
 	/* Aggregation is implemented fully in firmware,
 	 * including block ack negotiation. Do not allow
diff --git a/drivers/net/wireless/cw1200/sta.h b/drivers/net/wireless/cw1200/sta.h
index b7e386b..bebb337 100644
--- a/drivers/net/wireless/cw1200/sta.h
+++ b/drivers/net/wireless/cw1200/sta.h
@@ -111,7 +111,7 @@ int cw1200_ampdu_action(struct ieee80211_hw *hw,
 			struct ieee80211_vif *vif,
 			enum ieee80211_ampdu_mlme_action action,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			u8 buf_size);
+			u8 buf_size, bool amsdu);
 
 void cw1200_suspend_resume(struct cw1200_common *priv,
 			  struct wsm_suspend_resume *arg);
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 44fa422..6656215 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5984,7 +5984,7 @@ int
 il4965_mac_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum ieee80211_ampdu_mlme_action action,
 			struct ieee80211_sta *sta, u16 tid, u16 * ssn,
-			u8 buf_size)
+			u8 buf_size, bool amsdu)
 {
 	struct il_priv *il = hw->priv;
 	int ret = -EINVAL;
diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index 3a57f71..8ab8706 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -184,7 +184,7 @@ void il4965_mac_update_tkip_key(struct ieee80211_hw *hw,
 int il4965_mac_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    enum ieee80211_ampdu_mlme_action action,
 			    struct ieee80211_sta *sta, u16 tid, u16 * ssn,
-			    u8 buf_size);
+			    u8 buf_size, bool amsdu);
 int il4965_mac_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta);
 void
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 7acaa26..26445a5 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -719,7 +719,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
 				   enum ieee80211_ampdu_mlme_action action,
 				   struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-				   u8 buf_size)
+				   u8 buf_size, bool amsdu)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	int ret = -EINVAL;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index dfdab38..dc46919 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -815,7 +815,7 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
 				    enum ieee80211_ampdu_mlme_action action,
 				    struct ieee80211_sta *sta, u16 tid,
-				    u16 *ssn, u8 buf_size)
+				    u16 *ssn, u8 buf_size, bool amsdu)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	int ret;
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index dbb46ec..6d2a622 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1819,7 +1819,7 @@ static int mac80211_hwsim_ampdu_action(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       enum ieee80211_ampdu_mlme_action action,
 				       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-				       u8 buf_size)
+				       u8 buf_size, bool amsdu)
 {
 	switch (action) {
 	case IEEE80211_AMPDU_TX_START:
diff --git a/drivers/net/wireless/mediatek/mt7601u/main.c b/drivers/net/wireless/mediatek/mt7601u/main.c
index 169384b..f715eee 100644
--- a/drivers/net/wireless/mediatek/mt7601u/main.c
+++ b/drivers/net/wireless/mediatek/mt7601u/main.c
@@ -335,7 +335,8 @@ static int mt7601u_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 static int
 mt76_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		  enum ieee80211_ampdu_mlme_action action,
-		  struct ieee80211_sta *sta, u16 tid, u16 *ssn, u8 buf_size)
+		  struct ieee80211_sta *sta, u16 tid, u16 *ssn, u8 buf_size,
+		  bool amsdu)
 {
 	struct mt7601u_dev *dev = hw->priv;
 	struct mt76_sta *msta = (struct mt76_sta *) sta->drv_priv;
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 77361af..6aa78ca 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -5422,7 +5422,7 @@ static int
 mwl8k_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		   enum ieee80211_ampdu_mlme_action action,
 		   struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-		   u8 buf_size)
+		   u8 buf_size, bool amsdu)
 {
 
 	int i, rc = 0;
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 7e80432..b5bcc93 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -664,6 +664,7 @@ static int rsi_mac80211_set_key(struct ieee80211_hw *hw,
  * @tid: Traffic identifier.
  * @ssn: Pointer to ssn value.
  * @buf_size: Buffer size (for kernel version > 2.6.38).
+ * @amsdu: is AMSDU in AMPDU allowed
  *
  * Return: status: 0 on success, negative error code on failure.
  */
@@ -673,7 +674,8 @@ static int rsi_mac80211_ampdu_action(struct ieee80211_hw *hw,
 				     struct ieee80211_sta *sta,
 				     unsigned short tid,
 				     unsigned short *ssn,
-				     unsigned char buf_size)
+				     unsigned char buf_size,
+				     bool amsdu)
 {
 	int status = -EOPNOTSUPP;
 	struct rsi_hw *adapter = hw->priv;
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 9524564..9733b31 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -7937,7 +7937,7 @@ EXPORT_SYMBOL_GPL(rt2800_get_tsf);
 int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum ieee80211_ampdu_mlme_action action,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			u8 buf_size)
+			u8 buf_size, bool amsdu)
 {
 	struct rt2x00_sta *sta_priv = (struct rt2x00_sta *)sta->drv_priv;
 	int ret = 0;
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 1609b8a..440790b 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -220,7 +220,7 @@ u64 rt2800_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum ieee80211_ampdu_mlme_action action,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			u8 buf_size);
+			u8 buf_size, bool amsdu);
 int rt2800_get_survey(struct ieee80211_hw *hw, int idx,
 		      struct survey_info *survey);
 void rt2800_disable_wpdma(struct rt2x00_dev *rt2x00dev);
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 3b3a88b..18bcc88 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -1370,7 +1370,7 @@ static int rtl_op_ampdu_action(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       enum ieee80211_ampdu_mlme_action action,
 			       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			       u8 buf_size)
+			       u8 buf_size, bool amsdu)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 337223b..b715825 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5222,7 +5222,7 @@ static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif,
 				  enum ieee80211_ampdu_mlme_action action,
 				  struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-				  u8 buf_size)
+				  u8 buf_size, bool amsdu)
 {
 	struct wl1271 *wl = hw->priv;
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index cfa906f..19eb9ec 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1379,6 +1379,7 @@ struct ieee80211_ht_operation {
 
 
 /* block-ack parameters */
+#define IEEE80211_ADDBA_PARAM_AMSDU_MASK 0x0001
 #define IEEE80211_ADDBA_PARAM_POLICY_MASK 0x0002
 #define IEEE80211_ADDBA_PARAM_TID_MASK 0x003C
 #define IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK 0xFFC0
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 344424c..d37d6cd 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3033,6 +3033,9 @@ enum ieee80211_reconfig_type {
  *	buffer size of 8. Correct ways to retransmit #1 would be:
  *	 - TX:       1 or 18 or 81
  *	Even "189" would be wrong since 1 could be lost again.
+ *	The @amsdu parameter is valid when the action is set to
+ *	%IEEE80211_AMPDU_TX_OPERATIONAL and indicates the peer's ability
+ *	to receive A-MSDU within A-MPDU.
  *
  *	Returns a negative error code on failure.
  *	The callback can sleep.
@@ -3370,7 +3373,7 @@ struct ieee80211_ops {
 			    struct ieee80211_vif *vif,
 			    enum ieee80211_ampdu_mlme_action action,
 			    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
-			    u8 buf_size);
+			    u8 buf_size, bool amsdu);
 	int (*get_survey)(struct ieee80211_hw *hw, int idx,
 		struct survey_info *survey);
 	void (*rfkill_poll)(struct ieee80211_hw *hw);
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 78de79b..10ad4ac 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -79,7 +79,7 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 	       (int)reason);
 
 	if (drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_STOP,
-			     &sta->sta, tid, NULL, 0))
+			     &sta->sta, tid, NULL, 0, false))
 		sdata_info(sta->sdata,
 			   "HW problem - can not stop rx aggregation for %pM tid %d\n",
 			   sta->sta.addr, tid);
@@ -323,7 +323,7 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 		__skb_queue_head_init(&tid_agg_rx->reorder_buf[i]);
 
 	ret = drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_START,
-			       &sta->sta, tid, &start_seq_num, 0);
+			       &sta->sta, tid, &start_seq_num, 0, false);
 	ht_dbg(sta->sdata, "Rx A-MPDU request on %pM tid %d result %d\n",
 	       sta->sta.addr, tid, ret);
 	if (ret) {
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index c8ba2e7..a758eb84 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -97,7 +97,8 @@ static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
 	mgmt->u.action.u.addba_req.action_code = WLAN_ACTION_ADDBA_REQ;
 
 	mgmt->u.action.u.addba_req.dialog_token = dialog_token;
-	capab = (u16)(1 << 1);		/* bit 1 aggregation policy */
+	capab = (u16)(1 << 0);		/* bit 0 A-MSDU support */
+	capab |= (u16)(1 << 1);		/* bit 1 aggregation policy */
 	capab |= (u16)(tid << 2); 	/* bit 5:2 TID number */
 	capab |= (u16)(agg_size << 6);	/* bit 15:6 max size of aggergation */
 
@@ -331,7 +332,7 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 			return -EALREADY;
 		ret = drv_ampdu_action(local, sta->sdata,
 				       IEEE80211_AMPDU_TX_STOP_FLUSH_CONT,
-				       &sta->sta, tid, NULL, 0);
+				       &sta->sta, tid, NULL, 0, false);
 		WARN_ON_ONCE(ret);
 		return 0;
 	}
@@ -381,7 +382,7 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 	tid_tx->tx_stop = reason == AGG_STOP_LOCAL_REQUEST;
 
 	ret = drv_ampdu_action(local, sta->sdata, action,
-			       &sta->sta, tid, NULL, 0);
+			       &sta->sta, tid, NULL, 0, false);
 
 	/* HW shall not deny going back to legacy */
 	if (WARN_ON(ret)) {
@@ -469,7 +470,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 	start_seq_num = sta->tid_seq[tid] >> 4;
 
 	ret = drv_ampdu_action(local, sdata, IEEE80211_AMPDU_TX_START,
-			       &sta->sta, tid, &start_seq_num, 0);
+			       &sta->sta, tid, &start_seq_num, 0, false);
 	if (ret) {
 		ht_dbg(sdata,
 		       "BA request denied - HW unavailable for %pM tid %d\n",
@@ -693,7 +694,8 @@ static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
 
 	drv_ampdu_action(local, sta->sdata,
 			 IEEE80211_AMPDU_TX_OPERATIONAL,
-			 &sta->sta, tid, NULL, tid_tx->buf_size);
+			 &sta->sta, tid, NULL, tid_tx->buf_size,
+			 tid_tx->amsdu);
 
 	/*
 	 * synchronize with TX path, while splicing the TX path
@@ -918,8 +920,10 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 	struct tid_ampdu_tx *tid_tx;
 	u16 capab, tid;
 	u8 buf_size;
+	bool amsdu;
 
 	capab = le16_to_cpu(mgmt->u.action.u.addba_resp.capab);
+	amsdu = capab & IEEE80211_ADDBA_PARAM_AMSDU_MASK;
 	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
 	buf_size = (capab & IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK) >> 6;
 
@@ -968,6 +972,7 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 		}
 
 		tid_tx->buf_size = buf_size;
+		tid_tx->amsdu = amsdu;
 
 		if (test_bit(HT_AGG_STATE_DRV_READY, &tid_tx->state))
 			ieee80211_agg_tx_operational(local, sta, tid);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 157b20b..31482e2 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -734,7 +734,7 @@ static inline int drv_ampdu_action(struct ieee80211_local *local,
 				   struct ieee80211_sub_if_data *sdata,
 				   enum ieee80211_ampdu_mlme_action action,
 				   struct ieee80211_sta *sta, u16 tid,
-				   u16 *ssn, u8 buf_size)
+				   u16 *ssn, u8 buf_size, bool amsdu)
 {
 	int ret = -EOPNOTSUPP;
 
@@ -744,11 +744,12 @@ static inline int drv_ampdu_action(struct ieee80211_local *local,
 	if (!check_sdata_in_driver(sdata))
 		return -EIO;
 
-	trace_drv_ampdu_action(local, sdata, action, sta, tid, ssn, buf_size);
+	trace_drv_ampdu_action(local, sdata, action, sta, tid,
+			       ssn, buf_size, amsdu);
 
 	if (local->ops->ampdu_action)
 		ret = local->ops->ampdu_action(&local->hw, &sdata->vif, action,
-					       sta, tid, ssn, buf_size);
+					       sta, tid, ssn, buf_size, amsdu);
 
 	trace_drv_return_int(local, ret);
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index b087c71..d5ded87 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -133,6 +133,7 @@ enum ieee80211_agg_stop_reason {
  * @buf_size: reorder buffer size at receiver
  * @failed_bar_ssn: ssn of the last failed BAR tx attempt
  * @bar_pending: BAR needs to be re-sent
+ * @amsdu: support A-MSDU withing A-MDPU
  *
  * This structure's lifetime is managed by RCU, assignments to
  * the array holding it must hold the aggregation mutex.
@@ -158,6 +159,7 @@ struct tid_ampdu_tx {
 
 	u16 failed_bar_ssn;
 	bool bar_pending;
+	bool amsdu;
 };
 
 /**
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index b5960b9..314e3bd 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -974,9 +974,9 @@ TRACE_EVENT(drv_ampdu_action,
 		 struct ieee80211_sub_if_data *sdata,
 		 enum ieee80211_ampdu_mlme_action action,
 		 struct ieee80211_sta *sta, u16 tid,
-		 u16 *ssn, u8 buf_size),
+		 u16 *ssn, u8 buf_size, bool amsdu),
 
-	TP_ARGS(local, sdata, action, sta, tid, ssn, buf_size),
+	TP_ARGS(local, sdata, action, sta, tid, ssn, buf_size, amsdu),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
@@ -985,6 +985,7 @@ TRACE_EVENT(drv_ampdu_action,
 		__field(u16, tid)
 		__field(u16, ssn)
 		__field(u8, buf_size)
+		__field(bool, amsdu)
 		VIF_ENTRY
 	),
 
@@ -996,12 +997,13 @@ TRACE_EVENT(drv_ampdu_action,
 		__entry->tid = tid;
 		__entry->ssn = ssn ? *ssn : 0;
 		__entry->buf_size = buf_size;
+		__entry->amsdu = amsdu;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT VIF_PR_FMT STA_PR_FMT " action:%d tid:%d buf:%d",
+		LOCAL_PR_FMT VIF_PR_FMT STA_PR_FMT " action:%d tid:%d buf:%d amsdu:%d",
 		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->action,
-		__entry->tid, __entry->buf_size
+		__entry->tid, __entry->buf_size, __entry->amsdu
 	)
 );
 
-- 
2.1.4

