Return-Path: <SRS0=EDlr=BE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D1BC433E4
	for <linux-wireless@archiver.kernel.org>; Sat, 25 Jul 2020 19:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00D33206D8
	for <linux-wireless@archiver.kernel.org>; Sat, 25 Jul 2020 19:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgGYT4L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 25 Jul 2020 15:56:11 -0400
Received: from smtprelay0112.hostedemail.com ([216.40.44.112]:55772 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727978AbgGYT4K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Jul 2020 15:56:10 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id D2749181D3025;
        Sat, 25 Jul 2020 19:56:08 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: cloud03_2802f4d26f52
X-Filterd-Recvd-Size: 8842
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Sat, 25 Jul 2020 19:56:07 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] rtlwifi: Remove unnecessary parenthese in rtl_dbg uses
Date:   Sat, 25 Jul 2020 12:55:04 -0700
Message-Id: <9b2eaedb7ea123ea766a379459b20a9486d1cd41.1595706420.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1595706419.git.joe@perches.com>
References: <cover.1595706419.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Make these statements a little simpler.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c   | 14 +++++------
 .../rtlwifi/btcoexist/halbtc8192e2ant.c       | 23 ++++++++++---------
 .../rtlwifi/btcoexist/halbtc8821a2ant.c       | 12 +++++-----
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c  |  9 ++++----
 drivers/net/wireless/realtek/rtlwifi/pci.c    |  2 +-
 5 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 270aea0f841b..b8d184950dac 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -1385,7 +1385,7 @@ bool rtl_action_proc(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
 			if (mac->act_scanning)
 				return false;
 
-			rtl_dbg(rtlpriv, (COMP_SEND | COMP_RECV), DBG_DMESG,
+			rtl_dbg(rtlpriv, COMP_SEND | COMP_RECV, DBG_DMESG,
 				"%s ACT_ADDBAREQ From :%pM\n",
 				is_tx ? "Tx" : "Rx", hdr->addr2);
 			RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_DMESG, "req\n",
@@ -1428,12 +1428,12 @@ bool rtl_action_proc(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
 			}
 			break;
 		case ACT_ADDBARSP:
-			rtl_dbg(rtlpriv, (COMP_SEND | COMP_RECV), DBG_DMESG,
+			rtl_dbg(rtlpriv, COMP_SEND | COMP_RECV, DBG_DMESG,
 				"%s ACT_ADDBARSP From :%pM\n",
 				is_tx ? "Tx" : "Rx", hdr->addr2);
 			break;
 		case ACT_DELBA:
-			rtl_dbg(rtlpriv, (COMP_SEND | COMP_RECV), DBG_DMESG,
+			rtl_dbg(rtlpriv, COMP_SEND | COMP_RECV, DBG_DMESG,
 				"ACT_ADDBADEL From :%pM\n", hdr->addr2);
 			break;
 		}
@@ -1519,9 +1519,9 @@ u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx,
 				/* 68 : UDP BOOTP client
 				 * 67 : UDP BOOTP server
 				 */
-				rtl_dbg(rtlpriv, (COMP_SEND | COMP_RECV),
+				rtl_dbg(rtlpriv, COMP_SEND | COMP_RECV,
 					DBG_DMESG, "dhcp %s !!\n",
-					(is_tx) ? "Tx" : "Rx");
+					is_tx ? "Tx" : "Rx");
 
 				if (is_tx)
 					setup_special_tx(rtlpriv, ppsc,
@@ -1540,8 +1540,8 @@ u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx,
 		rtlpriv->btcoexist.btc_info.in_4way = true;
 		rtlpriv->btcoexist.btc_info.in_4way_ts = jiffies;
 
-		rtl_dbg(rtlpriv, (COMP_SEND | COMP_RECV), DBG_DMESG,
-			"802.1X %s EAPOL pkt!!\n", (is_tx) ? "Tx" : "Rx");
+		rtl_dbg(rtlpriv, COMP_SEND | COMP_RECV, DBG_DMESG,
+			"802.1X %s EAPOL pkt!!\n", is_tx ? "Tx" : "Rx");
 
 		if (is_tx) {
 			rtlpriv->ra.is_special_data = true;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
index 4989fd3bae15..30c782d61d70 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
@@ -801,8 +801,8 @@ static void btc8192e2ant_bt_auto_report(struct btc_coexist *btcoexist,
 
 	rtl_dbg(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		"[BTCoex], %s BT Auto report = %s\n",
-		(force_exec ? "force to" : ""),
-		((enable_auto_report) ? "Enabled" : "Disabled"));
+		force_exec ? "force to" : "",
+		enable_auto_report ? "Enabled" : "Disabled");
 	coex_dm->cur_bt_auto_report = enable_auto_report;
 
 	if (!force_exec) {
@@ -878,9 +878,9 @@ static void btc8192e2ant_rf_shrink(struct btc_coexist *btcoexist,
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
 	rtl_dbg(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		"[BTCoex], %s turn Rx RF Shrink = %s\n",
-		(force_exec ? "force to" : ""),
-		((rx_rf_shrink_on) ? "ON" : "OFF"));
+		"[BTCoex], %sturn Rx RF Shrink = %s\n",
+		force_exec ? "force to " : "",
+		rx_rf_shrink_on ? "ON" : "OFF");
 	coex_dm->cur_rf_rx_lpf_shrink = rx_rf_shrink_on;
 
 	if (!force_exec) {
@@ -927,9 +927,10 @@ static void btc8192e2ant_dac_swing(struct btc_coexist *btcoexist,
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
 	rtl_dbg(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		"[BTCoex], %s turn DacSwing=%s, dac_swing_lvl = 0x%x\n",
-		(force_exec ? "force to" : ""),
-		((dac_swing_on) ? "ON" : "OFF"), dac_swing_lvl);
+		"[BTCoex], %sturn DacSwing=%s, dac_swing_lvl = 0x%x\n",
+		force_exec ? "force to " : "",
+		dac_swing_on ? "ON" : "OFF",
+		dac_swing_lvl);
 	coex_dm->cur_dac_swing_on = dac_swing_on;
 	coex_dm->cur_dac_swing_lvl = dac_swing_lvl;
 
@@ -987,9 +988,9 @@ static void btc8192e2ant_agc_table(struct btc_coexist *btcoexist,
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
 	rtl_dbg(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		"[BTCoex], %s %s Agc Table\n",
-		(force_exec ? "force to" : ""),
-		((agc_table_en) ? "Enable" : "Disable"));
+		"[BTCoex], %s%s Agc Table\n",
+		force_exec ? "force to " : "",
+		agc_table_en ? "Enable" : "Disable");
 	coex_dm->cur_agc_table_en = agc_table_en;
 
 	if (!force_exec) {
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index d2f4287da9a5..43bd52a62c4f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -732,9 +732,9 @@ static void btc8821a2ant_low_penalty_ra(struct btc_coexist *btcoexist,
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
 	rtl_dbg(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		"[BTCoex], %s turn LowPenaltyRA = %s\n",
-		(force_exec ? "force to" : ""),
-		((low_penalty_ra) ? "ON" : "OFF"));
+		"[BTCoex], %sturn LowPenaltyRA = %s\n",
+		force_exec ? "force to " : "",
+		low_penalty_ra ? "ON" : "OFF");
 	coex_dm->cur_low_penalty_ra = low_penalty_ra;
 
 	if (!force_exec) {
@@ -780,9 +780,9 @@ static void btc8821a2ant_dac_swing(struct btc_coexist *btcoexist,
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
 	rtl_dbg(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		"[BTCoex], %s turn DacSwing = %s, dac_swing_lvl = 0x%x\n",
-		(force_exec ? "force to" : ""),
-		((dac_swing_on) ? "ON" : "OFF"),
+		"[BTCoex], %sturn DacSwing = %s, dac_swing_lvl = 0x%x\n",
+		force_exec ? "force to " : "",
+		dac_swing_on ? "ON" : "OFF",
 		dac_swing_lvl);
 	coex_dm->cur_dac_swing_on = dac_swing_on;
 	coex_dm->cur_dac_swing_lvl = dac_swing_lvl;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 8d28c68f083e..f9a2d8a6730c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -874,11 +874,10 @@ static void halbtc_display_wifi_status(struct btc_coexist *btcoexist,
 	seq_printf(m, "\n %-35s = %s / %s/ %s/ AP=%d ",
 		   "Wifi freq/ bw/ traffic",
 		   gl_btc_wifi_freq_string[wifi_freq],
-		   ((wifi_under_b_mode) ? "11b" :
-		    gl_btc_wifi_bw_string[wifi_bw]),
-		   ((!wifi_busy) ? "idle" : ((BTC_WIFI_TRAFFIC_TX ==
-					      wifi_traffic_dir) ? "uplink" :
-					     "downlink")),
+		   wifi_under_b_mode ? "11b" : gl_btc_wifi_bw_string[wifi_bw],
+		   (!wifi_busy ? "idle" :
+		    wifi_traffic_dir == BTC_WIFI_TRAFFIC_TX ? "uplink" :
+		    "downlink"),
 		   ap_num);
 
 	/* power status	 */
diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 1d0af72ee780..3189d1c50d52 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -557,7 +557,7 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 		if (rtlpriv->rtlhal.earlymode_enable)
 			skb_pull(skb, EM_HDR_LEN);
 
-		rtl_dbg(rtlpriv, (COMP_INTR | COMP_SEND), DBG_TRACE,
+		rtl_dbg(rtlpriv, COMP_INTR | COMP_SEND, DBG_TRACE,
 			"new ring->idx:%d, free: skb_queue_len:%d, free: seq:%x\n",
 			ring->idx,
 			skb_queue_len(&ring->queue),
-- 
2.26.0

