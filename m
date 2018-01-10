Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:48248 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965080AbeAJLOB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 06:14:01 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 2/9] staging: wilc1000: remove unnecessary typedef enum G_OPERATING_MODE_T
Date: Wed, 10 Jan 2018 16:42:44 +0530
Message-ID: <1515582771-28408-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180110_121404_447730_A7B69BEF)
In-Reply-To: <1515582771-28408-1-git-send-email-ajay.kathat@microchip.com>
References: <1515582771-28408-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch has removed G_OPERATING_MODE_T typedef enum.
Now, its used as anonymous-enums for constants.
checkpatch.pl warning to avoid new typedef is fixes with this patch.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan_if.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 2baf6c4..222bde2 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -107,12 +107,12 @@ typedef enum {
 	RATE_54MB		= 54
 } TX_RATE_T;
 
-typedef enum {
+enum {
 	B_ONLY_MODE		= 0,    /* 1, 2 M, otherwise 5, 11 M */
 	G_ONLY_MODE,			/* 6,12,24 otherwise 9,18,36,48,54 */
 	G_MIXED_11B_1_MODE,		/* 1,2,5.5,11 otherwise all on */
 	G_MIXED_11B_2_MODE,		/* 1,2,5,11,6,12,24 otherwise all on */
-} G_OPERATING_MODE_T;
+};
 
 typedef enum {
 	G_SHORT_PREAMBLE	= 0,	/* Short Preamble */
-- 
2.7.4
