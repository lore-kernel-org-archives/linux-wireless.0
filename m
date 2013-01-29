Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43091 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab3A2Xr6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 18:47:58 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Arend van Spriel <arend@broadcom.com>,
	Luciano Coelho <coelho@ti.com>, ath9k-devel@lists.ath9k.org,
	brcm80211-dev-list@broadcom.com, users@rt2x00.serialmonkey.com
Subject: [PATCH 5/7] mac80211: Expand powersave configuration flag to be two bits
Date: Tue, 29 Jan 2013 17:47:33 -0600
Message-Id: <1359503255-18270-6-git-send-email-seth.forshee@canonical.com> (sfid-20130130_004803_624489_CC0823AF)
In-Reply-To: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
References: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The powersave configuration flag is a single bit and can thus only
indicate that powersave is either on or off. This is inadequate for
off-channel powersave, where the hardware must remain powered on but
some configuration of the hardware may be required (e.g. to ensure that
PM is set in frame control in frames sent to the associated AP, as with
brcmsmac).

In preparation for supporting an off-channel powersave state, expand the
powersave configuration flag to two bits. Also introduce some interfaces
which functionally replace the current open-coded setting and checking
of the power state and update mac80211 and the drivers to use these
interfaces. Update the documentation to refer to the new interfaces.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |    2 +-
 drivers/net/wireless/ath/ath9k/main.c              |    2 +-
 drivers/net/wireless/ath/carl9170/main.c           |    2 +-
 drivers/net/wireless/ath/carl9170/rx.c             |    2 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    2 +-
 drivers/net/wireless/iwlwifi/dvm/power.c           |    2 +-
 drivers/net/wireless/mac80211_hwsim.c              |    2 +-
 drivers/net/wireless/p54/fwio.c                    |    2 +-
 drivers/net/wireless/p54/txrx.c                    |    2 +-
 drivers/net/wireless/rt2x00/rt2400pci.c            |    3 +-
 drivers/net/wireless/rt2x00/rt2500pci.c            |    3 +-
 drivers/net/wireless/rt2x00/rt2500usb.c            |    3 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |    3 +-
 drivers/net/wireless/rt2x00/rt2x00config.c         |    4 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |    3 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |    3 +-
 drivers/net/wireless/rtlwifi/core.c                |    2 +-
 drivers/net/wireless/rtlwifi/ps.c                  |    4 +-
 drivers/net/wireless/ti/wl1251/main.c              |    7 +-
 drivers/net/wireless/ti/wlcore/main.c              |    6 +-
 include/net/mac80211.h                             |   96 +++++++++++++++-----
 net/mac80211/mlme.c                                |   26 +++---
 net/mac80211/offchannel.c                          |   10 +-
 net/mac80211/tx.c                                  |    2 +-
 net/mac80211/util.c                                |    2 +-
 26 files changed, 123 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index a8016d7..85f84fa 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1212,7 +1212,7 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
