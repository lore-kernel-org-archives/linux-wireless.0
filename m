Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:58301 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbaKCTtz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2014 14:49:55 -0500
Received: by mail-wi0-f179.google.com with SMTP id h11so7404569wiw.6
        for <linux-wireless@vger.kernel.org>; Mon, 03 Nov 2014 11:49:53 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/2] iwlwifi: mvm: initialize the cur_ucode upon boot
Date: Mon,  3 Nov 2014 21:49:45 +0200
Message-Id: <1415044186-5559-1-git-send-email-egrumbach@gmail.com> (sfid-20141103_204958_301574_31D4A995)
In-Reply-To: <5457DC1C.7020200@gmail.com>
References: <5457DC1C.7020200@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

mvm->cur_ucode wasn't set before we actually load the
firmware. This caused issues when we boot in RFKILL since
we get an RFKILL interrupt upon boot even before we load
any firmware.
This leads to issues since iwl_mvm_set_hw_rfkill_state
(the RFKILL interrupts handler in mvm) relies on this
variable.

Fix this.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 48cb25a..27fb0a1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -424,6 +424,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	}
 	mvm->sf_state = SF_UNINIT;
 	mvm->low_latency_agg_frame_limit = 6;
+	mvm->cur_ucode = IWL_UCODE_INIT;
 
 	mutex_init(&mvm->mutex);
 	mutex_init(&mvm->d0i3_suspend_mutex);
-- 
1.9.1

