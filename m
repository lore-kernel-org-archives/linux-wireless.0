Return-Path: <SRS0=Z1rL=YC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83728ECE58E
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Oct 2019 09:50:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DDD0218AC
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Oct 2019 09:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbfJIJu7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Oct 2019 05:50:59 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:47806 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726211AbfJIJu6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Oct 2019 05:50:58 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1iI8cS-0003o4-QW; Wed, 09 Oct 2019 12:50:57 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Wed,  9 Oct 2019 12:48:53 +0300
Message-Id: <1570614256-@changeid>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <1570614256-@changeid>
References: <1570614256-@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 1/2] iwlwifi: exclude GEO SAR support for 3168
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20191009094853.PfIm3J8o7DN_Femup-OXkJdtmKE7rftk1ODkm7cx-vk@z>

From: Luca Coelho <luciano.coelho@intel.com>

We currently support two NICs in FW version 29, namely 7265D and 3168.
Out of these, only 7265D supports GEO SAR, so adjust the function that
checks for it accordingly.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Fixes: f5a47fae6aa3 ("iwlwifi: mvm: fix version check for GEO_TX_POWER_LIMIT support")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 0d2229319261..d9eb2b286438 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -899,15 +899,17 @@ static bool iwl_mvm_sar_geo_support(struct iwl_mvm *mvm)
 	 * firmware versions.  Unfortunately, we don't have a TLV API
 	 * flag to rely on, so rely on the major version which is in
 	 * the first byte of ucode_ver.  This was implemented
-	 * initially on version 38 and then backported to29 and 17.
-	 * The intention was to have it in 36 as well, but not all
-	 * 8000 family got this feature enabled.  The 8000 family is
-	 * the only one using version 36, so skip this version
-	 * entirely.
+	 * initially on version 38 and then backported to 17.  It was
+	 * also backported to 29, but only for 7265D devices.  The
+	 * intention was to have it in 36 as well, but not all 8000
+	 * family got this feature enabled.  The 8000 family is the
+	 * only one using version 36, so skip this version entirely.
 	 */
 	return IWL_UCODE_SERIAL(mvm->fw->ucode_ver) >= 38 ||
-	       IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 29 ||
-	       IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 17;
+	       IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 17 ||
+	       (IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 29 &&
+		((mvm->trans->hw_rev & CSR_HW_REV_TYPE_MSK) ==
+		 CSR_HW_REV_TYPE_7265D));
 }
 
 int iwl_mvm_get_sar_geo_profile(struct iwl_mvm *mvm)
-- 
2.23.0

