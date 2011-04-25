Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49150 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758203Ab1DYSXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 14:23:16 -0400
Date: Mon, 25 Apr 2011 13:23:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 05/18] rtlwifi: Convert core routines for addition of
 rtl8192se and rtl8192de
Message-ID: <4db5bc0e.GYT4mUfa4SQS6JSe%Larry.Finger@lwfinger.net> (sfid-20110425_202320_297780_EAE3A409)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming_Li <chaoming_li@realsil.com.cn>

Convert core routines for addition of RTL8192SE and RTL8192DE code.

Additional files are changed to allow compilation.

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 base.c          |    7 
 core.c          |  409 +++++++++++++++++++++++++++++++++++---------------------
 core.h          |    2 
 ps.c            |    4 
 rtl8192cu/trx.c |    2 
 usb.c           |    3 
 wifi.h          |    4 
 7 files changed, 270 insertions(+), 161 deletions(-)
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/base.c
@@ -1182,14 +1182,8 @@ int rtl_send_smps_action(struct ieee8021
 		info->control.rates[0].idx = 0;
 		info->control.sta = sta;
 		info->band = hw->conf.channel->band;
-#if 0
 		rtlpriv->intf_ops->adapter_tx(hw, skb, &tcb_desc);
-#else
-		rtlpriv->intf_ops->adapter_tx(hw, skb);
-#endif
 	}
-	return 1;
-
 err_free:
 	return 0;
 }
Index: wireless-testing/drivers/net/wireless/rtlwifi/core.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/core.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/core.c
@@ -24,6 +24,7 @@
  * Hsinchu 300, Taiwan.
  *
  * Larry Finger <Larry.Finger@lwfinger.net>
+ *
  *****************************************************************************/
 
 #include "wifi.h"
@@ -70,6 +71,7 @@ static void rtl_op_stop(struct ieee80211
 
 	mac->link_state = MAC80211_NOLINK;
 	memset(mac->bssid, 0, 6);
+	mac->vendor = PEER_UNKNOWN;
 
 	/*reset sec info */
 	rtl_cam_reset_sec_info(hw);
@@ -85,6 +87,8 @@ static void rtl_op_tx(struct ieee80211_h
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	struct rtl_tcb_desc tcb_desc;
+	memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
 
 	if (unlikely(is_hal_stop(rtlhal) || ppsc->rfpwr_state != ERFON))
 		goto err_free;
@@ -92,8 +96,8 @@ static void rtl_op_tx(struct ieee80211_h
 	if (!test_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status))
 		goto err_free;
 
-
-	rtlpriv->intf_ops->adapter_tx(hw, skb);
+	if (!rtlpriv->intf_ops->waitq_insert(hw, skb))
+		rtlpriv->intf_ops->adapter_tx(hw, skb, &tcb_desc);
 
 	return;
 
@@ -134,10 +138,26 @@ static int rtl_op_add_interface(struct i
 
 		mac->link_state = MAC80211_LINKED;
 		rtlpriv->cfg->ops->set_bcn_reg(hw);
+		if (rtlpriv->rtlhal.current_bandtype == BAND_ON_2_4G)
+			mac->basic_rates = 0xfff;
+		else
+			mac->basic_rates = 0xff0;
+		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_BASIC_RATE,
+				(u8 *) (&mac->basic_rates));
+
 		break;
 	case NL80211_IFTYPE_AP:
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 			 ("NL80211_IFTYPE_AP\n"));
+
+		mac->link_state = MAC80211_LINKED;
+		rtlpriv->cfg->ops->set_bcn_reg(hw);
+		if (rtlpriv->rtlhal.current_bandtype == BAND_ON_2_4G)
+			mac->basic_rates = 0xfff;
+		else
+			mac->basic_rates = 0xff0;
+		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_BASIC_RATE,
+				(u8 *) (&mac->basic_rates));
 		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
@@ -184,13 +204,12 @@ static void rtl_op_remove_interface(stru
 	mac->vif = NULL;
 	mac->link_state = MAC80211_NOLINK;
 	memset(mac->bssid, 0, 6);
+	mac->vendor = PEER_UNKNOWN;
 	mac->opmode = NL80211_IFTYPE_UNSPECIFIED;
 	rtlpriv->cfg->ops->set_network_type(hw, mac->opmode);
-
 	mutex_unlock(&rtlpriv->locks.conf_mutex);
 }
 
