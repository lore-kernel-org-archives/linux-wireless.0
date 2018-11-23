Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60608C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FDF8206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:27:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FDF8206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503790AbeKWWK5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Nov 2018 17:10:57 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:38354 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2409641AbeKWWK5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Nov 2018 17:10:57 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gQ9bl-0008GU-5S; Fri, 23 Nov 2018 13:26:49 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 23 Nov 2018 13:26:31 +0200
Message-Id: <20181123112631.29360-16-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181123112631.29360-1-luca@coelho.fi>
References: <20181123112631.29360-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 15/15] iwlwifi: mvm: don't check if a pointer is set if it can't be unset
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We used to have many versions of statistics notification
coming from the firmware. In one of the cleanup patches,
we forgot to clean the code that checks if data->general
is set. Since it is always set, remove the check.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c | 37 ++++++++++-----------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index ef624833cf1b..6653a238f32e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -593,31 +593,28 @@ static void iwl_mvm_stat_iterator(void *_data, u8 *mac,
 	int hyst = vif->bss_conf.cqm_rssi_hyst;
 	u16 id = le32_to_cpu(data->mac_id);
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	u16 vif_id = mvmvif->id;
 
 	/* This doesn't need the MAC ID check since it's not taking the
 	 * data copied into the "data" struct, but rather the data from
 	 * the notification directly.
 	 */
-	if (data->general) {
-		u16 vif_id = mvmvif->id;
-
-		if (iwl_mvm_is_cdb_supported(mvm)) {
-			struct mvm_statistics_general_cdb *general =
-				data->general;
-
-			mvmvif->beacon_stats.num_beacons =
-				le32_to_cpu(general->beacon_counter[vif_id]);
-			mvmvif->beacon_stats.avg_signal =
-				-general->beacon_average_energy[vif_id];
-		} else {
-			struct mvm_statistics_general_v8 *general =
-				data->general;
-
-			mvmvif->beacon_stats.num_beacons =
-				le32_to_cpu(general->beacon_counter[vif_id]);
-			mvmvif->beacon_stats.avg_signal =
-				-general->beacon_average_energy[vif_id];
-		}
+	if (iwl_mvm_is_cdb_supported(mvm)) {
+		struct mvm_statistics_general_cdb *general =
+			data->general;
+
+		mvmvif->beacon_stats.num_beacons =
+			le32_to_cpu(general->beacon_counter[vif_id]);
+		mvmvif->beacon_stats.avg_signal =
+			-general->beacon_average_energy[vif_id];
+	} else {
+		struct mvm_statistics_general_v8 *general =
+			data->general;
+
+		mvmvif->beacon_stats.num_beacons =
+			le32_to_cpu(general->beacon_counter[vif_id]);
+		mvmvif->beacon_stats.avg_signal =
+			-general->beacon_average_energy[vif_id];
 	}
 
 	if (mvmvif->id != id)
-- 
2.19.1

