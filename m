Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:60903 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965080AbeAJLOH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 06:14:07 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 4/9] staging: wilc1000: removed few unnecessary enums typedef
Date: Wed, 10 Jan 2018 16:42:46 +0530
Message-ID: <1515582771-28408-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180110_121413_803095_3474B44A)
In-Reply-To: <1515582771-28408-1-git-send-email-ajay.kathat@microchip.com>
References: <1515582771-28408-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes following RSNA_REKEY_POLICY_T,SCAN_CLASS_FITLER_T,
SCAN_PRI_T,CH_FILTER_T,N_PROTECTION_MODE_T,G_PROTECTION_MODE_T typedef
enum.
Now, these enums are used as anonymous-enums for constants.

checkpatch.pl warning to avoid new typedef is fixes with this patch.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan_if.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 598ba9e..eec8760 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -189,42 +189,42 @@ enum {
 	NO_REQUEST		= 2,
 };
 
-typedef enum {
+enum {
 	REKEY_DISABLE		= 1,
 	REKEY_TIME_BASE,
 	REKEY_PKT_BASE,
 	REKEY_TIME_PKT_BASE
-} RSNA_REKEY_POLICY_T;
+};
 
-typedef enum {
+enum {
 	FILTER_NO		= 0x00,
 	FILTER_AP_ONLY		= 0x01,
 	FILTER_STA_ONLY		= 0x02
-} SCAN_CLASS_FITLER_T;
+};
 
-typedef enum {
+enum {
 	PRI_HIGH_RSSI		= 0x00,
 	PRI_LOW_RSSI		= 0x04,
 	PRI_DETECT		= 0x08
-} SCAN_PRI_T;
+};
 
-typedef enum {
+enum {
 	CH_FILTER_OFF		= 0x00,
 	CH_FILTER_ON		= 0x10
-} CH_FILTER_T;
+};
 
-typedef enum {
+enum {
 	AUTO_PROT		= 0,	/* Auto */
 	NO_PROT,			/* Do not use any protection */
 	ERP_PROT,			/* Protect all ERP frame exchanges */
 	HT_PROT,			/* Protect all HT frame exchanges  */
 	GF_PROT,			/* Protect all GF frame exchanges  */
-} N_PROTECTION_MODE_T;
+};
 
-typedef enum {
+enum {
 	G_SELF_CTS_PROT,
 	G_RTS_CTS_PROT,
-} G_PROTECTION_MODE_T;
+};
 
 typedef enum {
 	HT_MIXED_MODE		= 1,
-- 
2.7.4