-
 static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -222,10 +241,25 @@ static int rtl_op_config(struct ieee8021
 
 	/*For LPS */
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
-		if (conf->flags & IEEE80211_CONF_PS)
-			rtl_lps_enter(hw);
-		else
-			rtl_lps_leave(hw);
+		cancel_delayed_work(&rtlpriv->works.ps_work);
+		cancel_delayed_work(&rtlpriv->works.ps_rfon_wq);
+		if (conf->flags & IEEE80211_CONF_PS) {
+			rtlpriv->psc.sw_ps_enabled = true;
+			/* sleep here is must, or we may recv the beacon and
+			 * cause mac80211 into wrong ps state, this will cause
+			 * power save nullfunc send fail, and further cause
+			 * pkt loss, So sleep must quickly but not immediatly
+			 * because that will cause nullfunc send by mac80211
+			 * fail, and cause pkt loss, we have tested that 5mA
+			 * is worked very well */
+			if (!rtlpriv->psc.multi_buffered)
+				queue_delayed_work(rtlpriv->works.rtl_wq,
+						&rtlpriv->works.ps_work,
+						MSECS(5));
+		} else {
+			rtl_swlps_rf_awake(hw);
+			rtlpriv->psc.sw_ps_enabled = false;
+		}
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS) {
@@ -257,7 +291,7 @@ static int rtl_op_config(struct ieee8021
 		case NL80211_CHAN_NO_HT:
 			/* SC */
 			mac->cur_40_prime_sc =
-			    PRIME_CHNL_OFFSET_DONT_CARE;
+				PRIME_CHNL_OFFSET_DONT_CARE;
 			rtlphy->current_chan_bw = HT_CHANNEL_WIDTH_20;
 			mac->bw_40 = false;
 			break;
@@ -265,7 +299,7 @@ static int rtl_op_config(struct ieee8021
 			/* SC */
 			mac->cur_40_prime_sc = PRIME_CHNL_OFFSET_UPPER;
 			rtlphy->current_chan_bw =
-			    HT_CHANNEL_WIDTH_20_40;
+				HT_CHANNEL_WIDTH_20_40;
 			mac->bw_40 = true;
 
 			/*wide channel */
@@ -276,7 +310,7 @@ static int rtl_op_config(struct ieee8021
 			/* SC */
 			mac->cur_40_prime_sc = PRIME_CHNL_OFFSET_LOWER;
 			rtlphy->current_chan_bw =
-			    HT_CHANNEL_WIDTH_20_40;
+				HT_CHANNEL_WIDTH_20_40;
 			mac->bw_40 = true;
 
 			/*wide channel */
@@ -286,16 +320,29 @@ static int rtl_op_config(struct ieee8021
 		default:
 			mac->bw_40 = false;
 			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 ("switch case not processed\n"));
+					("switch case not processed\n"));
 			break;
 		}
 
 		if (wide_chan <= 0)
 			wide_chan = 1;
+
+		/* In scanning, before we go offchannel we may send a ps=1 null
+		 * to AP, and then we may send a ps = 0 null to AP quickly, but
+		 * first null may have caused AP to put lots of packet to hw tx
+		 * buffer. These packets must be tx'd before we go off channel
+		 * so we must delay more time to let AP flush these packets
+		 * before going offchannel, or dis-association or delete BA will
+		 * happen by AP
+		 */
+		if (rtlpriv->mac80211.offchan_deley) {
+			rtlpriv->mac80211.offchan_deley = false;
+			mdelay(50);
+		}
 		rtlphy->current_channel = wide_chan;
 
-		rtlpriv->cfg->ops->set_channel_access(hw);
 		rtlpriv->cfg->ops->switch_channel(hw);
+		rtlpriv->cfg->ops->set_channel_access(hw);
 		rtlpriv->cfg->ops->set_bw_mode(hw,
 					       hw->conf.channel_type);
 	}
@@ -343,27 +390,28 @@ static void rtl_op_configure_filter(stru
 		}
 	}
 
