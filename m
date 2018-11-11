Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 100A3C43441
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 10:26:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6C0D208A3
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 10:26:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6C0D208A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbeKKUOu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 11 Nov 2018 15:14:50 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:35844 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727344AbeKKUOu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Nov 2018 15:14:50 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gLmwv-00007G-3p; Sun, 11 Nov 2018 12:26:37 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>, stable@vger.kernel.org
Date:   Sun, 11 Nov 2018 12:26:27 +0200
Message-Id: <20181111102627.18461-6-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181111102627.18461-1-luca@coelho.fi>
References: <20181111102627.18461-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 5/5] iwlwifi: mvm: don't use SAR Geo if basic SAR is not used
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

We can't use SAR Geo if basic SAR is not enabled, since the SAR Geo
tables define offsets in relation to the basic SAR table in use.

To fix this, make iwl_mvm_sar_init() return one in case WRDS is not
available, so we can skip reading WGDS entirely.

Fixes: a6bff3cb19b7 ("iwlwifi: mvm: add GEO_TX_POWER_LIMIT cmd for geographic tx power table")
Cc: stable@vger.kernel.org # 4.12+
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 31 +++++++++++++++------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 899f4a6432fb..da9afa6824cb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -954,8 +954,11 @@ static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
 		IWL_DEBUG_RADIO(mvm,
 				"WRDS SAR BIOS table invalid or unavailable. (%d)\n",
 				ret);
-		/* if not available, don't fail and don't bother with EWRD */
-		return 0;
+		/*
+		 * If not available, don't fail and don't bother with EWRD.
+		 * Return 1 to tell that we can't use WGDS either.
+		 */
+		return 1;
 	}
 
 	ret = iwl_mvm_sar_get_ewrd_table(mvm);
@@ -968,9 +971,13 @@ static int iwl_mvm_sar_init(struct iwl_mvm *mvm)
 	/* choose profile 1 (WRDS) as default for both chains */
 	ret = iwl_mvm_sar_select_profile(mvm, 1, 1);
 
-	/* if we don't have profile 0 from BIOS, just skip it */
+	/*
+	 * If we don't have profile 0 from BIOS, just skip it.  This
+	 * means that SAR Geo will not be enabled either, even if we
+	 * have other valid profiles.
+	 */
 	if (ret == -ENOENT)
-		return 0;
+		return 1;
 
 	return ret;
 }
@@ -1168,11 +1175,19 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 		iwl_mvm_unref(mvm, IWL_MVM_REF_UCODE_DOWN);
 
 	ret = iwl_mvm_sar_init(mvm);
-	if (ret)
-		goto error;
+	if (ret == 0) {
+		ret = iwl_mvm_sar_geo_init(mvm);
+	} else if (ret > 0 && !iwl_mvm_sar_get_wgds_table(mvm)) {
+		/*
+		 * If basic SAR is not available, we check for WGDS,
+		 * which should *not* be available either.  If it is
+		 * available, issue an error, because we can't use SAR
+		 * Geo without basic SAR.
+		 */
+		IWL_ERR(mvm, "BIOS contains WGDS but no WRDS\n");
+	}
 
-	ret = iwl_mvm_sar_geo_init(mvm);
-	if (ret)
+	if (ret < 0)
 		goto error;
 
 	iwl_mvm_leds_sync(mvm);
-- 
2.19.1

