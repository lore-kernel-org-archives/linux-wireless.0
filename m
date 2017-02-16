Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35836 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752186AbdBPH0y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Feb 2017 02:26:54 -0500
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Ming Lei <ming.lei@canonical.com>,
        "Luis R . Rodriguez" <mcgrof@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 1/2] firmware: add more flexible request_firmware_async function
Date: Thu, 16 Feb 2017 08:26:35 +0100
Message-Id: <20170216072636.7128-1-zajec5@gmail.com> (sfid-20170216_082732_627582_F09112E6)
In-Reply-To: <20170215222948.21030-1-zajec5@gmail.com>
References: <20170215222948.21030-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

So far we got only one function for loading firmware asynchronously:
request_firmware_nowait. It didn't allow much customization of firmware
loading process - there is only one bool uevent argument. Moreover this
bool also controls user helper in an unclear way.

Resolve this problem by adding a one flexible function and making old
request_firmware_nowait a simple inline using new solution. This
implementation:
1) Modifies only single bits on existing code
2) Doesn't require adjusting / rewriting current drivers
3) Adds new function for drivers that need more control over loading a
   firmware. Thanks to using flags more features can be added later.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
This patch is based on top of
[PATCH V2 RESEND] firmware: simplify defining and handling FW_OPT_FALLBACK
applied on top of Linux 4.10-rc8.

Ming/Luis/Greg: assuming this gets a positive review, could someone of you pick
this patchset? Second patch modifies brcmfmac, I'll try to get a proper Ack for
that one.
Unless you want this to go through wireless tree, then let me know please.
---
 drivers/base/firmware_class.c | 25 ++++++-------------------
 include/linux/firmware.h      | 34 +++++++++++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 24 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d05be1732c8b..7b3f0a018dc3 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -182,18 +182,6 @@ static int __fw_state_check(struct fw_state *fw_st, enum fw_status status)
 
 #endif /* CONFIG_FW_LOADER_USER_HELPER */
 
-/* firmware behavior options */
-#define FW_OPT_UEVENT	(1U << 0)
-#define FW_OPT_NOWAIT	(1U << 1)
-#ifdef CONFIG_FW_LOADER_USER_HELPER
-#define FW_OPT_USERHELPER	(1U << 2)
-#else
-#define FW_OPT_USERHELPER	0
-#endif
-#define FW_OPT_NO_WARN	(1U << 3)
-#define FW_OPT_NOCACHE	(1U << 4)
-#define FW_OPT_FALLBACK	(1U << 5)
-
 struct firmware_cache {
 	/* firmware_buf instance will be added into the below list */
 	spinlock_t lock;
@@ -1356,7 +1344,7 @@ static void request_firmware_work_func(struct work_struct *work)
 	_request_firmware(&fw, fw_work->name, fw_work->device, NULL, 0,
 			  fw_work->opt_flags);
 	fw_work->cont(fw, fw_work->context);
-	put_device(fw_work->device); /* taken in request_firmware_nowait() */
+	put_device(fw_work->device); /* taken in request_firmware_async() */
 
 	module_put(fw_work->module);
 	kfree_const(fw_work->name);
@@ -1364,7 +1352,7 @@ static void request_firmware_work_func(struct work_struct *work)
 }
 
 /**
- * request_firmware_nowait - asynchronous version of request_firmware
+ * request_firmware_async - asynchronous version of request_firmware
  * @module: module requesting the firmware
  * @uevent: sends uevent to copy the firmware image if this flag
  *	is non-zero else the firmware copy must be done manually.
@@ -1387,8 +1375,8 @@ static void request_firmware_work_func(struct work_struct *work)
  *		- can't sleep at all if @gfp is GFP_ATOMIC.
  **/
 int
-request_firmware_nowait(
-	struct module *module, bool uevent,
+request_firmware_async(
+	struct module *module, unsigned int opt_flags,
 	const char *name, struct device *device, gfp_t gfp, void *context,
 	void (*cont)(const struct firmware *fw, void *context))
 {
@@ -1407,8 +1395,7 @@ request_firmware_nowait(
 	fw_work->device = device;
 	fw_work->context = context;
 	fw_work->cont = cont;
-	fw_work->opt_flags = FW_OPT_NOWAIT | FW_OPT_FALLBACK |
-		(uevent ? FW_OPT_UEVENT : FW_OPT_USERHELPER);
+	fw_work->opt_flags = FW_OPT_NOWAIT | opt_flags;
 
 	if (!try_module_get(module)) {
 		kfree_const(fw_work->name);
@@ -1421,7 +1408,7 @@ request_firmware_nowait(
 	schedule_work(&fw_work->work);
 	return 0;
 }
-EXPORT_SYMBOL(request_firmware_nowait);
+EXPORT_SYMBOL(request_firmware_async);
 
 #ifdef CONFIG_PM_SLEEP
 static ASYNC_DOMAIN_EXCLUSIVE(fw_cache_domain);
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index b1f9f0ccb8ac..1f2bf14aa441 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -8,6 +8,18 @@
 #define FW_ACTION_NOHOTPLUG 0
 #define FW_ACTION_HOTPLUG 1
 
+/* firmware behavior options */
+#define FW_OPT_UEVENT	(1U << 0)
+#define FW_OPT_NOWAIT	(1U << 1)
+#ifdef CONFIG_FW_LOADER_USER_HELPER
+#define FW_OPT_USERHELPER	(1U << 2)
+#else
+#define FW_OPT_USERHELPER	0
+#endif
+#define FW_OPT_NO_WARN	(1U << 3)
+#define FW_OPT_NOCACHE	(1U << 4)
+#define FW_OPT_FALLBACK	(1U << 5)
+
 struct firmware {
 	size_t size;
 	const u8 *data;
@@ -41,8 +53,8 @@ struct builtin_fw {
 #if defined(CONFIG_FW_LOADER) || (defined(CONFIG_FW_LOADER_MODULE) && defined(MODULE))
 int request_firmware(const struct firmware **fw, const char *name,
 		     struct device *device);
-int request_firmware_nowait(
-	struct module *module, bool uevent,
+int request_firmware_async(
+	struct module *module, unsigned int opt_flags,
 	const char *name, struct device *device, gfp_t gfp, void *context,
 	void (*cont)(const struct firmware *fw, void *context));
 int request_firmware_direct(const struct firmware **fw, const char *name,
@@ -58,8 +70,8 @@ static inline int request_firmware(const struct firmware **fw,
 {
 	return -EINVAL;
 }
-static inline int request_firmware_nowait(
-	struct module *module, bool uevent,
+static inline int request_firmware_async(
+	struct module *module, unsigned int opt_flags,
 	const char *name, struct device *device, gfp_t gfp, void *context,
 	void (*cont)(const struct firmware *fw, void *context))
 {
@@ -82,6 +94,18 @@ static inline int request_firmware_into_buf(const struct firmware **firmware_p,
 {
 	return -EINVAL;
 }
-
 #endif
+
+static inline int request_firmware_nowait(
+	struct module *module, bool uevent,
+	const char *name, struct device *device, gfp_t gfp, void *context,
+	void (*cont)(const struct firmware *fw, void *context))
+{
+	unsigned int opt_flags = FW_OPT_FALLBACK |
+		(uevent ? FW_OPT_UEVENT : FW_OPT_USERHELPER);
+
+	return request_firmware_async(module, opt_flags, name, device, gfp,
+				      context, cont);
+}
+
 #endif
-- 
2.11.0
