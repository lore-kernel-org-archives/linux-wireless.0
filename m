Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:33549 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751287AbdBAVJ0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Feb 2017 16:09:26 -0500
Received: by mail-ot0-f195.google.com with SMTP id f9so46849539otd.0
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2017 13:09:25 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 7/7] rtlwifi: btcoexist: Convert halbtcoutsrc.c to use standard debugging
Date: Wed,  1 Feb 2017 15:08:57 -0600
Message-Id: <20170201210857.26516-8-Larry.Finger@lwfinger.net> (sfid-20170201_220934_881825_2A94D14C)
In-Reply-To: <20170201210857.26516-1-Larry.Finger@lwfinger.net>
References: <20170201210857.26516-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The routines in btcoexist use different debugging routines than are used
in the other drivers. This patch converts halbtcoutsrc.c to use the
standard routines. It also deletes the definitions of the now-unused
debugging macros, and turns on compilation of all the routines in
btcoexist.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile      |  7 +++++--
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c    |  4 ++--
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h    | 12 ------------
 3 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile b/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
index 0ef0d31..20582df 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
@@ -1,5 +1,8 @@
-btcoexist-objs :=	halbtc8723b2ant.o	\
-			halbtc8192e2ant.o	\
+btcoexist-objs :=	halbtc8192e2ant.o	\
+			halbtc8723b1ant.o	\
+			halbtc8723b2ant.o	\
+			halbtc8821a1ant.o	\
+			halbtc8821a2ant.o	\
 			halbtcoutsrc.o		\
 			rtl_btc.o
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 9a89ae0..150aeb8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -141,8 +141,8 @@ static u8 halbtc_get_wifi_central_chnl(struct btc_coexist *btcoexist)
 
 	if (rtlphy->current_channel != 0)
 		chnl = rtlphy->current_channel;
-	btc_alg_dbg(ALGO_TRACE,
-		    "static halbtc_get_wifi_central_chnl:%d\n", chnl);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "static halbtc_get_wifi_central_chnl:%d\n", chnl);
 	return chnl;
 }
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index f9e7c5e..601bbe1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -116,18 +116,6 @@ extern u32 btc_dbg_type[];
 #define		WIFI_P2P_GO_CONNECTED			BIT3
 #define		WIFI_P2P_GC_CONNECTED			BIT4
 
-#define	btc_alg_dbg(dbgflag, fmt, ...)					\
-do {									\
-	if (unlikely(btc_dbg_type[BTC_MSG_ALGORITHM] & dbgflag))	\
-		printk(KERN_DEBUG fmt, ##__VA_ARGS__);			\
-} while (0)
-#define	btc_iface_dbg(dbgflag, fmt, ...)				\
-do {									\
-	if (unlikely(btc_dbg_type[BTC_MSG_INTERFACE] & dbgflag))	\
-		printk(KERN_DEBUG fmt, ##__VA_ARGS__);			\
-} while (0)
-
-
 #define	BTC_RSSI_HIGH(_rssi_)	\
 	((_rssi_ == BTC_RSSI_STATE_HIGH ||	\
 	  _rssi_ == BTC_RSSI_STATE_STAY_HIGH) ? true : false)
-- 
2.10.2
