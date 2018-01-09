Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:21050 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751521AbeAIJcd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 04:32:33 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH] staging: wilc1000: removed few unnecessary enums typedef
Date: Tue, 9 Jan 2018 15:02:09 +0530
Message-ID: <1515490329-8688-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180109_103237_507302_7F03824D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes following N_OPERATING_MODE_T,N_OBSS_DETECTION_T,
N_PROTECTION_TYPE_T,N_SMPS_MODE_T,TX_ABORT_OPTION_T, typedef enum.
Now, these enums are used as anonymous-enums for constants.

checkpatch.pl warning to not add new typedef is fixes with this patch.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan_if.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index eec8760..cf4a44d 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -226,40 +226,40 @@ enum {
 	G_RTS_CTS_PROT,
 };
 
-typedef enum {
+enum {
 	HT_MIXED_MODE		= 1,
 	HT_ONLY_20MHZ_MODE,
 	HT_ONLY_20_40MHZ_MODE,
-} N_OPERATING_MODE_T;
+};
 
-typedef enum {
+enum {
 	NO_DETECT		= 0,
 	DETECT_ONLY		= 1,
 	DETECT_PROTECT		= 2,
 	DETECT_PROTECT_REPORT	= 3,
-} N_OBSS_DETECTION_T;
+};
 
-typedef enum {
+enum {
 	RTS_CTS_NONHT_PROT	= 0,	/* RTS-CTS at non-HT rate */
 	FIRST_FRAME_NONHT_PROT,		/* First frame at non-HT rate */
 	LSIG_TXOP_PROT,                 /* LSIG TXOP Protection */
 	FIRST_FRAME_MIXED_PROT,		/* First frame at Mixed format */
-} N_PROTECTION_TYPE_T;
+};
 
-typedef enum {
+enum {
 	STATIC_MODE		= 1,
 	DYNAMIC_MODE		= 2,
 	MIMO_MODE		= 3,	/* power save disable */
-} N_SMPS_MODE_T;
+};
 
-typedef enum {
+enum {
 	DISABLE_SELF_CTS,
 	ENABLE_SELF_CTS,
 	DISABLE_TX_ABORT,
 	ENABLE_TX_ABORT,
 	HW_TRIGGER_ABORT,
 	SW_TRIGGER_ABORT,
-} TX_ABORT_OPTION_T;
+};
 
 enum wid_type {
 	WID_CHAR		= 0,
-- 
2.7.4
