Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11717 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757806Ab1D3Qku (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 12:40:50 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/14] iwlagn: remove spectrum measurement header
Date: Sat, 30 Apr 2011 09:17:37 -0700
Message-Id: <1304180260-13875-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110430_184102_649836_88ED216F)
In-Reply-To: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1304180260-13875-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This header file isn't used, and if we ever need
these definitions they shouldn't be added to a
driver but rather to the common 802.11 include
file that has all frame definitions. Thus, just
remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-spectrum.h |   92 ---------------------------
 1 files changed, 0 insertions(+), 92 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-spectrum.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-spectrum.h b/drivers/net/wireless/iwlwifi/iwl-spectrum.h
deleted file mode 100644
index cb80bb4..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-spectrum.h
+++ /dev/null
@@ -1,92 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
- *
- * Portions of this file are derived from the ieee80211 subsystem header files.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- *****************************************************************************/
-
-#ifndef __iwl_spectrum_h__
-#define __iwl_spectrum_h__
-enum {				/* ieee80211_basic_report.map */
-	IEEE80211_BASIC_MAP_BSS = (1 << 0),
-	IEEE80211_BASIC_MAP_OFDM = (1 << 1),
-	IEEE80211_BASIC_MAP_UNIDENTIFIED = (1 << 2),
-	IEEE80211_BASIC_MAP_RADAR = (1 << 3),
-	IEEE80211_BASIC_MAP_UNMEASURED = (1 << 4),
-	/* Bits 5-7 are reserved */
-
-};
-struct ieee80211_basic_report {
-	u8 channel;
-	__le64 start_time;
-	__le16 duration;
-	u8 map;
-} __packed;
-
-enum {				/* ieee80211_measurement_request.mode */
-	/* Bit 0 is reserved */
-	IEEE80211_MEASUREMENT_ENABLE = (1 << 1),
-	IEEE80211_MEASUREMENT_REQUEST = (1 << 2),
-	IEEE80211_MEASUREMENT_REPORT = (1 << 3),
-	/* Bits 4-7 are reserved */
-};
-
-enum {
-	IEEE80211_REPORT_BASIC = 0,	/* required */
-	IEEE80211_REPORT_CCA = 1,	/* optional */
-	IEEE80211_REPORT_RPI = 2,	/* optional */
-	/* 3-255 reserved */
-};
-
-struct ieee80211_measurement_params {
-	u8 channel;
-	__le64 start_time;
-	__le16 duration;
-} __packed;
-
-struct ieee80211_info_element {
-	u8 id;
-	u8 len;
-	u8 data[0];
-} __packed;
-
-struct ieee80211_measurement_request {
-	struct ieee80211_info_element ie;
-	u8 token;
-	u8 mode;
-	u8 type;
-	struct ieee80211_measurement_params params[0];
-} __packed;
-
-struct ieee80211_measurement_report {
-	struct ieee80211_info_element ie;
-	u8 token;
-	u8 mode;
-	u8 type;
-	union {
-		struct ieee80211_basic_report basic[0];
-	} u;
-} __packed;
-
-#endif
-- 
1.7.0.4

