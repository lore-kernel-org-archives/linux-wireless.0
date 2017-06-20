Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35911 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752676AbdFTAcd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 20:32:33 -0400
Received: by mail-oi0-f67.google.com with SMTP id g14so10724160oib.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jun 2017 17:32:33 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 08/10] rtlwifi: Fill ap_num field by driver
Date: Mon, 19 Jun 2017 19:32:16 -0500
Message-Id: <20170620003218.17010-9-Larry.Finger@lwfinger.net> (sfid-20170620_023243_377587_C98BE463)
In-Reply-To: <20170620003218.17010-1-Larry.Finger@lwfinger.net>
References: <20170620003218.17010-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Check beacon and probe_resp frames to know ap_num

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 102 ++++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtlwifi/base.h |   2 +
 drivers/net/wireless/realtek/rtlwifi/core.c |   3 +
 drivers/net/wireless/realtek/rtlwifi/pci.c  |   3 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h |  13 ++++
 5 files changed, 123 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 1994125a21b5..574f9943d70e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -628,6 +628,7 @@ int rtl_init_core(struct ieee80211_hw *hw)
 	spin_lock_init(&rtlpriv->locks.waitq_lock);
 	spin_lock_init(&rtlpriv->locks.entry_list_lock);
 	spin_lock_init(&rtlpriv->locks.c2hcmd_lock);
+	spin_lock_init(&rtlpriv->locks.scan_list_lock);
 	spin_lock_init(&rtlpriv->locks.cck_and_rw_pagea_lock);
 	spin_lock_init(&rtlpriv->locks.check_sendpkt_lock);
 	spin_lock_init(&rtlpriv->locks.fw_ps_lock);
@@ -636,6 +637,7 @@ int rtl_init_core(struct ieee80211_hw *hw)
 	/* <5> init list */
 	INIT_LIST_HEAD(&rtlpriv->entry_list);
 	INIT_LIST_HEAD(&rtlpriv->c2hcmd_list);
+	INIT_LIST_HEAD(&rtlpriv->scan_list.list);
 
 	rtlmac->link_state = MAC80211_NOLINK;
 
