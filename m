Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:34508 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab3IPSz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 14:55:57 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 8/8 V2] rtlwifi: Remove variable 'noise' from rtl_stats struct
Date: Mon, 16 Sep 2013 13:55:22 -0500
Message-Id: <1379357722-17687-9-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130916_205606_945828_7803D3C0)
In-Reply-To: <1379357722-17687-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1379357722-17687-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All uses of this variable have been removed. Now delete it from the struct
and from a few places that use it in commented-out lines.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c | 1 -
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c | 1 -
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c | 1 -
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c | 1 -
 drivers/net/wireless/rtlwifi/wifi.h          | 1 -
 5 files changed, 5 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
index a8871d6..5e628ab 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
@@ -477,7 +477,6 @@ bool rtl88ee_rx_query_desc(struct ieee80211_hw *hw,
 
 	/*rx_status->qual = status->signal; */
 	rx_status->signal = status->recvsignalpower + 10;
-	/*rx_status->noise = -status->noise; */
 	if (status->packet_report_type == TX_REPORT2) {
 		status->macid_valid_entry[0] =
 			 GET_RX_RPT2_DESC_MACID_VALID_1(pdesc);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
index 6ad23b4..52abf0a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -420,7 +420,6 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 
 	/*rx_status->qual = stats->signal; */
 	rx_status->signal = stats->recvsignalpower + 10;
-	/*rx_status->noise = -stats->noise; */
 
 	return true;
 }
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index c709511..222d2e7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -330,7 +330,6 @@ bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 
 	/*rx_status->qual = stats->signal; */
 	rx_status->signal = stats->rssi + 10;
-	/*rx_status->noise = -stats->noise; */
 
 	return true;
 }
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
index c72758d..e85ec21 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
@@ -359,7 +359,6 @@ bool rtl8723ae_rx_query_desc(struct ieee80211_hw *hw,
 
 	/*rx_status->qual = status->signal; */
 	rx_status->signal = status->recvsignalpower + 10;
-	/*rx_status->noise = -status->noise; */
 
 	return true;
 }
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index cc03e7c..284ee8d 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1535,7 +1535,6 @@ struct rtl_stats {
 	u32 mac_time[2];
 	s8 rssi;
 	u8 signal;
-	u8 noise;
 	u8 rate;		/* hw desc rate */
 	u8 received_channel;
 	u8 control;
-- 
1.8.1.4

