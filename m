Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:53461 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbcE0NIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2016 09:08:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Matti Gottlieb <matti.gottlieb@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Intel Linux Wireless <linuxwifi@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Moshe Harel <moshe.harel@intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: mvm: avoid harmless -Wmaybe-uninialized warning
Date: Fri, 27 May 2016 15:07:03 +0200
Message-Id: <1464354462-1940949-1-git-send-email-arnd@arndb.de> (sfid-20160527_150838_433926_047FAC5E)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
---
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c | 41 ++++++++++++++--------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index 25a98401a64f..0551a4bb163c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -667,8 +667,7 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 		.mcc = cpu_to_le16(alpha2[0] << 8 | alpha2[1]),
 		.source_id = (u8)src_id,
 	};
-	struct iwl_mcc_update_resp *mcc_resp, *resp_cp = NULL;
-	struct iwl_mcc_update_resp_v1 *mcc_resp_v1 = NULL;
+	struct iwl_mcc_update_resp *resp_cp;
 	struct iwl_rx_packet *pkt;
 	struct iwl_host_cmd cmd = {
 		.id = MCC_UPDATE_CMD,
@@ -701,34 +700,36 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 
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
2.7.0

