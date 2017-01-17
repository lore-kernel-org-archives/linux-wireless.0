Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:36570 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751391AbdAQXYT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 18:24:19 -0500
Received: by mail-pf0-f181.google.com with SMTP id 189so65494706pfu.3
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2017 15:23:39 -0800 (PST)
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org
From: Jens Axboe <axboe@kernel.dk>
Subject: iwlwifi: fix kernel crash when unregistering thermal zone
Message-ID: <b6a2209c-1343-cbda-c6c2-ae5eb93148d3@kernel.dk> (sfid-20170118_002555_878589_D0C0E894)
Date: Tue, 17 Jan 2017 14:22:24 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A recent firmware change seems to have enabled thermal zones on the
iwlwifi driver. Unfortunately, my device fails when registering the
thermal zone. This doesn't stop the driver from attempting to unregister
the thermal zone at unload time, triggering a NULL pointer deference in
strlen() off the thermal_zone_device_unregister() path.

Don't unregister if name is NULL, for that case we failed registering.
Do the same for the cooling zone.

Signed-off-by: Jens Axboe <axboe@fb.com>

---

Would be great if this could go into the current series, as sometimes I
have to reload the driver. Right now I can't, since it crashes...

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index 63a051be832e..bec7d9c46087 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -843,8 +843,10 @@ static void iwl_mvm_thermal_zone_unregister(struct iwl_mvm *mvm)
 		return;
 
 	IWL_DEBUG_TEMP(mvm, "Thermal zone device unregister\n");
-	thermal_zone_device_unregister(mvm->tz_device.tzone);
-	mvm->tz_device.tzone = NULL;
+	if (mvm->tz_device.tzone) {
+		thermal_zone_device_unregister(mvm->tz_device.tzone);
+		mvm->tz_device.tzone = NULL;
+	}
 }
 
 static void iwl_mvm_cooling_device_unregister(struct iwl_mvm *mvm)
@@ -853,8 +855,10 @@ static void iwl_mvm_cooling_device_unregister(struct iwl_mvm *mvm)
 		return;
 
 	IWL_DEBUG_TEMP(mvm, "Cooling device unregister\n");
-	thermal_cooling_device_unregister(mvm->cooling_dev.cdev);
-	mvm->cooling_dev.cdev = NULL;
+	if (mvm->cooling_dev.cdev) {
+		thermal_cooling_device_unregister(mvm->cooling_dev.cdev);
+		mvm->cooling_dev.cdev = NULL;
+	}
 }
 #endif /* CONFIG_THERMAL */
