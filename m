Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49789 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab2DGIku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Apr 2012 04:40:50 -0400
Received: by obbtb18 with SMTP id tb18so3974137obb.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 Apr 2012 01:40:49 -0700 (PDT)
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>
Subject: [PATCH] net/wireless: ipw2x00: remove unused libipw_measurement_report struct
Date: Sat,  7 Apr 2012 04:44:40 -0400
Message-Id: <1333788280-5091-1-git-send-email-stas.yakovlev@gmail.com> (sfid-20120407_104112_655500_CC645C63)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

and all referenced structs and corresponding enums because the driver
does not use it.

Note: keep libipw_info_element struct since it is still in use.

Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
---
 drivers/net/wireless/ipw2x00/libipw.h |   55 ---------------------------------
 1 files changed, 0 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/libipw.h b/drivers/net/wireless/ipw2x00/libipw.h
index 8874588..0b22fb4 100644
--- a/drivers/net/wireless/ipw2x00/libipw.h
+++ b/drivers/net/wireless/ipw2x00/libipw.h
@@ -584,61 +584,6 @@ struct libipw_tim_parameters {
 
 /*******************************************************/
 
-enum {				/* libipw_basic_report.map */
-	LIBIPW_BASIC_MAP_BSS = (1 << 0),
-	LIBIPW_BASIC_MAP_OFDM = (1 << 1),
-	LIBIPW_BASIC_MAP_UNIDENTIFIED = (1 << 2),
-	LIBIPW_BASIC_MAP_RADAR = (1 << 3),
-	LIBIPW_BASIC_MAP_UNMEASURED = (1 << 4),
-	/* Bits 5-7 are reserved */
-
-};
-struct libipw_basic_report {
-	u8 channel;
-	__le64 start_time;
-	__le16 duration;
-	u8 map;
-} __packed;
-
-enum {				/* libipw_measurement_request.mode */
-	/* Bit 0 is reserved */
-	LIBIPW_MEASUREMENT_ENABLE = (1 << 1),
-	LIBIPW_MEASUREMENT_REQUEST = (1 << 2),
-	LIBIPW_MEASUREMENT_REPORT = (1 << 3),
-	/* Bits 4-7 are reserved */
-};
-
-enum {
-	LIBIPW_REPORT_BASIC = 0,	/* required */
-	LIBIPW_REPORT_CCA = 1,	/* optional */
-	LIBIPW_REPORT_RPI = 2,	/* optional */
-	/* 3-255 reserved */
-};
-
-struct libipw_measurement_params {
-	u8 channel;
-	__le64 start_time;
-	__le16 duration;
-} __packed;
-
-struct libipw_measurement_request {
-	struct libipw_info_element ie;
-	u8 token;
-	u8 mode;
-	u8 type;
-	struct libipw_measurement_params params[0];
-} __packed;
-
-struct libipw_measurement_report {
-	struct libipw_info_element ie;
-	u8 token;
-	u8 mode;
-	u8 type;
-	union {
-		struct libipw_basic_report basic[0];
-	} u;
-} __packed;
-
 struct libipw_tpc_report {
 	u8 transmit_power;
 	u8 link_margin;
-- 
1.7.2.5

