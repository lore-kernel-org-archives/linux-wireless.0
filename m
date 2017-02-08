Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39318 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754715AbdBHPxM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 10:53:12 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  8 Feb 2017 17:51:42 +0200
Message-Id: <20170208155149.1704-2-luca@coelho.fi> (sfid-20170208_165325_803640_25947E5D)
In-Reply-To: <20170208155149.1704-1-luca@coelho.fi>
References: <20170208112322.29413-1-luca@coelho.fi>
 <20170208155149.1704-1-luca@coelho.fi>
Subject: [PATCH 10/17] iwlwifi: make RTPM depend on EXPERT
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Enabling the RTPM Kconfig option can be fairly risky.
Runtime PM must be validated against a specific platform
before it can be safely enabled. Hence, it makes no sense
for distros and other big OS vendors to enable it since
they ship code to various systems and unknown platform.

Make sure that this is hinted properly by making the
IWLWIFI_PCIE_RTPM Kconfig option depend on EXPERT.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=172411
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/Kconfig | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index b64db47b31bb..c5f2ddf9b0fe 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -90,13 +90,16 @@ config IWLWIFI_BCAST_FILTERING
 
 config IWLWIFI_PCIE_RTPM
        bool "Enable runtime power management mode for PCIe devices"
-       depends on IWLMVM && PM
+       depends on IWLMVM && PM && EXPERT
        default false
        help
          Say Y here to enable runtime power management for PCIe
          devices.  If enabled, the device will go into low power mode
          when idle for a short period of time, allowing for improved
-         power saving during runtime.
+         power saving during runtime. Note that this feature requires
+         a tight integration with the platform. It is not recommended
+         to enable this feature without proper validation with the
+         specific target platform.
 
 	 If unsure, say N.
 
-- 
2.11.0