@@ -646,9 +648,12 @@ int rtl_init_core(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL_GPL(rtl_init_core);
 
+static void rtl_free_entries_from_scan_list(struct ieee80211_hw *hw);
+
 void rtl_deinit_core(struct ieee80211_hw *hw)
 {
 	rtl_c2hcmd_launcher(hw, 0);
+	rtl_free_entries_from_scan_list(hw);
 }
 EXPORT_SYMBOL_GPL(rtl_deinit_core);
 
@@ -1768,6 +1773,100 @@ void rtl_beacon_statistic(struct ieee80211_hw *hw, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(rtl_beacon_statistic);
 
+static void rtl_free_entries_from_scan_list(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_bssid_entry *entry, *next;
+
+	list_for_each_entry_safe(entry, next, &rtlpriv->scan_list.list, list) {
+		list_del(&entry->list);
+		kfree(entry);
+		rtlpriv->scan_list.num--;
+	}
+}
+
+void rtl_scan_list_expire(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_bssid_entry *entry, *next;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rtlpriv->locks.scan_list_lock, flags);
+
+	list_for_each_entry_safe(entry, next, &rtlpriv->scan_list.list, list) {
+		/* 180 seconds */
+		if (jiffies_to_msecs(jiffies - entry->age) < 180000)
+			continue;
+
+		list_del(&entry->list);
+		kfree(entry);
+		rtlpriv->scan_list.num--;
+
+		RT_TRACE(rtlpriv, COMP_SCAN, DBG_LOUD,
+			 "BSSID=%pM is expire in scan list (total=%d)\n",
+			 entry->bssid, rtlpriv->scan_list.num);
+	}
+
+	spin_unlock_irqrestore(&rtlpriv->locks.scan_list_lock, flags);
+
+	rtlpriv->btcoexist.btc_info.ap_num = rtlpriv->scan_list.num;
+}
+
+void rtl_collect_scan_list(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	unsigned long flags;
+
+	struct rtl_bssid_entry *entry;
+	bool entry_found = false;
+
+	/* check if it is scanning */
+	if (!mac->act_scanning)
+		return;
+
+	/* check if this really is a beacon */
+	if (!ieee80211_is_beacon(hdr->frame_control) &&
+	    !ieee80211_is_probe_resp(hdr->frame_control))
+		return;
+
+	spin_lock_irqsave(&rtlpriv->locks.scan_list_lock, flags);
+
+	list_for_each_entry(entry, &rtlpriv->scan_list.list, list) {
+		if (memcmp(entry->bssid, hdr->addr3, ETH_ALEN) == 0) {
+			list_del_init(&entry->list);
+			entry_found = true;
+			RT_TRACE(rtlpriv, COMP_SCAN, DBG_LOUD,
+				 "Update BSSID=%pM to scan list (total=%d)\n",
+				 hdr->addr3, rtlpriv->scan_list.num);
+			break;
+		}
+	}
+
+	if (!entry_found) {
+		entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
+
+		if (!entry)
+			goto label_err;
+
+		memcpy(entry->bssid, hdr->addr3, ETH_ALEN);
+		rtlpriv->scan_list.num++;
+
+		RT_TRACE(rtlpriv, COMP_SCAN, DBG_LOUD,
+			 "Add BSSID=%pM to scan list (total=%d)\n",
+			 hdr->addr3, rtlpriv->scan_list.num);
+	}
+
+	entry->age = jiffies;
+
+	list_add_tail(&entry->list, &rtlpriv->scan_list.list);
+
+label_err:
+	spin_unlock_irqrestore(&rtlpriv->locks.scan_list_lock, flags);
+}
+EXPORT_SYMBOL(rtl_collect_scan_list);
+
 void rtl_watchdog_wq_callback(void *data)
 {
 	struct rtl_works *rtlworks = container_of_dwork_rtl(data,
@@ -1925,6 +2024,9 @@ void rtl_watchdog_wq_callback(void *data)
 		rtlpriv->btcoexist.btc_ops->btc_periodical(rtlpriv);
 
 	rtlpriv->link_info.bcn_rx_inperiod = 0;
+
+	/* <6> scan list */
+	rtl_scan_list_expire(hw);
 }
 
 void rtl_watch_dog_timer_callback(unsigned long data)
diff --git a/drivers/net/wireless/realtek/rtlwifi/base.h b/drivers/net/wireless/realtek/rtlwifi/base.h
index 21fa4562f631..ab7d81904d25 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.h
+++ b/drivers/net/wireless/realtek/rtlwifi/base.h
@@ -137,6 +137,8 @@ bool rtl_check_tx_report_acked(struct ieee80211_hw *hw);
 void rtl_wait_tx_report_acked(struct ieee80211_hw *hw, u32 wait_ms);
 
 void rtl_beacon_statistic(struct ieee80211_hw *hw, struct sk_buff *skb);
+void rtl_collect_scan_list(struct ieee80211_hw *hw, struct sk_buff *skb);
+void rtl_scan_list_expire(struct ieee80211_hw *hw);
 int rtl_tx_agg_start(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct ieee80211_sta *sta, u16 tid, u16 *ssn);
 int rtl_tx_agg_stop(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 1a53a95d373b..b0ad061048c5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -1464,6 +1464,9 @@ static void rtl_op_sw_scan_complete(struct ieee80211_hw *hw,
 	RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD, "\n");
 	mac->act_scanning = false;
 	mac->skip_scan = false;
+
+	rtlpriv->btcoexist.btc_info.ap_num = rtlpriv->scan_list.num;
+
 	if (rtlpriv->link_info.higher_busytraffic)
 		return;
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 00a354c85ece..58f69375fd1c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -881,6 +881,9 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 				if (unicast)
 					rtlpriv->link_info.num_rx_inperiod++;
 			}
+
+			rtl_collect_scan_list(hw, skb);
+
 			/* static bcn for roaming */
 			rtl_beacon_statistic(hw, skb);
 			rtl_p2p_info(hw, (void *)skb->data, skb->len);
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 2fb83a7061dd..98183dc707aa 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2333,6 +2333,7 @@ struct rtl_locks {
 	spinlock_t entry_list_lock;
 	spinlock_t usb_lock;
 	spinlock_t c2hcmd_lock;
+	spinlock_t scan_list_lock; /* lock for the scan list */
 
 	/*FW clock change */
 	spinlock_t fw_ps_lock;
@@ -2587,6 +2588,17 @@ struct rtl_c2hcmd {
 	u8 *val;
 };
 
+struct rtl_bssid_entry {
+	struct list_head list;
+	u8 bssid[ETH_ALEN];
+	u32 age;
+};
+
+struct rtl_scan_list {
+	int num;
+	struct list_head list;	/* sort by age */
+};
+
 struct rtl_priv {
 	struct ieee80211_hw *hw;
 	struct completion firmware_loading_complete;
@@ -2608,6 +2620,7 @@ struct rtl_priv {
 	struct rtl_efuse efuse;
 	struct rtl_led_ctl ledctl;
 	struct rtl_tx_report tx_report;
+	struct rtl_scan_list scan_list;
 
 	struct rtl_ps_ctl psc;
 	struct rate_adaptive ra;
-- 
2.12.3
