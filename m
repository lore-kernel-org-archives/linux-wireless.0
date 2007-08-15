Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57459 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761463AbXHOOuM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 10:50:12 -0400
Message-Id: <20070815145044.386019000@sipsolutions.net>
References: <20070815144920.135826000@sipsolutions.net>
Date: Wed, 15 Aug 2007 16:49:27 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 07/20] mac80211: remove unused ioctls (2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ioctls

 * PRISM2_PARAM_STA_ANTENNA_SEL
 * PRISM2_PARAM_TX_POWER_REDUCTION
 * PRISM2_PARAM_KEY_INDEX
 * PRISM2_PARAM_DEFAULT_WEP_ONLY
 * PRISM2_PARAM_ALLOW_BROADCAST_ALWAYS

are not used by hostapd or wpa_supplicant.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwl-4965-rs.c |    2 -
 include/net/mac80211.h             |    1 
 net/mac80211/debugfs.c             |    5 ---
 net/mac80211/hostapd_ioctl.h       |    5 ---
 net/mac80211/ieee80211_i.h         |   11 ------
 net/mac80211/ieee80211_ioctl.c     |   59 -------------------------------------
 net/mac80211/rc80211_simple.c      |    8 -----
 net/mac80211/sta_info.h            |    4 --
 net/mac80211/tx.c                  |    3 -
 9 files changed, 98 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-08-15 14:07:56.616516958 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-08-15 14:16:21.946516958 +0200
@@ -37,13 +37,8 @@ enum {
 	PRISM2_PARAM_NEXT_MODE = 1008,
 	PRISM2_PARAM_PRIVACY_INVOKED = 1014,
 	PRISM2_PARAM_BROADCAST_SSID = 1015,
-	PRISM2_PARAM_STA_ANTENNA_SEL = 1017,
-	PRISM2_PARAM_TX_POWER_REDUCTION = 1022,
 	PRISM2_PARAM_EAPOL = 1023,
 	PRISM2_PARAM_KEY_TX_RX_THRESHOLD = 1024,
-	PRISM2_PARAM_KEY_INDEX = 1025,
-	PRISM2_PARAM_DEFAULT_WEP_ONLY = 1026,
-	PRISM2_PARAM_ALLOW_BROADCAST_ALWAYS = 1034,
 	PRISM2_PARAM_HW_MODES = 1036,
 	PRISM2_PARAM_CREATE_IBSS = 1037,
 	PRISM2_PARAM_WMM_ENABLED = 1038,
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-08-15 14:07:46.456516958 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-08-15 14:16:22.076516958 +0200
@@ -591,12 +591,6 @@ struct ieee80211_local {
 	struct work_struct sta_debugfs_add;
 #endif
 
-	enum {
-		STA_ANTENNA_SEL_AUTO = 0,
-		STA_ANTENNA_SEL_SW_CTRL = 1,
-		STA_ANTENNA_SEL_SW_CTRL_DEBUG = 2
-	} sta_antenna_sel;
-
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	/* TX/RX handler statistics */
 	unsigned int tx_handlers_drop;
@@ -632,10 +626,6 @@ struct ieee80211_local {
 	int total_ps_buffered; /* total number of all buffered unicast and
 				* multicast packets for power saving stations
 				*/
-	int allow_broadcast_always; /* whether to allow TX of broadcast frames
-				     * even when there are no associated STAs
-				     */
-
 	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
 
 	unsigned int enabled_modes; /* bitfield of allowed modes;
@@ -662,7 +652,6 @@ struct ieee80211_local {
 		struct dentry *mode;
 		struct dentry *wep_iv;
 		struct dentry *rate_ctrl_alg;
-		struct dentry *tx_power_reduction;
 		struct dentry *modes;
 		struct dentry *statistics;
 		struct local_debugfsdentries_statsdentries {
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-15 14:07:56.626516958 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-15 14:16:22.106516958 +0200
@@ -2201,17 +2201,6 @@ static int ieee80211_ioctl_prism2_param(
 			local->hw.conf.flags &= ~IEEE80211_CONF_SSID_HIDDEN;
 		break;
 
-	case PRISM2_PARAM_STA_ANTENNA_SEL:
-		local->sta_antenna_sel = value;
-		break;
-
-	case PRISM2_PARAM_TX_POWER_REDUCTION:
-		if (value < 0)
-			ret = -EINVAL;
-		else
-			local->hw.conf.tx_power_reduction = value;
-		break;
-
 	case PRISM2_PARAM_EAPOL:
 		sdata->eapol = value;
 		break;
@@ -2220,23 +2209,6 @@ static int ieee80211_ioctl_prism2_param(
 		local->key_tx_rx_threshold = value;
 		break;
 
-	case PRISM2_PARAM_KEY_INDEX:
-		if (value < 0 || value >= NUM_DEFAULT_KEYS)
-			ret = -EINVAL;
-		else if (!sdata->keys[value])
-			ret = -ENOENT;
-		else
-			sdata->default_key = sdata->keys[value];
-		break;
-
-	case PRISM2_PARAM_DEFAULT_WEP_ONLY:
-		ret = ieee80211_ioctl_default_wep_only(local, value);
-		break;
-
-	case PRISM2_PARAM_ALLOW_BROADCAST_ALWAYS:
-		local->allow_broadcast_always = value;
-		break;
-
 	case PRISM2_PARAM_MIXED_CELL:
 		if (sdata->type != IEEE80211_IF_TYPE_STA &&
 		    sdata->type != IEEE80211_IF_TYPE_IBSS)
@@ -2348,14 +2320,6 @@ static int ieee80211_ioctl_get_prism2_pa
 		*param = !!(local->hw.conf.flags & IEEE80211_CONF_SSID_HIDDEN);
 		break;
 
-	case PRISM2_PARAM_STA_ANTENNA_SEL:
-		*param = local->sta_antenna_sel;
-		break;
-
-	case PRISM2_PARAM_TX_POWER_REDUCTION:
-		*param = local->hw.conf.tx_power_reduction;
-		break;
-
 	case PRISM2_PARAM_EAPOL:
 		*param = sdata->eapol;
 		break;
@@ -2364,29 +2328,6 @@ static int ieee80211_ioctl_get_prism2_pa
 		*param = local->key_tx_rx_threshold;
 		break;
 
-	case PRISM2_PARAM_KEY_INDEX:
-		if (!sdata->default_key)
-			ret = -ENOENT;
-		else if (sdata->default_key == sdata->keys[0])
-			*param = 0;
-		else if (sdata->default_key == sdata->keys[1])
-			*param = 1;
-		else if (sdata->default_key == sdata->keys[2])
-			*param = 2;
-		else if (sdata->default_key == sdata->keys[3])
-			*param = 3;
-		else
-			ret = -ENOENT;
-		break;
-
-	case PRISM2_PARAM_DEFAULT_WEP_ONLY:
-		*param = local->default_wep_only;
-		break;
-
-	case PRISM2_PARAM_ALLOW_BROADCAST_ALWAYS:
-		*param = local->allow_broadcast_always;
-		break;
-
 	case PRISM2_PARAM_HW_MODES:
 		*param = local->enabled_modes;
 		break;
--- wireless-dev.orig/net/mac80211/rc80211_simple.c	2007-08-15 14:04:45.496516958 +0200
+++ wireless-dev/net/mac80211/rc80211_simple.c	2007-08-15 14:08:02.996516958 +0200
@@ -147,14 +147,6 @@ static void rate_control_simple_tx_statu
 	srctrl = sta->rate_ctrl_priv;
 	srctrl->tx_num_xmit++;
 	if (status->excessive_retries) {
-		sta->antenna_sel_tx = sta->antenna_sel_tx == 1 ? 2 : 1;
-		sta->antenna_sel_rx = sta->antenna_sel_rx == 1 ? 2 : 1;
-		if (local->sta_antenna_sel == STA_ANTENNA_SEL_SW_CTRL_DEBUG) {
-			printk(KERN_DEBUG "%s: " MAC_FMT " TX antenna --> %d "
-			       "RX antenna --> %d (@%lu)\n",
-			       dev->name, MAC_ARG(hdr->addr1),
-			       sta->antenna_sel_tx, sta->antenna_sel_rx, jiffies);
-		}
 		srctrl->tx_num_failures++;
 		sta->tx_retry_failed++;
 		sta->tx_num_consecutive_failures++;
--- wireless-dev.orig/net/mac80211/tx.c	2007-08-15 14:04:47.806516958 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-08-15 14:08:02.996516958 +0200
@@ -243,7 +243,6 @@ ieee80211_tx_h_check_assoc(struct ieee80
 	} else {
 		if (unlikely((tx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA &&
 			     tx->local->num_sta == 0 &&
-			     !tx->local->allow_broadcast_always &&
 			     tx->sdata->type != IEEE80211_IF_TYPE_IBSS)) {
 			/*
 			 * No associated STAs - no need to send multicast
@@ -959,8 +958,6 @@ __ieee80211_tx_prepare(struct ieee80211_
 	 */
 	control->power_level = local->hw.conf.power_level;
 	control->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
-	if (local->sta_antenna_sel != STA_ANTENNA_SEL_AUTO && tx->sta)
-		control->antenna_sel_tx = tx->sta->antenna_sel_tx;
 
 	/* process and remove the injection radiotap header */
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
--- wireless-dev.orig/net/mac80211/sta_info.h	2007-08-15 14:04:45.536516958 +0200
+++ wireless-dev/net/mac80211/sta_info.h	2007-08-15 14:08:02.996516958 +0200
@@ -91,10 +91,6 @@ struct sta_info {
 	int channel_use;
 	int channel_use_raw;
 
-	u8 antenna_sel_tx;
-	u8 antenna_sel_rx;
-
-
 	int key_idx_compression; /* key table index for compression and TX
 				  * filtering; used only if sta->key is not
 				  * set */
--- wireless-dev.orig/include/net/mac80211.h	2007-08-15 14:07:46.476516958 +0200
+++ wireless-dev/include/net/mac80211.h	2007-08-15 14:16:19.606516958 +0200
@@ -294,7 +294,6 @@ struct ieee80211_conf {
 	u8 power_level;			/* transmit power limit for current
 					 * regulatory domain; in dBm */
 	u8 antenna_max;			/* maximum antenna gain */
-	short tx_power_reduction; /* in 0.1 dBm */
 
 	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */
 	u8 antenna_sel_tx;
--- wireless-dev.orig/net/mac80211/debugfs.c	2007-08-15 14:04:45.596516958 +0200
+++ wireless-dev/net/mac80211/debugfs.c	2007-08-15 14:16:19.396516958 +0200
@@ -124,9 +124,6 @@ DEBUGFS_READONLY_FILE(mode, 20, "%s",
 		      ieee80211_mode_str(local->hw.conf.phymode));
 DEBUGFS_READONLY_FILE(wep_iv, 20, "%#06x",
 		      local->wep_iv & 0xffffff);
-DEBUGFS_READONLY_FILE(tx_power_reduction, 20, "%d.%d dBm",
-		      local->hw.conf.tx_power_reduction / 10,
-		      local->hw.conf.tx_power_reduction % 10);
 DEBUGFS_READ(rate_ctrl_alg, 100, "%s",
 	     local->rate_ctrl ? local->rate_ctrl->ops->name : "<unset>");
 
@@ -347,7 +344,6 @@ void debugfs_hw_add(struct ieee80211_loc
 	DEBUGFS_ADD(total_ps_buffered);
 	DEBUGFS_ADD(mode);
 	DEBUGFS_ADD(wep_iv);
-	DEBUGFS_ADD(tx_power_reduction);
 	DEBUGFS_ADD_MODE(rate_ctrl_alg, 0644);
 	DEBUGFS_ADD(modes);
 
@@ -413,7 +409,6 @@ void debugfs_hw_del(struct ieee80211_loc
 	DEBUGFS_DEL(total_ps_buffered);
 	DEBUGFS_DEL(mode);
 	DEBUGFS_DEL(wep_iv);
-	DEBUGFS_DEL(tx_power_reduction);
 	DEBUGFS_DEL(rate_ctrl_alg);
 	DEBUGFS_DEL(modes);
 
--- wireless-dev.orig/drivers/net/wireless/iwl-4965-rs.c	2007-08-15 14:16:19.686516958 +0200
+++ wireless-dev/drivers/net/wireless/iwl-4965-rs.c	2007-08-15 14:16:28.706516958 +0200
@@ -1661,8 +1661,6 @@ out:
 	    (lq_data->phymode == (u8) MODE_ATHEROS_TURBO))
 		sta->txrate = i - IWL_FIRST_OFDM_RATE;
 
-	sta->antenna_sel_tx = tbl->lq_type;
-
 	return;
 }
 

-- 

