Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37316 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab2HUPBs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 11:01:48 -0400
Received: by ggdk6 with SMTP id k6so5887981ggd.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Aug 2012 08:01:47 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Li Chaoming <chaoming_li@realsil.com.cn>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 4/6] rtlwifi: Add changes for new vendor driver version
Date: Tue, 21 Aug 2012 10:00:53 -0500
Message-Id: <1345561255-10349-5-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120821_170158_879990_8691E007)
In-Reply-To: <1345561255-10349-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1345561255-10349-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Li Chaoming <chaoming_li@realsil.com.cn>

Realtek driver rtl_92ce_92se_92de_linux_mac80211_0005.1230.2011 includes
many changes not previously included. The main changes are as follows:

1. Support for the PHY mode switch implemented for some models.
2. Implementation of new routines for the dual-MAC devices.
3. Implement a mechanism for reaching the private data storage
   of the other unit in a dual-MAC device.
4. Impplementation of RX aggregation.
5. Storage of beacon statistics for roaming.
6. The RX routine has been rewritten to reduce the number of O(1) buffers.

Signed-off-by: Li Chaoming <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/base.c  |  323 ++++++++++++++++--
 drivers/net/wireless/rtlwifi/base.h  |   10 +-
 drivers/net/wireless/rtlwifi/cam.c   |    7 +-
 drivers/net/wireless/rtlwifi/core.c  |   76 +++--
 drivers/net/wireless/rtlwifi/debug.h |    8 +
 drivers/net/wireless/rtlwifi/efuse.c |   40 ++-
 drivers/net/wireless/rtlwifi/efuse.h |    1 -
 drivers/net/wireless/rtlwifi/pci.c   |  624 +++++++++++++++++++---------------
 drivers/net/wireless/rtlwifi/pci.h   |    3 +
 drivers/net/wireless/rtlwifi/ps.c    |   93 ++++-
 drivers/net/wireless/rtlwifi/ps.h    |    3 +-
 drivers/net/wireless/rtlwifi/rc.c    |    3 +-
 drivers/net/wireless/rtlwifi/regd.c  |   18 +
 13 files changed, 851 insertions(+), 358 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index 942e56b..b9afd49 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -208,24 +208,40 @@ static void _rtl_init_hw_ht_capab(struct ieee80211_hw *hw,
 	 *if BW_40 rx_mask[4]=0x01;
 	 *highest supported RX rate
 	 */
-	if (get_rf_type(rtlphy) == RF_1T2R || get_rf_type(rtlphy) == RF_2T2R) {
-
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "1T2R or 2T2R\n");
+	if (rtlpriv->dm.supp_phymode_switch) {
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG,
+			 "Support phy mode switch\n");
 
 		ht_cap->mcs.rx_mask[0] = 0xFF;
 		ht_cap->mcs.rx_mask[1] = 0xFF;
 		ht_cap->mcs.rx_mask[4] = 0x01;
 
-		ht_cap->mcs.rx_highest = cpu_to_le16(MAX_BIT_RATE_40MHZ_MCS15);
-	} else if (get_rf_type(rtlphy) == RF_1T1R) {
+		ht_cap->mcs.rx_highest =
+			 cpu_to_le16(MAX_BIT_RATE_40MHZ_MCS15);
+	} else {
+		if (get_rf_type(rtlphy) == RF_1T2R ||
+		    get_rf_type(rtlphy) == RF_2T2R) {
 
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "1T1R\n");
+			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+				 "1T2R or 2T2R\n");
 
-		ht_cap->mcs.rx_mask[0] = 0xFF;
-		ht_cap->mcs.rx_mask[1] = 0x00;
-		ht_cap->mcs.rx_mask[4] = 0x01;
+			ht_cap->mcs.rx_mask[0] = 0xFF;
+			ht_cap->mcs.rx_mask[1] = 0xFF;
+			ht_cap->mcs.rx_mask[4] = 0x01;
+
+			ht_cap->mcs.rx_highest =
+				cpu_to_le16(MAX_BIT_RATE_40MHZ_MCS15);
+		} else if (get_rf_type(rtlphy) == RF_1T1R) {
 
-		ht_cap->mcs.rx_highest = cpu_to_le16(MAX_BIT_RATE_40MHZ_MCS7);
+			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "1T1R\n");
+
+			ht_cap->mcs.rx_mask[0] = 0xFF;
+			ht_cap->mcs.rx_mask[1] = 0x00;
+			ht_cap->mcs.rx_mask[4] = 0x01;
+
+			ht_cap->mcs.rx_highest =
+				cpu_to_le16(MAX_BIT_RATE_40MHZ_MCS7);
+		}
 	}
 }
 
@@ -311,7 +327,9 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 	    IEEE80211_HW_AMPDU_AGGREGATION |
 	    IEEE80211_HW_CONNECTION_MONITOR |
 	    /* IEEE80211_HW_SUPPORTS_CQM_RSSI | */
-	    IEEE80211_HW_REPORTS_TX_ACK_STATUS | 0;
+	    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
+	    WIPHY_FLAG_IBSS_RSN |
+	    IEEE80211_HW_MFP_CAPABLE | 0;
 
 	/* swlps or hwlps has been set in diff chip in init_sw_vars */
 	if (rtlpriv->psc.swctrl_lps)
@@ -357,6 +375,9 @@ static void _rtl_init_deferred_work(struct ieee80211_hw *hw)
 	init_timer(&rtlpriv->works.watchdog_timer);
 	setup_timer(&rtlpriv->works.watchdog_timer,
 		    rtl_watch_dog_timer_callback, (unsigned long)hw);
+	init_timer(&rtlpriv->works.dualmac_easyconcurrent_retrytimer);
+	setup_timer(&rtlpriv->works.dualmac_easyconcurrent_retrytimer,
+		    rtl_easy_concurrent_retrytimer_callback, (unsigned long)hw);
 
 	/* <2> work queue */
 	rtlpriv->works.hw = hw;
@@ -446,18 +467,23 @@ int rtl_init_core(struct ieee80211_hw *hw)
 
 	/* <4> locks */
 	mutex_init(&rtlpriv->locks.conf_mutex);
-	mutex_init(&rtlpriv->locks.ps_mutex);
 	spin_lock_init(&rtlpriv->locks.ips_lock);
 	spin_lock_init(&rtlpriv->locks.irq_th_lock);
 	spin_lock_init(&rtlpriv->locks.h2c_lock);
 	spin_lock_init(&rtlpriv->locks.rf_ps_lock);
 	spin_lock_init(&rtlpriv->locks.rf_lock);
+	spin_lock_init(&rtlpriv->locks.lps_lock);
 	spin_lock_init(&rtlpriv->locks.waitq_lock);
+	spin_lock_init(&rtlpriv->locks.entry_list_lock);
 	spin_lock_init(&rtlpriv->locks.cck_and_rw_pagea_lock);
+	spin_lock_init(&rtlpriv->locks.check_sendpkt_lock);
 
 	rtlmac->link_state = MAC80211_NOLINK;
 
-	/* <5> init deferred work */
+	/* <5> init list */
+	INIT_LIST_HEAD(&rtlpriv->entry_list);
+
+	/* <6> init deferred work */
 	_rtl_init_deferred_work(hw);
 
 	return 0;
@@ -583,17 +609,18 @@ static void _rtl_txrate_selectmode(struct ieee80211_hw *hw,
 				tcb_desc->hw_rate =
 				    rtlpriv->cfg->maps[RTL_RC_CCK_RATE2M];
 				tcb_desc->use_driver_rate = 1;
+				tcb_desc->ratr_index = RATR_INX_WIRELESS_MC;
 			} else {
-				/* TODO */
+				tcb_desc->ratr_index = ratr_index;
 			}
