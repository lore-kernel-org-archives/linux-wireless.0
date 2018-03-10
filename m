Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751216AbeCJOPW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 09:15:22 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, cantabile.desu@gmail.com,
        kubakici@wp.pl, linux-wireless@vger.kernel.org,
        keescook@chromium.org, shuah@kernel.org, mfuzzey@parkeon.com,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        pali.rohar@gmail.com, tiwai@suse.de, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        bjorn.andersson@linaro.org, jewalt@lgsinnovations.com,
        oneukum@suse.com, ast@fb.com, andresx7@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v3 07/20] firmware: move loading timeout under struct firmware_fallback_config
Date: Sat, 10 Mar 2018 06:14:48 -0800
Message-Id: <20180310141501.2214-8-mcgrof@kernel.org> (sfid-20180310_152037_469065_896D7058)
In-Reply-To: <20180310141501.2214-1-mcgrof@kernel.org>
References: <20180310141501.2214-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The timeout is a fallback construct, so we can just stuff the
timeout configuration under struct firmware_fallback_config.

While at it, add a few helpers which vets the use of getting or
setting the timeout as an int. The main use of the timeout is
to set a timeout for completion, and that is used as an unsigned
long. There a few cases however where it makes sense to get or
set the timeout as an int, the helpers annotate these use cases
have been properly vetted for.

Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/base/firmware_loader.c | 46 ++++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 13 deletions(-)

diff --git a/drivers/base/firmware_loader.c b/drivers/base/firmware_loader.c
index 2d819875348d..9757f9fff01e 100644
--- a/drivers/base/firmware_loader.c
+++ b/drivers/base/firmware_loader.c
@@ -266,21 +266,38 @@ static inline bool fw_state_is_aborted(struct fw_priv *fw_priv)
  *
  * @force_sysfs_fallback: force the sysfs fallback mechanism to be used
  * 	as if one had enabled CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y.
+ * @old_timeout: for internal use
+ * @loading_timeout: the timeout to wait for the fallback mechanism before
+ * 	giving up, in seconds.
  */
 struct firmware_fallback_config {
-	bool force_sysfs_fallback;
+	const bool force_sysfs_fallback;
+	int old_timeout;
+	int loading_timeout;
 };
 
-static const struct firmware_fallback_config fw_fallback_config = {
+static struct firmware_fallback_config fw_fallback_config = {
 	.force_sysfs_fallback = IS_ENABLED(CONFIG_FW_LOADER_USER_HELPER_FALLBACK),
+	.loading_timeout = 60,
+	.old_timeout = 60,
 };
 
-static int old_timeout;
-static int loading_timeout = 60;	/* In seconds */
+/* These getters are vetted to use int properly */
+static inline int __firmware_loading_timeout(void)
+{
+	return fw_fallback_config.loading_timeout;
+}
+
+/* These setters are vetted to use int properly */
+static void __fw_fallback_set_timeout(int timeout)
+{
+	fw_fallback_config.loading_timeout = timeout;
+}
 
 static inline long firmware_loading_timeout(void)
 {
-	return loading_timeout > 0 ? loading_timeout * HZ : MAX_JIFFY_OFFSET;
+	return __firmware_loading_timeout() > 0 ?
+		__firmware_loading_timeout() * HZ : MAX_JIFFY_OFFSET;
 }
 
 /*
@@ -291,14 +308,14 @@ static inline long firmware_loading_timeout(void)
  */
 static void fw_fallback_set_cache_timeout(void)
 {
-	old_timeout = loading_timeout;
-	loading_timeout = 10;
+	fw_fallback_config.old_timeout = __firmware_loading_timeout();
+	__fw_fallback_set_timeout(10);
 }
 
 /* Restores the timeout to the value last configured during normal operation */
 static void fw_fallback_set_default_timeout(void)
 {
-	loading_timeout =  old_timeout;
+	__fw_fallback_set_timeout(fw_fallback_config.old_timeout);
 }
 
 static inline bool fw_sysfs_done(struct fw_priv *fw_priv)
@@ -677,7 +694,7 @@ static void kill_pending_fw_fallback_reqs(bool only_kill_custom)
 static ssize_t timeout_show(struct class *class, struct class_attribute *attr,
 			    char *buf)
 {
-	return sprintf(buf, "%d\n", loading_timeout);
+	return sprintf(buf, "%d\n", __firmware_loading_timeout());
 }
 
 /**
@@ -696,9 +713,12 @@ static ssize_t timeout_show(struct class *class, struct class_attribute *attr,
 static ssize_t timeout_store(struct class *class, struct class_attribute *attr,
 			     const char *buf, size_t count)
 {
-	loading_timeout = simple_strtol(buf, NULL, 10);
-	if (loading_timeout < 0)
-		loading_timeout = 0;
+	int tmp_loading_timeout = simple_strtol(buf, NULL, 10);
+
+	if (tmp_loading_timeout < 0)
+		tmp_loading_timeout = 0;
+
+	__fw_fallback_set_timeout(tmp_loading_timeout);
 
 	return count;
 }
@@ -721,7 +741,7 @@ static int do_firmware_uevent(struct fw_sysfs *fw_sysfs, struct kobj_uevent_env
 {
 	if (add_uevent_var(env, "FIRMWARE=%s", fw_sysfs->fw_priv->fw_name))
 		return -ENOMEM;
-	if (add_uevent_var(env, "TIMEOUT=%i", loading_timeout))
+	if (add_uevent_var(env, "TIMEOUT=%i", __firmware_loading_timeout()))
 		return -ENOMEM;
 	if (add_uevent_var(env, "ASYNC=%d", fw_sysfs->nowait))
 		return -ENOMEM;
-- 
2.16.2
