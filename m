Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA0B2C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:50:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2C9421929
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:50:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436648AbfBOLuB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 06:50:01 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:60536 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727790AbfBOLuB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 06:50:01 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1guc00-0008TN-7Y; Fri, 15 Feb 2019 13:49:44 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Feb 2019 13:49:21 +0200
Message-Id: <20190215114924.2545-18-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190215114924.2545-1-luca@coelho.fi>
References: <20190215114924.2545-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 17/20] iwlwifi: mvm: implement VHT extended NSS support in rs.c
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

For non-offloaded rate control, implement VHT extended NSS
support by just ignoring 160 MHz on transmit if the peer
doesn't support the full NSS (2). This is pretty unlikely
and gets us 160 MHz RX as well as TX in most cases, since
the typical case for this workaround is 4x4 AP only doing
2x2 on 160 MHz.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 23 +++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 2d7a089d93a3..e231a44d2423 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -3,7 +3,7 @@
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -1643,8 +1643,26 @@ static s32 rs_get_best_rate(struct iwl_mvm *mvm,
 
 static u32 rs_bw_from_sta_bw(struct ieee80211_sta *sta)
 {
+	struct ieee80211_sta_vht_cap *sta_vht_cap = &sta->vht_cap;
+	struct ieee80211_vht_cap vht_cap = {
+		.vht_cap_info = cpu_to_le32(sta_vht_cap->cap),
+		.supp_mcs = sta_vht_cap->vht_mcs,
+	};
+
 	switch (sta->bandwidth) {
 	case IEEE80211_STA_RX_BW_160:
+		/*
+		 * Don't use 160 MHz if VHT extended NSS support
+		 * says we cannot use 2 streams, we don't want to
+		 * deal with this.
+		 * We only check MCS 0 - they will support that if
+		 * we got here at all and we don't care which MCS,
+		 * we want to determine a more global state.
+		 */
+		if (ieee80211_get_vht_max_nss(&vht_cap,
+					      IEEE80211_VHT_CHANWIDTH_160MHZ,
+					      0, true) < sta->rx_nss)
+			return RATE_MCS_CHAN_WIDTH_80;
 		return RATE_MCS_CHAN_WIDTH_160;
 	case IEEE80211_STA_RX_BW_80:
 		return RATE_MCS_CHAN_WIDTH_80;
@@ -1796,7 +1814,7 @@ static bool rs_tweak_rate_tbl(struct iwl_mvm *mvm,
 			      struct iwl_scale_tbl_info *tbl,
 			      enum rs_action scale_action)
 {
-	if (sta->bandwidth != IEEE80211_STA_RX_BW_80)
+	if (rs_bw_from_sta_bw(sta) != RATE_MCS_CHAN_WIDTH_80)
 		return false;
 
 	if (!is_vht_siso(&tbl->rate))
@@ -4127,6 +4145,7 @@ static const struct rate_control_ops rs_mvm_ops_drv = {
 	.add_sta_debugfs = rs_drv_add_sta_debugfs,
 	.remove_sta_debugfs = rs_remove_sta_debugfs,
 #endif
+	.capa = RATE_CTRL_CAPA_VHT_EXT_NSS_BW,
 };
 
 void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-- 
2.20.1

