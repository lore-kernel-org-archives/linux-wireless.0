Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E01EAC43387
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 16:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CA15206C2
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 16:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbeLNQaa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 11:30:30 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41904 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729623AbeLNQa3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 11:30:29 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gXqM6-0002LV-Rg; Fri, 14 Dec 2018 18:30:27 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 14 Dec 2018 18:30:22 +0200
Message-Id: <20181214163022.22162-1-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v4.20] iwlwifi: mvm: don't send GEO_TX_POWER_LIMIT to old firmwares
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Old firmware versions don't support this command. Sending it
to any firmware before -41.ucode will crash the firmware.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=201975

Fixes: 66e839030fd6 ("iwlwifi: fix wrong WGDS_WIFI_DATA_SIZE")
CC: <stable@vger.kernel.org> #4.19+
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 2ba890445c35..1689bead1b4f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -881,6 +881,15 @@ static int iwl_mvm_sar_geo_init(struct iwl_mvm *mvm)
 	int ret, i, j;
 	u16 cmd_wide_id =  WIDE_ID(PHY_OPS_GROUP, GEO_TX_POWER_LIMIT);
 
+	/*
+	 * This command is not supported on earlier firmware versions.
+	 * Unfortunately, we don't have a TLV API flag to rely on, so
+	 * rely on the major version which is in the first byte of
+	 * ucode_ver.
+	 */
+	if (IWL_UCODE_SERIAL(mvm->fw->ucode_ver) < 41)
+		return 0;
+
 	ret = iwl_mvm_sar_get_wgds_table(mvm);
 	if (ret < 0) {
 		IWL_DEBUG_RADIO(mvm,
-- 
2.19.2

