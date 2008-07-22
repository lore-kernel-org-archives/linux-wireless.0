Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:9567 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504AbYGVA34 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 20:29:56 -0400
Received: by ug-out-1314.google.com with SMTP id h2so320048ugf.16
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2008 17:29:56 -0700 (PDT)
Message-ID: <48852A00.5050306@gmail.com> (sfid-20080722_023014_641284_51E4B550)
Date: Mon, 21 Jul 2008 20:29:52 -0400
From: roel kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: ipw2100-admin@linux.intel.com, linux-wireless@vger.kernel.org,
	ipw2100-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] iwl-4965: test below 0 on unsigned num_tbs
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

num_tbs is unsigned so the test doesn't work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index de330ae..9e957a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3121,7 +3121,7 @@ int iwl4965_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
 	u32 num_tbs = IWL_GET_BITS(*tfd, num_tbs);
 
 	/* Each TFD can point to a maximum 20 Tx buffers */
-	if ((num_tbs >= MAX_NUM_OF_TBS) || (num_tbs < 0)) {
+	if (num_tbs >= MAX_NUM_OF_TBS) {
 		IWL_ERROR("Error can not send more than %d chunks\n",
 			  MAX_NUM_OF_TBS);
 		return -EINVAL;
