Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:9146 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934637AbeAKPJD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Jan 2018 10:09:03 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v3 3/6] staging: wilc1000: removed enums typedef for BEACON_IE & TX_RATE_T
Date: Thu, 11 Jan 2018 19:42:16 +0530
Message-ID: <1515679939-13202-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180111_160927_058475_3A25DF90)
In-Reply-To: <1515679939-13202-1-git-send-email-ajay.kathat@microchip.com>
References: <1515679939-13202-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removed the unnecessary enum typedef for BEACON_IE &
TX_RATE_T
It fix "WARNING: do not add new typedefs" reported by checkpatch.pl

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan_if.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 222bde2..db2dab4 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -75,7 +75,7 @@ typedef void (*wilc_tx_complete_func_t)(void *, int);
 #define MAX_SSID_LEN            33
 #define MAX_RATES_SUPPORTED     12
 
-typedef enum {
+enum {
 	SUPP_RATES_IE		= 1,
 	EXT_SUPP_RATES_IE	= 50,
 	HT_CAPABILITY_IE	= 45,
@@ -83,7 +83,7 @@ typedef enum {
 	WPA_IE			= 221,
 	WMM_IE			= 221,
 	P2P_IE			= 221,
-} BEACON_IE;
+};
 
 enum bss_types {
 	INFRASTRUCTURE		= 0,
@@ -91,7 +91,7 @@ enum bss_types {
 	AP,
 };
 
-typedef enum {
+enum {
 	RATE_AUTO		= 0,
 	RATE_1MB		= 1,
 	RATE_2MB		= 2,
@@ -105,7 +105,7 @@ typedef enum {
 	RATE_26MB		= 36,
 	RATE_48MB		= 48,
 	RATE_54MB		= 54
-} TX_RATE_T;
+};
 
 enum {
 	B_ONLY_MODE		= 0,    /* 1, 2 M, otherwise 5, 11 M */
-- 
2.7.4
