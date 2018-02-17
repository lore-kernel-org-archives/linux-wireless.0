Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59312 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751110AbeBQIeJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Feb 2018 03:34:09 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Ulf Magnusson <ulfalizer@gmail.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 17 Feb 2018 10:33:54 +0200
Message-Id: <20180217083354.31160-10-luca@coelho.fi> (sfid-20180217_093421_337580_FE78E639)
In-Reply-To: <20180217083354.31160-1-luca@coelho.fi>
References: <20180217083354.31160-1-luca@coelho.fi>
Subject: [PATCH 9/9] iwlwifi: fix malformed CONFIG_IWLWIFI_PCIE_RTPM default
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ulf Magnusson <ulfalizer@gmail.com>

'default false' should be 'default n', though they happen to have the
same effect here, due to undefined symbols ('false' in this case)
evaluating to n in a tristate sense.

Remove the default instead of changing it. bool and tristate symbols
implicitly default to n.

Discovered with the
https://github.com/ulfalizer/Kconfiglib/blob/master/examples/list_undefined.py
script.

Signed-off-by: Ulf Magnusson <ulfalizer@gmail.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index c5f2ddf9b0fe..e5a2fc738ac3 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -91,7 +91,6 @@ config IWLWIFI_BCAST_FILTERING
 config IWLWIFI_PCIE_RTPM
        bool "Enable runtime power management mode for PCIe devices"
        depends on IWLMVM && PM && EXPERT
-       default false
        help
          Say Y here to enable runtime power management for PCIe
          devices.  If enabled, the device will go into low power mode
-- 
2.15.1