-			tcb_desc->ratr_index = ratr_index;
 		} else if (mac->opmode == NL80211_IFTYPE_AP) {
 			tcb_desc->ratr_index = ratr_index;
 		}
 	}
 
 	if (rtlpriv->dm.useramask) {
-		/* TODO we will differentiate adhoc and station futrue  */
+		/* TODO In future, differentiate adhoc and station */
+		tcb_desc->ratr_index = ratr_index;
 		if (mac->opmode == NL80211_IFTYPE_STATION) {
 			tcb_desc->mac_id = 0;
 
@@ -840,8 +867,6 @@ void rtl_get_tcb_desc(struct ieee80211_hw *hw,
 	txrate = ieee80211_get_tx_rate(hw, info);
 	if (txrate)
 		tcb_desc->hw_rate = txrate->hw_value;
-	else
-		tcb_desc->hw_rate = 0;
 
 	if (ieee80211_is_data(fc)) {
 		/*
@@ -901,6 +926,33 @@ void rtl_get_tcb_desc(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(rtl_get_tcb_desc);
 
+bool rtl_tx_mgmt_proc(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	__le16 fc = rtl_get_fc(skb);
+
+	if (rtlpriv->dm.supp_phymode_switch &&
+	    mac->link_state < MAC80211_LINKED &&
+	    (ieee80211_is_auth(fc) || ieee80211_is_probe_req(fc))) {
+		if (rtlpriv->cfg->ops->check_switch_to_dmdp)
+			rtlpriv->cfg->ops->check_switch_to_dmdp(hw);
+	}
+	if (ieee80211_is_auth(fc)) {
+		RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG, "MAC80211_LINKING\n");
+		rtl_ips_nic_on(hw);
+
+		mac->link_state = MAC80211_LINKING;
+		/* Dual mac */
+		rtlpriv->phy.need_iqk = true;
+
+	}
+
+	return true;
+}
+
+struct sk_buff *rtl_make_del_ba(struct ieee80211_hw *hw, u8 *sa, u8 *bssid, u16 tid);
+
 bool rtl_action_proc(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
 {
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
@@ -925,6 +977,56 @@ bool rtl_action_proc(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
 			RT_TRACE(rtlpriv, (COMP_SEND | COMP_RECV), DBG_DMESG,
 				 "%s ACT_ADDBAREQ From :%pM\n",
 				 is_tx ? "Tx" : "Rx", hdr->addr2);
+			RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_DMESG, "req\n",
+				      skb->data, skb->len);
+			if (!is_tx) {
+				struct ieee80211_sta *sta = NULL;
+				struct rtl_sta_info *sta_entry = NULL;
+				struct ieee80211_mgmt *mgmt = (void *)skb->data;
+				u16 capab = 0, tid = 0;
+				struct rtl_tid_data *tid_data;
+				struct sk_buff *skb_delba = NULL;
+				struct ieee80211_rx_status rx_status = { 0 };
+				rcu_read_lock();
+				sta = rtl_find_sta(hw, hdr->addr3);
+				if (sta == NULL) {
+					RT_TRACE(rtlpriv,
+						 (COMP_SEND | COMP_RECV),
+						 DBG_EMERG,
+						 "sta is NULL\n");
+					rcu_read_unlock();
+					return true;
+				}
+
+				sta_entry = (struct rtl_sta_info *)sta->drv_priv;
+				if (!sta_entry) {
+					rcu_read_unlock();
+					return true;
+				}
+				capab = le16_to_cpu(mgmt->u.action.u.addba_req.capab);
+				tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
+				tid_data = &sta_entry->tids[tid];
+				if (tid_data->agg.rx_agg_state == RTL_RX_AGG_START) {
+					skb_delba = rtl_make_del_ba(hw,
+							 hdr->addr2,
+							 hdr->addr3, tid);
+					if (skb_delba) {
+						rx_status.freq = hw->conf.channel->center_freq;
+						rx_status.band = hw->conf.channel->band;
+						rx_status.flag |= RX_FLAG_DECRYPTED;
+						rx_status.flag |= RX_FLAG_MACTIME_MPDU;
+						rx_status.rate_idx = 0;
+						rx_status.signal = 50 + 10;
+						memcpy(IEEE80211_SKB_RXCB(skb_delba), &rx_status,
+								sizeof(rx_status));
+						RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_DMESG,
+								("fake del\n"), skb_delba->data,
+								skb_delba->len);
+						ieee80211_rx_irqsafe(hw, skb_delba);
+					}
+				}
+			rcu_read_unlock();
+			}
 			break;
 		case ACT_ADDBARSP:
 			RT_TRACE(rtlpriv, (COMP_SEND | COMP_RECV), DBG_DMESG,
@@ -1077,6 +1179,60 @@ int rtl_tx_agg_stop(struct ieee80211_hw *hw,
 	return 0;
 }
 
+int rtl_rx_agg_start(struct ieee80211_hw *hw,
+		struct ieee80211_sta *sta, u16 tid)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_tid_data *tid_data;
+	struct rtl_sta_info *sta_entry = NULL;
+
+	if (sta == NULL)
+		return -EINVAL;
+
+	if (unlikely(tid >= MAX_TID_COUNT))
+		return -EINVAL;
+
+	sta_entry = (struct rtl_sta_info *)sta->drv_priv;
+	if (!sta_entry)
+		return -ENXIO;
+	tid_data = &sta_entry->tids[tid];
+
+	RT_TRACE(rtlpriv, COMP_RECV, DBG_DMESG,
+		 "on ra = %pM tid = %d seq:%d\n", sta->addr, tid,
+		 tid_data->seq_number);
+
+	tid_data->agg.rx_agg_state = RTL_RX_AGG_START;
+	return 0;
+}
+
+int rtl_rx_agg_stop(struct ieee80211_hw *hw,
+		struct ieee80211_sta *sta, u16 tid)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_tid_data *tid_data;
+	struct rtl_sta_info *sta_entry = NULL;
+
+	if (sta == NULL)
+		return -EINVAL;
+
+	if (!sta->addr) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "ra = NULL\n");
+		return -EINVAL;
+	}
+
+	RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG,
+		 "on ra = %pM tid = %d\n", sta->addr, tid);
+
+	if (unlikely(tid >= MAX_TID_COUNT))
+		return -EINVAL;
+
+	sta_entry = (struct rtl_sta_info *)sta->drv_priv;
+	tid_data = &sta_entry->tids[tid];
+	sta_entry->tids[tid].agg.rx_agg_state = RTL_RX_AGG_STOP;
+
+	return 0;
+}
+
 int rtl_tx_agg_oper(struct ieee80211_hw *hw,
 		struct ieee80211_sta *sta, u16 tid)
 {
@@ -1108,6 +1264,34 @@ int rtl_tx_agg_oper(struct ieee80211_hw *hw,
  * wq & timer callback functions
  *
  *********************************************************/
+/* this function is used for roaming */
+void rtl_beacon_statistic(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+
+	if (rtlpriv->mac80211.opmode != NL80211_IFTYPE_STATION)
+		return;
+
+	if (rtlpriv->mac80211.link_state < MAC80211_LINKED)
+		return;
+
+	/* check if this really is a beacon */
+	if (!ieee80211_is_beacon(hdr->frame_control) &&
+	    !ieee80211_is_probe_resp(hdr->frame_control))
+		return;
+
+	/* min. beacon length + FCS_LEN */
+	if (skb->len <= 40 + FCS_LEN)
+		return;
+
+	/* and only beacons from the associated BSSID, please */
+	if (!ether_addr_equal(hdr->addr3, rtlpriv->mac80211.bssid))
+		return;
+
+	rtlpriv->link_info.bcn_rx_inperiod++;
+}
+
 void rtl_watchdog_wq_callback(void *data)
 {
 	struct rtl_works *rtlworks = container_of_dwork_rtl(data,
@@ -1118,6 +1302,8 @@ void rtl_watchdog_wq_callback(void *data)
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	bool busytraffic = false;
+	bool tx_busy_traffic = false;
+	bool rx_busy_traffic = false;
 	bool higher_busytraffic = false;
 	bool higher_busyrxtraffic = false;
 	u8 idx, tid;
@@ -1167,8 +1353,13 @@ void rtl_watchdog_wq_callback(void *data)
 		aver_tx_cnt_inperiod = tx_cnt_inp4eriod / 4;
 
 		/* (2) check traffic busy */
-		if (aver_rx_cnt_inperiod > 100 || aver_tx_cnt_inperiod > 100)
+		if (aver_rx_cnt_inperiod > 100 || aver_tx_cnt_inperiod > 100) {
 			busytraffic = true;
+			if (aver_rx_cnt_inperiod > aver_tx_cnt_inperiod)
+				rx_busy_traffic = true;
+			else
+				tx_busy_traffic = false;
+		}
 
 		/* Higher Tx/Rx data. */
 		if (aver_rx_cnt_inperiod > 4000 ||
@@ -1221,11 +1412,34 @@ void rtl_watchdog_wq_callback(void *data)
 		rtlpriv->link_info.tidtx_inperiod[tid] = 0;
 
 	rtlpriv->link_info.busytraffic = busytraffic;
+	rtlpriv->link_info.rx_busy_traffic = rx_busy_traffic;
+	rtlpriv->link_info.tx_busy_traffic = tx_busy_traffic;
 	rtlpriv->link_info.higher_busytraffic = higher_busytraffic;
 	rtlpriv->link_info.higher_busyrxtraffic = higher_busyrxtraffic;
 
 	/* <3> DM */
 	rtlpriv->cfg->ops->dm_watchdog(hw);
+
+	/* <4> roaming */
+	if (mac->link_state == MAC80211_LINKED &&
+	    mac->opmode == NL80211_IFTYPE_STATION) {
+		if ((rtlpriv->link_info.bcn_rx_inperiod +
+		    rtlpriv->link_info.num_rx_inperiod) == 0) {
+			rtlpriv->link_info.roam_times++;
+			RT_TRACE(rtlpriv, COMP_ERR, DBG_DMESG, "AP off for %d s\n",
+				(rtlpriv->link_info.roam_times * 2));
+
+			/* if we can't recv beacon for 6s, we should reconnect this AP */
+			if (rtlpriv->link_info.roam_times >= 3) {
+				RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "AP off, try to reconnect now\n");
+				rtlpriv->link_info.roam_times = 0;
+				ieee80211_connection_loss(rtlpriv->mac80211.vif);
+			}
+		} else {
+			rtlpriv->link_info.roam_times = 0;
+		}
+	}
+	rtlpriv->link_info.bcn_rx_inperiod = 0;
 }
 
 void rtl_watch_dog_timer_callback(unsigned long data)
@@ -1240,6 +1454,18 @@ void rtl_watch_dog_timer_callback(unsigned long data)
 		  jiffies + MSECS(RTL_WATCH_DOG_TIME));
 }
 
+void rtl_easy_concurrent_retrytimer_callback(unsigned long data)
+{
+	struct ieee80211_hw *hw = (struct ieee80211_hw *)data;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_priv *buddy_priv = rtlpriv->buddy_priv;
+
+	if (buddy_priv == NULL)
+		return;
+
+	rtlpriv->cfg->ops->dualmac_easy_concurrent(hw);
+}
+
 /*********************************************************
  *
  * frame process functions
@@ -1310,14 +1536,16 @@ static struct sk_buff *rtl_make_smps_action(struct ieee80211_hw *hw,
 }
 
 int rtl_send_smps_action(struct ieee80211_hw *hw,
-		struct ieee80211_sta *sta, u8 *da, u8 *bssid,
+		struct ieee80211_sta *sta,
 		enum ieee80211_smps_mode smps)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	struct sk_buff *skb = rtl_make_smps_action(hw, smps, da, bssid);
+	struct sk_buff *skb;
 	struct rtl_tcb_desc tcb_desc;
+	u8 bssid[ETH_ALEN];
+
 	memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
 
 	if (rtlpriv->mac80211.act_scanning)
@@ -1332,22 +1560,67 @@ int rtl_send_smps_action(struct ieee80211_hw *hw,
 	if (!test_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status))
 		goto err_free;
 
+	if (rtlpriv->mac80211.opmode == NL80211_IFTYPE_AP)
+		memcpy(bssid, rtlpriv->efuse.dev_addr, ETH_ALEN);
+	else
+		memcpy(bssid, rtlpriv->mac80211.bssid, ETH_ALEN);
+
+	skb = rtl_make_smps_action(hw, smps, sta->addr, bssid);
 	/* this is a type = mgmt * stype = action frame */
 	if (skb) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 		struct rtl_sta_info *sta_entry =
 			(struct rtl_sta_info *) sta->drv_priv;
 		sta_entry->mimo_ps = smps;
-		rtlpriv->cfg->ops->update_rate_tbl(hw, sta, 0);
 
 		info->control.rates[0].idx = 0;
 		info->control.sta = sta;
 		info->band = hw->conf.channel->band;
 		rtlpriv->intf_ops->adapter_tx(hw, skb, &tcb_desc);
 	}
+	return 1;
 err_free:
 	return 0;
 }
+EXPORT_SYMBOL(rtl_send_smps_action);
+
+/* mac80211 have issues when receive del ba
+ * so here we just make a fake del_ba when we receive a ba_req
+ * but rx_agg was opened to let mac80211 release some ba
+ * related resources, so please this del_ba for tx
+ */
+struct sk_buff *rtl_make_del_ba(struct ieee80211_hw *hw,
+		u8 *sa, u8 *bssid, u16 tid)
+{
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *action_frame;
+	u16 params;
+
+	/* 27 = header + category + action + smps mode */
+	skb = dev_alloc_skb(34 + hw->extra_tx_headroom);
+	if (!skb)
+		return NULL;
+
+	skb_reserve(skb, hw->extra_tx_headroom);
+	action_frame = (void *)skb_put(skb, 34);
+	memset(action_frame, 0, 34);
+	memcpy(action_frame->sa, sa, ETH_ALEN);
+	memcpy(action_frame->da, rtlefuse->dev_addr, ETH_ALEN);
+	memcpy(action_frame->bssid, bssid, ETH_ALEN);
+	action_frame->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+						  IEEE80211_STYPE_ACTION);
+	action_frame->u.action.category = WLAN_CATEGORY_BACK;
+	action_frame->u.action.u.delba.action_code = WLAN_ACTION_DELBA;
+	params = (u16)(1 << 11);		/* bit 11 initiator */
+	params |= (u16)(tid << 12);		/* bit 15:12 TID number */
+
+	action_frame->u.action.u.delba.params = cpu_to_le16(params);
+	action_frame->u.action.u.delba.reason_code =
+		cpu_to_le16(WLAN_REASON_QSTA_TIMEOUT);
+
+	return skb;
+}
 
 /*********************************************************
  *
@@ -1564,11 +1837,17 @@ MODULE_AUTHOR("Larry Finger	<Larry.FInger@lwfinger.net>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Realtek 802.11n PCI wireless core");
 
+struct rtl_global_var global_var = {};
+
 static int __init rtl_core_module_init(void)
 {
 	if (rtl_rate_control_register())
 		pr_err("Unable to register rtl_rc, use default RC !!\n");
 
+	/* init some global vars */
+	INIT_LIST_HEAD(&global_var.glb_priv_list);
+	spin_lock_init(&global_var.glb_list_lock);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/rtlwifi/base.h b/drivers/net/wireless/rtlwifi/base.h
index f35af0f..04bd282 100644
--- a/drivers/net/wireless/rtlwifi/base.h
+++ b/drivers/net/wireless/rtlwifi/base.h
@@ -117,8 +117,10 @@ void rtl_watch_dog_timer_callback(unsigned long data);
 void rtl_deinit_deferred_work(struct ieee80211_hw *hw);
 
 bool rtl_action_proc(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx);
+bool rtl_tx_mgmt_proc(struct ieee80211_hw *hw, struct sk_buff *skb);
 u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx);
 
+void rtl_beacon_statistic(struct ieee80211_hw *hw, struct sk_buff *skb);
 void rtl_watch_dog_timer_callback(unsigned long data);
 int rtl_tx_agg_start(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 		     u16 tid, u16 *ssn);
