Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60861 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab1ISTeg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 15:34:36 -0400
Received: by mail-gy0-f174.google.com with SMTP id 10so4313865gyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 12:34:36 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] rtlwifi: Combine instances of RTL_HAL_IS_CCK_RATE macros.
Date: Mon, 19 Sep 2011 14:34:10 -0500
Message-Id: <1316460850-16443-5-git-send-email-Larry.Finger@lwfinger.net> (sfid-20110919_213445_420512_83C73861)
In-Reply-To: <1316460850-16443-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1316460850-16443-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Three drivers, rtl8192ce, rtl8192cu and rtl8192de, use the same macro
to check if a particular rate is in the CCK set. This common code is
relocated to a common header file. A distinct macro used by rtl8192se
with the same name is renamed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h |    6 ------
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.h |    6 ------
 drivers/net/wireless/rtlwifi/rtl8192de/trx.h |    6 ------
 drivers/net/wireless/rtlwifi/rtl8192se/def.h |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c |    2 +-
 drivers/net/wireless/rtlwifi/wifi.h          |    6 ++++++
 6 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
index 81ae642..c8977a5 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
@@ -537,12 +537,6 @@ do {							\
 		memset(__pdesc, 0, _size);	\
 } while (0);
 
-#define RX_HAL_IS_CCK_RATE(_pdesc)\
-	(_pdesc->rxmcs == DESC92_RATE1M ||		\
-	 _pdesc->rxmcs == DESC92_RATE2M ||		\
-	 _pdesc->rxmcs == DESC92_RATE5_5M ||		\
-	 _pdesc->rxmcs == DESC92_RATE11M)
-
 struct rx_fwinfo_92c {
 	u8 gain_trsw[4];
 	u8 pwdb_all;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
index 35529f7..626d88e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
@@ -87,12 +87,6 @@ void rtl92c_set_data_filter(struct ieee80211_hw *hw, u16 filter);
 
 u32 rtl92c_get_txdma_status(struct ieee80211_hw *hw);
 
-#define RX_HAL_IS_CCK_RATE(_pdesc)\
-	(GET_RX_DESC_RX_MCS(_pdesc) == DESC92_RATE1M ||\
-	 GET_RX_DESC_RX_MCS(_pdesc) == DESC92_RATE2M ||\
-	 GET_RX_DESC_RX_MCS(_pdesc) == DESC92_RATE5_5M ||\
-	 GET_RX_DESC_RX_MCS(_pdesc) == DESC92_RATE11M)
-
 struct rx_fwinfo_92c {
 	u8 gain_trsw[4];
 	u8 pwdb_all;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/trx.h b/drivers/net/wireless/rtlwifi/rtl8192de/trx.h
index 6c22368..4d55d0b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/trx.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/trx.h
@@ -537,12 +537,6 @@ do {							\
 		memset((void *)__pdesc, 0, _size);	\
 } while (0);
 
-#define RX_HAL_IS_CCK_RATE(_pdesc)\
-	(_pdesc->rxmcs == DESC92_RATE1M ||		\
-	 _pdesc->rxmcs == DESC92_RATE2M ||		\
-	 _pdesc->rxmcs == DESC92_RATE5_5M ||		\
-	 _pdesc->rxmcs == DESC92_RATE11M)
-
 /* For 92D early mode */
 #define SET_EARLYMODE_PKTNUM(__paddr, __value)		\
 	SET_BITS_OFFSET_LE(__paddr, 0, 3, __value)
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/def.h b/drivers/net/wireless/rtlwifi/rtl8192se/def.h
index 68204ea..c6c0448 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/def.h
@@ -459,7 +459,7 @@ do {								\
 #define SET_RX_STATUS__DESC_BUFF_ADDR(__pdesc, __val)	\
 	SET_BITS_OFFSET_LE(__pdesc + 24, 0, 32, __val)
 
-#define RX_HAL_IS_CCK_RATE(_pdesc)\
+#define SE_RX_HAL_IS_CCK_RATE(_pdesc)\
 	(GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC92_RATE1M ||	\
 	 GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC92_RATE2M ||	\
 	 GET_RX_STATUS_DESC_RX_MCS(_pdesc) == DESC92_RATE5_5M ||\
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index 044ee2a..18867fd 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -126,7 +126,7 @@ static void _rtl92se_query_rxphystatus(struct ieee80211_hw *hw,
 	bool in_powersavemode = false;
 	bool is_cck_rate;
 
-	is_cck_rate = RX_HAL_IS_CCK_RATE(pdesc);
+	is_cck_rate = SE_RX_HAL_IS_CCK_RATE(pdesc);
 	pstats->packet_matchbssid = packet_match_bssid;
 	pstats->packet_toself = packet_toself;
 	pstats->is_cck = is_cck_rate;
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 8a90919..615f6b4 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -165,6 +165,12 @@ enum hardware_type {
 #define IS_HARDWARE_TYPE_8723U(rtlhal)			\
 	(rtlhal->hw_type == HARDWARE_TYPE_RTL8723U)
 
+#define RX_HAL_IS_CCK_RATE(_pdesc)\
+	(_pdesc->rxmcs == DESC92_RATE1M ||		\
+	 _pdesc->rxmcs == DESC92_RATE2M ||		\
+	 _pdesc->rxmcs == DESC92_RATE5_5M ||		\
+	 _pdesc->rxmcs == DESC92_RATE11M)
+
 enum scan_operation_backup_opt {
 	SCAN_OPT_BACKUP = 0,
 	SCAN_OPT_RESTORE,
-- 
1.7.6.1

