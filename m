Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46916 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753271AbeE3HUP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 03:20:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Aviya Erenfeld <aviya.erenfeld@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 30 May 2018 10:19:58 +0300
Message-Id: <20180530072005.633-4-luca@coelho.fi> (sfid-20180530_092040_515864_7700D5DD)
In-Reply-To: <20180530072005.633-1-luca@coelho.fi>
References: <20180530072005.633-1-luca@coelho.fi>
Subject: [PATCH 03/10] iwlmvm: tdls: Check TDLS channel switch support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aviya Erenfeld <aviya.erenfeld@intel.com>

Some versions of the FW don't support channel switch in TDLS.
Add a condition that checks it.

Fixes: 307e47235a10 ("iwlwifi: mvm: configure TDLS peers to FW")
Signed-off-by: Aviya Erenfeld <aviya.erenfeld@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c b/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
index 3d97436bbdf5..67f360c0d17e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tdls.c
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2017 Intel Deutschland GmbH
+ * Copyright(C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -18,9 +19,7 @@
  * General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
+ * along with this program.
  *
  * The full GNU General Public License is included in this distribution
  * in the file called COPYING.
@@ -33,6 +32,7 @@
  *
  * Copyright(c) 2014 Intel Mobile Communications GmbH
  * Copyright(c) 2017 Intel Deutschland GmbH
+ * Copyright(C) 2018 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -188,8 +188,14 @@ void iwl_mvm_recalc_tdls_state(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (tdls_sta_cnt == 1 && sta_added)
 		iwl_mvm_power_update_mac(mvm);
 
-	/* configure the FW with TDLS peer info */
-	iwl_mvm_tdls_config(mvm, vif);
+	/* Configure the FW with TDLS peer info only if TDLS channel switch
+	 * capability is set.
+	 * TDLS config data is used currently only in TDLS channel switch code.
+	 * Supposed to serve also TDLS buffer station which is not implemneted
+	 * yet in FW*/
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH))
+		iwl_mvm_tdls_config(mvm, vif);
 
 	/* when the last peer leaves, send a power update last */
 	if (tdls_sta_cnt == 0 && !sta_added)
-- 
2.17.0
