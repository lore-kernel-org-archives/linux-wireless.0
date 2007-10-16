Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:32816 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966054AbXJPVnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 17:43:24 -0400
Received: by py-out-1112.google.com with SMTP id u77so3942702pyb
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2007 14:43:23 -0700 (PDT)
Message-ID: <40f31dec0710161443h433e09a4x2c0c1503e00f17bd@mail.gmail.com> (sfid-20071016_224332_628961_5360AB20)
Date: Wed, 17 Oct 2007 00:43:21 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Jiri Slaby" <jirislaby@gmail.com>
Subject: [PATCH 3/4] ath5k: Clean up unused definitions in base.h
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Get rid of some definitions that are not used anywhere...

Changes-licensed-under: 3-clause-BSD

Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
---
diff --git a/drivers/net/wireless/ath5k/base.c
b/drivers/net/wireless/ath5k/base.c
index 3a9652b..86606ce 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -96,7 +96,7 @@ enum {
        ATH_LED_RX,
 };

-static int ath_calinterval = ATH_SHORT_CALIB;
+static int ath_calinterval = 1; /* Calibrate PHY every 1 sec (TODO: Fixme) */

 #if AR_DEBUG
 static unsigned int ath_debug;
@@ -620,11 +620,12 @@ static int ath_beaconq_config(struct ath_softc *sc)
        if (sc->opmode == IEEE80211_IF_TYPE_AP ||
                        sc->opmode == IEEE80211_IF_TYPE_IBSS) {
                /*
-               * Always burst out beacon and CAB traffic.
-               */
-               qi.tqi_aifs = ATH_BEACON_AIFS_DEFAULT;
-               qi.tqi_cw_min = ATH_BEACON_CWMIN_DEFAULT;
-               qi.tqi_cw_max = ATH_BEACON_CWMAX_DEFAULT;
+                * Always burst out beacon and CAB traffic
+                * (aifs = cwmin = cwmax = 0)
+                */
+               qi.tqi_aifs = 0;
+               qi.tqi_cw_min = 0;
+               qi.tqi_cw_max = 0;
        }

        ret = ath5k_hw_setup_tx_queueprops(ah, sc->bhalq, &qi);
diff --git a/drivers/net/wireless/ath5k/base.h
b/drivers/net/wireless/ath5k/base.h
index 09e8dbe..ad22712 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -48,39 +48,9 @@

 #include "ath5k.h"

-#define        ATH_TIMEOUT             1000
-
-#define ATH_LONG_CALIB         30 /* seconds */
-#define ATH_SHORT_CALIB                1
-
-/*
- * Maximum acceptable MTU
- * MAXFRAMEBODY - WEP - QOS - RSN/WPA:
- * 2312 - 8 - 2 - 12 = 2290
- */
-#define ATH_MAX_MTU    2290
-#define ATH_MIN_MTU    32
-
 #define        ATH_RXBUF       40              /* number of RX buffers */
 #define        ATH_TXBUF       200             /* number of TX buffers */
 #define ATH_BCBUF      1               /* number of beacon buffers */
-#define        ATH_TXMAXTRY    11              /* max number of
transmit attempts */
-#define        ATH_TXINTR_PERIOD 5             /* max number of
batched tx descriptors */
-
-#define ATH_BEACON_AIFS_DEFAULT  0     /* default aifs for ap beacon q */
-#define ATH_BEACON_CWMIN_DEFAULT 0     /* default cwmin for ap beacon q */
-#define ATH_BEACON_CWMIN_DEFAULT 0     /* default cwmin for ap beacon q */
-#define ATH_BEACON_CWMAX_DEFAULT 0     /* default cwmax for ap beacon q */
-
-#define ATH_RSSI_LPF_LEN       10
-#define ATH_RSSI_DUMMY_MARKER  0x127
-#define ATH_EP_MUL(x, mul)     ((x) * (mul))
-#define ATH_RSSI_IN(x)         (ATH_EP_MUL((x), AR5K_RSSI_EP_MULTIPLIER))
-#define ATH_LPF_RSSI(x, y, len) \
-    ((x != ATH_RSSI_DUMMY_MARKER) ? (((x) * ((len) - 1) + (y)) / (len)) : (y))
-#define ATH_RSSI_LPF(x, y) do {
         \
-       if ((y) >= -20)                                                 \
-               x = ATH_LPF_RSSI((x), ATH_RSSI_IN((y)), ATH_RSSI_LPF_LEN); \
-} while (0)

 struct ath_buf {
        struct list_head        list;


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
