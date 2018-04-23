Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:54864 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932507AbeDWUMW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 16:12:22 -0400
From: Andres Rodriguez <andresx7@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: andresx7@gmail.com, gregkh@linuxfoundation.org, mcgrof@kernel.org,
        alexdeucher@gmail.com, christian.koenig@amd.com,
        kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        hdegoede@redhat.com
Subject: [PATCH 5/9] firmware: add function to load firmware without warnings v5
Date: Mon, 23 Apr 2018 16:12:01 -0400
Message-Id: <20180423201205.20533-6-andresx7@gmail.com> (sfid-20180423_221501_999298_6CA8B38B)
In-Reply-To: <20180423201205.20533-1-andresx7@gmail.com>
References: <20180423201205.20533-1-andresx7@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the firmware loader only exposes one silent path for querying
optional firmware, and that is firmware_request_direct(). This function
also disables the fallback path, which might not always be the
desired behaviour. [0]

This patch introduces a variations of firmware_request() that enable the
caller to disable the undesired warning messages. This is equivalent to
adding FW_OPT_NO_WARN to the old behaviour.

v2: add header prototype, use updated opt_flags
v3: split debug message to separate patch
    added _nowait variant
    added documentation
v4: fix kernel-doc style
v5: drop _nowait for now, since we lack agreement on the API

[0]: https://git.kernel.org/linus/c0cc00f250e1

Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
---
 .../driver-api/firmware/request_firmware.rst       |  5 +++++
 drivers/base/firmware_loader/main.c                | 24 ++++++++++++++++++++++
 include/linux/firmware.h                           |  2 ++
 3 files changed, 31 insertions(+)

diff --git a/Documentation/driver-api/firmware/request_firmware.rst b/Documentation/driver-api/firmware/request_firmware.rst
index 7632f8807472..c8bddbdcfd10 100644
--- a/Documentation/driver-api/firmware/request_firmware.rst
+++ b/Documentation/driver-api/firmware/request_firmware.rst
@@ -20,6 +20,11 @@ firmware_request
 .. kernel-doc:: drivers/base/firmware_loader/main.c
    :functions: firmware_request
 
+firmware_request_nowarn
+-----------------------
+.. kernel-doc:: drivers/base/firmware_loader/main.c
+   :functions: firmware_request_nowarn
+
 firmware_request_direct
 -----------------------
 .. kernel-doc:: drivers/base/firmware_loader/main.c
diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index d028cd3257f7..58aaadf81e12 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -631,6 +631,30 @@ firmware_request(const struct firmware **firmware_p, const char *name,
 }
 EXPORT_SYMBOL(firmware_request);
 
+/**
+ * firmware_request_nowarn() - request for an optional fw module
+ * @firmware: pointer to firmware image
+ * @name: name of firmware file
+ * @device: device for which firmware is being loaded
+ *
+ * This function is similar in behaviour to firmware_request(), except
+ * it doesn't produce warning messages when the file is not found.
+ **/
+int
+firmware_request_nowarn(const struct firmware **firmware, const char *name,
+			struct device *device)
+{
+	int ret;
+
+	/* Need to pin this module until return */
+	__module_get(THIS_MODULE);
+	ret = _firmware_request(firmware, name, device, NULL, 0,
+				FW_OPT_UEVENT | FW_OPT_NO_WARN);
+	module_put(THIS_MODULE);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(firmware_request_nowarn);
+
 /**
  * firmware_request_direct() - load firmware directly without usermode helper
  * @firmware_p: pointer to firmware image
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index db8351a42405..a34e16f77f20 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -42,6 +42,8 @@ struct builtin_fw {
 #if defined(CONFIG_FW_LOADER) || (defined(CONFIG_FW_LOADER_MODULE) && defined(MODULE))
 int firmware_request(const struct firmware **fw, const char *name,
 		     struct device *device);
+int firmware_request_nowarn(const struct firmware **fw, const char *name,
+			    struct device *device);
 int firmware_request_nowait(
 	struct module *module, bool uevent,
 	const char *name, struct device *device, gfp_t gfp, void *context,
-- 
2.14.1
