Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2111FC5AC81
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1A662086D
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbfARTBC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 14:01:02 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:48436 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729245AbfARTBB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 14:01:01 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gkZNR-0004cj-9s; Fri, 18 Jan 2019 21:00:25 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 18 Jan 2019 21:00:03 +0200
Message-Id: <20190118190004.22270-16-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118190004.22270-1-luca@coelho.fi>
References: <20190118190004.22270-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 15/16] iwlwifi: mvm: make NVM access actually fail on failures
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

On any failure, including if we crash the firmware or get garbage
data, we currently ignore this and pretend the OTP was empty.
Clearly, this isn't typically the case.

In cases other than the firmware saying it can't read the requested
section, or the section having ended, make the access actually fail
and trickle the error up through the layers to fail init.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index 6fc5cc1f2b5b..f08934b03cf3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -179,7 +179,7 @@ static int iwl_nvm_read_chunk(struct iwl_mvm *mvm, u16 section,
 			IWL_DEBUG_EEPROM(mvm->trans->dev,
 					 "NVM access command failed with status %d (device: %s)\n",
 					 ret, mvm->cfg->name);
-			ret = -EIO;
+			ret = -ENODATA;
 		}
 		goto exit;
 	}
@@ -380,8 +380,12 @@ int iwl_nvm_init(struct iwl_mvm *mvm)
 		/* we override the constness for initial read */
 		ret = iwl_nvm_read_section(mvm, section, nvm_buffer,
 					   size_read);
-		if (ret < 0)
+		if (ret == -ENODATA) {
+			ret = 0;
 			continue;
+		}
+		if (ret < 0)
+			break;
 		size_read += ret;
 		temp = kmemdup(nvm_buffer, ret, GFP_KERNEL);
 		if (!temp) {
@@ -454,7 +458,7 @@ int iwl_nvm_init(struct iwl_mvm *mvm)
 	IWL_DEBUG_EEPROM(mvm->trans->dev, "nvm version = %x\n",
 			 mvm->nvm_data->nvm_version);
 
-	return 0;
+	return ret < 0 ? ret : 0;
 }
 
 struct iwl_mcc_update_resp *
-- 
2.20.1

