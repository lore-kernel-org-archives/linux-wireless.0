Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34056 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbbEFA5g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 20:57:36 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: rusty@rustcorp.com.au, dhowells@redhat.com, ming.lei@canonical.com,
	seth.forshee@canonical.com, kyle@kernel.org
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	keescook@chromium.org, casey@schaufler-ca.com, tiwai@suse.de,
	mjg59@srcf.ucam.org, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org, jlee@suse.com,
	linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v1 05/12] firmware: add firmware signature checking support
Date: Tue,  5 May 2015 17:44:23 -0700
Message-Id: <1430873070-7290-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20150506_025753_552525_F653D17D)
In-Reply-To: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Systems that have module signing currently enabled may
wish to extend vetting of firmware passed to the kernel
as well. We can re-use most of the code for module signing
for firmware signature verification and signing. This will
also later enable re-use of this same code for subsystems
that wish to provide their own cryptographic verification
mechanisms on userspace data needed.

As with module signing, we do a very simple search for a
particular string appended to the firmware. There's both a
config option and a boot parameter which control whether we
accept or fail with unsigned firmware and firmware that are
signed with an unknown key.

If firmware signing is enabled, the kernel will be tainted
if a firmware is loaded that is unsigned or has a signature
for which we don't have the key.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: Kyle McMartin <kyle@kernel.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/base/Kconfig                               | 16 +++++++
 drivers/base/firmware_class.c                      | 52 +++++++++++++++++++++-
 include/linux/firmware.h                           |  1 +
 .../sysdata-internal.h => include/linux/sysdata.h  |  1 +
 kernel/module.c                                    |  2 +-
 kernel/sysdata_signing.c                           |  3 +-
 kernel/system_keyring.c                            |  2 +-
 scripts/sign-file                                  | 20 ++++++---
 8 files changed, 87 insertions(+), 10 deletions(-)
 rename kernel/sysdata-internal.h => include/linux/sysdata.h (87%)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 98504ec..a831772 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -85,6 +85,22 @@ config FW_LOADER
 	  require userspace firmware loading support, but a module built
 	  out-of-tree does.
 
+config FIRMWARE_SIG
+	bool "Firmware signature verification"
+	depends on FW_LOADER
+	select SYSDATA_SIG
+	help
+	  Check firmware files for valid signatures upon load: the signature
+	  is simply appended to the firmware. For more information see
+	  Documentation/firmware-signing.txt.
+
+config FIRMWARE_SIG_FORCE
+	bool "Require all firmware to be validly signed"
+	depends on FIRMWARE_SIG
+	help
+	  Reject unsigned files or signed files for which we don't have a
+	  key.  Without this, such firmware files will simply taint the kernel.
+
 config FIRMWARE_IN_KERNEL
 	bool "Include in-kernel firmware blobs in kernel binary"
 	depends on FW_LOADER
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 2e85860..65fcf2d 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -29,6 +29,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/reboot.h>
 #include <linux/security.h>
+#include <linux/sysdata.h>
 
 #include <generated/utsrelease.h>
 
@@ -38,6 +39,11 @@ MODULE_AUTHOR("Manuel Estrada Sainz");
 MODULE_DESCRIPTION("Multi purpose firmware loading support");
 MODULE_LICENSE("GPL");
 
+static bool fw_sig_enforce = IS_ENABLED(CONFIG_FIRMWARE_SIG_FORCE);
+#ifndef CONFIG_FIRMWARE_SIG_FORCE
+module_param(fw_sig_enforce, bool_enable_only, 0644);
+#endif /* !CONFIG_FIRMWARE_SIG_FORCE */
+
 /* Builtin firmware support */
 
 #ifdef CONFIG_FW_LOADER
@@ -142,6 +148,7 @@ struct firmware_buf {
 	unsigned long status;
 	void *data;
 	size_t size;
+	bool sig_ok;
 #ifdef CONFIG_FW_LOADER_USER_HELPER
 	bool is_paged_buf;
 	bool need_uevent;
@@ -378,12 +385,50 @@ static void fw_set_page_data(struct firmware_buf *buf, struct firmware *fw)
 #endif
 	fw->size = buf->size;
 	fw->data = buf->data;
+	fw->sig_ok = buf->sig_ok;
 
-	pr_debug("%s: fw-%s buf=%p data=%p size=%u\n",
+	pr_debug("%s: fw-%s buf=%p data=%p size=%u sig_ok=%d\n",
 		 __func__, buf->fw_id, buf, buf->data,
-		 (unsigned int)buf->size);
+		 (unsigned int)buf->size, buf->sig_ok);
 }
 
