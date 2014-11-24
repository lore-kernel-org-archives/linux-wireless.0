Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:55577 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaKXOfA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:00 -0500
Received: by mail-wg0-f53.google.com with SMTP id l18so12519516wgh.12
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:34:59 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/75] iwlwifi: mvm: handle error from iwl_trans_update_sf
Date: Mon, 24 Nov 2014 16:33:38 +0200
Message-Id: <1416839691-28533-2-git-send-email-egrumbach@gmail.com> (sfid-20141124_153505_573275_B55E47AB)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

iwl_trans_update_sf can fail and this wasn't handled.
Fix this.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index e0d9f19..8c96e5a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -227,6 +227,10 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	st_fwrd_space.addr = mvm->sf_space.addr;
 	st_fwrd_space.size = mvm->sf_space.size;
 	ret = iwl_trans_update_sf(mvm->trans, &st_fwrd_space);
+	if (ret) {
+		IWL_ERR(mvm, "Failed to update SF size. ret %d\n", ret);
+		return ret;
+	}
 
 	iwl_trans_fw_alive(mvm->trans, alive_data.scd_base_addr);
 
-- 
1.9.1