-	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
-		/*
-		 *TODO: BIT(5) is probe response BIT(8) is beacon
-		 *TODO: Use define for BIT(5) and BIT(8)
-		 */
-		if (*new_flags & FIF_BCN_PRBRESP_PROMISC)
-			mac->rx_mgt_filter |= (BIT(5) | BIT(8));
-		else
-			mac->rx_mgt_filter &= ~(BIT(5) | BIT(8));
+	/* if ssid not set to hw don't check bssid
+	 * here just used for linked scanning, & linked
+	 * and nolink check bssid is set in set network_type */
+	if ((changed_flags & FIF_BCN_PRBRESP_PROMISC) &&
+		(mac->link_state >= MAC80211_LINKED)) {
+		if (mac->opmode != NL80211_IFTYPE_AP) {
+			if (*new_flags & FIF_BCN_PRBRESP_PROMISC) {
+				rtlpriv->cfg->ops->set_chk_bssid(hw, false);
+			} else {
+				rtlpriv->cfg->ops->set_chk_bssid(hw, true);
+			}
+		}
 	}
 
 	if (changed_flags & FIF_CONTROL) {
 		if (*new_flags & FIF_CONTROL) {
 			mac->rx_conf |= rtlpriv->cfg->maps[MAC_RCR_ACF];
-			mac->rx_ctrl_filter |= RTL_SUPPORTED_CTRL_FILTER;
 
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 				 ("Enable receive control frame.\n"));
 		} else {
 			mac->rx_conf &= ~rtlpriv->cfg->maps[MAC_RCR_ACF];
-			mac->rx_ctrl_filter &= ~RTL_SUPPORTED_CTRL_FILTER;
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 				 ("Disable receive control frame.\n"));
 		}
@@ -380,14 +428,54 @@ static void rtl_op_configure_filter(stru
 				 ("Disable receive other BSS's frame.\n"));
 		}
 	}
-
-	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR, (u8 *) (&mac->rx_conf));
-	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_MGT_FILTER,
-				      (u8 *) (&mac->rx_mgt_filter));
-	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_CTRL_FILTER,
-				      (u8 *) (&mac->rx_ctrl_filter));
 }
+static int rtl_op_sta_add(struct ieee80211_hw *hw,
+			 struct ieee80211_vif *vif,
+			 struct ieee80211_sta *sta)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_sta_info *sta_entry;
 
+	if (sta) {
+		sta_entry = (struct rtl_sta_info *) sta->drv_priv;
+		if (rtlhal->current_bandtype == BAND_ON_2_4G) {
+			sta_entry->wireless_mode = WIRELESS_MODE_G;
+			if (sta->supp_rates[0] <= 0xf)
+				sta_entry->wireless_mode = WIRELESS_MODE_B;
+			if (sta->ht_cap.ht_supported == true)
+				sta_entry->wireless_mode = WIRELESS_MODE_N_24G;
+		} else if (rtlhal->current_bandtype == BAND_ON_5G) {
+			sta_entry->wireless_mode = WIRELESS_MODE_A;
+			if (sta->ht_cap.ht_supported == true)
+				sta_entry->wireless_mode = WIRELESS_MODE_N_24G;
+		}
+
+		/* I found some times mac80211 give wrong supp_rates for adhoc*/
+		if (rtlpriv->mac80211.opmode == NL80211_IFTYPE_ADHOC)
+			sta_entry->wireless_mode = WIRELESS_MODE_G;
+
+		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
+			("Add sta addr is "MAC_FMT"\n", MAC_ARG(sta->addr)));
+		rtlpriv->cfg->ops->update_rate_tbl(hw, sta, 0);
+	}
+	return 0;
+}
+static int rtl_op_sta_remove(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_sta_info *sta_entry;
+	if (sta) {
+		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
+			("Remove sta addr is "MAC_FMT"\n", MAC_ARG(sta->addr)));
+		sta_entry = (struct rtl_sta_info *) sta->drv_priv;
+		sta_entry->wireless_mode = 0;
+		sta_entry->ratr_index = 0;
+	}
+	return 0;
+}
 static int _rtl_get_hal_qnum(u16 queue)
 {
 	int qnum;
@@ -444,19 +532,18 @@ static void rtl_op_bss_info_changed(stru
 			     struct ieee80211_bss_conf *bss_conf, u32 changed)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	struct ieee80211_sta *sta = NULL;
 
 	mutex_lock(&rtlpriv->locks.conf_mutex);
-
 	if ((vif->type == NL80211_IFTYPE_ADHOC) ||
 	    (vif->type == NL80211_IFTYPE_AP) ||
 	    (vif->type == NL80211_IFTYPE_MESH_POINT)) {
-
 		if ((changed & BSS_CHANGED_BEACON) ||
 		    (changed & BSS_CHANGED_BEACON_ENABLED &&
 		     bss_conf->enable_beacon)) {
-
 			if (mac->beacon_enabled == 0) {
 				RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
 					 ("BSS_CHANGED_BEACON_ENABLED\n"));
@@ -468,8 +555,13 @@ static void rtl_op_bss_info_changed(stru
 						rtlpriv->cfg->maps
 						[RTL_IBSS_INT_MASKS],
 						0);
+
+				if (rtlpriv->cfg->ops->linked_set_reg)
+					rtlpriv->cfg->ops->linked_set_reg(hw);
 			}
-		} else {
+		}
+		if ((changed & BSS_CHANGED_BEACON_ENABLED &&
+			!bss_conf->enable_beacon)) {
 			if (mac->beacon_enabled == 1) {
 				RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
 					 ("ADHOC DISABLE BEACON\n"));
@@ -480,7 +572,6 @@ static void rtl_op_bss_info_changed(stru
 						[RTL_IBSS_INT_MASKS]);
 			}
 		}
