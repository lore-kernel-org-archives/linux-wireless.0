Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:33121 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751202AbdFYPnv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 11:43:51 -0400
Received: by mail-ot0-f194.google.com with SMTP id q16so9327878otb.0
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jun 2017 08:43:50 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 01/10] rtlwifi: Fill in_4way field by driver
Date: Sun, 25 Jun 2017 10:43:35 -0500
Message-Id: <20170625154344.19213-2-Larry.Finger@lwfinger.net> (sfid-20170625_174354_707686_55EDF3A8)
In-Reply-To: <20170625154344.19213-1-Larry.Finger@lwfinger.net>
References: <20170625154344.19213-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Because it isn't always correct to use EAPOL to check 4-way,
we add a timer to handle exception.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - no changes
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 11 +++++++++++
 drivers/net/wireless/realtek/rtlwifi/core.c |  2 ++
 drivers/net/wireless/realtek/rtlwifi/wifi.h |  3 +++
 3 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index bd9ae07647e1..7aa3c39c9c5c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1408,6 +1408,11 @@ u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx,
 
 		return true;
 	} else if (ETH_P_PAE == ether_type) {
+		/* EAPOL is seens as in-4way */
+		rtlpriv->btcoexist.btc_info.in_4way = true;
+		rtlpriv->btcoexist.btc_info.in_4way_ts = jiffies;
+	rtlpriv->btcoexist.btc_info.in_4way_ts = jiffies;
+
 		RT_TRACE(rtlpriv, (COMP_SEND | COMP_RECV), DBG_DMESG,
 			 "802.1X %s EAPOL pkt!!\n", (is_tx) ? "Tx" : "Rx");
 
@@ -1959,6 +1964,12 @@ void rtl_watchdog_wq_callback(void *data)
 	if (rtlpriv->cfg->ops->get_btc_status())
 		rtlpriv->btcoexist.btc_ops->btc_periodical(rtlpriv);
 
+	if (rtlpriv->btcoexist.btc_info.in_4way) {
+		if (time_after(jiffies, rtlpriv->btcoexist.btc_info.in_4way_ts +
+			       msecs_to_jiffies(IN_4WAY_TIMEOUT_TIME)))
+			rtlpriv->btcoexist.btc_info.in_4way = false;
+	}
+
 	rtlpriv->link_info.bcn_rx_inperiod = 0;
 
 	/* <6> scan list */
diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index b0ad061048c5..c53cbf3d52bd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -1505,6 +1505,8 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	u8 mac_addr[ETH_ALEN];
 	u8 bcast_addr[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
+	rtlpriv->btcoexist.btc_info.in_4way = false;
+
 	if (rtlpriv->cfg->mod_params->sw_crypto || rtlpriv->sec.use_sw_sec) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 "not open hw encryption\n");
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index fb1ebb01133f..7ec0d502a0d9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2477,6 +2477,8 @@ struct rtl_global_var {
 	spinlock_t glb_list_lock;
 };
 
+#define IN_4WAY_TIMEOUT_TIME	(30 * MSEC_PER_SEC)	/* 30 seconds */
+
 struct rtl_btc_info {
 	u8 bt_type;
 	u8 btcoexist;
@@ -2485,6 +2487,7 @@ struct rtl_btc_info {
 
 	u8 ap_num;
 	bool in_4way;
+	unsigned long in_4way_ts;
 };
 
 struct bt_coexist_info {
-- 
2.12.3
