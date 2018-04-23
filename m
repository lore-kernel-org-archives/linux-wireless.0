Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:32796 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932480AbeDWUMQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 16:12:16 -0400
From: Andres Rodriguez <andresx7@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: andresx7@gmail.com, gregkh@linuxfoundation.org, mcgrof@kernel.org,
        alexdeucher@gmail.com, christian.koenig@amd.com,
        kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        hdegoede@redhat.com
Subject: [PATCH 1/9] firmware: some documentation fixes
Date: Mon, 23 Apr 2018 16:11:57 -0400
Message-Id: <20180423201205.20533-2-andresx7@gmail.com> (sfid-20180423_221437_037581_5E054D92)
In-Reply-To: <20180423201205.20533-1-andresx7@gmail.com>
References: <20180423201205.20533-1-andresx7@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Including:
 - Fixup outdated kernel-doc paths
 - Slightly too short title underline
 - Some typos

Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
---
 Documentation/driver-api/firmware/request_firmware.rst | 16 ++++++++--------
 drivers/base/firmware_loader/fallback.c                |  4 ++--
 drivers/base/firmware_loader/fallback.h                |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/driver-api/firmware/request_firmware.rst b/Documentation/driver-api/firmware/request_firmware.rst
index 9305bf4db38e..7632f8807472 100644
--- a/Documentation/driver-api/firmware/request_firmware.rst
+++ b/Documentation/driver-api/firmware/request_firmware.rst
@@ -17,17 +17,17 @@ an error is returned.
 
 firmware_request
 ----------------
-.. kernel-doc:: drivers/base/firmware_class.c
+.. kernel-doc:: drivers/base/firmware_loader/main.c
    :functions: firmware_request
 
 firmware_request_direct
 -----------------------
-.. kernel-doc:: drivers/base/firmware_class.c
+.. kernel-doc:: drivers/base/firmware_loader/main.c
    :functions: firmware_request_direct
 
 firmware_request_into_buf
 -------------------------
-.. kernel-doc:: drivers/base/firmware_class.c
+.. kernel-doc:: drivers/base/firmware_loader/main.c
    :functions: firmware_request_into_buf
 
 Asynchronous firmware requests
@@ -41,7 +41,7 @@ in atomic contexts.
 
 firmware_request_nowait
 -----------------------
-.. kernel-doc:: drivers/base/firmware_class.c
+.. kernel-doc:: drivers/base/firmware_loader/main.c
    :functions: firmware_request_nowait
 
 Special optimizations on reboot
@@ -50,12 +50,12 @@ Special optimizations on reboot
 Some devices have an optimization in place to enable the firmware to be
 retained during system reboot. When such optimizations are used the driver
 author must ensure the firmware is still available on resume from suspend,
-this can be done with firmware_request_cache() insted of requesting for the
-firmare to be loaded.
+this can be done with firmware_request_cache() instead of requesting for the
+firmware to be loaded.
 
 firmware_request_cache()
------------------------
-.. kernel-doc:: drivers/base/firmware_class.c
+------------------------
+.. kernel-doc:: drivers/base/firmware_loader/main.c
    :functions: firmware_request_cache
 
 request firmware API expected driver use
diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
index 71f529de5243..da97fc26119c 100644
--- a/drivers/base/firmware_loader/fallback.c
+++ b/drivers/base/firmware_loader/fallback.c
@@ -536,8 +536,8 @@ fw_create_instance(struct firmware *firmware, const char *fw_name,
 }
 
 /**
- * fw_load_sysfs_fallback - load a firmware via the syfs fallback mechanism
- * @fw_sysfs: firmware syfs information for the firmware to load
+ * fw_load_sysfs_fallback - load a firmware via the sysfs fallback mechanism
+ * @fw_sysfs: firmware sysfs information for the firmware to load
  * @opt_flags: flags of options, FW_OPT_*
  * @timeout: timeout to wait for the load
  *
diff --git a/drivers/base/firmware_loader/fallback.h b/drivers/base/firmware_loader/fallback.h
index dfebc644ed35..f8255670a663 100644
--- a/drivers/base/firmware_loader/fallback.h
+++ b/drivers/base/firmware_loader/fallback.h
@@ -6,7 +6,7 @@
 #include <linux/device.h>
 
 /**
- * struct firmware_fallback_config - firmware fallback configuratioon settings
+ * struct firmware_fallback_config - firmware fallback configuration settings
  *
  * Helps describe and fine tune the fallback mechanism.
  *
-- 
2.14.1