-
 		if (changed & BSS_CHANGED_BEACON_INT) {
 			RT_TRACE(rtlpriv, COMP_BEACON, DBG_TRACE,
 				 ("BSS_CHANGED_BEACON_INT\n"));
@@ -492,11 +583,25 @@ static void rtl_op_bss_info_changed(stru
 	/*TODO: reference to enum ieee80211_bss_change */
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
+			/* we should reset all sec info & cam
+			 * before set cam after linked, we should not
+			 * reset in disassoc, that will cause tkip->wep
+			 * fail because some flag will be wrong */
+			/* reset sec info */
+			rtl_cam_reset_sec_info(hw);
+			/* reset cam to fix wep fail issue
+			 * when change from wpa to wep */
+			rtl_cam_reset_all_entry(hw);
+
 			mac->link_state = MAC80211_LINKED;
 			mac->cnt_after_linked = 0;
 			mac->assoc_id = bss_conf->aid;
 			memcpy(mac->bssid, bss_conf->bssid, 6);
 
+			if (rtlpriv->cfg->ops->linked_set_reg)
+				rtlpriv->cfg->ops->linked_set_reg(hw);
+			if (mac->opmode == NL80211_IFTYPE_STATION && sta)
+				rtlpriv->cfg->ops->update_rate_tbl(hw, sta, 0);
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
 				 ("BSS_CHANGED_ASSOC\n"));
 		} else {
@@ -505,9 +610,7 @@ static void rtl_op_bss_info_changed(stru
 
 			mac->link_state = MAC80211_NOLINK;
 			memset(mac->bssid, 0, 6);
-
-			/* reset sec info */
-			rtl_cam_reset_sec_info(hw);
+			mac->vendor = PEER_UNKNOWN;
 
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
 				 ("BSS_CHANGED_UN_ASSOC\n"));
@@ -544,14 +647,10 @@ static void rtl_op_bss_info_changed(stru
 	}
 
 	if (changed & BSS_CHANGED_HT) {
-		struct ieee80211_sta *sta = NULL;
-
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_TRACE,
 			 ("BSS_CHANGED_HT\n"));
-
 		rcu_read_lock();
-		sta = ieee80211_find_sta(mac->vif, mac->bssid);
-
+		sta = get_sta(hw, vif, (u8 *)bss_conf->bssid);
 		if (sta) {
 			if (sta->ht_cap.ampdu_density >
 			    mac->current_ampdu_density)
@@ -573,9 +672,7 @@ static void rtl_op_bss_info_changed(stru
 	}
 
 	if (changed & BSS_CHANGED_BSSID) {
-		struct ieee80211_sta *sta = NULL;
 		u32 basic_rates;
-		u8 i;
 
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_BSSID,
 					      (u8 *) bss_conf->bssid);
@@ -583,96 +680,65 @@ static void rtl_op_bss_info_changed(stru
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
 			 (MAC_FMT "\n", MAC_ARG(bss_conf->bssid)));
 
+		mac->vendor = PEER_UNKNOWN;
 		memcpy(mac->bssid, bss_conf->bssid, 6);
-		if (is_valid_ether_addr(bss_conf->bssid)) {
-			switch (vif->type) {
-			case NL80211_IFTYPE_UNSPECIFIED:
-				break;
-			case NL80211_IFTYPE_ADHOC:
-				break;
-			case NL80211_IFTYPE_STATION:
-				break;
-			case NL80211_IFTYPE_AP:
-				break;
-			default:
-				RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-					 ("switch case not process\n"));
-				break;
-			}
-			rtlpriv->cfg->ops->set_network_type(hw, vif->type);
-		} else
-			rtlpriv->cfg->ops->set_network_type(hw,
-					NL80211_IFTYPE_UNSPECIFIED);
-
-		memset(mac->mcs, 0, 16);
-		mac->ht_enable = false;
-		mac->sgi_40 = false;
-		mac->sgi_20 = false;
-
-		if (!bss_conf->use_short_slot)
-			mac->mode = WIRELESS_MODE_B;
-		else
-			mac->mode = WIRELESS_MODE_G;
+		rtlpriv->cfg->ops->set_network_type(hw, vif->type);
 
 		rcu_read_lock();
-		sta = ieee80211_find_sta(mac->vif, mac->bssid);
+		sta = get_sta(hw, vif, (u8 *)bss_conf->bssid);
+		if (!sta) {
+			rcu_read_unlock();
+			goto out;
+		}
 
-		if (sta) {
-			if (sta->ht_cap.ht_supported) {
+		if (rtlhal->current_bandtype == BAND_ON_5G) {
+			mac->mode = WIRELESS_MODE_A;
+		} else {
+			if (sta->supp_rates[0] <= 0xf)
+				mac->mode = WIRELESS_MODE_B;
+			else
+				mac->mode = WIRELESS_MODE_G;
+		}
+
+		if (sta->ht_cap.ht_supported) {
+			if (rtlhal->current_bandtype == BAND_ON_2_4G)
 				mac->mode = WIRELESS_MODE_N_24G;
-				mac->ht_enable = true;
-			}
+			else
+				mac->mode = WIRELESS_MODE_N_5G;
+		}
 
-			if (mac->ht_enable) {
-				u16 ht_cap = sta->ht_cap.cap;
-				memcpy(mac->mcs, (u8 *) (&sta->ht_cap.mcs), 16);
-
-				for (i = 0; i < 16; i++)
-					RT_TRACE(rtlpriv, COMP_MAC80211,
-						 DBG_LOUD, ("%x ",
-							    mac->mcs[i]));
-				RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
-					 ("\n"));
-
-				if (ht_cap & IEEE80211_HT_CAP_SGI_40)
-					mac->sgi_40 = true;
-
-				if (ht_cap & IEEE80211_HT_CAP_SGI_20)
-					mac->sgi_20 = true;
-
-				/*
-				 * for cisco 1252 bw20 it's wrong
-				 * if (ht_cap &
-				 *     IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
-				 *	mac->bw_40 = true;
-				 * }
-				 */
-			}
+		/* just station need it, because ibss & ap mode will
+		 * set in sta_add, and will be NULL here */
+		if (mac->opmode == NL80211_IFTYPE_STATION) {
+			struct rtl_sta_info *sta_entry;
+			sta_entry = (struct rtl_sta_info *) sta->drv_priv;
+			sta_entry->wireless_mode = mac->mode;
+		}
+
+		if (sta->ht_cap.ht_supported) {
+			mac->ht_enable = true;
+
+			/*
+			 * for cisco 1252 bw20 it's wrong
+			 * if (ht_cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
+			 *	mac->bw_40 = true;
+			 * }
+			 * */
 		}
-		rcu_read_unlock();
 
-		/*mac80211 just give us CCK rates any time
-		 *So we add G rate in basic rates when
-		 not in B mode*/
 		if (changed & BSS_CHANGED_BASIC_RATES) {
-			if (mac->mode == WIRELESS_MODE_B)
-				basic_rates = bss_conf->basic_rates | 0x00f;
+			/* for 5G must << RATE_6M_INDEX=4,
+			 * because 5G have no cck rate*/
+			if (rtlhal->current_bandtype == BAND_ON_5G)
+				basic_rates = sta->supp_rates[1] << 4;
 			else
-				basic_rates = bss_conf->basic_rates | 0xff0;
-
-			if (!vif)
-				goto out;
+				basic_rates = sta->supp_rates[0];
 
 			mac->basic_rates = basic_rates;
 			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_BASIC_RATE,
 					(u8 *) (&basic_rates));
-
-			if (rtlpriv->dm.useramask)
-				rtlpriv->cfg->ops->update_rate_mask(hw, 0);
-			else
-				rtlpriv->cfg->ops->update_rate_table(hw);
-
 		}
