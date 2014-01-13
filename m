Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:42229 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbaAMUWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:22:07 -0500
Received: by mail-ea0-f181.google.com with SMTP id m10so3576426eaj.12
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 12:22:06 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/18] iwlwifi: mvm: fix missing cleanup in .start() error path
Date: Mon, 13 Jan 2014 22:21:42 +0200
Message-Id: <1389644517-22807-3-git-send-email-egrumbach@gmail.com> (sfid-20140113_212217_044265_BD47FA79)
In-Reply-To: <52D44A46.4000805@gmail.com>
References: <52D44A46.4000805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliadx.peller@intel.com>

Cleanup of iwl_mvm_leds was missing in case of error,
resulting in the following warning:

WARNING: at lib/kobject.c:196 kobject_add_internal+0x1f4/0x210()
kobject_add_internal failed for phy0-led with -EEXIST, don't try to register things with the same name in the same directory.

which prevents further reloads of the driver.

Cc: stable@vger.kernel.org [3.10+]
Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 552c76a..2437a06 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -472,6 +472,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
  out_unregister:
 	ieee80211_unregister_hw(mvm->hw);
+	iwl_mvm_leds_exit(mvm);
  out_free:
 	iwl_phy_db_free(mvm->phy_db);
 	kfree(mvm->scan_cmd);
-- 
1.7.9.5

