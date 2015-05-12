Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35605 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013AbbELSjq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 14:39:46 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: ming.lei@canonical.com, rusty@rustcorp.com.au
Cc: dhowells@redhat.com, seth.forshee@canonical.com,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	pebolle@tiscali.nl, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Kyle McMartin <kyle@kernel.org>
Subject: [PATCH v2 3/5] firmware: check for possible file truncation early
Date: Tue, 12 May 2015 11:30:55 -0700
Message-Id: <1431455457-25322-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20150512_204024_363772_86256155)
In-Reply-To: <1431455457-25322-1-git-send-email-mcgrof@do-not-panic.com>
References: <1431455457-25322-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Instead of waiting until the last second to fail
on a request_firmware*() calls due to filename
truncation we can do an early check upon boot
and immediatley avoid any possible issues upfront.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>
Cc: Kyle McMartin <kyle@kernel.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/base/firmware_class.c | 49 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 99385fc..448388b 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -38,6 +38,20 @@ MODULE_AUTHOR("Manuel Estrada Sainz");
 MODULE_DESCRIPTION("Multi purpose firmware loading support");
 MODULE_LICENSE("GPL");
 
+static size_t __read_mostly max_sysdata_path_size;
+
+static int sysdata_validate_filename(const char *name)
+{
+	if (!name)
+		return -EINVAL;
+	/* POSIX.1 2.4: an empty pathname is invalid, match other checks */
+	if (name[0] == '\0')
+		return -ENOENT;
+	if (strlen(name) > (PATH_MAX - max_sysdata_path_size))
+		return -ENAMETOOLONG;
+	return 0;
+}
+
 /* Builtin firmware support */
 
 #ifdef CONFIG_FW_LOADER
@@ -1105,9 +1119,6 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	if (!firmware_p)
 		return -EINVAL;
 
-	if (!name || name[0] == '\0')
-		return -EINVAL;
-
 	ret = _request_firmware_prepare(&fw, name, device);
 	if (ret <= 0) /* error or already assigned */
 		goto out;
@@ -1185,6 +1196,10 @@ request_firmware(const struct firmware **firmware_p, const char *name,
 {
 	int ret;
 
+	ret = sysdata_validate_filename(name);
+	if (ret)
+		return ret;
+
 	/* Need to pin this module until return */
 	__module_get(THIS_MODULE);
 	ret = _request_firmware(firmware_p, name, device,
@@ -1210,6 +1225,10 @@ int request_firmware_direct(const struct firmware **firmware_p,
 {
 	int ret;
 
+	ret = sysdata_validate_filename(name);
+	if (ret)
+		return ret;
+
 	__module_get(THIS_MODULE);
 	ret = _request_firmware(firmware_p, name, device,
 				FW_OPT_UEVENT | FW_OPT_NO_WARN);
@@ -1288,8 +1307,13 @@ request_firmware_nowait(
 	const char *name, struct device *device, gfp_t gfp, void *context,
 	void (*cont)(const struct firmware *fw, void *context))
 {
+	int ret;
 	struct firmware_work *fw_work;
 
+	ret = sysdata_validate_filename(name);
+	if (ret)
+		return ret;
+
 	fw_work = kzalloc(sizeof(struct firmware_work), gfp);
 	if (!fw_work)
 		return -ENOMEM;
@@ -1668,8 +1692,27 @@ static void __init fw_cache_init(void)
 #endif
 }
 
+static size_t __init get_max_sysdata_path(void)
+{
+	size_t max_size = 0;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
+		size_t path_size;
+		/* skip the unset customized path */
+		if (!fw_path[i][0])
+			continue;
+		path_size = strlen(fw_path[i]);
+		if (path_size > max_size)
+			max_size = path_size;
+	}
+
+	return max_size;
+}
+
 static int __init firmware_class_init(void)
 {
+	max_sysdata_path_size = get_max_sysdata_path();
 	fw_cache_init();
 #ifdef CONFIG_FW_LOADER_USER_HELPER
 	register_reboot_notifier(&fw_shutdown_nb);
-- 
2.3.2.209.gd67f9d5.dirty