+		rcu_read_unlock();
 	}
 
 	/*
@@ -758,16 +824,17 @@ static int rtl_op_ampdu_action(struct ie
 	case IEEE80211_AMPDU_TX_START:
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_TRACE,
 			 ("IEEE80211_AMPDU_TX_START: TID:%d\n", tid));
-		return rtl_tx_agg_start(hw, sta->addr, tid, ssn);
+		return rtl_tx_agg_start(hw, sta, tid, ssn);
 		break;
 	case IEEE80211_AMPDU_TX_STOP:
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_TRACE,
 			 ("IEEE80211_AMPDU_TX_STOP: TID:%d\n", tid));
-		return rtl_tx_agg_stop(hw, sta->addr, tid);
+		return rtl_tx_agg_stop(hw, sta, tid);
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_TRACE,
 			 ("IEEE80211_AMPDU_TX_OPERATIONAL:TID:%d\n", tid));
+		rtl_tx_agg_oper(hw, sta, tid);
 		break;
 	case IEEE80211_AMPDU_RX_START:
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_TRACE,
@@ -797,8 +864,12 @@ static void rtl_op_sw_scan_start(struct
 	if (mac->link_state == MAC80211_LINKED) {
 		rtl_lps_leave(hw);
 		mac->link_state = MAC80211_LINKED_SCANNING;
-	} else
+	} else {
 		rtl_ips_nic_on(hw);
+	}
+
+	/* Dual mac */
+	rtlpriv->rtlhal.load_imrandiqk_setting_for2g = false;
 
 	rtlpriv->cfg->ops->led_control(hw, LED_CTL_SITE_SURVEY);
 	rtlpriv->cfg->ops->scan_operation_backup(hw, SCAN_OPT_BACKUP);
