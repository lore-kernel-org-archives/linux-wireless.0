Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:33827 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752243AbeAIJZM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 04:25:12 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH] staging: wilc1000: removed unnecessary enum typedefs
Date: Tue, 9 Jan 2018 14:54:51 +0530
Message-ID: <1515489891-8512-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180109_102519_238964_DC4CC55A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes following G_PREAMBLE_T,SCANTYPE_T,
USER_PS_MODE_T,SECURITY_T,ACK_POLICY_T,RESET_REQ_T typedef enum.

Now, these enums are used as anonymous-enums for constants.

checkpatch.pl warning to avoid new typedef is fixes with this patch.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan_if.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 222bde2..598ba9e 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -114,28 +114,28 @@ enum {
 	G_MIXED_11B_2_MODE,		/* 1,2,5,11,6,12,24 otherwise all on */
 };
 
-typedef enum {
+enum {
 	G_SHORT_PREAMBLE	= 0,	/* Short Preamble */
 	G_LONG_PREAMBLE		= 1,	/* Long Preamble */
 	G_AUTO_PREAMBLE		= 2,	/* Auto Preamble Selection */
-} G_PREAMBLE_T;
+};
 
 #define MAC_CONNECTED		1
 #define MAC_DISCONNECTED	0
 
 #define SCAN_DONE		TRUE
-typedef enum {
+enum {
 	PASSIVE_SCAN		= 0,
 	ACTIVE_SCAN		= 1,
-} SCANTYPE_T;
+};
 
-typedef enum {
+enum {
 	NO_POWERSAVE		= 0,
 	MIN_FAST_PS		= 1,
 	MAX_FAST_PS		= 2,
 	MIN_PSPOLL_PS		= 3,
 	MAX_PSPOLL_PS		= 4
-} USER_PS_MODE_T;
+};
 
 typedef enum {
 	CHIP_WAKEDUP		= 0,
@@ -153,7 +153,7 @@ typedef enum {
 	RELEASE_ALLOW_SLEEP	= 1,
 } BUS_RELEASE_T;
 
-typedef enum {
+enum {
 	NO_SECURITY		= 0,
 	WEP_40			= 0x3,
 	WEP_104			= 0x7,
@@ -163,7 +163,7 @@ typedef enum {
 	WPA2_AES		= 0x31,
 	WPA2_TKIP		= 0x51,
 	WPA2_AES_TKIP		= 0x71,	/* Aes or Tkip */
-} SECURITY_T;
+};
 
 enum AUTHTYPE {
 	OPEN_SYSTEM		= 1,
@@ -178,16 +178,16 @@ enum SITESURVEY {
 	SITE_SURVEY_OFF		= 2
 };
 
-typedef enum {
+enum {
 	NORMAL_ACK		= 0,
 	NO_ACK,
-} ACK_POLICY_T;
+};
 
-typedef enum {
+enum {
 	DONT_RESET		= 0,
 	DO_RESET		= 1,
 	NO_REQUEST		= 2,
-} RESET_REQ_T;
+};
 
 typedef enum {
 	REKEY_DISABLE		= 1,
-- 
2.7.4