@@ -126,6 +128,10 @@ int rtl_tx_agg_stop(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 		    u16 tid);
 int rtl_tx_agg_oper(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 		    u16 tid);
+int rtl_rx_agg_start(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+		     u16 tid);
+int rtl_rx_agg_stop(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+		    u16 tid);
 void rtl_watchdog_wq_callback(void *data);
 
 void rtl_get_tcb_desc(struct ieee80211_hw *hw,
@@ -134,12 +140,14 @@ void rtl_get_tcb_desc(struct ieee80211_hw *hw,
 		      struct sk_buff *skb, struct rtl_tcb_desc *tcb_desc);
 
 int rtl_send_smps_action(struct ieee80211_hw *hw,
-		struct ieee80211_sta *sta, u8 *da, u8 *bssid,
+		struct ieee80211_sta *sta,
 		enum ieee80211_smps_mode smps);
 u8 *rtl_find_ie(u8 *data, unsigned int len, u8 ie);
 void rtl_recognize_peer(struct ieee80211_hw *hw, u8 *data, unsigned int len);
 u8 rtl_tid_to_ac(u8 tid);
 extern struct attribute_group rtl_attribute_group;
+void rtl_easy_concurrent_retrytimer_callback(unsigned long data);
+extern struct rtl_global_var global_var;
 int rtlwifi_rate_mapping(struct ieee80211_hw *hw,
 			 bool isht, u8 desc_rate, bool first_ampdu);
 #endif
diff --git a/drivers/net/wireless/rtlwifi/cam.c b/drivers/net/wireless/rtlwifi/cam.c
index 5b4b4d4..48dcef4 100644
--- a/drivers/net/wireless/rtlwifi/cam.c
+++ b/drivers/net/wireless/rtlwifi/cam.c
@@ -52,11 +52,8 @@ static void rtl_cam_program_entry(struct ieee80211_hw *hw, u32 entry_no,
 	u32 target_content = 0;
 	u8 entry_i;
 
-	RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
-		 "key_cont_128:\n %x:%x:%x:%x:%x:%x\n",
-		 key_cont_128[0], key_cont_128[1],
-		 key_cont_128[2], key_cont_128[3],
-		 key_cont_128[4], key_cont_128[5]);
+	RT_PRINT_DATA(rtlpriv, COMP_SEC, DBG_LOUD, "Key content :",
+			key_cont_128, 16);
 
 	for (entry_i = 0; entry_i < CAM_CONTENT_COUNT; entry_i++) {
 		target_command = entry_i + CAM_CONTENT_COUNT * entry_no;
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index a18ad2a..8e2ad66 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -154,8 +154,6 @@ static int rtl_op_add_interface(struct ieee80211_hw *hw,
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	int err = 0;
 
-	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
-
 	if (mac->vif) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 "vif has been set!! mac->vif = 0x%p\n", mac->vif);
@@ -321,6 +319,13 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 		struct ieee80211_channel *channel = hw->conf.channel;
 		u8 wide_chan = (u8) channel->hw_value;
 
+		if (rtlpriv->dm.supp_phymode_switch &&
+		    mac->link_state < MAC80211_LINKED &&
+		    !mac->act_scanning) {
+			if (rtlpriv->cfg->ops->check_switch_to_dmdp)
+				rtlpriv->cfg->ops->check_switch_to_dmdp(hw);
+		}
+
 		/*
 		 *because we should back channel to
 		 *current_network.chan in in scanning,
@@ -483,21 +488,26 @@ static int rtl_op_sta_add(struct ieee80211_hw *hw,
 
 	if (sta) {
 		sta_entry = (struct rtl_sta_info *) sta->drv_priv;
+		spin_lock_bh(&rtlpriv->locks.entry_list_lock);
+		list_add_tail(&sta_entry->list, &rtlpriv->entry_list);
+		spin_unlock_bh(&rtlpriv->locks.entry_list_lock);
 		if (rtlhal->current_bandtype == BAND_ON_2_4G) {
 			sta_entry->wireless_mode = WIRELESS_MODE_G;
 			if (sta->supp_rates[0] <= 0xf)
 				sta_entry->wireless_mode = WIRELESS_MODE_B;
 			if (sta->ht_cap.ht_supported)
 				sta_entry->wireless_mode = WIRELESS_MODE_N_24G;
+
+			if (rtlpriv->mac80211.opmode == NL80211_IFTYPE_ADHOC)
+				sta_entry->wireless_mode = WIRELESS_MODE_G;
 		} else if (rtlhal->current_bandtype == BAND_ON_5G) {
 			sta_entry->wireless_mode = WIRELESS_MODE_A;
 			if (sta->ht_cap.ht_supported)
 				sta_entry->wireless_mode = WIRELESS_MODE_N_24G;
-		}
 
-		/* I found some times mac80211 give wrong supp_rates for adhoc*/
-		if (rtlpriv->mac80211.opmode == NL80211_IFTYPE_ADHOC)
-			sta_entry->wireless_mode = WIRELESS_MODE_G;
+			if (rtlpriv->mac80211.opmode == NL80211_IFTYPE_ADHOC)
+				sta_entry->wireless_mode = WIRELESS_MODE_A;
+		}
 
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
 			 "Add sta addr is %pM\n", sta->addr);
@@ -517,6 +527,9 @@ static int rtl_op_sta_remove(struct ieee80211_hw *hw,
 		sta_entry = (struct rtl_sta_info *) sta->drv_priv;
 		sta_entry->wireless_mode = 0;
 		sta_entry->ratr_index = 0;
+		spin_lock_bh(&rtlpriv->locks.entry_list_lock);
+		list_del(&sta_entry->list);
+		spin_unlock_bh(&rtlpriv->locks.entry_list_lock);
 	}
 	return 0;
 }
@@ -645,9 +658,20 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 
 			if (rtlpriv->cfg->ops->linked_set_reg)
 				rtlpriv->cfg->ops->linked_set_reg(hw);
+
+			rcu_read_lock();
+			sta = ieee80211_find_sta(vif, (u8 *)bss_conf->bssid);
 			if (mac->opmode == NL80211_IFTYPE_STATION && sta)
 				rtlpriv->cfg->ops->update_rate_tbl(hw, sta, 0);
-			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
+			RT_TRACE(rtlpriv, COMP_EASY_CONCURRENT, DBG_LOUD,
+				 "send PS STATIC frame\n");
+			if (rtlpriv->dm.supp_phymode_switch) {
+				if (sta->ht_cap.ht_supported)
+					rtl_send_smps_action(hw, sta,
+						IEEE80211_SMPS_STATIC);
+			}
+			rcu_read_unlock();
+				RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
 				 "BSS_CHANGED_ASSOC\n");
 		} else {
 			if (mac->link_state == MAC80211_LINKED)
@@ -655,13 +679,12 @@ static void rtl_op_bss_info_changed(struct ieee80211_hw *hw,
 
 			mac->link_state = MAC80211_NOLINK;
 			memset(mac->bssid, 0, 6);
-
-			/* reset sec info */
-			rtl_cam_reset_sec_info(hw);
-
-			rtl_cam_reset_all_entry(hw);
 			mac->vendor = PEER_UNKNOWN;
 
+			if (rtlpriv->dm.supp_phymode_switch) {
+				if (rtlpriv->cfg->ops->check_switch_to_dmdp)
+					rtlpriv->cfg->ops->check_switch_to_dmdp(hw);
+			}
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_DMESG,
 				 "BSS_CHANGED_UN_ASSOC\n");
 		}
@@ -876,12 +899,10 @@ static int rtl_op_ampdu_action(struct ieee80211_hw *hw,
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_TRACE,
 			 "IEEE80211_AMPDU_TX_START: TID:%d\n", tid);
 		return rtl_tx_agg_start(hw, sta, tid, ssn);
-		break;
 	case IEEE80211_AMPDU_TX_STOP:
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_TRACE,
 			 "IEEE80211_AMPDU_TX_STOP: TID:%d\n", tid);
 		return rtl_tx_agg_stop(hw, sta, tid);
-		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_TRACE,
 			 "IEEE80211_AMPDU_TX_OPERATIONAL:TID:%d\n", tid);
@@ -890,11 +911,11 @@ static int rtl_op_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_RX_START:
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_TRACE,
 			 "IEEE80211_AMPDU_RX_START:TID:%d\n", tid);
-		break;
+		return rtl_rx_agg_start(hw, sta, tid);
 	case IEEE80211_AMPDU_RX_STOP:
 		RT_TRACE(rtlpriv, COMP_MAC80211, DBG_TRACE,
 			 "IEEE80211_AMPDU_RX_STOP:TID:%d\n", tid);
-		break;
+		return rtl_rx_agg_stop(hw, sta, tid);
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 "IEEE80211_AMPDU_ERR!!!!:\n");
@@ -908,6 +929,10 @@ static void rtl_op_sw_scan_start(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
+	if (rtlpriv->dm.supp_phymode_switch) {
+		if (rtlpriv->cfg->ops->check_switch_to_dmdp)
+			rtlpriv->cfg->ops->check_switch_to_dmdp(hw);
+	}
 	mac->act_scanning = true;
 
 	RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD, "\n");
@@ -967,6 +992,10 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			 "not open hw encryption\n");
 		return -ENOSPC;	/*User disabled HW-crypto */
 	}
+	/* To support IBSS, use sw-crypto for GTK */
+	if (vif->type == NL80211_IFTYPE_ADHOC &&
+	   !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+		return -ENOSPC;
 	RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
 		 "%s hardware based encryption for keyidx: %d, mac: %pM\n",
 		 cmd == SET_KEY ? "Using" : "Disabling", key->keyidx,
@@ -993,6 +1022,15 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		key_type = AESCCMP_ENCRYPTION;
 		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG, "alg:CCMP\n");
 		break;
+	case WLAN_CIPHER_SUITE_AES_CMAC:
+		/*HW don't support CMAC encryption, use software CMAC encryption */
+		key_type = AESCMAC_ENCRYPTION;
+		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG, "alg:CMAC\n");
+		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
+			 "HW don't support CMAC encrypiton, "
+			 "use software CMAC encrypiton\n");
+		err = -EOPNOTSUPP;
+		goto out_unlock;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, "alg_err:%x!!!!\n",
 			 key->cipher);
@@ -1095,6 +1133,9 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		key->hw_key_idx = key_idx;
 		if (key_type == TKIP_ENCRYPTION)
 			key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+		/*use software CCMP encryption for management frames (MFP) */
+		if (key_type == AESCCMP_ENCRYPTION)
+			key->flags |= IEEE80211_KEY_FLAG_SW_MGMT;
 		break;
 	case DISABLE_KEY:
 		RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
@@ -1113,9 +1154,6 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		 *or clear all entry here.
 		 */
 		rtl_cam_delete_one_entry(hw, mac_addr, key_idx);
-
-		rtl_cam_reset_sec_info(hw);
-
 		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
diff --git a/drivers/net/wireless/rtlwifi/debug.h b/drivers/net/wireless/rtlwifi/debug.h
index 07493d2..2ce21e8 100644
--- a/drivers/net/wireless/rtlwifi/debug.h
+++ b/drivers/net/wireless/rtlwifi/debug.h
@@ -106,6 +106,7 @@
 #define COMP_REGD			BIT(27)
 #define COMP_CHAN			BIT(28)
 #define COMP_USB			BIT(29)
