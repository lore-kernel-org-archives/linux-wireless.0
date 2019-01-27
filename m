Return-Path: <SRS0=DVo7=QD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9EB5C282C9
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 933322146E
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbfA0KUQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Jan 2019 05:20:16 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:51438 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726839AbfA0KUP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Jan 2019 05:20:15 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gnhXK-0001vC-G5; Sun, 27 Jan 2019 12:19:34 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 27 Jan 2019 12:19:02 +0200
Message-Id: <20190127101908.6428-16-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190127101908.6428-1-luca@coelho.fi>
References: <20190127101908.6428-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 15/21] iwlwifi: trigger dump on assert prior to setting the device up
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

In the regular flow, when we receive an assert, ieee80211_reconfig is
called which reconfig the driver using iwl_mvm_mac_start.
iwl_mvm_mac_start is clearing the restart bit and does dump collection.

Prior to setting the device up, ieee80211_reconfig does not call
iwl_mvm_mac_start since there is nothing to reconfig and we miss the
dump collection of the assert.

solve it by checking the restart bit before we stop the device
and trigger a dump collection in case it is set.

note that we don't need to do it in the fmac case since in fmac
assert flow in iwl_fmac_nic_error we call iwl_fw_dbg_collect_desc
so we can be sure that there will a dump collection in
iwl_fmac_stop_device.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index ac526b412aa6..12e9ecc3ee27 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1997,6 +1997,16 @@ static inline u32 iwl_mvm_flushable_queues(struct iwl_mvm *mvm)
 static inline void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 {
 	lockdep_assert_held(&mvm->mutex);
+	/* If IWL_MVM_STATUS_HW_RESTART_REQUESTED bit is set then we received
+	 * an assert. Since we failed to bring the interface up, mac80211
+	 * will not attempt to reconfig the device,
+	 * which handles the dump collection in assert flow,
+	 * so trigger dump collection here.
+	 */
+	if (test_and_clear_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED,
+			       &mvm->status))
+		iwl_fw_dbg_collect_desc(&mvm->fwrt, &iwl_dump_desc_assert,
+					false, 0);
 	/* calling this function without using dump_start/end since at this
 	 * point we already hold the op mode mutex
 	 */
-- 
2.20.1

