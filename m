Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:47814 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaBCUjc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:39:32 -0500
Received: by mail-ea0-f173.google.com with SMTP id d10so3900334eaj.18
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:39:31 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/8] iwlwifi: mvm: print the version of the firmware when it asserts
Date: Mon,  3 Feb 2014 22:39:17 +0200
Message-Id: <1391459962-7381-3-git-send-email-egrumbach@gmail.com> (sfid-20140203_213938_667026_D7DAE3A4)
In-Reply-To: <52EFFCE8.6070505@gmail.com>
References: <52EFFCE8.6070505@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This can be useful to be able to spot the firmware version
from the error reports without needing to fetch it from
another place.

Cc: <stable@vger.kernel.org> [3.10+]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/utils.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index a4a5e25..86989df 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -411,6 +411,8 @@ void iwl_mvm_dump_nic_error_log(struct iwl_mvm *mvm)
 			mvm->status, table.valid);
 	}
 
+	IWL_ERR(mvm, "Loaded firmware version: %s\n", mvm->fw->fw_version);
+
 	trace_iwlwifi_dev_ucode_error(trans->dev, table.error_id, table.tsf_low,
 				      table.data1, table.data2, table.data3,
 				      table.blink1, table.blink2, table.ilink1,
-- 
1.7.9.5

