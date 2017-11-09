Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:52437 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755327AbdKIXi5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 18:38:57 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Gnedt <david.gnedt@davizone.at>,
        Michal Kazior <michal.kazior@tieto.com>,
        Daniel Wagner <wagi@monom.org>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v2 5/6] firmware: Add request_firmware_prefer_user() function
Date: Fri, 10 Nov 2017 00:38:27 +0100
Message-Id: <1510270708-14377-6-git-send-email-pali.rohar@gmail.com> (sfid-20171110_004044_017324_77AA6D70)
In-Reply-To: <1510270708-14377-1-git-send-email-pali.rohar@gmail.com>
References: <1482598381-16513-1-git-send-email-pali.rohar@gmail.com>
 <1510270708-14377-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function works pretty much like request_firmware(), but it prefer
usermode helper. If usermode helper fails then it fallback to direct
access. Useful for dynamic or model specific firmware data.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/base/firmware_class.c |   45 +++++++++++++++++++++++++++++++++++++++--
 include/linux/firmware.h      |    9 +++++++++
 2 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 4b57cf5..c3a9fe5 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -195,6 +195,11 @@ static int __fw_state_check(struct fw_state *fw_st, enum fw_status status)
 #endif
 #define FW_OPT_NO_WARN	(1U << 3)
 #define FW_OPT_NOCACHE	(1U << 4)
+#ifdef CONFIG_FW_LOADER_USER_HELPER
+#define FW_OPT_PREFER_USER	(1U << 5)
+#else
+#define FW_OPT_PREFER_USER	0
+#endif
 
 struct firmware_cache {
 	/* firmware_buf instance will be added into the below list */
@@ -1214,13 +1219,26 @@ static void fw_abort_batch_reqs(struct firmware *fw)
 	if (ret <= 0) /* error or already assigned */
 		goto out;
 
-	ret = fw_get_filesystem_firmware(device, fw->priv);
+	if (opt_flags & FW_OPT_PREFER_USER) {
+		ret = fw_load_from_user_helper(fw, name, device, opt_flags, timeout);
+		if (ret && !(opt_flags & FW_OPT_NO_WARN)) {
+			dev_warn(device,
+				 "User helper firmware load for %s failed with error %d\n",
+				 name, ret);
+			dev_warn(device, "Falling back to direct firmware load\n");
+		}
+	} else {
+		ret = -EINVAL;
+	}
+
+	if (ret)
+		ret = fw_get_filesystem_firmware(device, fw->priv);
 	if (ret) {
 		if (!(opt_flags & FW_OPT_NO_WARN))
 			dev_warn(device,
 				 "Direct firmware load for %s failed with error %d\n",
 				 name, ret);
-		if (opt_flags & FW_OPT_USERHELPER) {
+		if ((opt_flags & FW_OPT_USERHELPER) && !(opt_flags & FW_OPT_PREFER_USER)) {
 			dev_warn(device, "Falling back to user helper\n");
 			ret = fw_load_from_user_helper(fw, name, device,
 						       opt_flags);
@@ -1329,6 +1347,29 @@ int request_firmware_direct(const struct firmware **firmware_p,
 EXPORT_SYMBOL(request_firmware_into_buf);
 
 /**
+ * request_firmware_prefer_user: - prefer usermode helper for loading firmware
+ * @firmware_p: pointer to firmware image
+ * @name: name of firmware file
+ * @device: device for which firmware is being loaded
+ *
+ * This function works pretty much like request_firmware(), but it prefer
+ * usermode helper. If usermode helper fails then it fallback to direct access.
+ * Useful for dynamic or model specific firmware data.
+ **/
+int request_firmware_prefer_user(const struct firmware **firmware_p,
+			    const char *name, struct device *device)
+{
+	int ret;
+
+	__module_get(THIS_MODULE);
+	ret = _request_firmware(firmware_p, name, device, NULL, 0,
+				FW_OPT_UEVENT | FW_OPT_PREFER_USER);
+	module_put(THIS_MODULE);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(request_firmware_prefer_user);
+
+/**
  * release_firmware: - release the resource associated with a firmware image
  * @fw: firmware resource to release
  **/
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index d450808..8584528 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -48,6 +48,8 @@ int request_firmware_nowait(
 	void (*cont)(const struct firmware *fw, void *context));
 int request_firmware_direct(const struct firmware **fw, const char *name,
 			    struct device *device);
+int request_firmware_prefer_user(const struct firmware **fw, const char *name,
+				 struct device *device);
 int request_firmware_into_buf(const struct firmware **firmware_p,
 	const char *name, struct device *device, void *buf, size_t size);
 
@@ -78,6 +80,13 @@ static inline int request_firmware_direct(const struct firmware **fw,
 	return -EINVAL;
 }
 
+static inline int request_firmware_prefer_user(const struct firmware **fw,
+					       const char *name,
+					       struct device *device)
+{
+	return -EINVAL;
+}
+
 static inline int request_firmware_into_buf(const struct firmware **firmware_p,
 	const char *name, struct device *device, void *buf, size_t size)
 {
-- 
1.7.9.5
