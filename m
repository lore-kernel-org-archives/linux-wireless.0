Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40906 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751700AbeDVI2T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Apr 2018 04:28:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 22 Apr 2018 11:27:43 +0300
Message-Id: <20180422082745.9743-11-luca@coelho.fi> (sfid-20180422_102822_131573_3F9540DC)
In-Reply-To: <20180422082745.9743-1-luca@coelho.fi>
References: <20180422082745.9743-1-luca@coelho.fi>
Subject: [PATCH 10/12] iwlwifi: make bitfield a u32 instead of u16
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The bitfield we use in struct iwl_cfg contains 17 bits, but we declare
it as u16.  The compiler doesn't seem to have any problems with that
(it probably automatically makes it u32), but it's cleaner to use a
type that is long enough for all the flags.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-config.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index cfd14e5ea59c..c503b26793f6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -420,7 +420,7 @@ struct iwl_cfg {
 	u32 soc_latency;
 	u16 nvm_ver;
 	u16 nvm_calib_ver;
-	u16 rx_with_siso_diversity:1,
+	u32 rx_with_siso_diversity:1,
 	    bt_shared_single_ant:1,
 	    internal_wimax_coex:1,
 	    host_interrupt_operation_mode:1,
-- 
2.17.0