-		if (conf->flags & IEEE80211_CONF_PS) {
+		if (ieee80211_is_ps_enabled(conf)) {
 			ath9k_htc_setpower(priv, ATH9K_PM_NETWORK_SLEEP);
 			priv->ps_enabled = true;
 		} else {
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4b72b66..a4f2151 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1180,7 +1180,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
 		unsigned long flags;
 		spin_lock_irqsave(&sc->sc_pm_lock, flags);
-		if (conf->flags & IEEE80211_CONF_PS)
+		if (ieee80211_is_ps_enabled(conf))
 			ath9k_enable_ps(sc);
 		else
 			ath9k_disable_ps(sc);
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index ef82751..80336e3d 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -836,7 +836,7 @@ static int carl9170_ps_update(struct ar9170 *ar)
 	int err = 0;
 
 	if (!ar->ps.off_override)
-		ps = (ar->hw->conf.flags & IEEE80211_CONF_PS);
+		ps = ieee80211_is_ps_enabled(&ar->hw->conf);
 
 	if (ps != ar->ps.state) {
 		err = carl9170_powersave(ar, ps);
diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index 4684dd9..424d856 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -524,7 +524,7 @@ static void carl9170_ps_beacon(struct ar9170 *ar, void *data, unsigned int len)
 	u8 tim_len;
 	bool cam;
 
-	if (likely(!(ar->hw->conf.flags & IEEE80211_CONF_PS)))
+	if (likely(ieee80211_is_ps_disabled(&ar->hw->conf)))
 		return;
 
 	/* check if this really is a beacon */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 7fc49ca..be3820e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -395,7 +395,7 @@ static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 			       "true" : "false");
 	if (changed & IEEE80211_CONF_CHANGE_PS)
 		brcms_err(core, "%s: change power-save mode: %s (implement)\n",
-			  __func__, conf->flags & IEEE80211_CONF_PS ?
+			  __func__, ieee80211_is_ps_enabled(conf) ?
 			  "true" : "false");
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
diff --git a/drivers/net/wireless/iwlwifi/dvm/power.c b/drivers/net/wireless/iwlwifi/dvm/power.c
index 518cf37..deea146 100644
--- a/drivers/net/wireless/iwlwifi/dvm/power.c
+++ b/drivers/net/wireless/iwlwifi/dvm/power.c
@@ -286,7 +286,7 @@ static int iwl_set_power(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd)
 static void iwl_power_build_cmd(struct iwl_priv *priv,
 				struct iwl_powertable_cmd *cmd)
 {
-	bool enabled = priv->hw->conf.flags & IEEE80211_CONF_PS;
+	bool enabled = ieee80211_is_ps_enabled(&priv->hw->conf);
 	int dtimper;
 
 	dtimper = priv->hw->conf.ps_dtim_period ?: 1;
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index b73e497..3d27eb9 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1080,7 +1080,7 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 		    conf->channel ? conf->channel->center_freq : 0,
 		    hwsim_chantypes[conf->channel_type],
 		    !!(conf->flags & IEEE80211_CONF_IDLE),
-		    !!(conf->flags & IEEE80211_CONF_PS),
+		    ieee80211_is_ps_enabled(conf),
 		    smps_modes[conf->smps_mode]);
 
 	data->idle = !!(conf->flags & IEEE80211_CONF_IDLE);
diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
index 9ba8510..3bb650c 100644
--- a/drivers/net/wireless/p54/fwio.c
+++ b/drivers/net/wireless/p54/fwio.c
@@ -601,7 +601,7 @@ int p54_set_ps(struct p54_common *priv)
 	unsigned int i;
 	u16 mode;
 
-	if (priv->hw->conf.flags & IEEE80211_CONF_PS &&
+	if (ieee80211_is_ps_enabled(&priv->hw->conf) &&
 	    !priv->powersave_override)
 		mode = P54_PSM | P54_PSM_BEACON_TIMEOUT | P54_PSM_DTIM |
 		       P54_PSM_CHECKSUM | P54_PSM_MCBC;
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 12f0a34..baadb8f 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -380,7 +380,7 @@ static int p54_rx_data(struct p54_common *priv, struct sk_buff *skb)
 
 	skb_pull(skb, header_len);
 	skb_trim(skb, le16_to_cpu(hdr->len));
-	if (unlikely(priv->hw->conf.flags & IEEE80211_CONF_PS))
+	if (unlikely(ieee80211_is_ps_enabled(&priv->hw->conf)))
 		p54_pspoll_workaround(priv, skb);
 
 	ieee80211_rx_irqsafe(priv->hw, skb);
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index a2d2bc2..375ec2d 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -521,8 +521,7 @@ static void rt2400pci_config_ps(struct rt2x00_dev *rt2x00dev,
 				struct rt2x00lib_conf *libconf)
 {
 	enum dev_state state =
-	    (libconf->conf->flags & IEEE80211_CONF_PS) ?
-		STATE_SLEEP : STATE_AWAKE;
+	    ieee80211_is_ps_enabled(libconf->conf) ? STATE_SLEEP : STATE_AWAKE;
 	u32 reg;
 
 	if (state == STATE_SLEEP) {
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 9bea10f..45fa63f 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -570,8 +570,7 @@ static void rt2500pci_config_ps(struct rt2x00_dev *rt2x00dev,
 				struct rt2x00lib_conf *libconf)
 {
 	enum dev_state state =
-	    (libconf->conf->flags & IEEE80211_CONF_PS) ?
-		STATE_SLEEP : STATE_AWAKE;
+	    ieee80211_is_ps_enabled(libconf->conf) ? STATE_SLEEP : STATE_AWAKE;
 	u32 reg;
 
 	if (state == STATE_SLEEP) {
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 6b2e1e43..92cf483 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -649,8 +649,7 @@ static void rt2500usb_config_ps(struct rt2x00_dev *rt2x00dev,
 				struct rt2x00lib_conf *libconf)
 {
 	enum dev_state state =
-	    (libconf->conf->flags & IEEE80211_CONF_PS) ?
-		STATE_SLEEP : STATE_AWAKE;
+	    ieee80211_is_ps_enabled(libconf->conf) ? STATE_SLEEP : STATE_AWAKE;
 	u16 reg;
 
 	if (state == STATE_SLEEP) {
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index a5c694f..564ec67 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2862,8 +2862,7 @@ static void rt2800_config_ps(struct rt2x00_dev *rt2x00dev,
 			     struct rt2x00lib_conf *libconf)
 {
 	enum dev_state state =
-	    (libconf->conf->flags & IEEE80211_CONF_PS) ?
-		STATE_SLEEP : STATE_AWAKE;
+	    ieee80211_is_ps_enabled(libconf->conf) ? STATE_SLEEP : STATE_AWAKE;
 	u32 reg;
 
 	if (state == STATE_SLEEP) {
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 49a63e9..bebe0b2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -261,7 +261,7 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 	if (test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) &&
 	    test_bit(REQUIRE_PS_AUTOWAKE, &rt2x00dev->cap_flags) &&
 	    (ieee80211_flags & IEEE80211_CONF_CHANGE_PS) &&
-	    (conf->flags & IEEE80211_CONF_PS)) {
+	    ieee80211_is_ps_enabled(conf)) {
 		beacon_diff = (long)jiffies - (long)rt2x00dev->last_beacon;
 		beacon_int = msecs_to_jiffies(rt2x00dev->beacon_int);
 
@@ -274,7 +274,7 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 				   autowake_timeout - 15);
 	}
 
-	if (conf->flags & IEEE80211_CONF_PS)
+	if (ieee80211_is_ps_enabled(conf))
 		set_bit(CONFIG_POWERSAVING, &rt2x00dev->flags);
 	else
 		clear_bit(CONFIG_POWERSAVING, &rt2x00dev->flags);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index b40a538..b3e8367 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -596,7 +596,7 @@ static void rt2x00lib_rxdone_check_ps(struct rt2x00_dev *rt2x00dev,
 	 * configured, or if the device is already in powersaving mode
 	 * we can exit now. */
 	if (likely(!ieee80211_is_beacon(hdr->frame_control) ||
-		   !(rt2x00dev->hw->conf.flags & IEEE80211_CONF_PS)))
+		   ieee80211_is_ps_disabled(&rt2x00dev->hw->conf)))
 		return;
 
 	/* min. beacon length + FCS_LEN */
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index f95792c..5cd1e4e 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -942,8 +942,7 @@ static void rt61pci_config_ps(struct rt2x00_dev *rt2x00dev,
 				struct rt2x00lib_conf *libconf)
 {
 	enum dev_state state =
-	    (libconf->conf->flags & IEEE80211_CONF_PS) ?
-		STATE_SLEEP : STATE_AWAKE;
+	    ieee80211_is_ps_enabled(libconf->conf) ? STATE_SLEEP : STATE_AWAKE;
 	u32 reg;
 
 	if (state == STATE_SLEEP) {
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 24eec66..f44fc3d 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -827,8 +827,7 @@ static void rt73usb_config_ps(struct rt2x00_dev *rt2x00dev,
 				struct rt2x00lib_conf *libconf)
 {
 	enum dev_state state =
-	    (libconf->conf->flags & IEEE80211_CONF_PS) ?
-		STATE_SLEEP : STATE_AWAKE;
+	    ieee80211_is_ps_enabled(libconf->conf) ? STATE_SLEEP : STATE_AWAKE;
 	u32 reg;
 
 	if (state == STATE_SLEEP) {
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index d3ce9fb..ca42a89 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -289,7 +289,7 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
 		cancel_delayed_work(&rtlpriv->works.ps_work);
 		cancel_delayed_work(&rtlpriv->works.ps_rfon_wq);
-		if (conf->flags & IEEE80211_CONF_PS) {
+		if (ieee80211_is_ps_enabled(conf)) {
 			rtlpriv->psc.sw_ps_enabled = true;
 			/* sleep here is must, or we may recv the beacon and
 			 * cause mac80211 into wrong ps state, this will cause
diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/rtlwifi/ps.c
index 13ad33e..b181d22 100644
--- a/drivers/net/wireless/rtlwifi/ps.c
+++ b/drivers/net/wireless/rtlwifi/ps.c
@@ -468,7 +468,7 @@ void rtl_swlps_beacon(struct ieee80211_hw *hw, void *data, unsigned int len)
 	if (rtlpriv->psc.fwctrl_lps)
 		return;
 
-	if (likely(!(hw->conf.flags & IEEE80211_CONF_PS)))
+	if (likely(ieee80211_is_ps_disabled(&hw->conf)))
 		return;
 
 	/* check if this really is a beacon */
@@ -624,7 +624,7 @@ void rtl_swlps_wq_callback(void *data)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	bool ps = false;
 
-	ps = (hw->conf.flags & IEEE80211_CONF_PS);
+	ps = ieee80211_is_ps_enabled(&hw->conf);
 
 	/* we can sleep after ps null send ok */
 	if (rtlpriv->psc.state_inap) {
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index f47e8b0..4bee40b 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -576,7 +576,7 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	wl1251_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d",
 		     channel,
-		     conf->flags & IEEE80211_CONF_PS ? "on" : "off",
+		     ieee80211_is_ps_enabled(conf) ? "on" : "off",
 		     conf->power_level);
 
 	mutex_lock(&wl->mutex);
@@ -594,7 +594,7 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 			goto out_sleep;
 	}
 
-	if (conf->flags & IEEE80211_CONF_PS && !wl->psm_requested) {
+	if (ieee80211_is_ps_enabled(conf) && !wl->psm_requested) {
 		wl1251_debug(DEBUG_PSM, "psm enabled");
 
 		wl->psm_requested = true;
@@ -610,8 +610,7 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 		ret = wl1251_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
 		if (ret < 0)
 			goto out_sleep;
-	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
-		   wl->psm_requested) {
+	} else if (ieee80211_is_ps_disabled(conf) && wl->psm_requested) {
 		wl1251_debug(DEBUG_PSM, "psm disabled");
 
 		wl->psm_requested = false;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index ce6e62a..4235868 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2670,7 +2670,7 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 	if ((changed & IEEE80211_CONF_CHANGE_PS) && !is_ap) {
 
-		if ((conf->flags & IEEE80211_CONF_PS) &&
+		if (ieee80211_is_ps_enabled(conf) &&
 		    test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags) &&
 		    !test_bit(WLVIF_FLAG_IN_PS, &wlvif->flags)) {
 
@@ -2693,7 +2693,7 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 				wl1271_warning("enter %s ps failed %d",
 					       ps_mode_str, ret);
 
-		} else if (!(conf->flags & IEEE80211_CONF_PS) &&
+		} else if (ieee80211_is_ps_disabled(conf) &&
 			   test_bit(WLVIF_FLAG_IN_PS, &wlvif->flags)) {
 
 			wl1271_debug(DEBUG_PSM, "auto ps disabled");
@@ -2728,7 +2728,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	wl1271_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d %s"
 		     " changed 0x%x",
 		     channel,
-		     conf->flags & IEEE80211_CONF_PS ? "on" : "off",
+		     ieee80211_is_ps_enabled(conf) ? "on" : "off",
 		     conf->power_level,
 		     conf->flags & IEEE80211_CONF_IDLE ? "idle" : "in use",
 			 changed);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3037f49..d6c24d9 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -861,13 +861,16 @@ struct ieee80211_rx_status {
  * @IEEE80211_CONF_MONITOR: there's a monitor interface present -- use this
  *	to determine for example whether to calculate timestamps for packets
  *	or not, do not use instead of filter flags!
- * @IEEE80211_CONF_PS: Enable 802.11 power save mode (managed mode only).
- *	This is the power save mode defined by IEEE 802.11-2007 section 11.2,
- *	meaning that the hardware still wakes up for beacons, is able to
- *	transmit frames and receive the possible acknowledgment frames.
- *	Not to be confused with hardware specific wakeup/sleep states,
- *	driver is responsible for that. See the section "Powersave support"
- *	for more.
+ * @IEEE80211_CONF_PS_MASK: This mask defines the bits which identify the
+ *	802.11 power save mode defined by IEEE 802.11-2007 secion 11.2.
+ *	Possible values for this fields are defined by subsequent
+ *	IEEE80211_CONF_PS_* flags. See the secion "Powersave support" for more.
+ * @IEEE80211_CONF_PS_DISABLED: Power save is disabled. The hardware is able
+ *	to transmit and receive frames.
+ * @IEEE80211_CONF_PS_ENABLED: Power save is enabled. The hardware still wakes
+ *	up for beacons, is able to transmit frames and receive the possible
+ *	acknowledgement frames. Not to be confused with hardware specific
+ *	wakeup/sleep states; the driver is responsible for that.
  * @IEEE80211_CONF_IDLE: The device is running, but idle; if the flag is set
  *	the driver should be prepared to handle configuration requests but
  *	may turn the device off as much as possible. Typically, this flag will
@@ -878,12 +881,13 @@ struct ieee80211_rx_status {
  */
 enum ieee80211_conf_flags {
 	IEEE80211_CONF_MONITOR		= (1<<0),
-	IEEE80211_CONF_PS		= (1<<1),
-	IEEE80211_CONF_IDLE		= (1<<2),
-	IEEE80211_CONF_OFFCHANNEL	= (1<<3),
+	IEEE80211_CONF_PS_MASK		= (3<<1),
+	IEEE80211_CONF_PS_DISABLED	= (0<<1),
+	IEEE80211_CONF_PS_ENABLED	= (1<<1),
+	IEEE80211_CONF_IDLE		= (1<<3),
+	IEEE80211_CONF_OFFCHANNEL	= (1<<4),
 };
 
-
 /**
  * enum ieee80211_conf_changed - denotes which configuration changed
  *
@@ -983,6 +987,49 @@ struct ieee80211_conf {
 };
 
 /**
+ * ieee80211_is_ps_disabled - check if powersave is disabled
+ *
+ * Returns true if powersave is disabled in the supplied configuration.
+ *
+ * @conf: device configuration
+ */
+static inline bool ieee80211_is_ps_disabled(struct ieee80211_conf *conf)
+{
+	return (conf->flags & IEEE80211_CONF_PS_MASK) ==
+	       IEEE80211_CONF_PS_DISABLED;
+}
+
+/**
+ * ieee80211_is_ps_enabled - check if powersave is enabled
+ *
+ * Returns true if powersave is enabled in the supplied configuration.
+ *
+ * @conf: device configuration
+ */
+static inline bool ieee80211_is_ps_enabled(struct ieee80211_conf *conf)
+{
+	return (conf->flags & IEEE80211_CONF_PS_MASK) ==
+	       IEEE80211_CONF_PS_ENABLED;
+}
+
+/**
+ * ieee80211_set_ps_state - set device powersave state
+ *
+ * Sets the powersave state in the supplied device configuration to the
+ * specified state.
+ *
+ * @conf: device configuration
+ * @state: new powersave state. Must be one of the IEEE80211_CONF_PS_*
+ *	flags from enum ieee80211_conf_flags.
+ */
+static inline void ieee80211_set_ps_state(struct ieee80211_conf *conf,
+					  u32 state)
+{
+	conf->flags = (conf->flags & ~IEEE80211_CONF_PS_MASK) |
+		      (state & IEEE80211_CONF_PS_MASK);
+}
+
+/**
  * struct ieee80211_channel_switch - holds the channel switch data
  *
  * The information provided in this structure is required for channel switch
@@ -1640,13 +1687,14 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  * First, it can support hardware that handles all powersaving by itself,
  * such hardware should simply set the %IEEE80211_HW_SUPPORTS_PS hardware
  * flag. In that case, it will be told about the desired powersave mode
- * with the %IEEE80211_CONF_PS flag depending on the association status.
+ * with the %IEEE80211_CONF_PS_* states depending on the association status.
+ * The current state can be checked with the ieee80211_is_ps_*() functions.
  * The hardware must take care of sending nullfunc frames when necessary,
  * i.e. when entering and leaving powersave mode. The hardware is required
  * to look at the AID in beacons and signal to the AP that it woke up when
  * it finds traffic directed to it.
  *
- * %IEEE80211_CONF_PS flag enabled means that the powersave mode defined in
+ * When ieee80211_is_ps_enabled() returns true the powersave mode defined in
  * IEEE 802.11-2007 section 11.2 is enabled. This is not to be confused
  * with hardware wakeup and sleep states. Driver is responsible for waking
  * up the hardware before issuing commands to the hardware and putting it
@@ -1678,9 +1726,9 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  * %IEEE80211_HW_SUPPORTS_DYNAMIC_PS flag to indicate that it can support
  * dynamic PS mode itself. The driver needs to look at the
  * @dynamic_ps_timeout hardware configuration value and use it that value
- * whenever %IEEE80211_CONF_PS is set. In this case mac80211 will disable
- * dynamic PS feature in stack and will just keep %IEEE80211_CONF_PS
- * enabled whenever user has enabled powersave.
+ * whenever ieee80211_is_ps_enabled() returns true. In this case mac80211 will
+ * disable dynamic PS feature in stack and will just keep powersave enabled
+ * whenever user has enabled powersave.
  *
  * Some hardware need to toggle a single shared antenna between WLAN and
  * Bluetooth to facilitate co-existence. These types of hardware set
@@ -1715,9 +1763,10 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  *
  * Beacon filter support is advertised with the %IEEE80211_VIF_BEACON_FILTER
  * interface capability. The driver needs to enable beacon filter support
- * whenever power save is enabled, that is %IEEE80211_CONF_PS is set. When
- * power save is enabled, the stack will not check for beacon loss and the
- * driver needs to notify about loss of beacons with ieee80211_beacon_loss().
+ * whenever power save is enabled, that is ieee80211_is_ps_enabled() returns
+ * true. When power save is enabled, the stack will not check for beacon loss
+ * and the driver needs to notify about loss of beacons with
+ * ieee80211_beacon_loss().
  *
  * The time (or number of beacons missed) until the firmware notifies the
  * driver of a beacon loss event (which in turn causes the driver to call
@@ -3847,8 +3896,8 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  *
  * When beacon filtering is enabled with %IEEE80211_VIF_BEACON_FILTER and
- * %IEEE80211_CONF_PS is set, the driver needs to inform whenever the
- * hardware is not receiving beacons with this function.
+ * ieee80211_is_ps_enabled() returns true, the driver needs to inform whenever
+ * the hardware is not receiving beacons with this function.
  */
 void ieee80211_beacon_loss(struct ieee80211_vif *vif);
 
@@ -3858,8 +3907,9 @@ void ieee80211_beacon_loss(struct ieee80211_vif *vif);
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  *
  * When beacon filtering is enabled with %IEEE80211_VIF_BEACON_FILTER, and
- * %IEEE80211_CONF_PS and %IEEE80211_HW_CONNECTION_MONITOR are set, the driver
- * needs to inform if the connection to the AP has been lost.
+ * ieee80211_is_ps_enabled() returns true and %IEEE80211_HW_CONNECTION_MONITOR
+ * are set, the driver needs to inform if the connection to the AP has been
+ * lost.
  *
  * This function will cause immediate change to disassociated state,
  * without connection recovery attempts.
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7211344..df64efe 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1004,7 +1004,7 @@ static void ieee80211_enable_ps(struct ieee80211_local *local,
 		    (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS))
 			return;
 
-		conf->flags |= IEEE80211_CONF_PS;
+		ieee80211_set_ps_state(conf, IEEE80211_CONF_PS_ENABLED);
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
 }
@@ -1015,8 +1015,8 @@ static void ieee80211_change_ps(struct ieee80211_local *local)
 
 	if (local->ps_sdata) {
 		ieee80211_enable_ps(local, local->ps_sdata);
-	} else if (conf->flags & IEEE80211_CONF_PS) {
-		conf->flags &= ~IEEE80211_CONF_PS;
+	} else if (ieee80211_is_ps_enabled(conf)) {
+		ieee80211_set_ps_state(conf, IEEE80211_CONF_PS_DISABLED);
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 		del_timer_sync(&local->dynamic_ps_timer);
 		cancel_work_sync(&local->dynamic_ps_enable_work);
@@ -1150,8 +1150,9 @@ void ieee80211_dynamic_ps_disable_work(struct work_struct *work)
 		container_of(work, struct ieee80211_local,
 			     dynamic_ps_disable_work);
 
-	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
-		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+	if (ieee80211_is_ps_enabled(&local->hw.conf)) {
+		ieee80211_set_ps_state(&local->hw.conf,
+				       IEEE80211_CONF_PS_DISABLED);
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
 
@@ -1175,7 +1176,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 
 	ifmgd = &sdata->u.mgd;
 
-	if (local->hw.conf.flags & IEEE80211_CONF_PS)
+	if (ieee80211_is_ps_enabled(&local->hw.conf))
 		return;
 
 	if (!local->disable_dynamic_ps &&
@@ -1226,7 +1227,8 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 	      (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)) ||
 	    (ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)) {
 		ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
-		local->hw.conf.flags |= IEEE80211_CONF_PS;
+		ieee80211_set_ps_state(&local->hw.conf,
+				       IEEE80211_CONF_PS_ENABLED);
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
 
@@ -1534,8 +1536,9 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	 * to do it before sending disassoc, as otherwise the null-packet
 	 * won't be valid.
 	 */
-	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
-		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+	if (!ieee80211_is_ps_disabled(&local->hw.conf)) {
+		ieee80211_set_ps_state(&local->hw.conf,
+				       IEEE80211_CONF_PS_DISABLED);
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
 	local->ps_sdata = NULL;
@@ -2671,8 +2674,9 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 							ifmgd->aid);
 		if (directed_tim) {
 			if (local->hw.conf.dynamic_ps_timeout > 0) {
-				if (local->hw.conf.flags & IEEE80211_CONF_PS) {
-					local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+				if (ieee80211_is_ps_enabled(&local->hw.conf)) {
+					ieee80211_set_ps_state(&local->hw.conf,
+							       IEEE80211_CONF_PS_DISABLED);
 					ieee80211_hw_config(local,
 							    IEEE80211_CONF_CHANGE_PS);
 				}
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 28274f9..d524794 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -40,9 +40,10 @@ static bool ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 
 	cancel_work_sync(&local->dynamic_ps_enable_work);
 
-	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
+	if (ieee80211_is_ps_enabled(&local->hw.conf)) {
 		local->offchannel_ps_enabled = true;
-		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+		ieee80211_set_ps_state(&local->hw.conf,
+				       IEEE80211_CONF_PS_DISABLED);
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	}
 
@@ -87,11 +88,12 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 		/* TODO:  Only set hardware if CONF_PS changed?
 		 * TODO:  Should we set offchannel_ps_enabled to false?
 		 */
-		local->hw.conf.flags |= IEEE80211_CONF_PS;
+		ieee80211_set_ps_state(&local->hw.conf,
+				       IEEE80211_CONF_PS_ENABLED);
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 	} else if (local->hw.conf.dynamic_ps_timeout > 0) {
 		/*
-		 * If IEEE80211_CONF_PS was not set and the dynamic_ps_timer
+		 * If power save was not enabled and the dynamic_ps_timer
 		 * had been running before leaving the operating channel,
 		 * restart the timer now and send a nullfunc frame to inform
 		 * the AP that we are awake.
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 80b514a..ff64a4b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -231,7 +231,7 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 	    skb_get_queue_mapping(tx->skb) == IEEE80211_AC_VO)
 		return TX_CONTINUE;
 
-	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
+	if (ieee80211_is_ps_enabled(&local->hw.conf)) {
 		ieee80211_stop_queues_by_reason(&local->hw,
 						IEEE80211_QUEUE_STOP_REASON_PS);
 		ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 0923892..cf9ea6f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1594,7 +1594,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	 * explicitly send a null packet in order to make sure
 	 * it'll sync against the ap (and get out of psm).
 	 */
-	if (!(local->hw.conf.flags & IEEE80211_CONF_PS)) {
+	if (ieee80211_is_ps_disabled(&local->hw.conf)) {
 		list_for_each_entry(sdata, &local->interfaces, list) {
 			if (sdata->vif.type != NL80211_IFTYPE_STATION)
 				continue;
-- 
1.7.9.5

