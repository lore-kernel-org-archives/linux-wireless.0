Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:37831 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751229AbdLIRhS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Dec 2017 12:37:18 -0500
Received: by mail-ot0-f196.google.com with SMTP id s4so11627156ote.4
        for <linux-wireless@vger.kernel.org>; Sat, 09 Dec 2017 09:37:18 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Tsang-Shian Lin <thlin@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 2/3] rtlwifi: Add beacon check mechanism to check if AP settings changed.
Date: Sat,  9 Dec 2017 11:37:09 -0600
Message-Id: <20171209173710.9879-3-Larry.Finger@lwfinger.net> (sfid-20171209_183726_588694_19730082)
In-Reply-To: <20171209173710.9879-1-Larry.Finger@lwfinger.net>
References: <20171209173710.9879-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tsang-Shian Lin <thlin@realtek.com>

AP WiFi settings are changed(channel, bandwidth), but deauth may not
received by STA. For these cases, we need to detect and handle beacon
changes.

Signed-off-by: Tsang-Shian Lin <thlin@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 179 ++++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtlwifi/base.h |   3 +-
 drivers/net/wireless/realtek/rtlwifi/core.c |  48 ++++++++
 drivers/net/wireless/realtek/rtlwifi/pci.c  |   2 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h |  13 ++
 5 files changed, 244 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index cad2272ae21b..a04afdd55569 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -2360,6 +2360,185 @@ struct sk_buff *rtl_make_del_ba(struct ieee80211_hw *hw,
 	return skb;
 }
 
