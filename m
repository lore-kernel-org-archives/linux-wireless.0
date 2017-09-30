Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36972 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750847AbdI3IMn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Sep 2017 04:12:43 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 30 Sep 2017 11:12:34 +0300
Message-Id: <20170930081234.31940-1-luca@coelho.fi> (sfid-20170930_101223_393037_2BF77C6C)
In-Reply-To: <20170929120305.20551-4-luca@coelho.fi>
References: <20170929120305.20551-4-luca@coelho.fi>
Subject: [PATCH v2 3/5] iwlwifi: mvm: return -ENODATA when reading the temperature with the FW down
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

It seems that libsensors treats -EIO as a special non-recoverable
failure when it tries to read the temperature while the firmware is
not running.  To solve that, change the error code to a milder
-ENODATA.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=196941

Fixes: c221daf219b1 ("iwlwifi: mvm: add registration to thermal zone")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---

In v2:
   * added a Fixes tag

drivers/net/wireless/intel/iwlwifi/mvm/tt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index 4d907f60bce9..1232f63278eb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -631,7 +631,7 @@ static int iwl_mvm_tzone_get_temp(struct thermal_zone_device *device,
 
 	if (!iwl_mvm_firmware_running(mvm) ||
 	    mvm->fwrt.cur_fw_img != IWL_UCODE_REGULAR) {
-		ret = -EIO;
+		ret = -ENODATA;
 		goto out;
 	}
 
-- 
2.14.1
