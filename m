Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:47187 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756AbaLBSLn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:11:43 -0500
Received: by mail-wg0-f45.google.com with SMTP id b13so17797963wgh.4
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:11:42 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/26] iwlwifi: pcie: claim ownership on the device after stop_device()
Date: Tue,  2 Dec 2014 20:11:05 +0200
Message-Id: <1417543877-24193-14-git-send-email-egrumbach@gmail.com> (sfid-20141202_191147_652038_FD5CC5B5)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Not doing so would allow other possible users of the device
to take ownership and prevent normal WiFi operation.

This fixes the second part of:
https://bugzilla.kernel.org/show_bug.cgi?id=87191

Reviewed-by: Moshe Harel <moshe.harel@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index a3b63b7..7d7f05e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -994,6 +994,9 @@ static void iwl_trans_pcie_stop_device(struct iwl_trans *trans)
 		clear_bit(STATUS_RFKILL, &trans->status);
 	if (hw_rfkill != was_hw_rfkill)
 		iwl_trans_pcie_rf_kill(trans, hw_rfkill);
+
+	/* re-take ownership to prevent other users from stealing the deivce */
+	iwl_pcie_prepare_card_hw(trans);
 }
 
 void iwl_trans_pcie_rf_kill(struct iwl_trans *trans, bool state)
-- 
1.9.1

