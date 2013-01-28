Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41673 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3A1Jh2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 04:37:28 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 07/37] iwlwifi: add the MVM driver (fw-api-power)
Date: Mon, 28 Jan 2013 10:37:14 +0100
Message-Id: <1359365864-4259-8-git-send-email-johannes@sipsolutions.net> (sfid-20130128_103735_723244_A82B1452)
In-Reply-To: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
References: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Newer firmware revisions have a completely new
firmware API. This is the new driver for this
new API.

I've listed the people who directly contributed
code, but many others from various teams have
contributed in other ways.

Change-Id: Id62a7ce1b80ec762c9a902b93188d3502837b77b
Cc: Alexander Bondar <alexander.bondar@intel.com>
Cc: Amit Beka <amit.beka@intel.com>
Cc: Amnon Paz <amnonx.paz@intel.com>
Cc: Assaf Krauss <assaf.krauss@intel.com>
Cc: David Spinadel <david.spinadel@intel.com>
Cc: Dor Shaish <dor.shaish@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Eytan Lifshitz <eytan.lifshitz@intel.com>
Cc: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h | 140 ++++++++++++++++++++++++
 1 file changed, 140 insertions(+)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
new file mode 100644
index 0000000..be36b76
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
@@ -0,0 +1,140 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+
+#ifndef __fw_api_power_h__
+#define __fw_api_power_h__
+
+/* Power Management Commands, Responses, Notifications */
+
+/**
+ * enum iwl_scan_flags - masks for power table command flags
+ * @POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK: '0' Driver disables power management,
+ *		'1' Driver enables PM (use rest of parameters)
+ * @POWER_FLAGS_SLEEP_OVER_DTIM_MSK: '0' PM have to walk up every DTIM,
+ *		'1' PM could sleep over DTIM till listen Interval.
+ * @POWER_FLAGS_LPRX_ENA_MSK: Low Power RX enable.
+ * @POWER_FLAGS_SNOOZE_ENA_MSK: Enable snoozing only if uAPSD is enabled and all
+ *		access categories are both delivery and trigger enabled.
+ * @POWER_FLAGS_BT_SCO_ENA: Enable BT SCO coex only if uAPSD and
+ *		PBW Snoozing enabled
+ * @POWER_FLAGS_ADVANCE_PM_ENA_MSK: Advanced PM (uAPSD) enable mask
+*/
+enum iwl_power_flags {
+	POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK	= BIT(0),
+	POWER_FLAGS_SLEEP_OVER_DTIM_MSK		= BIT(1),
+	POWER_FLAGS_LPRX_ENA_MSK		= BIT(2),
+	POWER_FLAGS_SNOOZE_ENA_MSK		= BIT(3),
+	POWER_FLAGS_BT_SCO_ENA			= BIT(4),
+	POWER_FLAGS_ADVANCE_PM_ENA_MSK		= BIT(5)
+};
+
+/**
+ * struct iwl_powertable_cmd - Power Table Command
+ * POWER_TABLE_CMD = 0x77 (command, has simple generic response)
+ *
+ * @id_and_color:	MAC contex identifier
+ * @action:		Action on context - no action, add new,
+ *			modify existent, remove
+ * @flags:		Power table command flags from POWER_FLAGS_*
+ * @keep_alive_seconds: Keep alive period in seconds. Default - 25 sec.
+ *			Minimum allowed:- 3 * DTIM
+ * @rx_data_timeout:    Minimum time (usec) from last Rx packet for AM to
+ *			PSM transition - legacy PM
+ * @tx_data_timeout:    Minimum time (usec) from last Tx packet for AM to
+ *			PSM transition - legacy PM
+ * @rx_data_timeout_uapsd: Minimum time (usec) from last Rx packet for AM to
+ *			PSM transition - uAPSD
+ * @tx_data_timeout_uapsd: Minimum time (usec) from last Tx packet for AM to
+ *			PSM transition - uAPSD
+ * @lprx_rssi_threshold: Signal strength up to which LP RX can be enabled.
+ *			Default: 80dbm
+ * @num_skip_dtim:      Number of DTIMs to skip if Skip over DTIM flag is set
+ * @snooze_interval:    TBD
+ * @snooze_window:      TBD
+ * @snooze_step:        TBD
+ * @qndp_tid:           TBD
+ * @uapsd_ac_flags:     TBD
+ * @uapsd_max_sp:       TBD
+ */
+struct iwl_powertable_cmd {
+	/* COMMON_INDEX_HDR_API_S_VER_1 */
+	__le32 id_and_color;
+	__le32 action;
+	__le16 flags;
+	u8 reserved;
+	__le16 keep_alive_seconds;
+	__le32 rx_data_timeout;
+	__le32 tx_data_timeout;
+	__le32 rx_data_timeout_uapsd;
+	__le32 tx_data_timeout_uapsd;
+	u8 lprx_rssi_threshold;
+	u8 num_skip_dtim;
+	__le16 snooze_interval;
+	__le16 snooze_window;
+	u8 snooze_step;
+	u8 qndp_tid;
+	u8 uapsd_ac_flags;
+	u8 uapsd_max_sp;
+} __packed;
+
+#endif
-- 
1.8.0

