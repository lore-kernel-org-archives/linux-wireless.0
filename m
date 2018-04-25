Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36338 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755474AbeDYQZs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 12:25:48 -0400
From: Andres Rodriguez <andresx7@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: andresx7@gmail.com, gregkh@linuxfoundation.org, mcgrof@kernel.org,
        alexdeucher@gmail.com, christian.koenig@amd.com,
        kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        hdegoede@redhat.com
Subject: [PATCH 1/2] firmware: some documentation fixes
Date: Wed, 25 Apr 2018 12:25:39 -0400
Message-Id: <20180425162540.11574-1-andresx7@gmail.com> (sfid-20180425_182627_940406_8D6DE163)
In-Reply-To: <20180425152617.GA5058@kroah.com>
References: <20180425152617.GA5058@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Including:
 - Fixup outdated kernel-doc paths
 - Slightly too short title underline
 - Some typos

Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
---

Hey Greg,

Here is the patch rebased on gregkh/driver-core-linus as requested.

Note that there is a patch by Hans de Goede <hdegoede@redhat.com> that contains
some of the path fixes as well.

I also included an extra patch to fix the htmldocs build. I think we are in time
to squash the fix into the offending commit.

Regards,
Andres

 Documentation/driver-api/firmware/request_firmware.rst | 6 +++---
 drivers/base/firmware_loader/fallback.c                | 4 ++--
 drivers/base/firmware_loader/fallback.h                | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/driver-api/firmware/request_firmware.rst b/Documentation/driver-api/firmware/request_firmware.rst
index 20f21ed427a5..d5ec95a7195b 100644
--- a/Documentation/driver-api/firmware/request_firmware.rst
+++ b/Documentation/driver-api/firmware/request_firmware.rst
@@ -50,11 +50,11 @@ Special optimizations on reboot
 Some devices have an optimization in place to enable the firmware to be
 retained during system reboot. When such optimizations are used the driver
 author must ensure the firmware is still available on resume from suspend,
-this can be done with firmware_request_cache() insted of requesting for the
-firmare to be loaded.
+this can be done with firmware_request_cache() instead of requesting for the
+firmware to be loaded.
 
 firmware_request_cache()
------------------------
+------------------------
 .. kernel-doc:: drivers/base/firmware_loader/main.c
    :functions: firmware_request_cache
 
diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
index 31b5015b59fe..358354148dec 100644
--- a/drivers/base/firmware_loader/fallback.c
+++ b/drivers/base/firmware_loader/fallback.c
@@ -537,8 +537,8 @@ fw_create_instance(struct firmware *firmware, const char *fw_name,
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
