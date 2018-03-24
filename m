Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.196]:55579 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750743AbeCXEQs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Mar 2018 00:16:48 -0400
From: Quytelda Kahja <quytelda@tamalin.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Quytelda Kahja <quytelda@tamalin.org>
Subject: [PATCH 1/3] ieee80211: Replace bit shifts with the BIT() macro for WLAN_CAPABILITY_*.
Date: Fri, 23 Mar 2018 21:10:25 -0700
Message-Id: <20180324041027.6498-1-quytelda@tamalin.org> (sfid-20180324_051657_885230_EC90B6E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is neater and more consistent with the rest of the document to use the
BIT() macro from 'linux/bitops.h' to define the WLAN_CAPABILITY_*
bitmasks.  In the case of WLAN_CAPABILITY_DMG_TYPE_{IBSS, PBSS, AP},
bitshifting integers by 0 does nothing, so there is no reason to do it in
the code; replace these values with plain integers.

Signed-off-by: Quytelda Kahja <quytelda@tamalin.org>
---
 include/linux/ieee80211.h | 56 +++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ee6657a0ed69..58069176b432 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1588,8 +1588,8 @@ struct ieee80211_vht_operation {
 
 #define WLAN_AUTH_CHALLENGE_LEN 128
 
-#define WLAN_CAPABILITY_ESS		(1<<0)
-#define WLAN_CAPABILITY_IBSS		(1<<1)
+#define WLAN_CAPABILITY_ESS		BIT(0)
+#define WLAN_CAPABILITY_IBSS		BIT(1)
 
 /*
  * A mesh STA sets the ESS and IBSS capability bits to zero.
@@ -1599,37 +1599,37 @@ struct ieee80211_vht_operation {
 #define WLAN_CAPABILITY_IS_STA_BSS(cap)	\
 	(!((cap) & (WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_IBSS)))
 
-#define WLAN_CAPABILITY_CF_POLLABLE	(1<<2)
-#define WLAN_CAPABILITY_CF_POLL_REQUEST	(1<<3)
-#define WLAN_CAPABILITY_PRIVACY		(1<<4)
-#define WLAN_CAPABILITY_SHORT_PREAMBLE	(1<<5)
-#define WLAN_CAPABILITY_PBCC		(1<<6)
-#define WLAN_CAPABILITY_CHANNEL_AGILITY	(1<<7)
+#define WLAN_CAPABILITY_CF_POLLABLE	BIT(2)
+#define WLAN_CAPABILITY_CF_POLL_REQUEST	BIT(3)
+#define WLAN_CAPABILITY_PRIVACY		BIT(4)
+#define WLAN_CAPABILITY_SHORT_PREAMBLE	BIT(5)
+#define WLAN_CAPABILITY_PBCC		BIT(6)
+#define WLAN_CAPABILITY_CHANNEL_AGILITY	BIT(7)
 
 /* 802.11h */
-#define WLAN_CAPABILITY_SPECTRUM_MGMT	(1<<8)
-#define WLAN_CAPABILITY_QOS		(1<<9)
-#define WLAN_CAPABILITY_SHORT_SLOT_TIME	(1<<10)
-#define WLAN_CAPABILITY_APSD		(1<<11)
-#define WLAN_CAPABILITY_RADIO_MEASURE	(1<<12)
-#define WLAN_CAPABILITY_DSSS_OFDM	(1<<13)
-#define WLAN_CAPABILITY_DEL_BACK	(1<<14)
-#define WLAN_CAPABILITY_IMM_BACK	(1<<15)
+#define WLAN_CAPABILITY_SPECTRUM_MGMT	BIT(8)
+#define WLAN_CAPABILITY_QOS		BIT(9)
+#define WLAN_CAPABILITY_SHORT_SLOT_TIME	BIT(10)
+#define WLAN_CAPABILITY_APSD		BIT(11)
+#define WLAN_CAPABILITY_RADIO_MEASURE	BIT(12)
+#define WLAN_CAPABILITY_DSSS_OFDM	BIT(13)
+#define WLAN_CAPABILITY_DEL_BACK	BIT(14)
+#define WLAN_CAPABILITY_IMM_BACK	BIT(15)
 
 /* DMG (60gHz) 802.11ad */
 /* type - bits 0..1 */
-#define WLAN_CAPABILITY_DMG_TYPE_MASK		(3<<0)
-#define WLAN_CAPABILITY_DMG_TYPE_IBSS		(1<<0) /* Tx by: STA */
-#define WLAN_CAPABILITY_DMG_TYPE_PBSS		(2<<0) /* Tx by: PCP */
-#define WLAN_CAPABILITY_DMG_TYPE_AP		(3<<0) /* Tx by: AP */
-
-#define WLAN_CAPABILITY_DMG_CBAP_ONLY		(1<<2)
-#define WLAN_CAPABILITY_DMG_CBAP_SOURCE		(1<<3)
-#define WLAN_CAPABILITY_DMG_PRIVACY		(1<<4)
-#define WLAN_CAPABILITY_DMG_ECPAC		(1<<5)
-
-#define WLAN_CAPABILITY_DMG_SPECTRUM_MGMT	(1<<8)
-#define WLAN_CAPABILITY_DMG_RADIO_MEASURE	(1<<12)
+#define WLAN_CAPABILITY_DMG_TYPE_MASK   (BIT(0) | BIT(1))
+#define WLAN_CAPABILITY_DMG_TYPE_IBSS   1 /* Tx by: STA */
+#define WLAN_CAPABILITY_DMG_TYPE_PBSS   2 /* Tx by: PCP */
+#define WLAN_CAPABILITY_DMG_TYPE_AP     3 /* Tx by: AP */
+
+#define WLAN_CAPABILITY_DMG_CBAP_ONLY		BIT(2)
+#define WLAN_CAPABILITY_DMG_CBAP_SOURCE		BIT(3)
+#define WLAN_CAPABILITY_DMG_PRIVACY		BIT(4)
+#define WLAN_CAPABILITY_DMG_ECPAC		BIT(5)
+
+#define WLAN_CAPABILITY_DMG_SPECTRUM_MGMT	BIT(8)
+#define WLAN_CAPABILITY_DMG_RADIO_MEASURE	BIT(12)
 
 /* measurement */
 #define IEEE80211_SPCT_MSR_RPRT_MODE_LATE	(1<<0)
-- 
2.16.2