+#define COMP_EASY_CONCURRENT		BIT(30)
 
 /*--------------------------------------------------------------
 		Define the rt_print components
@@ -133,6 +134,13 @@
 #define	PHY_TXPWR			BIT(8)
 #define	PHY_PWRDIFF			BIT(9)
 
+/* Define Dynamic Mechanism check module bit --> FDM */
+#define WA_IOT				BIT(0)
+#define DM_PWDB				BIT(1)
+#define DM_MONITOR			BIT(2)
+#define DM_DIG				BIT(3)
+#define DM_EDCA_TURBO			BIT(4)
+
 enum dbgp_flag_e {
 	FQOS = 0,
 	FTX = 1,
diff --git a/drivers/net/wireless/rtlwifi/efuse.c b/drivers/net/wireless/rtlwifi/efuse.c
index 8e2f9af..1e3ff71 100644
--- a/drivers/net/wireless/rtlwifi/efuse.c
+++ b/drivers/net/wireless/rtlwifi/efuse.c
@@ -35,8 +35,6 @@ static const u8 MAX_PGPKT_SIZE = 9;
 static const u8 PGPKT_DATA_SIZE = 8;
 static const int EFUSE_MAX_SIZE = 512;
 
-static const u8 EFUSE_OOB_PROTECT_BYTES = 15;
-
 static const struct efuse_map RTL8712_SDIO_EFUSE_TABLE[] = {
 	{0, 0, 0, 2},
 	{0, 1, 0, 2},
@@ -240,6 +238,7 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 	u8 rtemp8[1];
 	u16 efuse_addr = 0;
 	u8 offset, wren;
+	u8 u1temp;
 	u16 i;
 	u16 j;
 	const u16 efuse_max_section =
@@ -287,6 +286,28 @@ void read_efuse(struct ieee80211_hw *hw, u16 _offset, u16 _size_byte, u8 *pbuf)
 	while ((*rtemp8 != 0xFF) && (efuse_addr < efuse_len)) {
 		offset = ((*rtemp8 >> 4) & 0x0f);
 
+		/*  Check PG header for section num.  */
+		if ((*rtemp8 & 0x1F) == 0x0F) { /* extended header */
+			u1temp = (*rtemp8 & 0xE0) >> 5;
+			read_efuse_byte(hw, efuse_addr, rtemp8);
+
+			if ((*rtemp8 & 0x0F) == 0x0F) {
+				efuse_addr++;
+				read_efuse_byte(hw, efuse_addr, rtemp8);
+
+				if (*rtemp8 != 0xFF && (efuse_addr < efuse_len))
+					efuse_addr++;
+				continue;
+			} else {
+				offset = ((*rtemp8 & 0xF0) >> 1) | u1temp;
+				wren = (*rtemp8 & 0x0F);
+				efuse_addr++;
+			}
+		} else {
+			offset = ((*rtemp8 >> 4) & 0x0f);
+			wren = (*rtemp8 & 0x0f);
+		}
+
 		if (offset < efuse_max_section) {
 			wren = (*rtemp8 & 0x0f);
 			RTPRINT(rtlpriv, FEEPROM, EFUSE_READ_ALL,
@@ -390,8 +411,8 @@ bool efuse_shadow_update_chk(struct ieee80211_hw *hw)
 	totalbytes = hdr_num + words_need * 2;
 	efuse_used = rtlefuse->efuse_usedbytes;
 
-	if ((totalbytes + efuse_used) >=
-	    (EFUSE_MAX_SIZE - EFUSE_OOB_PROTECT_BYTES))
+	if ((totalbytes + efuse_used) >= (EFUSE_MAX_SIZE -
+	    rtlpriv->cfg->maps[EFUSE_OOB_PROTECT_BYTES_LEN]))
 		result = false;
 
 	RT_TRACE(rtlpriv, COMP_EFUSE, DBG_LOUD,
@@ -932,8 +953,8 @@ static int efuse_pg_packet_write(struct ieee80211_hw *hw,
 	u8 badworden = 0x0F;
 	static int repeat_times;
 
-	if (efuse_get_current_size(hw) >=
-	    (EFUSE_MAX_SIZE - EFUSE_OOB_PROTECT_BYTES)) {
+	if (efuse_get_current_size(hw) >= (EFUSE_MAX_SIZE -
+	    rtlpriv->cfg->maps[EFUSE_OOB_PROTECT_BYTES_LEN])) {
 		RTPRINT(rtlpriv, FEEPROM, EFUSE_PG,
 			"efuse_pg_packet_write error\n");
 		return false;
@@ -949,8 +970,8 @@ static int efuse_pg_packet_write(struct ieee80211_hw *hw,
 
 	RTPRINT(rtlpriv, FEEPROM, EFUSE_PG,  "efuse Power ON\n");
 
-	while (continual && (efuse_addr <
-	       (EFUSE_MAX_SIZE - EFUSE_OOB_PROTECT_BYTES))) {
+	while (continual && (efuse_addr < (EFUSE_MAX_SIZE -
+	       rtlpriv->cfg->maps[EFUSE_OOB_PROTECT_BYTES_LEN]))) {
 
 		if (write_state == PG_STATE_HEADER) {
 			badworden = 0x0F;
@@ -1003,7 +1024,8 @@ static int efuse_pg_packet_write(struct ieee80211_hw *hw,
 		}
 	}
 
-	if (efuse_addr >= (EFUSE_MAX_SIZE - EFUSE_OOB_PROTECT_BYTES)) {
+	if (efuse_addr >= (EFUSE_MAX_SIZE -
+	    rtlpriv->cfg->maps[EFUSE_OOB_PROTECT_BYTES_LEN])) {
 		RT_TRACE(rtlpriv, COMP_EFUSE, DBG_LOUD,
 			 "efuse_addr(%#x) Out of size!!\n", efuse_addr);
 	}
diff --git a/drivers/net/wireless/rtlwifi/efuse.h b/drivers/net/wireless/rtlwifi/efuse.h
index 2bdea9a..395a326 100644
--- a/drivers/net/wireless/rtlwifi/efuse.h
+++ b/drivers/net/wireless/rtlwifi/efuse.h
@@ -32,7 +32,6 @@
 
 #define EFUSE_IC_ID_OFFSET		506
 
-#define EFUSE_REAL_CONTENT_LEN		512
 #define EFUSE_MAP_LEN			128
 #define EFUSE_MAX_WORD_UNIT		4
 
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 80f75d3..50c51f0 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -59,7 +59,7 @@ static u8 _rtl_mac_to_hwqueue(struct ieee80211_hw *hw,
 
 	if (unlikely(ieee80211_is_beacon(fc)))
 		return BEACON_QUEUE;
-	if (ieee80211_is_mgmt(fc))
+	if (ieee80211_is_mgmt(fc) || ieee80211_is_ctl(fc))
 		return MGNT_QUEUE;
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE)
 		if (ieee80211_is_nullfunc(fc))
@@ -349,6 +349,49 @@ static bool rtl_pci_get_amd_l1_patch(struct ieee80211_hw *hw)
 	return status;
 }
 
+static bool rtl_pci_check_buddy_priv(struct ieee80211_hw *hw,
+				     struct rtl_priv **buddy_priv)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
+	bool find_buddy_priv = false;
+	struct rtl_priv *temp_priv = NULL;
+	struct rtl_pci_priv *temp_pcipriv = NULL;
+
+	if (!list_empty(&rtlpriv->glb_var->glb_priv_list)) {
+		list_for_each_entry(temp_priv, &rtlpriv->glb_var->glb_priv_list,
+			list) {
+			if (temp_priv) {
+				temp_pcipriv = (struct rtl_pci_priv *)temp_priv->priv;
+				RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+					"pcipriv->ndis_adapter.funcnumber %x\n",
+					pcipriv->ndis_adapter.funcnumber);
+				RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+					"temp_pcipriv->ndis_adapter.funcnumber %x\n",
+					temp_pcipriv->ndis_adapter.funcnumber);
+
+				if ((pcipriv->ndis_adapter.busnumber ==
+				    temp_pcipriv->ndis_adapter.busnumber) &&
+				    (pcipriv->ndis_adapter.devnumber ==
+				    temp_pcipriv->ndis_adapter.devnumber) &&
+				    (pcipriv->ndis_adapter.funcnumber !=
+				    temp_pcipriv->ndis_adapter.funcnumber)) {
+					find_buddy_priv = true;
+					break;
+				}
+			}
+		}
+	}
+
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+		"find_buddy_priv %d\n", find_buddy_priv);
+
+	if (find_buddy_priv)
+		*buddy_priv = temp_priv;
+
+	return find_buddy_priv;
+}
+
 static void rtl_pci_get_linkcontrol_field(struct ieee80211_hw *hw)
 {
 	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
@@ -478,6 +521,12 @@ static void _rtl_pci_tx_chk_waitq(struct ieee80211_hw *hw)
 	if (!rtlpriv->rtlhal.earlymode_enable)
 		return;
 
+	if (rtlpriv->dm.supp_phymode_switch &&
+	    (rtlpriv->easy_concurrent_ctl.switch_in_process ||
+	    (rtlpriv->buddy_priv &&
+	    rtlpriv->buddy_priv->easy_concurrent_ctl.switch_in_process)))
+		return;
+
 	/* we juse use em for BE/BK/VI/VO */
 	for (tid = 7; tid >= 0; tid--) {
 		u8 hw_queue = ac_to_hwq[rtl_tid_to_ac(tid)];
@@ -571,6 +620,15 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 				rtlpriv->psc.state_inap = false;
 			}
 		}
+		if (ieee80211_is_action(fc)) {
+			struct ieee80211_mgmt *action_frame =
+				(struct ieee80211_mgmt *)skb->data;
+			if (action_frame->u.action.u.ht_smps.action ==
+			    WLAN_HT_ACTION_SMPS) {
+				dev_kfree_skb(skb);
+				goto tx_status_ok;
+			}
+		}
 
 		/* update tid tx pkt num */
 		tid = rtl_get_tid(skb);
@@ -602,169 +660,201 @@ tx_status_ok:
 	}
 
 	if (((rtlpriv->link_info.num_rx_inperiod +
-		rtlpriv->link_info.num_tx_inperiod) > 8) ||
-		(rtlpriv->link_info.num_rx_inperiod > 2)) {
-		schedule_work(&rtlpriv->works.lps_leave_work);
-	}
+	    rtlpriv->link_info.num_tx_inperiod) > 8) ||
+	    (rtlpriv->link_info.num_rx_inperiod > 2))
+		rtl_lps_leave(hw);
 }
 
-static void _rtl_receive_one(struct ieee80211_hw *hw, struct sk_buff *skb,
-			     struct ieee80211_rx_status rx_status)
+static int _rtl_pci_init_one_rxdesc(struct ieee80211_hw *hw,
+				    struct rtl_rx_desc *entry,
+				    int rxring_idx, int desc_idx)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct ieee80211_hdr *hdr = rtl_get_hdr(skb);
-	__le16 fc = rtl_get_fc(skb);
-	bool unicast = false;
-	struct sk_buff *uskb = NULL;
-	u8 *pdata;
-
+	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	u32 bufferaddress;
+	u8 tmp_one = 1;
+	struct sk_buff *skb;
+
+	skb = dev_alloc_skb(rtlpci->rxbuffersize);
+	if (!skb)
+		return 0;
+	rtlpci->rx_ring[rxring_idx].rx_buf[desc_idx] = skb;
+
+	/* just set skb->cb to mapping addr
+	 * for pci_unmap_single use */
+	*((dma_addr_t *) skb->cb) = pci_map_single(rtlpci->pdev,
+				skb_tail_pointer(skb), rtlpci->rxbuffersize,
+				PCI_DMA_FROMDEVICE);
+	bufferaddress = *((dma_addr_t *) skb->cb);
+
+	rtlpriv->cfg->ops->set_desc((u8 *)entry, false, HW_DESC_RXBUFF_ADDR,
+				    (u8 *)&bufferaddress);
+	rtlpriv->cfg->ops->set_desc((u8 *)entry, false, HW_DESC_RXPKT_LEN,
+				    (u8 *)&rtlpci->
+				    rxbuffersize);
+	rtlpriv->cfg->ops->set_desc((u8 *)entry, false, HW_DESC_RXOWN,
+				    (u8 *)&tmp_one);
 
-	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
+	return 1;
+}
 
-	if (is_broadcast_ether_addr(hdr->addr1)) {
-		;/*TODO*/
-	} else if (is_multicast_ether_addr(hdr->addr1)) {
-		;/*TODO*/
+/* inorder to receive 8K AMSDU we have set skb to
+ * 9100bytes in init rx ring, but if this packet is
+ * not a AMSDU, this so big packet will be sent to
+ * TCP/IP directly, this cause big packet ping fail
+ * like: "ping -s 65507", so here we will realloc skb
+ * based on the true size of packet, I think mac80211
+ * do it will be better, but now mac80211 haven't */
+
+/* but some platform will fail when alloc skb sometimes.
+ * in this condition, we will send the old skb to
+ * mac80211 directly, this will not cause any other
+ * issues, but only be losted by TCP/IP */
+static void _rtl_pci_rx_to_mac80211(struct ieee80211_hw *hw,
+	struct sk_buff *skb, struct ieee80211_rx_status rx_status)
+{
+	if (unlikely(!rtl_action_proc(hw, skb, false))) {
+		dev_kfree_skb_any(skb);
 	} else {
-		unicast = true;
-		rtlpriv->stats.rxbytesunicast += skb->len;
-	}
-
-	rtl_is_special_data(hw, skb, false);
-
-	if (ieee80211_is_data(fc)) {
-		rtlpriv->cfg->ops->led_control(hw, LED_CTL_RX);
-
-		if (unicast)
-			rtlpriv->link_info.num_rx_inperiod++;
+		struct sk_buff *uskb = NULL;
+		u8 *pdata;
+
+		uskb = dev_alloc_skb(skb->len + 128);
+		if (likely(uskb)) {
+			memcpy(IEEE80211_SKB_RXCB(uskb), &rx_status,
+			       sizeof(rx_status));
+			pdata = (u8 *)skb_put(uskb, skb->len);
+			memcpy(pdata, skb->data, skb->len);
+			dev_kfree_skb_any(skb);
+
+			ieee80211_rx_irqsafe(hw, uskb);
+		} else {
+			ieee80211_rx_irqsafe(hw, skb);
+		}
 	}
-
-	/* for sw lps */
-	rtl_swlps_beacon(hw, (void *)skb->data, skb->len);
-	rtl_recognize_peer(hw, (void *)skb->data, skb->len);
-	if ((rtlpriv->mac80211.opmode == NL80211_IFTYPE_AP) &&
-	    (rtlpriv->rtlhal.current_bandtype == BAND_ON_2_4G) &&
-	     (ieee80211_is_beacon(fc) || ieee80211_is_probe_resp(fc)))
-		return;
-
-	if (unlikely(!rtl_action_proc(hw, skb, false)))
-		return;
-
-	uskb = dev_alloc_skb(skb->len + 128);
-	if (!uskb)
-		return;		/* exit if allocation failed */
-	memcpy(IEEE80211_SKB_RXCB(uskb), &rx_status, sizeof(rx_status));
-	pdata = (u8 *)skb_put(uskb, skb->len);
-	memcpy(pdata, skb->data, skb->len);
-
-	ieee80211_rx_irqsafe(hw, uskb);
 }
 
 static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	int rx_queue_idx = RTL_PCI_RX_MPDU_QUEUE;
+	int rxring_idx = RTL_PCI_RX_MPDU_QUEUE;
 
 	struct ieee80211_rx_status rx_status = { 0 };
 	unsigned int count = rtlpci->rxringcount;
 	u8 own;
 	u8 tmp_one;
-	u32 bufferaddress;
+	bool unicast = false;
 
 	struct rtl_stats stats = {
 		.signal = 0,
 		.noise = -98,
 		.rate = 0,
 	};
-	int index = rtlpci->rx_ring[rx_queue_idx].idx;
 
 	/*RX NORMAL PKT */
 	while (count--) {
+		int index = rtlpci->rx_ring[rxring_idx].idx;
 		/*rx descriptor */
-		struct rtl_rx_desc *pdesc = &rtlpci->rx_ring[rx_queue_idx].desc[
+		struct rtl_rx_desc *pdesc = &rtlpci->rx_ring[rxring_idx].desc[
 				index];
 		/*rx pkt */
-		struct sk_buff *skb = rtlpci->rx_ring[rx_queue_idx].rx_buf[
+		struct sk_buff *skb = rtlpci->rx_ring[rxring_idx].rx_buf[
 				index];
-		struct sk_buff *new_skb = NULL;
 
 		own = (u8) rtlpriv->cfg->ops->get_desc((u8 *) pdesc,
 						       false, HW_DESC_OWN);
 
-		/*wait data to be filled by hardware */
-		if (own)
-			break;
-
-		rtlpriv->cfg->ops->query_rx_desc(hw, &stats,
-						 &rx_status,
-						 (u8 *) pdesc, skb);
-
-		if (stats.crc || stats.hwerror)
-			goto done;
+		if (own) {
+			/*wait data to be filled by hardware */
+			return;
+		} else {
+			struct ieee80211_hdr *hdr;
+			__le16 fc;
 
-		new_skb = dev_alloc_skb(rtlpci->rxbuffersize);
-		if (unlikely(!new_skb)) {
-			RT_TRACE(rtlpriv, (COMP_INTR | COMP_RECV), DBG_DMESG,
-				 "can't alloc skb for rx\n");
-			goto done;
-		}
+			rtlpriv->cfg->ops->query_rx_desc(hw, &stats,
+							 &rx_status,
+							 (u8 *)pdesc, skb);
+			pci_unmap_single(rtlpci->pdev, *((dma_addr_t *)skb->cb),
+					 rtlpci->rxbuffersize,
+					 PCI_DMA_FROMDEVICE);
 
-		pci_unmap_single(rtlpci->pdev,
-				 *((dma_addr_t *) skb->cb),
-				 rtlpci->rxbuffersize,
-				 PCI_DMA_FROMDEVICE);
+			skb_put(skb, rtlpriv->cfg->ops->get_desc((u8 *) pdesc,
+				false,	 HW_DESC_RXPKT_LEN));
+			skb_reserve(skb, stats.rx_drvinfo_size +
+				    stats.rx_bufshift);
 
-		skb_put(skb, rtlpriv->cfg->ops->get_desc((u8 *) pdesc, false,
-			HW_DESC_RXPKT_LEN));
-		skb_reserve(skb, stats.rx_drvinfo_size + stats.rx_bufshift);
+			/*
+			 *NOTICE This can not be use for mac80211,
+			 *this is done in mac80211 code,
+			 *if you done here sec DHCP will fail
+			 *skb_trim(skb, skb->len - 4);
+			 */
 
-		/*
-		 * NOTICE This can not be use for mac80211,
-		 * this is done in mac80211 code,
-		 * if you done here sec DHCP will fail
-		 * skb_trim(skb, skb->len - 4);
-		 */
+			hdr = rtl_get_hdr(skb);
+			fc = rtl_get_fc(skb);
+
+			if (!stats.crc && !stats.hwerror) {
+				memcpy(IEEE80211_SKB_RXCB(skb), &rx_status,
+				       sizeof(rx_status));
+
+				if (is_broadcast_ether_addr(hdr->addr1)) {
+					;/*TODO*/
+				} else if (is_multicast_ether_addr(hdr->addr1)) {
+					;/*TODO*/
+				} else {
+					unicast = true;
+					rtlpriv->stats.rxbytesunicast += skb->len;
+				}
+
+				rtl_is_special_data(hw, skb, false);
+
+				if (ieee80211_is_data(fc)) {
+					rtlpriv->cfg->ops->led_control(hw,
+							 LED_CTL_RX);
+
+					if (unicast)
+						rtlpriv->link_info.num_rx_inperiod++;
+				}
+
+				/* static bcn for roaming */
+				rtl_beacon_statistic(hw, skb);
+
+				/* for sw lps */
+				rtl_swlps_beacon(hw, (void *)skb->data,
+						 skb->len);
+				rtl_recognize_peer(hw, (void *)skb->data,
+						   skb->len);
+				if ((rtlpriv->mac80211.opmode ==
+				     NL80211_IFTYPE_AP) &&
+				    (rtlpriv->rtlhal.current_bandtype ==
+				    BAND_ON_2_4G) &&
+				    (ieee80211_is_beacon(fc) ||
+				    ieee80211_is_probe_resp(fc)))
+					dev_kfree_skb_any(skb);
+				else
+					_rtl_pci_rx_to_mac80211(hw, skb,
+								rx_status);
+			} else {
+				dev_kfree_skb_any(skb);
+			}
 
-		_rtl_receive_one(hw, skb, rx_status);
+			if (((rtlpriv->link_info.num_rx_inperiod +
+				rtlpriv->link_info.num_tx_inperiod) > 8) ||
+				(rtlpriv->link_info.num_rx_inperiod > 2))
+				rtl_lps_leave(hw);
 
-		if (((rtlpriv->link_info.num_rx_inperiod +
-			rtlpriv->link_info.num_tx_inperiod) > 8) ||
-			(rtlpriv->link_info.num_rx_inperiod > 2)) {
-			schedule_work(&rtlpriv->works.lps_leave_work);
+			_rtl_pci_init_one_rxdesc(hw, pdesc, rxring_idx,
+					rtlpci->rx_ring[rxring_idx].idx);
 		}
 
-		dev_kfree_skb_any(skb);
-		skb = new_skb;
-
-		rtlpci->rx_ring[rx_queue_idx].rx_buf[index] = skb;
-		*((dma_addr_t *) skb->cb) =
-			    pci_map_single(rtlpci->pdev, skb_tail_pointer(skb),
-					   rtlpci->rxbuffersize,
-					   PCI_DMA_FROMDEVICE);
-
-done:
-		bufferaddress = (*((dma_addr_t *)skb->cb));
-		tmp_one = 1;
-		rtlpriv->cfg->ops->set_desc((u8 *) pdesc, false,
-					    HW_DESC_RXBUFF_ADDR,
-					    (u8 *)&bufferaddress);
-		rtlpriv->cfg->ops->set_desc((u8 *)pdesc, false,
-					    HW_DESC_RXPKT_LEN,
-					    (u8 *)&rtlpci->rxbuffersize);
-
-		if (index == rtlpci->rxringcount - 1)
+		if (rtlpci->rx_ring[rxring_idx].idx == rtlpci->rxringcount - 1)
 			rtlpriv->cfg->ops->set_desc((u8 *)pdesc, false,
-						    HW_DESC_RXERO,
-						    &tmp_one);
-
-		rtlpriv->cfg->ops->set_desc((u8 *)pdesc, false, HW_DESC_RXOWN,
-					    &tmp_one);
-
-		index = (index + 1) % rtlpci->rxringcount;
+						     HW_DESC_RXERO,
+						     &tmp_one);
+		rtlpci->rx_ring[rxring_idx].idx = (rtlpci->rx_ring[rxring_idx].idx
+						   + 1)%rtlpci->rxringcount;
 	}
-
-	rtlpci->rx_ring[rx_queue_idx].idx = index;
 }
 
 static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
@@ -775,7 +865,6 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 	unsigned long flags;
 	u32 inta = 0;
 	u32 intb = 0;
-	irqreturn_t ret = IRQ_HANDLED;
 
 	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
 
@@ -783,10 +872,8 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 	rtlpriv->cfg->ops->interrupt_recognized(hw, &inta, &intb);
 
 	/*Shared IRQ or HW disappared */
-	if (!inta || inta == 0xffff) {
-		ret = IRQ_NONE;
+	if (!inta || inta == 0xffff)
 		goto done;
-	}
 
 	/*<1> beacon related */
 	if (inta & rtlpriv->cfg->maps[RTL_IMR_TBDOK]) {
@@ -889,7 +976,7 @@ static irqreturn_t _rtl_pci_interrupt(int irq, void *dev_id)
 
 done:
 	spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
-	return ret;
+	return IRQ_HANDLED;
 }
 
 static void _rtl_pci_irq_tasklet(struct ieee80211_hw *hw)
@@ -939,15 +1026,6 @@ static void _rtl_pci_prepare_bcn_tasklet(struct ieee80211_hw *hw)
 	return;
 }
 
-static void rtl_lps_leave_work_callback(struct work_struct *work)
-{
-	struct rtl_works *rtlworks =
-	    container_of(work, struct rtl_works, lps_leave_work);
-	struct ieee80211_hw *hw = rtlworks->hw;
-
-	rtl_lps_leave(hw);
-}
-
 static void _rtl_pci_init_trx_var(struct ieee80211_hw *hw)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
@@ -1009,7 +1087,6 @@ static void _rtl_pci_init_struct(struct ieee80211_hw *hw,
 	tasklet_init(&rtlpriv->works.irq_prepare_bcn_tasklet,
 		     (void (*)(unsigned long))_rtl_pci_prepare_bcn_tasklet,
 		     (unsigned long)hw);
-	INIT_WORK(&rtlpriv->works.lps_leave_work, rtl_lps_leave_work_callback);
 }
 
 static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
@@ -1022,6 +1099,7 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 	u32 nextdescaddress;
 	int i;
 
+	/* alloc dma for this ring */
 	ring = pci_alloc_consistent(rtlpci->pdev,
 				    sizeof(*ring) * entries, &dma);
 
@@ -1041,6 +1119,7 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, "queue:%d, ring_addr:%p\n",
 		 prio, ring);
 
+	/* init every desc in this ring */
 	for (i = 0; i < entries; i++) {
 		nextdescaddress = (u32) dma +
 					      ((i + 1) % entries) *
@@ -1054,84 +1133,38 @@ static int _rtl_pci_init_tx_ring(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw)
+static int _rtl_pci_init_rx_ring(struct ieee80211_hw *hw, int rxring_idx)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_rx_desc *entry = NULL;
-	int i, rx_queue_idx;
+	int i;
 	u8 tmp_one = 1;
 
-	/*
-	 *rx_queue_idx 0:RX_MPDU_QUEUE
-	 *rx_queue_idx 1:RX_CMD_QUEUE
-	 */
-	for (rx_queue_idx = 0; rx_queue_idx < RTL_PCI_MAX_RX_QUEUE;
-	     rx_queue_idx++) {
-		rtlpci->rx_ring[rx_queue_idx].desc =
-		    pci_alloc_consistent(rtlpci->pdev,
-					 sizeof(*rtlpci->rx_ring[rx_queue_idx].
-						desc) * rtlpci->rxringcount,
-					 &rtlpci->rx_ring[rx_queue_idx].dma);
-
-		if (!rtlpci->rx_ring[rx_queue_idx].desc ||
-		    (unsigned long)rtlpci->rx_ring[rx_queue_idx].desc & 0xFF) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 "Cannot allocate RX ring\n");
-			return -ENOMEM;
-		}
-
-		memset(rtlpci->rx_ring[rx_queue_idx].desc, 0,
-		       sizeof(*rtlpci->rx_ring[rx_queue_idx].desc) *
-		       rtlpci->rxringcount);
-
-		rtlpci->rx_ring[rx_queue_idx].idx = 0;
-
-		/* If amsdu_8k is disabled, set buffersize to 4096. This
-		 * change will reduce memory fragmentation.
-		 */
-		if (rtlpci->rxbuffersize > 4096 &&
-		    rtlpriv->rtlhal.disable_amsdu_8k)
-			rtlpci->rxbuffersize = 4096;
-
-		for (i = 0; i < rtlpci->rxringcount; i++) {
-			struct sk_buff *skb =
-			    dev_alloc_skb(rtlpci->rxbuffersize);
-			u32 bufferaddress;
-			if (!skb)
-				return 0;
-			kmemleak_not_leak(skb);
-			entry = &rtlpci->rx_ring[rx_queue_idx].desc[i];
-
-			/*skb->dev = dev; */
-
-			rtlpci->rx_ring[rx_queue_idx].rx_buf[i] = skb;
+	/* alloc dma for this ring */
+	rtlpci->rx_ring[rxring_idx].desc = pci_alloc_consistent(rtlpci->pdev,
+			 sizeof(*rtlpci->rx_ring[rxring_idx].desc) *
+			 rtlpci->rxringcount, &rtlpci->rx_ring[rxring_idx].dma);
+	if (!rtlpci->rx_ring[rxring_idx].desc ||
+	    (unsigned long)rtlpci->rx_ring[rxring_idx].desc & 0xFF) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 "Cannot allocate RX ring\n");
+		return -ENOMEM;
+	}
 
-			/*
-			 *just set skb->cb to mapping addr
-			 *for pci_unmap_single use
-			 */
-			*((dma_addr_t *) skb->cb) =
-			    pci_map_single(rtlpci->pdev, skb_tail_pointer(skb),
-					   rtlpci->rxbuffersize,
-					   PCI_DMA_FROMDEVICE);
-
-			bufferaddress = (*((dma_addr_t *)skb->cb));
-			rtlpriv->cfg->ops->set_desc((u8 *)entry, false,
-						    HW_DESC_RXBUFF_ADDR,
-						    (u8 *)&bufferaddress);
-			rtlpriv->cfg->ops->set_desc((u8 *)entry, false,
-						    HW_DESC_RXPKT_LEN,
-						    (u8 *)&rtlpci->
-						    rxbuffersize);
-			rtlpriv->cfg->ops->set_desc((u8 *) entry, false,
-						    HW_DESC_RXOWN,
-						    &tmp_one);
-		}
+	memset(rtlpci->rx_ring[rxring_idx].desc, 0,
+			sizeof(*rtlpci->rx_ring[rxring_idx].desc) *
+			rtlpci->rxringcount);
 
