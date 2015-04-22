Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33234 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758303AbbDVWED (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2015 18:04:03 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: rusty@rustcorp.com.au
Cc: akpm@linux-foundation.org, mingo@kernel.org, tj@kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	keescook@chromium.org, casey@schaufler-ca.com,
	cocci@systeme.lip6.fr, "Luis R. Rodriguez" <mcgrof@suse.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH v2 3/8] kernel/params.c: generalize bool_enable_only
Date: Wed, 22 Apr 2015 14:55:06 -0700
Message-Id: <1429739711-9415-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20150423_000408_061917_801B1EA8)
In-Reply-To: <1429739711-9415-1-git-send-email-mcgrof@do-not-panic.com>
References: <1429739711-9415-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This takes out the bool_enable_only implementation from
the module loading code and generalizes it so that others
can make use of it.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: cocci@systeme.lip6.fr
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 include/linux/moduleparam.h |  6 ++++++
 kernel/module.c             | 31 -------------------------------
 kernel/params.c             | 30 ++++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 5d0f4d9..7e00799 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -427,6 +427,12 @@ extern int param_set_bool(const char *val, const struct kernel_param *kp);
 extern int param_get_bool(char *buffer, const struct kernel_param *kp);
 #define param_check_bool(name, p) __param_check(name, p, bool)
 
+extern const struct kernel_param_ops param_ops_bool_enable_only;
+extern int param_set_bool_enable_only(const char *val,
+				      const struct kernel_param *kp);
+/* getter is the same as for the regular bool */
+#define param_check_bool_enable_only param_check_bool
+
 extern const struct kernel_param_ops param_ops_invbool;
 extern int param_set_invbool(const char *val, const struct kernel_param *kp);
 extern int param_get_invbool(char *buffer, const struct kernel_param *kp);
diff --git a/kernel/module.c b/kernel/module.c
index de12c4a..43a1ef3 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -111,37 +111,6 @@ static bool sig_enforce = true;
 #else
 static bool sig_enforce = false;
 
-static int param_set_bool_enable_only(const char *val,
-				      const struct kernel_param *kp)
-{
-	int err = 0;
-	bool new_value;
-	bool orig_value = *(bool *)kp->arg;
-	struct kernel_param dummy_kp = *kp;
-
-	dummy_kp.arg = &new_value;
-
-	err = param_set_bool(val, &dummy_kp);
-	if (err)
-		return err;
-
-	/* Don't let them unset it once it's set! */
-	if (!new_value && orig_value)
-		return -EROFS;
-
-	if (new_value)
-		err = param_set_bool(val, kp);
-
-	return err;
-}
-
-static const struct kernel_param_ops param_ops_bool_enable_only = {
-	.flags = KERNEL_PARAM_OPS_FL_NOARG,
-	.set = param_set_bool_enable_only,
-	.get = param_get_bool,
-};
-#define param_check_bool_enable_only param_check_bool
-
 module_param(sig_enforce, bool_enable_only, 0644);
 #endif /* !CONFIG_MODULE_SIG_FORCE */
 #endif /* CONFIG_MODULE_SIG */
diff --git a/kernel/params.c b/kernel/params.c
index b7635c0..324624e 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -335,6 +335,36 @@ const struct kernel_param_ops param_ops_bool = {
 };
 EXPORT_SYMBOL(param_ops_bool);
 
+int param_set_bool_enable_only(const char *val, const struct kernel_param *kp)
+{
+	int err = 0;
+	bool new_value;
+	bool orig_value = *(bool *)kp->arg;
+	struct kernel_param dummy_kp = *kp;
+
+	dummy_kp.arg = &new_value;
+
+	err = param_set_bool(val, &dummy_kp);
+	if (err)
+		return err;
+
+	/* Don't let them unset it once it's set! */
+	if (!new_value && orig_value)
+		return -EROFS;
+
+	if (new_value)
+		err = param_set_bool(val, kp);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(param_set_bool_enable_only);
+
+const struct kernel_param_ops param_ops_bool_enable_only = {
+	.flags = KERNEL_PARAM_OPS_FL_NOARG,
+	.set = param_set_bool_enable_only,
+	.get = param_get_bool,
+};
+
 /* This one must be bool. */
 int param_set_invbool(const char *val, const struct kernel_param *kp)
 {
-- 
2.3.2.209.gd67f9d5.dirty