+#ifdef CONFIG_FIRMWARE_SIG
+static int firmware_sig_check(struct firmware *fw)
+{
+	int err = -ENOKEY;
+	const unsigned long markerlen = sizeof(SYSDATA_SIG_STRING) - 1;
+	struct firmware_buf *buf = fw->priv;
+	const void *data = buf->data;
+
+	if (buf->size > markerlen &&
+	    memcmp(data + buf->size - markerlen, SYSDATA_SIG_STRING, markerlen) == 0) {
+		/* We truncate the firmware to discard the signature */
+		buf->size -= markerlen;
+		err = sysdata_verify_sig(data, &buf->size);
+	}
+
+	if (!err) {
+		buf->sig_ok = true;
+		fw_set_page_data(buf, fw);
+		return 0;
+	}
+
+	/* Not having a signature is only an error if we're strict. */
+	if (err == -ENOKEY && !fw_sig_enforce)
+		err = 0;
+
+	fw_set_page_data(buf, fw);
+
+	return err;
+}
+#else /* !CONFIG_FIRMWARE_SIG */
+static int firmware_sig_check(struct firmware *fw)
+{
+	return 0;
+}
+#endif /* !CONFIG_MODULE_SIG */
+
+
 #ifdef CONFIG_PM_SLEEP
 static void fw_name_devm_release(struct device *dev, void *res)
 {
@@ -1137,6 +1182,9 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	usermodehelper_read_unlock();
 
  out:
+	if (ret >= 0)
+		ret = firmware_sig_check(fw);
+
 	if (ret < 0) {
 		release_firmware(fw);
 		fw = NULL;
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 5c41c5e..d814102 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -11,6 +11,7 @@
 struct firmware {
 	size_t size;
 	const u8 *data;
+	bool sig_ok;
 	struct page **pages;
 
 	/* firmware loader private fields */
diff --git a/kernel/sysdata-internal.h b/include/linux/sysdata.h
similarity index 87%
rename from kernel/sysdata-internal.h
rename to include/linux/sysdata.h
index 0aa573e..b40b873 100644
--- a/kernel/sysdata-internal.h
+++ b/include/linux/sysdata.h
@@ -10,3 +10,4 @@
  */
 
 extern int sysdata_verify_sig(const void *data, unsigned long *_len);
+#define SYSDATA_SIG_STRING "~System data signature appended~\n"
diff --git a/kernel/module.c b/kernel/module.c
index eb61c10..1dda9749 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -59,8 +59,8 @@
 #include <linux/jump_label.h>
 #include <linux/pfn.h>
 #include <linux/bsearch.h>
+#include <linux/sysdata.h>
 #include <uapi/linux/module.h>
-#include "sysdata-internal.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
diff --git a/kernel/sysdata_signing.c b/kernel/sysdata_signing.c
index 8ba09aa..8179f8e 100644
--- a/kernel/sysdata_signing.c
+++ b/kernel/sysdata_signing.c
@@ -11,11 +11,11 @@
 
 #include <linux/kernel.h>
 #include <linux/err.h>
+#include <linux/sysdata.h>
 #include <crypto/public_key.h>
 #include <crypto/hash.h>
 #include <keys/asymmetric-type.h>
 #include <keys/system_keyring.h>
-#include "sysdata-internal.h"
 
 /*
  * System Data signature information block.
@@ -248,3 +248,4 @@ error_put_key:
 	pr_devel("<==%s() = %d\n", __func__, ret);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(sysdata_verify_sig);
diff --git a/kernel/system_keyring.c b/kernel/system_keyring.c
index 1eb0c86..a0b8653 100644
--- a/kernel/system_keyring.c
+++ b/kernel/system_keyring.c
@@ -14,9 +14,9 @@
 #include <linux/sched.h>
 #include <linux/cred.h>
 #include <linux/err.h>
+#include <linux/sysdata.h>
 #include <keys/asymmetric-type.h>
 #include <keys/system_keyring.h>
-#include "sysdata-internal.h"
 
 struct key *system_trusted_keyring;
 EXPORT_SYMBOL_GPL(system_trusted_keyring);
diff --git a/scripts/sign-file b/scripts/sign-file
index 3906ee1..dd7ef57 100755
--- a/scripts/sign-file
+++ b/scripts/sign-file
@@ -4,20 +4,24 @@
 #
 
 my $USAGE =
-"Usage: scripts/sign-file [-v] <hash algo> <key> <x509> <module> [<dest>]\n" .
-"       scripts/sign-file [-v] -s <raw sig> <hash algo> <x509> <module> [<dest>]\n";
+"Usage: scripts/sign-file [-v] [-d] <hash algo> <key> <x509> <module> [<dest>]\n" .
+"       scripts/sign-file [-v] [-d] -s <raw sig> <hash algo> <x509> <module> [<dest>]\n";
 
 use strict;
 use FileHandle;
 use IPC::Open2;
 use Getopt::Std;
 
+my $module_magic_number = "~Module signature appended~\n";
+my $system_magic_number = "~System data signature appended~\n";
+
 my %opts;
-getopts('vs:', \%opts) or die $USAGE;
+getopts('vds:', \%opts) or die $USAGE;
 my $verbose = $opts{'v'};
+my $system_data = $opts{'d'};
 my $signature_file = $opts{'s'};
 
-die $USAGE if ($#ARGV > 4);
+die $USAGE if ($#ARGV > 5);
 die $USAGE if (!$signature_file && $#ARGV < 3 || $signature_file && $#ARGV < 2);
 
 my $dgst = shift @ARGV;
@@ -385,7 +389,13 @@ $signature = pack("n", length($signature)) . $signature,
 #
 my $unsigned_module = read_file($module);
 
-my $magic_number = "~Module signature appended~\n";
+my $magic_number = "";
+
+if ($system_data) {
+	$magic_number = $system_magic_number;
+} else {
+	$magic_number = $module_magic_number;
+}
 
 my $info = pack("CCCCCxxxN",
 		$algo, $hash, $id_type,
-- 
2.3.2.209.gd67f9d5.dirty