@@ -810,22 +881,19 @@ static void rtl_op_sw_scan_complete(stru
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
 	RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD, ("\n"));
-
-	rtlpriv->cfg->ops->scan_operation_backup(hw, SCAN_OPT_RESTORE);
 	mac->act_scanning = false;
+	/* Dual mac */
+	rtlpriv->rtlhal.load_imrandiqk_setting_for2g = false;
+
 	if (mac->link_state == MAC80211_LINKED_SCANNING) {
 		mac->link_state = MAC80211_LINKED;
-
-		/* fix fwlps issue */
-		rtlpriv->cfg->ops->set_network_type(hw, mac->opmode);
-
-		if (rtlpriv->dm.useramask)
-			rtlpriv->cfg->ops->update_rate_mask(hw, 0);
-		else
-			rtlpriv->cfg->ops->update_rate_table(hw);
-
+		if (mac->opmode == NL80211_IFTYPE_STATION) {
+			/* fix fwlps issue */
+			rtlpriv->cfg->ops->set_network_type(hw, mac->opmode);
+		}
 	}
 
+	rtlpriv->cfg->ops->scan_operation_backup(hw, SCAN_OPT_RESTORE);
 }
 
 static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
@@ -856,49 +924,73 @@ static int rtl_op_set_key(struct ieee802
 	rtl_ips_nic_on(hw);
 	mutex_lock(&rtlpriv->locks.conf_mutex);
 	/* <1> get encryption alg */
+
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
 		key_type = WEP40_ENCRYPTION;
 		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG, ("alg:WEP40\n"));
