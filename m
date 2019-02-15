Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0068C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F64C21929
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436574AbfBOLtg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 06:49:36 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:60400 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2394511AbfBOLte (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 06:49:34 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gubzp-0008TN-EG; Fri, 15 Feb 2019 13:49:33 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Feb 2019 13:49:09 +0200
Message-Id: <20190215114924.2545-6-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190215114924.2545-1-luca@coelho.fi>
References: <20190215114924.2545-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/20] iwlwifi: nvm-parse: use struct_size() in kzalloc()
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

One of the more common cases of allocation size calculations is finding the
size of a structure that has a zero-sized array at the end, along with memory
for some number of elements for that array. For example:

struct foo {
    int stuff;
    void *entry[];
};

instance = kzalloc(sizeof(struct foo) + sizeof(void *) * count, GFP_KERNEL);

Instead of leaving these open-coded and prone to type mistakes, we can now
use the new struct_size() helper:

instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL);

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 503860a2b36d..ca6a243d704b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -946,15 +946,13 @@ iwl_parse_nvm_data(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	const __le16 *ch_section;
 
 	if (cfg->nvm_type != IWL_NVM_EXT)
-		data = kzalloc(sizeof(*data) +
-			       sizeof(struct ieee80211_channel) *
-			       IWL_NVM_NUM_CHANNELS,
-			       GFP_KERNEL);
+		data = kzalloc(struct_size(data, channels,
+					   IWL_NVM_NUM_CHANNELS),
+					   GFP_KERNEL);
 	else
-		data = kzalloc(sizeof(*data) +
-			       sizeof(struct ieee80211_channel) *
-			       IWL_NVM_NUM_CHANNELS_EXT,
-			       GFP_KERNEL);
+		data = kzalloc(struct_size(data, channels,
+					   IWL_NVM_NUM_CHANNELS_EXT),
+					   GFP_KERNEL);
 	if (!data)
 		return NULL;
 
@@ -1441,9 +1439,7 @@ struct iwl_nvm_data *iwl_get_nvm(struct iwl_trans *trans,
 	if (empty_otp)
 		IWL_INFO(trans, "OTP is empty\n");
 
-	nvm = kzalloc(sizeof(*nvm) +
-		      sizeof(struct ieee80211_channel) * IWL_NUM_CHANNELS,
-		      GFP_KERNEL);
+	nvm = kzalloc(struct_size(nvm, channels, IWL_NUM_CHANNELS), GFP_KERNEL);
 	if (!nvm) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.20.1