+bool rtl_check_beacon_key(struct ieee80211_hw *hw, void *data, unsigned int len)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_phy *rtlphy = &rtlpriv->phy;
+	struct ieee80211_hdr *hdr = data;
+	struct ieee80211_ht_cap *ht_cap_ie;
+	struct ieee80211_ht_operation *ht_oper_ie = NULL;
+	struct rtl_beacon_keys bcn_key = {0};
+	struct rtl_beacon_keys *cur_bcn_key;
+	u8 *ht_cap;
+	u8 ht_cap_len;
+	u8 *ht_oper;
+	u8 ht_oper_len;
+	u8 *ds_param;
+	u8 ds_param_len;
+
+	if (mac->opmode != NL80211_IFTYPE_STATION)
+		return false;
+
+	/* check if this really is a beacon*/
+	if (!ieee80211_is_beacon(hdr->frame_control))
+		return false;
+
+	/* min. beacon length + FCS_LEN */
+	if (len <= 40 + FCS_LEN)
+		return false;
+
+	cur_bcn_key = &mac->cur_beacon_keys;
+
+	if (rtlpriv->mac80211.link_state == MAC80211_NOLINK) {
+		if (cur_bcn_key->valid) {
+			cur_bcn_key->valid = false;
+			RT_TRACE(rtlpriv, COMP_BEACON, DBG_LOUD,
+				 "Reset cur_beacon_keys.valid to false!\n");
+		}
+		return false;
+	}
+
+	/* and only beacons from the associated BSSID, please */
+	if (!ether_addr_equal(hdr->addr3, rtlpriv->mac80211.bssid))
+		return false;
+
+	/***** Parsing DS Param IE ******/
+	ds_param = rtl_find_ie(data, len - FCS_LEN, WLAN_EID_DS_PARAMS);
+
+	if (ds_param && !(ds_param[1] < sizeof(*ds_param)))
+		ds_param_len = ds_param[1];
+	else
+		ds_param = NULL;
+
+	/***** Parsing HT Cap. IE ******/
+	ht_cap = rtl_find_ie(data, len - FCS_LEN, WLAN_EID_HT_CAPABILITY);
+
+	if (ht_cap && !(ht_cap[1] < sizeof(*ht_cap))) {
+		ht_cap_len = ht_cap[1];
+		ht_cap_ie = (struct ieee80211_ht_cap *)&ht_cap[2];
+	} else  {
+		ht_cap = NULL;
+		ht_cap_ie = NULL;
+	}
+
+	/***** Parsing HT Info. IE ******/
+	ht_oper = rtl_find_ie(data, len - FCS_LEN, WLAN_EID_HT_OPERATION);
+
+	if (ht_oper && !(ht_oper[1] < sizeof(*ht_oper))) {
+		ht_oper_len = ht_oper[1];
+		ht_oper_ie = (struct ieee80211_ht_operation *)&ht_oper[2];
+	} else {
+		ht_oper = NULL;
+	}
+
+	/* update bcn_key */
+	memset(&bcn_key, 0, sizeof(bcn_key));
+
+	if (ds_param)
+		bcn_key.bcn_channel = ds_param[2];
+	else if (ht_oper && ht_oper_ie)
+		bcn_key.bcn_channel = ht_oper_ie->primary_chan;
+
+	if (ht_cap_ie)
+		bcn_key.ht_cap_info = ht_cap_ie->cap_info;
+
+	if (ht_oper && ht_oper_ie)
+		bcn_key.ht_info_infos_0_sco = ht_oper_ie->ht_param & 0x03;
+
+	bcn_key.valid = true;
+
+	/* update cur_beacon_keys or compare beacon key */
+	if (rtlpriv->mac80211.link_state != MAC80211_LINKED &&
+	    rtlpriv->mac80211.link_state != MAC80211_LINKED_SCANNING)
+		return true;
+
+	if (!cur_bcn_key->valid) {
+		/* update cur_beacon_keys */
+		memset(cur_bcn_key, 0, sizeof(bcn_key));
+		memcpy(cur_bcn_key, &bcn_key, sizeof(bcn_key));
+		cur_bcn_key->valid = true;
+
+		RT_TRACE(rtlpriv, COMP_BEACON, DBG_LOUD,
+			 "Beacon key update!ch=%d, ht_cap_info=0x%x, sco=0x%x\n",
+			 cur_bcn_key->bcn_channel,
+			 cur_bcn_key->ht_cap_info,
+			 cur_bcn_key->ht_info_infos_0_sco);
+
+		return true;
+	}
+
+	/* compare beacon key */
+	if (!memcmp(cur_bcn_key, &bcn_key, sizeof(bcn_key))) {
+		/* same beacon key */
+		mac->new_beacon_cnt = 0;
+		goto chk_exit;
+	}
+
+	if (cur_bcn_key->bcn_channel == bcn_key.bcn_channel &&
+	    cur_bcn_key->ht_cap_info == bcn_key.ht_cap_info) {
+		/* Beacon HT info IE, secondary channel offset check */
+		/* 40M -> 20M */
+		if (cur_bcn_key->ht_info_infos_0_sco >
+		    bcn_key.ht_info_infos_0_sco) {
+			/* Not a new beacon */
+			RT_TRACE(rtlpriv, COMP_BEACON, DBG_DMESG,
+				 "Beacon BW change! sco:0x%x -> 0x%x\n",
+				 cur_bcn_key->ht_info_infos_0_sco,
+				 bcn_key.ht_info_infos_0_sco);
+
+			cur_bcn_key->ht_info_infos_0_sco =
+					bcn_key.ht_info_infos_0_sco;
+		} else {
+			/* 20M -> 40M */
+			if (rtlphy->max_ht_chan_bw >= HT_CHANNEL_WIDTH_20_40) {
+				/* Not a new beacon */
+				RT_TRACE(rtlpriv, COMP_BEACON, DBG_DMESG,
+					 "Beacon BW change! sco:0x%x -> 0x%x\n",
+					 cur_bcn_key->ht_info_infos_0_sco,
+					 bcn_key.ht_info_infos_0_sco);
+
+				cur_bcn_key->ht_info_infos_0_sco =
+					bcn_key.ht_info_infos_0_sco;
+			} else {
+				mac->new_beacon_cnt++;
+			}
+		}
+	} else {
+		mac->new_beacon_cnt++;
+	}
+
+	if (mac->new_beacon_cnt == 1) {
+		RT_TRACE(rtlpriv, COMP_BEACON, DBG_DMESG,
+			 "Get new beacon.\n");
+		RT_TRACE(rtlpriv, COMP_BEACON, DBG_DMESG,
+			 "Cur : ch=%d, ht_cap=0x%x, sco=0x%x\n",
+			 cur_bcn_key->bcn_channel,
+			 cur_bcn_key->ht_cap_info,
+			 cur_bcn_key->ht_info_infos_0_sco);
+		RT_TRACE(rtlpriv, COMP_BEACON, DBG_DMESG,
+			 "New RX : ch=%d, ht_cap=0x%x, sco=0x%x\n",
+			 bcn_key.bcn_channel,
+			 bcn_key.ht_cap_info,
+			 bcn_key.ht_info_infos_0_sco);
+
+	} else if (mac->new_beacon_cnt > 1) {
+		RT_TRACE(rtlpriv, COMP_BEACON, DBG_DMESG,
+			 "new beacon cnt: %d\n",
+			 mac->new_beacon_cnt);
+	}
+
+	if (mac->new_beacon_cnt > 3) {
+		ieee80211_connection_loss(rtlpriv->mac80211.vif);
+		RT_TRACE(rtlpriv, COMP_BEACON, DBG_DMESG,
+			 "new beacon cnt >3, disconnect !\n");
+	}
+
+chk_exit:
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(rtl_check_beacon_key);
 /*********************************************************
  *
  * IOT functions
diff --git a/drivers/net/wireless/realtek/rtlwifi/base.h b/drivers/net/wireless/realtek/rtlwifi/base.h
index 26735319b38f..3ad8e8107209 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.h
+++ b/drivers/net/wireless/realtek/rtlwifi/base.h
@@ -176,5 +176,6 @@ u8 rtl_tid_to_ac(u8 tid);
 void rtl_easy_concurrent_retrytimer_callback(struct timer_list *t);
 extern struct rtl_global_var rtl_global_var;
 void rtl_phy_scan_operation_backup(struct ieee80211_hw *hw, u8 operation);
-
+bool rtl_check_beacon_key(struct ieee80211_hw *hw, void *data,
+			  unsigned int len);
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 3cb88825473e..195f7c41b4aa 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -909,6 +909,7 @@ static int rtl_op_sta_add(struct ieee80211_hw *hw,
 			 struct ieee80211_sta *sta)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &rtlpriv->phy;
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_sta_info *sta_entry;
@@ -941,6 +942,16 @@ static int rtl_op_sta_add(struct ieee80211_hw *hw,
 		if (mac->p2p)
 			sta->supp_rates[0] &= 0xfffffff0;
 
+		if (sta->ht_cap.ht_supported) {
+			if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
+				rtlphy->max_ht_chan_bw = HT_CHANNEL_WIDTH_20_40;
+			else
+				rtlphy->max_ht_chan_bw = HT_CHANNEL_WIDTH_20;
+		}
+
+		if (sta->vht_cap.vht_supported)
+			rtlphy->max_vht_chan_bw = HT_CHANNEL_WIDTH_80;
+
 		memcpy(sta_entry->mac_addr, sta->addr, ETH_ALEN);
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
 			"Add sta addr is %pM\n", sta->addr);
@@ -1039,6 +1050,7 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 				    u32 changed)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &rtlpriv->phy;
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
@@ -1241,6 +1253,16 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 			    mac->current_ampdu_factor)
 				mac->current_ampdu_factor =
 				    sta->ht_cap.ampdu_factor;
+
+			if (sta->ht_cap.ht_supported) {
+				if (sta->ht_cap.cap &
+				    IEEE80211_HT_CAP_SUP_WIDTH_20_40)
+					rtlphy->max_ht_chan_bw =
+							HT_CHANNEL_WIDTH_20_40;
+				else
+					rtlphy->max_ht_chan_bw =
+							HT_CHANNEL_WIDTH_20;
+			}
 		}
 		rcu_read_unlock();
 
@@ -1252,6 +1274,32 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 					      &mac->current_ampdu_density);
 	}
 
+	if (changed & BSS_CHANGED_BANDWIDTH) {
+		struct ieee80211_sta *sta = NULL;
+
+		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_TRACE,
+			 "BSS_CHANGED_BANDWIDTH\n");
+
+		rcu_read_lock();
+		sta = ieee80211_find_sta(vif, (u8 *)bss_conf->bssid);
+
+		if (sta) {
+			if (sta->ht_cap.ht_supported) {
+				if (sta->ht_cap.cap &
+				    IEEE80211_HT_CAP_SUP_WIDTH_20_40)
+					rtlphy->max_ht_chan_bw =
+							HT_CHANNEL_WIDTH_20_40;
+				else
+					rtlphy->max_ht_chan_bw =
+							HT_CHANNEL_WIDTH_20;
+			}
+
+			if (sta->vht_cap.vht_supported)
+				rtlphy->max_vht_chan_bw = HT_CHANNEL_WIDTH_80;
+		}
+		rcu_read_unlock();
+	}
+
 	if (changed & BSS_CHANGED_BSSID) {
 		u32 basic_rates;
 		struct ieee80211_sta *sta = NULL;
diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 8ae36a263426..0bafcefacad0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -877,6 +877,8 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 			     ieee80211_is_probe_resp(fc))) {
 				dev_kfree_skb_any(skb);
 			} else {
+				rtl_check_beacon_key(hw, (void *)skb->data,
+						     skb->len);
 				_rtl_pci_rx_to_mac80211(hw, skb, rx_status);
 			}
 		} else {
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index e2b14793b705..d3ea6260f01c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -962,6 +962,15 @@ struct rtl_probe_rsp {
 	struct rtl_info_element info_element[0];
 } __packed;
 
+struct rtl_beacon_keys {
+	/*u8 ssid[32];*/
+	/*u32 ssid_len;*/
+	u8 bcn_channel;
+	__le16 ht_cap_info;
+	u8 ht_info_infos_0_sco; /* bit0 & bit1 in infos[0] is 2nd ch offset */
+	bool valid;
+};
+
 /*LED related.*/
 /*ledpin Identify how to implement this SW led.*/
 struct rtl_led {
@@ -1209,6 +1218,8 @@ struct rtl_phy {
 	u8 rf_mode;
 	u8 rf_type;
 	u8 current_chan_bw;
+	u8 max_ht_chan_bw;
+	u8 max_vht_chan_bw;
 	u8 set_bwmode_inprogress;
 	u8 sw_chnl_inprogress;
 	u8 sw_chnl_stage;
@@ -1380,6 +1391,8 @@ struct rtl_mac {
 	/*Probe Beacon management */
 	struct rtl_tid_data tids[MAX_TID_COUNT];
 	enum rtl_link_state link_state;
+	struct rtl_beacon_keys cur_beacon_keys;
+	u8 new_beacon_cnt;
 
 	int n_channels;
 	int n_bitrates;
-- 
2.15.1
