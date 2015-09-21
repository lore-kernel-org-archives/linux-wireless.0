Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45777 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932229AbbIUVBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 17:01:33 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 23:59:01 +0300
Message-Id: <1442869141-31637-21-git-send-email-luca@coelho.fi> (sfid-20150921_230139_247509_357AFDAD)
In-Reply-To: <1442868938.27148.361.camel@coelho.fi>
References: <1442868938.27148.361.camel@coelho.fi>
Subject: [PATCH 21/21] iwlwifi: mvm: add debug print for d0i3 exit indication
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

In order to verify d0i3 flow, add debug print to indicate
d0i3 exit was completed (right after tx was re-enabled),
along with the wakeup reasons.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 62eefab..3f6428c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -1263,7 +1263,7 @@ static void iwl_mvm_d0i3_exit_work(struct work_struct *wk)
 	};
 	struct iwl_wowlan_status *status;
 	int ret;
-	u32 handled_reasons, wakeup_reasons;
+	u32 handled_reasons, wakeup_reasons = 0;
 	__le16 *qos_seq = NULL;
 
 	mutex_lock(&mvm->mutex);
@@ -1295,6 +1295,9 @@ static void iwl_mvm_d0i3_exit_work(struct work_struct *wk)
 out:
 	iwl_mvm_d0i3_enable_tx(mvm, qos_seq);
 
+	IWL_DEBUG_INFO(mvm, "d0i3 exit completed (wakeup reasons: 0x%x)\n",
+		       wakeup_reasons);
+
 	/* qos_seq might point inside resp_pkt, so free it only now */
 	if (get_status_cmd.resp_pkt)
 		iwl_free_resp(&get_status_cmd);
-- 
2.5.1

