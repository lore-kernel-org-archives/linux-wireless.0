Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:58118 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbaBCU6e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:34 -0500
Received: by mail-ee0-f47.google.com with SMTP id d49so3859806eek.20
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:33 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/62] iwlwifi: mvm: check ARRAY_SIZE(mvm->fw_id_to_mac_id) = IWL_MVM_STATION_COUNT
Date: Mon,  3 Feb 2014 22:57:18 +0200
Message-Id: <1391461088-8082-12-git-send-email-egrumbach@gmail.com> (sfid-20140203_223006_570401_EE5BEEA4)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Since we use IWL_MVM_STATION_COUNT all over the driver, we
need to make sure that it is the right constant to look at.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index f38ed9f..5e4d56e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -338,6 +338,13 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	};
 	int err, scan_size;
 
+	/*
+	 * We use IWL_MVM_STATION_COUNT to check the validity of the station
+	 * index all over the driver - check that its value corresponds to the
+	 * array size.
+	 */
+	BUILD_BUG_ON(ARRAY_SIZE(mvm->fw_id_to_mac_id) != IWL_MVM_STATION_COUNT);
+
 	/********************************
 	 * 1. Allocating and configuring HW data
 	 ********************************/
-- 
1.7.9.5

