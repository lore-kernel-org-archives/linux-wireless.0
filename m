Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35755 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757030AbdDQAHR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 20:07:17 -0400
Received: by mail-oi0-f68.google.com with SMTP id a21so8751731oic.2
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 17:07:17 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 11/13] rtlwifi: btcoex: 21a 1ant: treat ARP as special packet
Date: Sun, 16 Apr 2017 19:06:58 -0500
Message-Id: <20170417000700.29057-12-Larry.Finger@lwfinger.net> (sfid-20170417_020748_750230_FAF8E912)
In-Reply-To: <20170417000700.29057-1-Larry.Finger@lwfinger.net>
References: <20170417000700.29057-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

We need to pay attention to ARP packets to correctly establish
connection, and reset the ARP counter when disconnected.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 49 ++++++++++++++++++++--
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h    |  1 +
 2 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index b8d5b73011ba..7d91d82e37fe 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -2592,7 +2592,7 @@ void ex_btc8821a1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 void ex_btc8821a1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	bool	wifi_connected = false, bt_hs_on = false;
+	bool wifi_connected = false, bt_hs_on = false;
 	u32 wifi_link_status = 0;
 	u32 num_of_wifi_link = 0;
 	bool bt_ctrl_agg_buf_size = false;
@@ -2610,6 +2610,18 @@ void ex_btc8821a1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 		return;
 	}
 
+	if (type == BTC_ASSOCIATE_START) {
+		coex_sta->wifi_is_high_pri_task = true;
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], CONNECT START notify\n");
+		coex_dm->arp_cnt = 0;
+	} else {
+		coex_sta->wifi_is_high_pri_task = false;
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], CONNECT FINISH notify\n");
+		coex_dm->arp_cnt = 0;
+	}
+
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
 			   &wifi_link_status);
 	num_of_wifi_link = wifi_link_status >> 16;
@@ -2675,6 +2687,7 @@ void ex_btc8821a1ant_media_status_notify(struct btc_coexist *btcoexist,
 	} else {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], MEDIA disconnect notify\n");
+		coex_dm->arp_cnt = 0;
 	}
 
 	/* only 2.4G we need to inform bt the chnl mask */
@@ -2728,6 +2741,24 @@ void ex_btc8821a1ant_special_packet_notify(struct btc_coexist *btcoexist,
 		return;
 	}
 
+	if (type == BTC_PACKET_DHCP || type == BTC_PACKET_EAPOL ||
+	    type == BTC_PACKET_ARP) {
+		coex_sta->wifi_is_high_pri_task = true;
+
+		if (type == BTC_PACKET_ARP) {
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], specific Packet ARP notify\n");
+		} else {
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], specific Packet DHCP or EAPOL notify\n");
+		}
+	} else {
+		coex_sta->wifi_is_high_pri_task = false;
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], specific Packet [Type = %d] notify\n",
+			 type);
+	}
+
 	coex_sta->special_pkt_period_cnt = 0;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
@@ -2750,8 +2781,20 @@ void ex_btc8821a1ant_special_packet_notify(struct btc_coexist *btcoexist,
 		return;
 	}
 
-	if (BTC_PACKET_DHCP == type ||
-	    BTC_PACKET_EAPOL == type) {
+	if (type == BTC_PACKET_DHCP || type == BTC_PACKET_EAPOL ||
+	    type == BTC_PACKET_ARP) {
+		if (type == BTC_PACKET_ARP) {
+			coex_dm->arp_cnt++;
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], ARP Packet Count = %d\n",
+				 coex_dm->arp_cnt);
+			if (coex_dm->arp_cnt >= 10)
+				/* if APR PKT > 10 after connect, do not go to
+				 * btc8821a1ant_act_wifi_conn_sp_pkt
+				 */
+				return;
+		}
+
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], special Packet(%d) notify\n", type);
 		btc8821a1ant_act_wifi_conn_sp_pkt(btcoexist);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
index 1bd1ebe3364e..8d6ee81586fd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
@@ -135,6 +135,7 @@ struct coex_dm_8821a_1ant {
 	u8	cur_retry_limit_type;
 	u8	pre_ampdu_time_type;
 	u8	cur_ampdu_time_type;
+	u32	arp_cnt;
 
 	u8	error_condition;
 };
-- 
2.12.0
