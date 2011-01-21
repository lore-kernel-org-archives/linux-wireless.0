Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:22142 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478Ab1AUIdb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 03:33:31 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 00:33:13 -0800
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: clean up enums and unused macros
Date: Fri, 21 Jan 2011 14:03:24 +0530
Message-ID: <1295598804-2043-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Remove unused macros and cleanup buffer_type enumeration

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    7 +++----
 drivers/net/wireless/ath/ath9k/xmit.c  |    2 --
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 6e22135..818b085 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -95,9 +95,9 @@ struct ath_config {
  * @BUF_XRETRY: To denote excessive retries of the buffer
  */
 enum buffer_type {
-	BUF_AMPDU		= BIT(2),
-	BUF_AGGR		= BIT(3),
-	BUF_XRETRY		= BIT(5),
+	BUF_AMPDU		= BIT(0),
+	BUF_AGGR		= BIT(1),
+	BUF_XRETRY		= BIT(2),
 };
 
 #define bf_isampdu(bf)		(bf->bf_state.bf_type & BUF_AMPDU)
@@ -137,7 +137,6 @@ void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
 	 (((_tid) == 4) || ((_tid) == 5)) ? WME_AC_VI :	\
 	 WME_AC_VO)
 
-#define ADDBA_EXCHANGE_ATTEMPTS    10
 #define ATH_AGGR_DELIM_SZ          4
 #define ATH_AGGR_MINPLEN           256 /* in bytes, minimum packet length */
 /* number of delimiters for encryption padding */
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index ad569e1..59ccecf 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -19,7 +19,6 @@
 
 #define BITS_PER_BYTE           8
 #define OFDM_PLCP_BITS          22
-#define HT_RC_2_MCS(_rc)        ((_rc) & 0x1f)
 #define HT_RC_2_STREAMS(_rc)    ((((_rc) & 0x78) >> 3) + 1)
 #define L_STF                   8
 #define L_LTF                   8
@@ -32,7 +31,6 @@
 #define NUM_SYMBOLS_PER_USEC(_usec) (_usec >> 2)
 #define NUM_SYMBOLS_PER_USEC_HALFGI(_usec) (((_usec*5)-4)/18)
 
-#define OFDM_SIFS_TIME    	    16
 
 static u16 bits_per_symbol[][2] = {
 	/* 20MHz 40MHz */
-- 
1.7.0.4

