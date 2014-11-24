Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:60182 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315AbaKXOgi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:38 -0500
Received: by mail-wg0-f50.google.com with SMTP id k14so12256407wgh.23
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:37 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH 62/75] iwlwifi: mvm: clear TE data if CSA time event fails to start
Date: Mon, 24 Nov 2014 16:34:38 +0200
Message-Id: <1416839691-28533-62-git-send-email-egrumbach@gmail.com> (sfid-20141124_153813_897504_35ACE26A)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

If setting the CSA time event fails, we must clear the TE data,
otherwise we'll try to remove it when, for instance, a disconnection
occurs, causing a SYSASSERT.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index ff631cc..54fafbf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -198,6 +198,7 @@ iwl_mvm_te_handle_notify_csa(struct iwl_mvm *mvm,
 {
 	if (!le32_to_cpu(notif->status)) {
 		IWL_DEBUG_TE(mvm, "CSA time event failed to start\n");
+		iwl_mvm_te_clear_data(mvm, te_data);
 		return;
 	}
 
-- 
1.9.1

