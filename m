Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54252 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1948970AbdDYUYA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:24:00 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:36 +0300
Message-Id: <20170425202243.7844-19-luca@coelho.fi> (sfid-20170425_222422_433955_1FCE81FF)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 18/25] iwlwifi: gen2: support nmi triggering from host
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

For gen2 there is a new register.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   | 3 +++
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index 0f893ae6e715..9c8b09cf1f7b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -246,6 +246,9 @@ void iwl_force_nmi(struct iwl_trans *trans)
 			       DEVICE_SET_NMI_VAL_DRV);
 		iwl_write_prph(trans, DEVICE_SET_NMI_REG,
 			       DEVICE_SET_NMI_VAL_HW);
+	} else if (trans->cfg->gen2) {
+		iwl_write_prph(trans, UREG_NIC_SET_NMI_DRIVER,
+			       DEVICE_SET_NMI_8000_VAL);
 	} else {
 		iwl_write_prph(trans, DEVICE_SET_NMI_8000_REG,
 			       DEVICE_SET_NMI_8000_VAL);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index f832e58e0ef9..306bc967742e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -114,6 +114,7 @@
 #define DEVICE_SET_NMI_VAL_DRV BIT(7)
 #define DEVICE_SET_NMI_8000_REG 0x00a01c24
 #define DEVICE_SET_NMI_8000_VAL 0x1000000
+#define UREG_NIC_SET_NMI_DRIVER 0x00a05c10
 
 /* Shared registers (0x0..0x3ff, via target indirect or periphery */
 #define SHR_BASE	0x00a10000
-- 
2.11.0
