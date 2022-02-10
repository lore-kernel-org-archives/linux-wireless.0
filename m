Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA08C433F5
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Feb 2022 16:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244831AbiBJQwW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Feb 2022 11:52:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244229AbiBJQwS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Feb 2022 11:52:18 -0500
Received: from farmhouse.coelho.fi (paleale.coelho.fi [176.9.41.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DCEEE
        for <linux-wireless@vger.kernel.org>; Thu, 10 Feb 2022 08:52:19 -0800 (PST)
Received: from 91-156-4-210.elisa-laajakaista.fi ([91.156.4.210] helo=kveik.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <luca@coelho.fi>)
        id 1nICDe-000Bxy-0L;
        Thu, 10 Feb 2022 18:22:55 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@kernel.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Thu, 10 Feb 2022 18:22:31 +0200
Message-Id: <iwlwifi.20220210181930.b8190c27dc87.Ie5b5f8c68ecafd1b51d197fc1273b024bc1575a4@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210162234.285578-1-luca@coelho.fi>
References: <20220210162234.285578-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/11] iwlwifi: api: remove ttl field from TX command
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This doesn't really exist in the firmware, it's just some
leftover from older versions. Remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
index e73cc7380a26..ecc6706f66ed 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2012-2014, 2018-2021 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2022 Intel Corporation
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
 #ifndef __iwl_fw_api_tx_h__
@@ -296,8 +296,7 @@ struct iwl_tx_cmd_gen2 {
  * @dram_info: FW internal DRAM storage
  * @rate_n_flags: rate for *all* Tx attempts, if TX_CMD_FLG_STA_RATE_MSK is
  *	cleared. Combination of RATE_MCS_*
- * @ttl: time to live - packet lifetime limit. The FW should drop if
- *	passed.
+ * @reserved: reserved
  * @hdr: 802.11 header
  */
 struct iwl_tx_cmd_gen3 {
@@ -306,7 +305,7 @@ struct iwl_tx_cmd_gen3 {
 	__le32 offload_assist;
 	struct iwl_dram_sec_info dram_info;
 	__le32 rate_n_flags;
-	__le64 ttl;
+	u8 reserved[8];
 	struct ieee80211_hdr hdr[];
 } __packed; /* TX_CMD_API_S_VER_8,
 	       TX_CMD_API_S_VER_10 */
-- 
2.34.1

