Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33562 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753917AbcGFKqC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:46:02 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:15 +0300
Message-Id: <1467801651-1816-20-git-send-email-luca@coelho.fi> (sfid-20160706_124607_453978_9AFCA1CF)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 20/56] iwlwifi: mvm: avoid harmless -Wmaybe-uninialized warning
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

gcc is apparently unablel to track the state of the local 'resp_v2'
variable across the kzalloc() function, and warns about the response
variable being used without an initialization:

drivers/net/wireless/intel/iwlwifi/mvm/nvm.c: In function ‘iwl_mvm_update_mcc’:
drivers/net/wireless/intel/iwlwifi/mvm/nvm.c:727:36: warning: ‘mcc_resp_v1’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   resp_cp->n_channels = mcc_resp_v1->n_channels;
drivers/net/wireless/intel/iwlwifi/mvm/nvm.c:721:3: warning: ‘mcc_resp’ may be used uninitialized in this function [-Wmaybe-uninitialized]
   memcpy(resp_cp, mcc_resp, resp_len);

The warning showed up in x86 allmodconfig after my patch to
unhide -Wmaybe-uninitialized warnings by default was merged,
though it always existed in randconfig builds. I did not
catch the warning earlier because I was testing on ARM, which
never produced the warning.

This rearranges the code in a way that improves readability for
both humans and the compiler, and that avoids the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 6fa52430f0b3 ("iwlwifi: mvm: change mcc update API")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c | 41 ++++++++++++++--------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index 182ec20..7a686f6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -666,8 +666,7 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 		.mcc = cpu_to_le16(alpha2[0] << 8 | alpha2[1]),
 		.source_id = (u8)src_id,
 	};
-	struct iwl_mcc_update_resp *mcc_resp, *resp_cp = NULL;
-	struct iwl_mcc_update_resp_v1 *mcc_resp_v1 = NULL;
+	struct iwl_mcc_update_resp *resp_cp;
 	struct iwl_rx_packet *pkt;
 	struct iwl_host_cmd cmd = {
 		.id = MCC_UPDATE_CMD,
@@ -700,34 +699,36 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 
 	/* Extract MCC response */
 	if (resp_v2) {
-		mcc_resp = (void *)pkt->data;
+		struct iwl_mcc_update_resp *mcc_resp = (void *)pkt->data;
+
 		n_channels =  __le32_to_cpu(mcc_resp->n_channels);
+		resp_len = sizeof(struct iwl_mcc_update_resp) +
+			   n_channels * sizeof(__le32);
+		resp_cp = kmemdup(mcc_resp, resp_len, GFP_KERNEL);
 	} else {
-		mcc_resp_v1 = (void *)pkt->data;
+		struct iwl_mcc_update_resp_v1 *mcc_resp_v1 = (void *)pkt->data;
+
 		n_channels =  __le32_to_cpu(mcc_resp_v1->n_channels);
+		resp_len = sizeof(struct iwl_mcc_update_resp) +
+			   n_channels * sizeof(__le32);
+		resp_cp = kzalloc(resp_len, GFP_KERNEL);
+
+		if (resp_cp) {
+			resp_cp->status = mcc_resp_v1->status;
+			resp_cp->mcc = mcc_resp_v1->mcc;
+			resp_cp->cap = mcc_resp_v1->cap;
+			resp_cp->source_id = mcc_resp_v1->source_id;
+			resp_cp->n_channels = mcc_resp_v1->n_channels;
+			memcpy(resp_cp->channels, mcc_resp_v1->channels,
+			       n_channels * sizeof(__le32));
+		}
 	}
 
-	resp_len = sizeof(struct iwl_mcc_update_resp) + n_channels *
-		sizeof(__le32);
-
-	resp_cp = kzalloc(resp_len, GFP_KERNEL);
 	if (!resp_cp) {
 		ret = -ENOMEM;
 		goto exit;
 	}
 
-	if (resp_v2) {
-		memcpy(resp_cp, mcc_resp, resp_len);
-	} else {
-		resp_cp->status = mcc_resp_v1->status;
-		resp_cp->mcc = mcc_resp_v1->mcc;
-		resp_cp->cap = mcc_resp_v1->cap;
-		resp_cp->source_id = mcc_resp_v1->source_id;
-		resp_cp->n_channels = mcc_resp_v1->n_channels;
-		memcpy(resp_cp->channels, mcc_resp_v1->channels,
-		       n_channels * sizeof(__le32));
-	}
-
 	status = le32_to_cpu(resp_cp->status);
 
 	mcc = le16_to_cpu(resp_cp->mcc);
-- 
2.8.1