-		rtlpriv->cfg->ops->set_desc((u8 *) entry, false,
-					    HW_DESC_RXERO, &tmp_one);
+	/* init every desc in this ring */
+	rtlpci->rx_ring[rxring_idx].idx = 0;
+	for (i = 0; i < rtlpci->rxringcount; i++) {
+		entry = &rtlpci->rx_ring[rxring_idx].desc[i];
+		if (!_rtl_pci_init_one_rxdesc(hw, entry, rxring_idx, i))
+			return -ENOMEM;
 	}
+	rtlpriv->cfg->ops->set_desc((u8 *) entry, false,
+				    HW_DESC_RXERO, &tmp_one);
 	return 0;
 }
 
@@ -1142,6 +1175,7 @@ static void _rtl_pci_free_tx_ring(struct ieee80211_hw *hw,
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[prio];
 
+	/* free every desc in this ring */
 	while (skb_queue_len(&ring->queue)) {
 		struct rtl_tx_desc *entry = &ring->desc[ring->idx];
 		struct sk_buff *skb = __skb_dequeue(&ring->queue);
@@ -1155,6 +1189,7 @@ static void _rtl_pci_free_tx_ring(struct ieee80211_hw *hw,
 		ring->idx = (ring->idx + 1) % ring->entries;
 	}
 
+	/* free dma of this ring */
 	if (ring->desc) {
 		pci_free_consistent(rtlpci->pdev,
 				    sizeof(*ring->desc) * ring->entries,
@@ -1163,35 +1198,30 @@ static void _rtl_pci_free_tx_ring(struct ieee80211_hw *hw,
 	}
 }
 
-static void _rtl_pci_free_rx_ring(struct rtl_pci *rtlpci)
+static void _rtl_pci_free_rx_ring(struct rtl_pci *rtlpci,
+			int rxring_idx)
 {
-	int i, rx_queue_idx;
-
-	/*rx_queue_idx 0:RX_MPDU_QUEUE */
-	/*rx_queue_idx 1:RX_CMD_QUEUE */
-	for (rx_queue_idx = 0; rx_queue_idx < RTL_PCI_MAX_RX_QUEUE;
-	     rx_queue_idx++) {
-		for (i = 0; i < rtlpci->rxringcount; i++) {
-			struct sk_buff *skb =
-			    rtlpci->rx_ring[rx_queue_idx].rx_buf[i];
-			if (!skb)
-				continue;
-
-			pci_unmap_single(rtlpci->pdev,
-					 *((dma_addr_t *) skb->cb),
-					 rtlpci->rxbuffersize,
-					 PCI_DMA_FROMDEVICE);
-			kfree_skb(skb);
-		}
+	int i;
 
-		if (rtlpci->rx_ring[rx_queue_idx].desc) {
-			pci_free_consistent(rtlpci->pdev,
-				    sizeof(*rtlpci->rx_ring[rx_queue_idx].
-					   desc) * rtlpci->rxringcount,
-				    rtlpci->rx_ring[rx_queue_idx].desc,
-				    rtlpci->rx_ring[rx_queue_idx].dma);
-			rtlpci->rx_ring[rx_queue_idx].desc = NULL;
-		}
+	/* free every desc in this ring */
+	for (i = 0; i < rtlpci->rxringcount; i++) {
+		struct sk_buff *skb = rtlpci->rx_ring[rxring_idx].rx_buf[i];
+		if (!skb)
+			continue;
+
+		pci_unmap_single(rtlpci->pdev, *((dma_addr_t *) skb->cb),
+				 rtlpci->rxbuffersize, PCI_DMA_FROMDEVICE);
+		kfree_skb(skb);
+	}
+
+	/* free dma of this ring */
+	if (rtlpci->rx_ring[rxring_idx].desc) {
+		pci_free_consistent(rtlpci->pdev,
+			    sizeof(*rtlpci->rx_ring[rxring_idx].desc) *
+			    rtlpci->rxringcount,
+			    rtlpci->rx_ring[rxring_idx].desc,
+			    rtlpci->rx_ring[rxring_idx].dma);
+		rtlpci->rx_ring[rxring_idx].desc = NULL;
 	}
 }
 
@@ -1199,15 +1229,19 @@ static int _rtl_pci_init_trx_ring(struct ieee80211_hw *hw)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	int ret;
-	int i;
+	int i, rxring_idx;
 
-	ret = _rtl_pci_init_rx_ring(hw);
-	if (ret)
-		return ret;
+	/* rxring_idx 0:RX_MPDU_QUEUE
+	 * rxring_idx 1:RX_CMD_QUEUE */
+	for (rxring_idx = 0; rxring_idx < RTL_PCI_MAX_RX_QUEUE;
+	     rxring_idx++) {
+		ret = _rtl_pci_init_rx_ring(hw, rxring_idx);
+		if (ret)
+			return ret;
+	}
 
 	for (i = 0; i < RTL_PCI_MAX_TX_QUEUE_COUNT; i++) {
-		ret = _rtl_pci_init_tx_ring(hw, i,
-				 rtlpci->txringcount[i]);
+		ret = _rtl_pci_init_tx_ring(hw, i, rtlpci->txringcount[i]);
 		if (ret)
 			goto err_free_rings;
 	}
@@ -1215,7 +1249,9 @@ static int _rtl_pci_init_trx_ring(struct ieee80211_hw *hw)
 	return 0;
 
 err_free_rings:
-	_rtl_pci_free_rx_ring(rtlpci);
+	for (rxring_idx = 0; rxring_idx < RTL_PCI_MAX_RX_QUEUE;
+	     rxring_idx++)
+		_rtl_pci_free_rx_ring(rtlpci, rxring_idx);
 
 	for (i = 0; i < RTL_PCI_MAX_TX_QUEUE_COUNT; i++)
 		if (rtlpci->tx_ring[i].desc)
@@ -1227,10 +1263,12 @@ err_free_rings:
 static int _rtl_pci_deinit_trx_ring(struct ieee80211_hw *hw)
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	u32 i;
+	u32 i, rxring_idx;
 
 	/*free rx rings */
-	_rtl_pci_free_rx_ring(rtlpci);
+	for (rxring_idx = 0; rxring_idx < RTL_PCI_MAX_RX_QUEUE;
+	     rxring_idx++)
+		_rtl_pci_free_rx_ring(rtlpci, rxring_idx);
 
 	/*free tx rings */
 	for (i = 0; i < RTL_PCI_MAX_TX_QUEUE_COUNT; i++)
@@ -1243,64 +1281,52 @@ int rtl_pci_reset_trx_ring(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-	int i, rx_queue_idx;
+	int i, rxring_idx;
 	unsigned long flags;
 	u8 tmp_one = 1;
 
-	/*rx_queue_idx 0:RX_MPDU_QUEUE */
-	/*rx_queue_idx 1:RX_CMD_QUEUE */
-	for (rx_queue_idx = 0; rx_queue_idx < RTL_PCI_MAX_RX_QUEUE;
-	     rx_queue_idx++) {
-		/*
-		 *force the rx_ring[RX_MPDU_QUEUE/
-		 *RX_CMD_QUEUE].idx to the first one
-		 */
-		if (rtlpci->rx_ring[rx_queue_idx].desc) {
+	/* rxring_idx 0:RX_MPDU_QUEUE */
+	/* rxring_idx 1:RX_CMD_QUEUE */
+	for (rxring_idx = 0; rxring_idx < RTL_PCI_MAX_RX_QUEUE;
+	     rxring_idx++) {
+		/* force the rx_ring[RX_MPDU_QUEUE/
+		 * RX_CMD_QUEUE].idx to the first one */
+		if (rtlpci->rx_ring[rxring_idx].desc) {
 			struct rtl_rx_desc *entry = NULL;
 
 			for (i = 0; i < rtlpci->rxringcount; i++) {
-				entry = &rtlpci->rx_ring[rx_queue_idx].desc[i];
-				rtlpriv->cfg->ops->set_desc((u8 *) entry,
-							    false,
-							    HW_DESC_RXOWN,
-							    &tmp_one);
+				entry = &rtlpci->rx_ring[rxring_idx].desc[i];
+				rtlpriv->cfg->ops->set_desc((u8 *) entry, false,
+					    HW_DESC_RXOWN, &tmp_one);
 			}
-			rtlpci->rx_ring[rx_queue_idx].idx = 0;
+			rtlpci->rx_ring[rxring_idx].idx = 0;
 		}
 	}
 
-	/*
-	 *after reset, release previous pending packet,
-	 *and force the  tx idx to the first one
-	 */
+	/* after reset, release previous pending packet,
+	 * and force the  tx idx to the first one */
+	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
 	for (i = 0; i < RTL_PCI_MAX_TX_QUEUE_COUNT; i++) {
 		if (rtlpci->tx_ring[i].desc) {
 			struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[i];
 
 			while (skb_queue_len(&ring->queue)) {
-				struct rtl_tx_desc *entry;
-				struct sk_buff *skb;
+				struct rtl_tx_desc *entry = &ring->desc[ring->idx];
+				struct sk_buff *skb = __skb_dequeue(&ring->queue);
 
-				spin_lock_irqsave(&rtlpriv->locks.irq_th_lock,
-						  flags);
-				entry = &ring->desc[ring->idx];
-				skb = __skb_dequeue(&ring->queue);
 				pci_unmap_single(rtlpci->pdev,
-						 rtlpriv->cfg->ops->
-							 get_desc((u8 *)
-							 entry,
-							 true,
-							 HW_DESC_TXBUFF_ADDR),
-						 skb->len, PCI_DMA_TODEVICE);
-				ring->idx = (ring->idx + 1) % ring->entries;
-				spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock,
-						  flags);
+					rtlpriv->cfg->ops->get_desc((u8 *)
+					entry, true, HW_DESC_TXBUFF_ADDR),
+					skb->len, PCI_DMA_TODEVICE);
 				kfree_skb(skb);
+				ring->idx = (ring->idx + 1) % ring->entries;
 			}
 			ring->idx = 0;
 		}
 	}
 
+	spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
+
 	return 0;
 }
 
@@ -1312,6 +1338,7 @@ static bool rtl_pci_tx_chk_waitq_insert(struct ieee80211_hw *hw,
 	struct ieee80211_sta *sta = info->control.sta;
 	struct rtl_sta_info *sta_entry = NULL;
 	u8 tid = rtl_get_tid(skb);
+	__le16 fc = rtl_get_fc(skb);
 
 	if (!sta)
 		return false;
@@ -1319,6 +1346,12 @@ static bool rtl_pci_tx_chk_waitq_insert(struct ieee80211_hw *hw,
 
 	if (!rtlpriv->rtlhal.earlymode_enable)
 		return false;
+	if (ieee80211_is_nullfunc(fc))
+		return false;
+	if (ieee80211_is_qos_nullfunc(fc))
+		return false;
+	if (ieee80211_is_pspoll(fc))
+		return false;
 	if (sta_entry->tids[tid].agg.agg_state != RTL_AGG_OPERATIONAL)
 		return false;
 	if (_rtl_mac_to_hwqueue(hw, skb) > VO_QUEUE)
@@ -1359,10 +1392,8 @@ static int rtl_pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	u8 own;
 	u8 temp_one = 1;
 
-	if (ieee80211_is_auth(fc)) {
-		RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG, "MAC80211_LINKING\n");
-		rtl_ips_nic_on(hw);
-	}
+	if (ieee80211_is_mgmt(fc))
+		rtl_tx_mgmt_proc(hw, skb);
 
 	if (rtlpriv->psc.sw_ps_enabled) {
 		if (ieee80211_is_data(fc) && !ieee80211_is_nullfunc(fc) &&
@@ -1462,7 +1493,7 @@ static void rtl_pci_flush(struct ieee80211_hw *hw, bool drop)
 			queue_id--;
 			continue;
 		} else {
-			msleep(20);
+			usleep_range(5000, 6000);
 			i++;
 		}
 
@@ -1482,7 +1513,6 @@ static void rtl_pci_deinit(struct ieee80211_hw *hw)
 
 	synchronize_irq(rtlpci->pdev->irq);
 	tasklet_kill(&rtlpriv->works.irq_tasklet);
-	cancel_work_sync(&rtlpriv->works.lps_leave_work);
 
 	flush_workqueue(rtlpriv->works.rtl_wq);
 	destroy_workqueue(rtlpriv->works.rtl_wq);
@@ -1557,7 +1587,6 @@ static void rtl_pci_stop(struct ieee80211_hw *hw)
 	set_hal_stop(rtlhal);
 
 	rtlpriv->cfg->ops->disable_interrupt(hw);
-	cancel_work_sync(&rtlpriv->works.lps_leave_work);
 
 	spin_lock_irqsave(&rtlpriv->locks.rf_ps_lock, flags);
 	while (ppsc->rfchange_inprogress) {
@@ -1630,7 +1659,7 @@ static bool _rtl_pci_find_adapter(struct pci_dev *pdev,
 				 "8192 PCI-E is found - vid/did=%x/%x\n",
 				 venderid, deviceid);
 			rtlhal->hw_type = HARDWARE_TYPE_RTL8192E;
-			break;
+			return false;
 		case RTL_PCI_REVISION_ID_8192SE:
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 				 "8192SE is found - vid/did=%x/%x\n",
@@ -1645,6 +1674,11 @@ static bool _rtl_pci_find_adapter(struct pci_dev *pdev,
 			break;
 
 		}
+	} else if (deviceid == RTL_PCI_8723AE_DID) {
+		rtlhal->hw_type = HARDWARE_TYPE_RTL8723AE;
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+			 "8723AE PCI-E is found - "
+			 "vid/did=%x/%x\n", venderid, deviceid);
 	} else if (deviceid == RTL_PCI_8192CET_DID ||
 		   deviceid == RTL_PCI_8192CE_DID ||
 		   deviceid == RTL_PCI_8191CE_DID ||
@@ -1690,6 +1724,10 @@ static bool _rtl_pci_find_adapter(struct pci_dev *pdev,
 	pcipriv->ndis_adapter.devnumber = PCI_SLOT(pdev->devfn);
 	pcipriv->ndis_adapter.funcnumber = PCI_FUNC(pdev->devfn);
 
+	/*find bridge info */
+	pcipriv->ndis_adapter.pcibridge_vendor = PCI_BRIDGE_VENDOR_UNKNOWN;
+	/* some ARM have no bridge_pdev and will crash here
+	 * so we should check if bridge_pdev is NULL */
 	if (bridge_pdev) {
 		/*find bridge info if available */
 		pcipriv->ndis_adapter.pcibridge_vendorid = bridge_pdev->vendor;
@@ -1712,6 +1750,10 @@ static bool _rtl_pci_find_adapter(struct pci_dev *pdev,
 		    PCI_SLOT(bridge_pdev->devfn);
 		pcipriv->ndis_adapter.pcibridge_funcnum =
 		    PCI_FUNC(bridge_pdev->devfn);
+		pcipriv->ndis_adapter.pcicfg_addrport =
+		    (pcipriv->ndis_adapter.pcibridge_busnum << 16) |
+		    (pcipriv->ndis_adapter.pcibridge_devnum << 11) |
+		    (pcipriv->ndis_adapter.pcibridge_funcnum << 8) | (1 << 31);
 		pcipriv->ndis_adapter.pcibridge_pciehdr_offset =
 		    pci_pcie_cap(bridge_pdev);
 		pcipriv->ndis_adapter.num4bytes =
@@ -1744,10 +1786,15 @@ static bool _rtl_pci_find_adapter(struct pci_dev *pdev,
 		 pcipriv->ndis_adapter.amd_l1_patch);
 
 	rtl_pci_parse_configuration(pdev, hw);
-
+	list_add_tail(&rtlpriv->list, &rtlpriv->glb_var->glb_priv_list);
 	return true;
 }
 
+/* this is used for other modules get
+ * hw pointer in rtl_pci_get_hw_pointer
+ */
+static struct ieee80211_hw *hw_export;
+
 int __devinit rtl_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *id)
 {
@@ -1785,6 +1832,7 @@ int __devinit rtl_pci_probe(struct pci_dev *pdev,
 		err = -ENOMEM;
 		goto fail1;
 	}
+	hw_export = hw;
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 	pci_set_drvdata(pdev, hw);
@@ -1798,6 +1846,7 @@ int __devinit rtl_pci_probe(struct pci_dev *pdev,
 	rtlpriv->rtlhal.interface = INTF_PCI;
 	rtlpriv->cfg = (struct rtl_hal_cfg *)(id->driver_data);
 	rtlpriv->intf_ops = &rtl_pci_ops;
+	rtlpriv->glb_var = &global_var;
 
 	/*
 	 *init dbgp flags before all
@@ -1843,6 +1892,7 @@ int __devinit rtl_pci_probe(struct pci_dev *pdev,
 	pci_write_config_byte(pdev, 0x04, 0x07);
 
 	/* find adapter */
+	/* if chip not supported, will return false */
 	if (!_rtl_pci_find_adapter(pdev, hw)) {
 		err = -ENODEV;
 		goto fail3;
@@ -1898,6 +1948,7 @@ int __devinit rtl_pci_probe(struct pci_dev *pdev,
 	}
 	rtlpci->irq_alloc = 1;
 
+	set_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
 	return 0;
 
 fail3:
@@ -1922,6 +1973,12 @@ fail1:
 }
 EXPORT_SYMBOL(rtl_pci_probe);
 
+struct ieee80211_hw *rtl_pci_get_hw_pointer(void)
+{
+	return hw_export;
+}
+EXPORT_SYMBOL(rtl_pci_get_hw_pointer);
+
 void rtl_pci_disconnect(struct pci_dev *pdev)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
@@ -1955,10 +2012,12 @@ void rtl_pci_disconnect(struct pci_dev *pdev)
 	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 
 	if (rtlpci->irq_alloc) {
+		synchronize_irq(rtlpci->pdev->irq);
 		free_irq(rtlpci->pdev->irq, hw);
 		rtlpci->irq_alloc = 0;
 	}
 
+	list_del(&rtlpriv->list);
 	if (rtlpriv->io.pci_mem_start != 0) {
 		pci_iounmap(pdev, (void __iomem *)rtlpriv->io.pci_mem_start);
 		pci_release_regions(pdev);
@@ -2018,6 +2077,7 @@ struct rtl_intf_ops rtl_pci_ops = {
 	.read_efuse_byte = read_efuse_byte,
 	.adapter_start = rtl_pci_start,
 	.adapter_stop = rtl_pci_stop,
+	.check_buddy_priv = rtl_pci_check_buddy_priv,
 	.adapter_tx = rtl_pci_tx,
 	.flush = rtl_pci_flush,
 	.reset_trx_ring = rtl_pci_reset_trx_ring,
diff --git a/drivers/net/wireless/rtlwifi/pci.h b/drivers/net/wireless/rtlwifi/pci.h
index 241448f..12975a3 100644
--- a/drivers/net/wireless/rtlwifi/pci.h
+++ b/drivers/net/wireless/rtlwifi/pci.h
@@ -86,6 +86,7 @@
 #define RTL_PCI_700F_DID	0x700F
 #define RTL_PCI_701F_DID	0x701F
 #define RTL_PCI_DLINK_DID	0x3304
+#define RTL_PCI_8723AE_DID	0x8723	/*8723e */
 #define RTL_PCI_8192CET_DID	0x8191	/*8192ce */
 #define RTL_PCI_8192CE_DID	0x8178	/*8192ce */
 #define RTL_PCI_8191CE_DID	0x8177	/*8192ce */
@@ -212,6 +213,7 @@ struct mp_adapter {
 	u16 pcibridge_vendorid;
 	u16 pcibridge_deviceid;
 
+	u32 pcicfg_addrport;
 	u8 num4bytes;
 
 	u8 pcibridge_pciehdr_offset;
@@ -239,6 +241,7 @@ int __devinit rtl_pci_probe(struct pci_dev *pdev,
 void rtl_pci_disconnect(struct pci_dev *pdev);
 int rtl_pci_suspend(struct device *dev);
 int rtl_pci_resume(struct device *dev);
+struct ieee80211_hw *rtl_pci_get_hw_pointer(void);
 static inline u8 pci_read8_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
 	return readb((u8 __iomem *) rtlpriv->io.pci_mem_start + addr);
diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/rtlwifi/ps.c
index 13ad33e..ce9ca3f 100644
--- a/drivers/net/wireless/rtlwifi/ps.c
+++ b/drivers/net/wireless/rtlwifi/ps.c
@@ -48,7 +48,7 @@ bool rtl_ps_enable_nic(struct ieee80211_hw *hw)
 
 	/*<2> Enable Adapter */
 	if (rtlpriv->cfg->ops->hw_init(hw))
-		return 1;
+		return false;
 	RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
 
 	/*<3> Enable Interrupt */
@@ -81,11 +81,53 @@ EXPORT_SYMBOL(rtl_ps_disable_nic);
 
 bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
 			 enum rf_pwrstate state_toset,
-			 u32 changesource)
+			 u32 changesource, bool protect_or_not)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+	enum rf_pwrstate rtstate;
 	bool actionallowed = false;
+	u16 rfwait_cnt = 0;
+
+	if (protect_or_not)
+		goto no_protect;
+
+	/*
+	 *Only one thread can change
+	 *the RF state at one time, and others
+	 *should wait to be executed.
+	 */
+	while (true) {
+		spin_lock(&rtlpriv->locks.rf_ps_lock);
+		if (ppsc->rfchange_inprogress) {
+			spin_unlock(&rtlpriv->locks.rf_ps_lock);
+
+			RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
+				 "RF Change in progress!"
+				  "Wait to set..state_toset(%d).\n",
+				  state_toset);
+
+			/* Set RF after the previous action is done.  */
+			while (ppsc->rfchange_inprogress) {
+				rfwait_cnt++;
+				mdelay(1);
+
+				/*
+				 *Waited too long, return false to avoid
+				 *to be stuck here.
+				 */
+				if (rfwait_cnt > 100)
+					return false;
+			}
+		} else {
+			ppsc->rfchange_inprogress = true;
+			spin_unlock(&rtlpriv->locks.rf_ps_lock);
+			break;
+		}
+	}
+
+no_protect:
+	rtstate = ppsc->rfpwr_state;
 
 	switch (state_toset) {
 	case ERFON:
@@ -127,6 +169,12 @@ bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
 	if (actionallowed)
 		rtlpriv->cfg->ops->set_rf_power_state(hw, state_toset);
 
+	if (!protect_or_not) {
+		spin_lock(&rtlpriv->locks.rf_ps_lock);
+		ppsc->rfchange_inprogress = false;
+		spin_unlock(&rtlpriv->locks.rf_ps_lock);
+	}
+
 	return actionallowed;
 }
 EXPORT_SYMBOL(rtl_ps_set_rf_state);
@@ -149,7 +197,8 @@ static void _rtl_ps_inactive_ps(struct ieee80211_hw *hw)
 		}
 	}
 
-	rtl_ps_set_rf_state(hw, ppsc->inactive_pwrstate, RF_CHANGE_BY_IPS);
+	rtl_ps_set_rf_state(hw, ppsc->inactive_pwrstate,
+			    RF_CHANGE_BY_IPS, false);
 
 	if (ppsc->inactive_pwrstate == ERFOFF &&
 	    rtlhal->interface == INTF_PCI) {
@@ -231,17 +280,16 @@ void rtl_ips_nic_off(struct ieee80211_hw *hw)
 			   &rtlpriv->works.ips_nic_off_wq, MSECS(100));
 }
 
+/* NOTICE: any opmode should exc nic_on, or disable without
+ * nic_on may ndicate that something is wrong, like adhoc TP
+ */
 void rtl_ips_nic_on(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	enum rf_pwrstate rtstate;
 	unsigned long flags;
 
-	if (mac->opmode != NL80211_IFTYPE_STATION)
-		return;
-
 	spin_lock_irqsave(&rtlpriv->locks.ips_lock, flags);
 
 	if (ppsc->inactiveps) {
@@ -375,6 +423,7 @@ void rtl_lps_enter(struct ieee80211_hw *hw)
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	unsigned long flag;
 
 	if (!ppsc->fwctrl_lps)
 		return;
@@ -395,7 +444,7 @@ void rtl_lps_enter(struct ieee80211_hw *hw)
 	if (mac->link_state != MAC80211_LINKED)
 		return;
 
-	mutex_lock(&rtlpriv->locks.ps_mutex);
+	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
 
 	/* Idle for a while if we connect to AP a while ago. */
 	if (mac->cnt_after_linked >= 2) {
@@ -407,7 +456,7 @@ void rtl_lps_enter(struct ieee80211_hw *hw)
 		}
 	}
 
-	mutex_unlock(&rtlpriv->locks.ps_mutex);
+	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
 }
 
 /*Leave the leisure power save mode.*/
@@ -416,8 +465,9 @@ void rtl_lps_leave(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	unsigned long flag;
 
-	mutex_lock(&rtlpriv->locks.ps_mutex);
+	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
 
 	if (ppsc->fwctrl_lps) {
 		if (ppsc->dot11_psmode != EACTIVE) {
@@ -438,7 +488,7 @@ void rtl_lps_leave(struct ieee80211_hw *hw)
 			rtl_lps_set_psmode(hw, EACTIVE);
 		}
 	}
-	mutex_unlock(&rtlpriv->locks.ps_mutex);
+	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
 }
 
 /* For sw LPS*/
@@ -527,6 +577,7 @@ void rtl_swlps_rf_awake(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	unsigned long flag;
 
 	if (!rtlpriv->psc.swctrl_lps)
 		return;
@@ -539,9 +590,9 @@ void rtl_swlps_rf_awake(struct ieee80211_hw *hw)
 		RT_CLEAR_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM);
 	}
 
-	mutex_lock(&rtlpriv->locks.ps_mutex);
-	rtl_ps_set_rf_state(hw, ERFON, RF_CHANGE_BY_PS);
-	mutex_unlock(&rtlpriv->locks.ps_mutex);
+	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
+	rtl_ps_set_rf_state(hw, ERFON, RF_CHANGE_BY_PS, false);
+	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flag);
 }
 
 void rtl_swlps_rfon_wq_callback(void *data)
@@ -559,6 +610,7 @@ void rtl_swlps_rf_sleep(struct ieee80211_hw *hw)
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	u8 sleep_intv;
+	unsigned long flags;
 
 	if (!rtlpriv->psc.sw_ps_enabled)
 		return;
@@ -574,9 +626,16 @@ void rtl_swlps_rf_sleep(struct ieee80211_hw *hw)
 	if (rtlpriv->link_info.busytraffic)
 		return;
 
-	mutex_lock(&rtlpriv->locks.ps_mutex);
-	rtl_ps_set_rf_state(hw, ERFSLEEP, RF_CHANGE_BY_PS);
-	mutex_unlock(&rtlpriv->locks.ps_mutex);
+	spin_lock(&rtlpriv->locks.rf_ps_lock);
+	if (rtlpriv->psc.rfchange_inprogress) {
+		spin_unlock(&rtlpriv->locks.rf_ps_lock);
+		return;
+	}
+	spin_unlock(&rtlpriv->locks.rf_ps_lock);
+
+	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flags);
+	rtl_ps_set_rf_state(hw, ERFSLEEP, RF_CHANGE_BY_PS, false);
+	spin_unlock_irqrestore(&rtlpriv->locks.lps_lock, flags);
 
 	if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM &&
 		!RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM)) {
diff --git a/drivers/net/wireless/rtlwifi/ps.h b/drivers/net/wireless/rtlwifi/ps.h
index 1357856..573dc9a 100644
--- a/drivers/net/wireless/rtlwifi/ps.h
+++ b/drivers/net/wireless/rtlwifi/ps.h
@@ -33,7 +33,8 @@
 #define MAX_SW_LPS_SLEEP_INTV	5
 
 bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
-			 enum rf_pwrstate state_toset, u32 changesource);
+			 enum rf_pwrstate state_toset, u32 changesource,
+			 bool protect_or_not);
 bool rtl_ps_enable_nic(struct ieee80211_hw *hw);
 bool rtl_ps_disable_nic(struct ieee80211_hw *hw);
 void rtl_ips_nic_off(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/rtlwifi/rc.c b/drivers/net/wireless/rtlwifi/rc.c
index d5cbf01..21560ff 100644
--- a/drivers/net/wireless/rtlwifi/rc.c
+++ b/drivers/net/wireless/rtlwifi/rc.c
@@ -35,7 +35,8 @@
  *Finds the highest rate index we can use
  *if skb is special data like DHCP/EAPOL, we set should
  *it to lowest rate CCK_1M, otherwise we set rate to
- *CCK11M or OFDM_54M based on wireless mode.
+ *highest rate based on wireless mode used for
+ *iwconfig show Tx rate.
  */
 static u8 _rtl_rc_get_highest_rix(struct rtl_priv *rtlpriv,
 				  struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/rtlwifi/regd.c b/drivers/net/wireless/rtlwifi/regd.c
index c1608cd..3da6219 100644
--- a/drivers/net/wireless/rtlwifi/regd.c
+++ b/drivers/net/wireless/rtlwifi/regd.c
@@ -303,6 +303,22 @@ static void _rtl_reg_apply_world_flags(struct wiphy *wiphy,
 	return;
 }
 
+static void _rtl_dump_channel_map(struct wiphy *wiphy)
+{
+	enum ieee80211_band band;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *ch;
+	unsigned int i;
+
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		if (!wiphy->bands[band])
+			continue;
+		sband = wiphy->bands[band];
+		for (i = 0; i < sband->n_channels; i++)
+			ch = &sband->channels[i];
+	}
+}
+
 static int _rtl_reg_notifier_apply(struct wiphy *wiphy,
 				   struct regulatory_request *request,
 				   struct rtl_regulatory *reg)
@@ -320,6 +336,8 @@ static int _rtl_reg_notifier_apply(struct wiphy *wiphy,
 		break;
 	}
 
+	_rtl_dump_channel_map(wiphy);
+
 	return 0;
 }
 
-- 
1.7.10.4

