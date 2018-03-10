Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932459AbeCJOP1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 09:15:27 -0500
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
Subject: [PATCH v3 11/20] firmware: enable to force disable the fallback mechanism at run time
Date: Sat, 10 Mar 2018 06:14:52 -0800
Message-Id: <20180310141501.2214-12-mcgrof@kernel.org> (sfid-20180310_151805_220106_469D8B33)
In-Reply-To: <20180310141501.2214-1-mcgrof@kernel.org>
References: <20180310141501.2214-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You currently need four different kernel builds to test the firmware
API fully. By adding a proc knob to force disable the fallback mechanism
completely we are able to reduce the amount of kernels you need built
to test the firmware API down to two.

Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 drivers/base/firmware_loader/fallback.c       | 5 +++++
 drivers/base/firmware_loader/fallback.h       | 4 ++++
 drivers/base/firmware_loader/fallback_table.c | 9 +++++++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
index 45cc40933a47..d6838e7ec00c 100644
--- a/drivers/base/firmware_loader/fallback.c
+++ b/drivers/base/firmware_loader/fallback.c
@@ -643,6 +643,11 @@ static bool fw_force_sysfs_fallback(unsigned int opt_flags)
 
 static bool fw_run_sysfs_fallback(unsigned int opt_flags)
 {
+	if (fw_fallback_config.ignore_sysfs_fallback) {
+		pr_info_once("Ignoring firmware sysfs fallback due to debugfs knob\n");
+		return false;
+	}
+
 	if ((opt_flags & FW_OPT_NOFALLBACK))
 		return false;
 
diff --git a/drivers/base/firmware_loader/fallback.h b/drivers/base/firmware_loader/fallback.h
index ca7e69a8417b..dfebc644ed35 100644
--- a/drivers/base/firmware_loader/fallback.h
+++ b/drivers/base/firmware_loader/fallback.h
@@ -14,12 +14,16 @@
  * 	as if one had enabled CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y.
  * 	Useful to help debug a CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
  * 	functionality on a kernel where that config entry has been disabled.
+ * @ignore_sysfs_fallback: force to disable the sysfs fallback mechanism.
+ * 	This emulates the behaviour as if we had set the kernel
+ * 	config CONFIG_FW_LOADER_USER_HELPER=n.
  * @old_timeout: for internal use
  * @loading_timeout: the timeout to wait for the fallback mechanism before
  * 	giving up, in seconds.
  */
 struct firmware_fallback_config {
 	unsigned int force_sysfs_fallback;
+	unsigned int ignore_sysfs_fallback;
 	int old_timeout;
 	int loading_timeout;
 };
diff --git a/drivers/base/firmware_loader/fallback_table.c b/drivers/base/firmware_loader/fallback_table.c
index 92365e053e30..7428659d8df9 100644
--- a/drivers/base/firmware_loader/fallback_table.c
+++ b/drivers/base/firmware_loader/fallback_table.c
@@ -39,6 +39,15 @@ struct ctl_table firmware_config_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+	{
+		.procname	= "ignore_sysfs_fallback",
+		.data		= &fw_fallback_config.ignore_sysfs_fallback,
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = proc_douintvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 	{ }
 };
 EXPORT_SYMBOL_GPL(firmware_config_table);
-- 
2.16.2