-		rtlpriv->sec.use_defaultkey = true;
 		break;
 	case WLAN_CIPHER_SUITE_WEP104:
 		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
 			 ("alg:WEP104\n"));
 		key_type = WEP104_ENCRYPTION;
-		rtlpriv->sec.use_defaultkey = true;
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
 		key_type = TKIP_ENCRYPTION;
 		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG, ("alg:TKIP\n"));
-		if (mac->opmode == NL80211_IFTYPE_ADHOC)
-			rtlpriv->sec.use_defaultkey = true;
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 		key_type = AESCCMP_ENCRYPTION;
 		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG, ("alg:CCMP\n"));
-		if (mac->opmode == NL80211_IFTYPE_ADHOC)
-			rtlpriv->sec.use_defaultkey = true;
 		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 ("alg_err:%x!!!!:\n", key->cipher));
 		goto out_unlock;
 	}
+	if (key_type == WEP40_ENCRYPTION ||
+			key_type == WEP104_ENCRYPTION ||
+			mac->opmode == NL80211_IFTYPE_ADHOC)
+		rtlpriv->sec.use_defaultkey = true;
+
 	/* <2> get key_idx */
 	key_idx = (u8) (key->keyidx);
 	if (key_idx > 3)
 		goto out_unlock;
 	/* <3> if pairwise key enable_hw_sec */
 	group_key = !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE);
