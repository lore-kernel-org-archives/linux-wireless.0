Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC626C5AC81
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:01:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88ED62086D
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:01:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbfARTBJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 14:01:09 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:48454 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729191AbfARTBJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 14:01:09 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gkZNM-0004cj-VT; Fri, 18 Jan 2019 21:00:21 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 18 Jan 2019 20:59:58 +0200
Message-Id: <20190118190004.22270-11-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118190004.22270-1-luca@coelho.fi>
References: <20190118190004.22270-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 10/16] iwlwifi: mvm: fix firmware statistics usage
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The new (CDB) statistics API is used by non-CDB devices
as well. Look at the right TLV flag to know which version
of the statistics notification to use.
To avoid confusion, remove the _cdb suffix from the
structure name.
While at it, remove a structure that was never used.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Fixes: 678d9b6dddea ("iwlwifi: mvm: update rx statistics cmd api")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/stats.h | 15 +++++----------
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c       | 10 +++++-----
 2 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/stats.h b/drivers/net/wireless/intel/iwlwifi/fw/api/stats.h
index 53cb622aa9ab..318843138490 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/stats.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/stats.h
@@ -8,6 +8,7 @@
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -29,6 +30,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright (C) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -363,14 +365,7 @@ struct mvm_statistics_general_v8 {
 	u8 reserved[4 - (NUM_MAC_INDEX % 4)];
 } __packed; /* STATISTICS_GENERAL_API_S_VER_8 */
 
-struct mvm_statistics_general_cdb_v9 {
-	struct mvm_statistics_general_common_v19 common;
-	__le32 beacon_counter[NUM_MAC_INDEX_CDB];
-	u8 beacon_average_energy[NUM_MAC_INDEX_CDB];
-	u8 reserved[4 - (NUM_MAC_INDEX_CDB % 4)];
-} __packed; /* STATISTICS_GENERAL_API_S_VER_9 */
-
-struct mvm_statistics_general_cdb {
+struct mvm_statistics_general {
 	struct mvm_statistics_general_common common;
 	__le32 beacon_counter[MAC_INDEX_AUX];
 	u8 beacon_average_energy[MAC_INDEX_AUX];
@@ -435,11 +430,11 @@ struct iwl_notif_statistics_v11 {
 	struct mvm_statistics_load_v1 load_stats;
 } __packed; /* STATISTICS_NTFY_API_S_VER_11 */
 
-struct iwl_notif_statistics_cdb {
+struct iwl_notif_statistics {
 	__le32 flag;
 	struct mvm_statistics_rx rx;
 	struct mvm_statistics_tx tx;
-	struct mvm_statistics_general_cdb general;
+	struct mvm_statistics_general general;
 	struct mvm_statistics_load load_stats;
 } __packed; /* STATISTICS_NTFY_API_S_VER_13 */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 6653a238f32e..235ab26ca429 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -599,8 +599,8 @@ static void iwl_mvm_stat_iterator(void *_data, u8 *mac,
 	 * data copied into the "data" struct, but rather the data from
 	 * the notification directly.
 	 */
-	if (iwl_mvm_is_cdb_supported(mvm)) {
-		struct mvm_statistics_general_cdb *general =
+	if (iwl_mvm_has_new_rx_stats_api(mvm)) {
+		struct mvm_statistics_general *general =
 			data->general;
 
 		mvmvif->beacon_stats.num_beacons =
@@ -723,7 +723,7 @@ void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 		else
 			expected_size = sizeof(struct iwl_notif_statistics_v10);
 	} else {
-		expected_size = sizeof(struct iwl_notif_statistics_cdb);
+		expected_size = sizeof(struct iwl_notif_statistics);
 	}
 
 	if (WARN_ONCE(iwl_rx_packet_payload_len(pkt) != expected_size,
@@ -753,7 +753,7 @@ void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 
 		flags = stats->flag;
 	} else {
-		struct iwl_notif_statistics_cdb *stats = (void *)&pkt->data;
+		struct iwl_notif_statistics *stats = (void *)&pkt->data;
 
 		data.mac_id = stats->rx.general.mac_id;
 		data.beacon_filter_average_energy =
@@ -792,7 +792,7 @@ void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 		bytes = (void *)&v11->load_stats.byte_count;
 		air_time = (void *)&v11->load_stats.air_time;
 	} else {
-		struct iwl_notif_statistics_cdb *stats = (void *)&pkt->data;
+		struct iwl_notif_statistics *stats = (void *)&pkt->data;
 
 		energy = (void *)&stats->load_stats.avg_energy;
 		bytes = (void *)&stats->load_stats.byte_count;
-- 
2.20.1

