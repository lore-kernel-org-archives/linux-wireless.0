Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60908 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751138AbdFBL2B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 07:28:01 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 14:25:38 +0300
Message-Id: <20170602112553.2466-11-luca@coelho.fi> (sfid-20170602_132805_343488_E5E9F14D)
In-Reply-To: <20170602112553.2466-1-luca@coelho.fi>
References: <20170602112553.2466-1-luca@coelho.fi>
Subject: [PATCH 10/25] iwlwifi: mvm: add documentation to some WoWLAN commands
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add some documentation for the WoWLAN commands, also linking the
correct enums used.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h | 29 +++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h
index 5f22cc7ac26a..edde49202786 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
- * Copyright(c) 2015 Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -34,6 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -254,6 +255,17 @@ enum iwl_wowlan_flags {
 	ENABLE_STORE_BEACON	= BIT(4),
 };
 
+/**
+ * struct iwl_wowlan_config_cmd - WoWLAN configuration
+ * @wakeup_filter: filter from &enum iwl_wowlan_wakeup_filters
+ * @non_qos_seq: non-QoS sequence counter to use next
+ * @qos_seq: QoS sequence counters to use next
+ * @wowlan_ba_teardown_tids: bitmap of BA sessions to tear down
+ * @is_11n_connection: indicates HT connection
+ * @offloading_tid: TID reserved for firmware use
+ * @flags: extra flags, see &enum iwl_wowlan_flags
+ * @reserved: reserved
+ */
 struct iwl_wowlan_config_cmd {
 	__le32 wakeup_filter;
 	__le16 non_qos_seq;
@@ -370,6 +382,21 @@ struct iwl_wowlan_gtk_status {
 	struct iwl_wowlan_rsc_tsc_params_cmd rsc;
 } __packed; /* WOWLAN_GTK_MATERIAL_VER_1 */
 
+/**
+ * struct iwl_wowlan_status - WoWLAN status
+ * @gtk: GTK data
+ * @replay_ctr: GTK rekey replay counter
+ * @pattern_number: number of the matched pattern
+ * @non_qos_seq_ctr: non-QoS sequence counter to use next
+ * @qos_seq_ctr: QoS sequence counters to use next
+ * @wakeup_reasons: wakeup reasons, see &enum iwl_wowlan_wakeup_reason
+ * @num_of_gtk_rekeys: number of GTK rekeys
+ * @transmitted_ndps: number of transmitted neighbor discovery packets
+ * @received_beacons: number of received beacons
+ * @wake_packet_length: wakeup packet length
+ * @wake_packet_bufsize: wakeup packet buffer size
+ * @wake_packet: wakeup packet
+ */
 struct iwl_wowlan_status {
 	struct iwl_wowlan_gtk_status gtk;
 	__le64 replay_ctr;
-- 
2.11.0