-	if ((!group_key) || (mac->opmode == NL80211_IFTYPE_ADHOC) ||
-	    rtlpriv->sec.pairwise_enc_algorithm == NO_ENCRYPTION) {
-		if (rtlpriv->sec.pairwise_enc_algorithm == NO_ENCRYPTION &&
-		    (key_type == WEP40_ENCRYPTION ||
-		     key_type == WEP104_ENCRYPTION))
-			wep_only = true;
-		rtlpriv->sec.pairwise_enc_algorithm = key_type;
-		rtlpriv->cfg->ops->enable_hw_sec(hw);
+
+	/* wep always be group key, but there are two conditions:
+	 * 1) wep only: is just for wep enc, in this condition
+	 * rtlpriv->sec.pairwise_enc_algorithm == NO_ENCRYPTION
+	 * will be true & enable_hw_sec will be set when wep
+	 * ke setting.
+	 * 2) wep(group) + AES(pairwise): some AP like cisco
+	 * may use it, in this condition enable_hw_sec will not
+	 * be set when wep key setting */
+	/* we must reset sec_info after lingked before set key,
+	 * or some flag will be wrong*/
+	if (mac->opmode == NL80211_IFTYPE_AP) {
+		if (!group_key || key_type == WEP40_ENCRYPTION ||
+			key_type == WEP104_ENCRYPTION) {
+			if (group_key)
+				wep_only = true;
+			rtlpriv->cfg->ops->enable_hw_sec(hw);
+		}
+	} else {
+		if ((!group_key) || (mac->opmode == NL80211_IFTYPE_ADHOC) ||
+		     rtlpriv->sec.pairwise_enc_algorithm == NO_ENCRYPTION) {
+			if (rtlpriv->sec.pairwise_enc_algorithm ==
+			    NO_ENCRYPTION &&
+			    (key_type == WEP40_ENCRYPTION ||
+			    key_type == WEP104_ENCRYPTION))
+				wep_only = true;
+			rtlpriv->sec.pairwise_enc_algorithm = key_type;
+			RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
+				("set enable_hw_sec, key_type:%x(OPEN:0 WEP40:1"
+				" TKIP:2 AES:4 WEP104:5)\n", key_type));
+			rtlpriv->cfg->ops->enable_hw_sec(hw);
+		}
 	}
 	/* <4> set key based on cmd */
 	switch (cmd) {
@@ -930,6 +1022,7 @@ static int rtl_op_set_key(struct ieee802
 			if (!sta) {
 				RT_ASSERT(false, ("pairwise key withnot"
 						  "mac_addr\n"));
+
 				err = -EOPNOTSUPP;
 				goto out_unlock;
 			}
@@ -957,6 +1050,10 @@ static int rtl_op_set_key(struct ieee802
 		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
 			 ("disable key delete one entry\n"));
 		/*set local buf about wep key. */
+		if (mac->opmode == NL80211_IFTYPE_AP) {
+			if (sta)
+				rtl_cam_del_entry(hw, sta->addr);
+		}
 		memset(rtlpriv->sec.key_buf[key_idx], 0, key->keylen);
 		rtlpriv->sec.key_len[key_idx] = 0;
 		memcpy(mac_addr, zero_addr, ETH_ALEN);
@@ -1009,6 +1106,18 @@ static void rtl_op_rfkill_poll(struct ie
 	mutex_unlock(&rtlpriv->locks.conf_mutex);
 }
 
+/* this function is called by mac80211 to flush tx buffer
+ * before switch channle or power save, or tx buffer packet
+ * maybe send after offchannel or rf sleep, this may cause
+ * dis-association by AP */
+static void rtl_op_flush(struct ieee80211_hw *hw, bool drop)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	if (rtlpriv->intf_ops->flush)
+		rtlpriv->intf_ops->flush(hw, drop);
+}
+
 const struct ieee80211_ops rtl_ops = {
 	.start = rtl_op_start,
 	.stop = rtl_op_stop,
@@ -1017,6 +1126,8 @@ const struct ieee80211_ops rtl_ops = {
 	.remove_interface = rtl_op_remove_interface,
 	.config = rtl_op_config,
 	.configure_filter = rtl_op_configure_filter,
+	.sta_add = rtl_op_sta_add,
+	.sta_remove = rtl_op_sta_remove,
 	.set_key = rtl_op_set_key,
 	.conf_tx = rtl_op_conf_tx,
 	.bss_info_changed = rtl_op_bss_info_changed,
@@ -1028,4 +1139,6 @@ const struct ieee80211_ops rtl_ops = {
 	.sw_scan_start = rtl_op_sw_scan_start,
 	.sw_scan_complete = rtl_op_sw_scan_complete,
 	.rfkill_poll = rtl_op_rfkill_poll,
+	.flush = rtl_op_flush,
 };
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/core.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/core.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/core.h
@@ -24,6 +24,7 @@
  * Hsinchu 300, Taiwan.
  *
  * Larry Finger <Larry.Finger@lwfinger.net>
+ *
  *****************************************************************************/
 
 #ifndef __RTL_CORE_H__
@@ -40,3 +41,4 @@
 
 extern const struct ieee80211_ops rtl_ops;
 #endif
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/ps.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/ps.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/ps.c
@@ -424,6 +424,10 @@ void rtl_swlps_wq_callback(void *data)
 {
 }
 
+void rtl_swlps_rf_awake(struct ieee80211_hw *hw)
+{
+}
+
 /*Enter the leisure power save mode.*/
 void rtl_lps_enter(struct ieee80211_hw *hw)
 {
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -504,7 +504,7 @@ void rtl92cu_tx_fill_desc(struct ieee802
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	bool defaultadapter = true;
-	struct ieee80211_sta *sta;
+	struct ieee80211_sta *sta = info->control.sta;
 	struct rtl_tcb_desc tcb_desc;
 	u8 *qc = ieee80211_get_qos_ctl(hdr);
 	u8 tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
Index: wireless-testing/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/usb.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/usb.c
@@ -885,7 +885,8 @@ static void _rtl_usb_tx_preprocess(struc
 		rtlpriv->cfg->ops->led_control(hw, LED_CTL_TX);
 }
 
-static int rtl_usb_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static int rtl_usb_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
+		      struct rtl_tcb_desc *dummy)
 {
 	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
Index: wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
@@ -1445,12 +1445,8 @@ struct rtl_intf_ops {
 	int (*adapter_start) (struct ieee80211_hw *hw);
 	void (*adapter_stop) (struct ieee80211_hw *hw);
 
-#if 0	/* temporary */
 	int (*adapter_tx) (struct ieee80211_hw *hw, struct sk_buff *skb,
 			struct rtl_tcb_desc *ptcb_desc);
-#else
-	int (*adapter_tx) (struct ieee80211_hw *hw, struct sk_buff *skb);
-#endif
 	void (*flush)(struct ieee80211_hw *hw, bool drop);
 	int (*reset_trx_ring) (struct ieee80211_hw *hw);
 	bool (*waitq_insert) (struct ieee80211_hw *hw, struct sk_buff *skb);
