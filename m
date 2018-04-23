Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:38432 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932306AbeDWUMT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 16:12:19 -0400
From: Andres Rodriguez <andresx7@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: andresx7@gmail.com, gregkh@linuxfoundation.org, mcgrof@kernel.org,
        alexdeucher@gmail.com, christian.koenig@amd.com,
        kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        hdegoede@redhat.com
Subject: [PATCH 3/9] firmware: add kernel-doc for enum fw_opt
Date: Mon, 23 Apr 2018 16:11:59 -0400
Message-Id: <20180423201205.20533-4-andresx7@gmail.com> (sfid-20180423_221403_842430_6FF972C6)
In-Reply-To: <20180423201205.20533-1-andresx7@gmail.com>
References: <20180423201205.20533-1-andresx7@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some basic definitions for the FW_OPT_* values

v2: Documentation corrections from Luis.

Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
---
 drivers/base/firmware_loader/firmware.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/base/firmware_loader/firmware.h b/drivers/base/firmware_loader/firmware.h
index b252bfa82295..a405d400a925 100644
--- a/drivers/base/firmware_loader/firmware.h
+++ b/drivers/base/firmware_loader/firmware.h
@@ -11,6 +11,26 @@
 
 #include <generated/utsrelease.h>
 
+/**
+ * enum fw_opt - options to control firmware loading behaviour
+ *
+ * @FW_OPT_UEVENT: Enables the fallback mechanism to send a kobject uevent
+ *                  when the firmware is not found. Userspace is in charge
+ *                  to load the firmware using the sysfs loading facility.
+ * @FW_OPT_NOWAIT: Used to describe the firmware request is asynchronous.
+ * @FW_OPT_USERHELPER: Enable the fallback mechanism, in case the direct
+ *                     filesystem lookup fails at finding the firmware.
+ *                     For details refer to fw_sysfs_fallback().
+ * @FW_OPT_NO_WARN: Quiet, avoid printing warning messages.
+ * @FW_OPT_NOCACHE: Disables firmware caching. Firmware caching is used to
+ *                  cache the firmware upon suspend, so that upon resume
+ *                  races against the firmware file lookup on storage is
+ *                  avoided. Used for calls where the file may be too
+ *                  big, or where the driver takes charge of its own firmware
+ *                  caching mechanism.
+ * @FW_OPT_NOFALLBACK: Disable the fallback mechanism. Takes precedence over
+ *                     &FW_OPT_UEVENT and &FW_OPT_USERHELPER.
+ */
 enum fw_opt {
 	FW_OPT_UEVENT =         BIT(0),
 	FW_OPT_NOWAIT =         BIT(1),
-- 
2.14.1
