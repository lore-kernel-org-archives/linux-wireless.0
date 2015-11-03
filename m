Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26418 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbbKCKCI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 05:02:08 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH] Revert "Staging: wilc1000: coreconfigurator: Drop unneeded wrapper functions"
Date: Tue, 3 Nov 2015 19:05:11 +0900
Message-ID: <1446545111-23325-1-git-send-email-glen.lee@atmel.com> (sfid-20151103_110544_122666_6AD639EF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The addresses are not properly aglined for using ether_addr_copy function.
I revert this as author agree to drop this patch.

This reverts commit d4622f68db8095dd54179e3134e97812727f6b89.
---
 drivers/staging/wilc1000/coreconfigurator.c | 48 +++++++++++++++--------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 1caa66e..954b5eb 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -13,12 +13,8 @@
 #include "wilc_wlan.h"
 #include <linux/errno.h>
 #include <linux/slab.h>
-#include <linux/etherdevice.h>
 #define TAG_PARAM_OFFSET	(MAC_HDR_LEN + TIME_STAMP_LEN + \
 							BEACON_INTERVAL_LEN + CAP_INFO_LEN)
-#define ADDR1 4
-#define ADDR2 10
-#define ADDR3 16
 
 /* Basic Frame Type Codes (2-bit) */
 enum basic_frame_type {
@@ -175,32 +171,38 @@ static inline u8 get_from_ds(u8 *header)
 	return ((header[1] & 0x02) >> 1);
 }
 
+/* This function extracts the MAC Address in 'address1' field of the MAC     */
+/* header and updates the MAC Address in the allocated 'addr' variable.      */
+static inline void get_address1(u8 *pu8msa, u8 *addr)
+{
+	memcpy(addr, pu8msa + 4, 6);
+}
+
+/* This function extracts the MAC Address in 'address2' field of the MAC     */
+/* header and updates the MAC Address in the allocated 'addr' variable.      */
+static inline void get_address2(u8 *pu8msa, u8 *addr)
+{
+	memcpy(addr, pu8msa + 10, 6);
+}
+
+/* This function extracts the MAC Address in 'address3' field of the MAC     */
+/* header and updates the MAC Address in the allocated 'addr' variable.      */
+static inline void get_address3(u8 *pu8msa, u8 *addr)
+{
+	memcpy(addr, pu8msa + 16, 6);
+}
+
 /* This function extracts the BSSID from the incoming WLAN packet based on   */
-/* the 'from ds' bit, and updates the MAC Address in the allocated 'data'    */
+/* the 'from ds' bit, and updates the MAC Address in the allocated 'addr'    */
 /* variable.                                                                 */
 static inline void get_BSSID(u8 *data, u8 *bssid)
 {
 	if (get_from_ds(data) == 1)
-		/*
-		 * Extract the MAC Address in 'address2' field of the MAC
-		 * header and update the MAC Address in the allocated 'data'
-		 *  variable.
-		 */
-		ether_addr_copy(data, bssid + ADDR2);
+		get_address2(data, bssid);
 	else if (get_to_ds(data) == 1)
-		/*
-		 * Extract the MAC Address in 'address1' field of the MAC
-		 * header and update the MAC Address in the allocated 'data'
-		 * variable.
-		 */
-		ether_addr_copy(data, bssid + ADDR1);
+		get_address1(data, bssid);
 	else
-		/*
-		 * Extract the MAC Address in 'address3' field of the MAC
-		 * header and update the MAC Address in the allocated 'data'
-		 * variable.
-		 */
-		ether_addr_copy(data, bssid + ADDR3);
+		get_address3(data, bssid);
 }
 
 /* This function extracts the SSID from a beacon/probe response frame        */
-- 
1.9.1

