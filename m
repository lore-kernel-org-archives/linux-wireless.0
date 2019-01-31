Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C35BC169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 495FD218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbfAaUXI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 15:23:08 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:53710 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727435AbfAaUXI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 15:23:08 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gpIr1-0004pL-Vm; Thu, 31 Jan 2019 22:22:32 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Thu, 31 Jan 2019 22:22:06 +0200
Message-Id: <20190131202206.15903-22-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190131202206.15903-1-luca@coelho.fi>
References: <20190131202206.15903-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 21/21] iwlwifi: implement BISR HW workaround for 22260 devices
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

There's a small hardware bug in 22260 devices which thus require a
few more delays during initialization. Implement this workaround.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c  |  3 +++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  4 +++-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c     | 10 ++++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index c547288d32aa..28d8c3477371 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -220,6 +220,7 @@ const struct iwl_cfg iwl22260_2ax_cfg = {
 	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
 	 */
 	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+	.bisr_workaround = 1,
 };
 
 const struct iwl_cfg killer1650x_2ax_cfg = {
@@ -232,6 +233,7 @@ const struct iwl_cfg killer1650x_2ax_cfg = {
 	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
 	 */
 	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+	.bisr_workaround = 1,
 };
 
 const struct iwl_cfg killer1650w_2ax_cfg = {
@@ -244,6 +246,7 @@ const struct iwl_cfg killer1650w_2ax_cfg = {
 	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
 	 */
 	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+	.bisr_workaround = 1,
 };
 
 /*
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index f1e493380713..5e713730165a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -379,6 +379,7 @@ struct iwl_csr_params {
  * @nvm_type: see &enum iwl_nvm_type
  * @d3_debug_data_base_addr: base address where D3 debug data is stored
  * @d3_debug_data_length: length of the D3 debug data
+ * @bisr_workaround: BISR hardware workaround (for 22260 series devices)
  *
  * We enable the driver to be backward compatible wrt. hardware features.
  * API differences in uCode shouldn't be handled here but through TLVs
@@ -428,7 +429,8 @@ struct iwl_cfg {
 	    use_tfh:1,
 	    gen2:1,
 	    cdb:1,
-	    dbgc_supported:1;
+	    dbgc_supported:1,
+	    bisr_workaround:1;
 	u8 valid_tx_ant;
 	u8 valid_rx_ant;
 	u8 non_shared_ant;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index 4ea5883f9175..bf171edad53a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -493,6 +493,11 @@ int iwl_finish_nic_init(struct iwl_trans *trans)
 {
 	int err;
 
+	if (trans->cfg->bisr_workaround) {
+		/* ensure the TOP FSM isn't still in previous reset */
+		mdelay(2);
+	}
+
 	/*
 	 * Set "initialization complete" bit to move adapter from
 	 * D0U* --> D0A* (powered-up active) state.
@@ -515,6 +520,11 @@ int iwl_finish_nic_init(struct iwl_trans *trans)
 	if (err < 0)
 		IWL_DEBUG_INFO(trans, "Failed to wake NIC\n");
 
+	if (trans->cfg->bisr_workaround) {
+		/* ensure BISR shift has finished */
+		udelay(200);
+	}
+
 	return err < 0 ? err : 0;
 }
 IWL_EXPORT_SYMBOL(iwl_finish_nic_init);
-- 
2.20.1

