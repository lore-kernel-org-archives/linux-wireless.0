Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9688 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbbJBFWd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 01:22:33 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/10] staging: wilc1000: remove typedef from enum
Date: Fri, 2 Oct 2015 14:22:03 +0900
Message-ID: <1443763332-7330-1-git-send-email-tony.cho@atmel.com> (sfid-20151002_072245_540154_A7125630)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from enumerated types defined in
coreconfigurator.c file and also changes their names to avoid CamelCase
naming convention as shown:

- tenuBasicFrmType to basic_frame_type
- tenuFrmSubtype to sub_frame_type
- tenuInfoElemID to info_element_id

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 136d207..63fde5b 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -18,16 +18,16 @@
 							BEACON_INTERVAL_LEN + CAP_INFO_LEN)
 
 /* Basic Frame Type Codes (2-bit) */
-typedef enum {
+enum basic_frame_type {
 	FRAME_TYPE_CONTROL     = 0x04,
 	FRAME_TYPE_DATA        = 0x08,
 	FRAME_TYPE_MANAGEMENT  = 0x00,
 	FRAME_TYPE_RESERVED    = 0x0C,
 	FRAME_TYPE_FORCE_32BIT = 0xFFFFFFFF
-} tenuBasicFrmType;
+};
 
 /* Frame Type and Subtype Codes (6-bit) */
-typedef enum {
+enum sub_frame_type {
 	ASSOC_REQ             = 0x00,
 	ASSOC_RSP             = 0x10,
 	REASSOC_REQ           = 0x20,
@@ -64,10 +64,10 @@ typedef enum {
 	BLOCKACK_REQ          = 0x84,
 	BLOCKACK              = 0x94,
 	FRAME_SUBTYPE_FORCE_32BIT  = 0xFFFFFFFF
-} tenuFrmSubtype;
+};
 
 /* Element ID  of various Information Elements */
-typedef enum {
+enum info_element_id {
 	ISSID               = 0,   /* Service Set Identifier         */
 	ISUPRATES           = 1,   /* Supported Rates                */
 	IFHPARMS            = 2,   /* FH parameter set               */
@@ -108,7 +108,7 @@ typedef enum {
 	IWMM                = 221, /* WMM parameters                 */
 	IWPAELEMENT         = 221, /* WPA Information Element        */
 	INFOELEM_ID_FORCE_32BIT  = 0xFFFFFFFF
-} tenuInfoElemID;
+};
 
 
 typedef struct {
@@ -159,9 +159,9 @@ static inline u32 get_beacon_timestamp_hi(u8 *data)
 /* This function extracts the 'frame type and sub type' bits from the MAC    */
 /* header of the input frame.                                                */
 /* Returns the value in the LSB of the returned value.                       */
-static inline tenuFrmSubtype get_sub_type(u8 *header)
+static inline enum sub_frame_type get_sub_type(u8 *header)
 {
-	return ((tenuFrmSubtype)(header[0] & 0xFC));
+	return ((enum sub_frame_type)(header[0] & 0xFC));
 }
 
 /* This function extracts the 'to ds' bit from the MAC header of the input   */
@@ -245,7 +245,7 @@ static inline u16 get_cap_info(u8 *data)
 {
 	u16 cap_info = 0;
 	u16 index    = MAC_HDR_LEN;
-	tenuFrmSubtype st;
+	enum sub_frame_type st;
 
 	st = get_sub_type(data);
 
-- 
1.9.1

