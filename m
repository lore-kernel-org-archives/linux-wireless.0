Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932107AbeCJOP3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 09:15:29 -0500
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
Subject: [PATCH v3 13/20] test_firmware: test three firmware kernel configs using a proc knob
Date: Sat, 10 Mar 2018 06:14:54 -0800
Message-Id: <20180310141501.2214-14-mcgrof@kernel.org> (sfid-20180310_151654_811774_240F14DB)
In-Reply-To: <20180310141501.2214-1-mcgrof@kernel.org>
References: <20180310141501.2214-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we now have knobs to twiddle what used to be set on kernel
configurations we can build one base kernel configuration and modify
behaviour to mimic such kernel configurations to test them.

Provided you build a kernel with:

CONFIG_TEST_FIRMWARE=y
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y

We should now be able test all possible kernel configurations
when FW_LOADER=y. Note that when FW_LOADER=m we just don't provide
the built-in functionality of the built-in firmware.

If you're on an old kernel and either don't have /proc/config.gz
(CONFIG_IKCONFIG_PROC) or haven't enabled CONFIG_FW_LOADER_USER_HELPER
we cannot run these dynamic tests, so just run both scripts just
as we used to before making blunt assumptions about your setup
and requirements exactly as we did before.

Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 tools/testing/selftests/firmware/Makefile        |  2 +-
 tools/testing/selftests/firmware/fw_lib.sh       | 51 +++++++++++++++++
 tools/testing/selftests/firmware/fw_run_tests.sh | 70 ++++++++++++++++++++++++
 3 files changed, 122 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/firmware/fw_run_tests.sh

diff --git a/tools/testing/selftests/firmware/Makefile b/tools/testing/selftests/firmware/Makefile
index 1894d625af2d..826f38d5dd19 100644
--- a/tools/testing/selftests/firmware/Makefile
+++ b/tools/testing/selftests/firmware/Makefile
@@ -3,7 +3,7 @@
 # No binaries, but make sure arg-less "make" doesn't trigger "run_tests"
 all:
 
-TEST_PROGS := fw_filesystem.sh fw_fallback.sh
+TEST_PROGS := fw_run_tests.sh
 
 include ../lib.mk
 
diff --git a/tools/testing/selftests/firmware/fw_lib.sh b/tools/testing/selftests/firmware/fw_lib.sh
index e3cc4483fdba..98dceb847ba0 100755
--- a/tools/testing/selftests/firmware/fw_lib.sh
+++ b/tools/testing/selftests/firmware/fw_lib.sh
@@ -47,6 +47,34 @@ check_setup()
 {
 	HAS_FW_LOADER_USER_HELPER="$(kconfig_has CONFIG_FW_LOADER_USER_HELPER=y)"
 	HAS_FW_LOADER_USER_HELPER_FALLBACK="$(kconfig_has CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y)"
+	PROC_FW_IGNORE_SYSFS_FALLBACK="0"
+	PROC_FW_FORCE_SYSFS_FALLBACK="0"
+
+	if [ -z $PROC_SYS_DIR ]; then
+		PROC_SYS_DIR="/proc/sys/kernel"
+	fi
+
+	FW_PROC="${PROC_SYS_DIR}/firmware_config"
+	FW_FORCE_SYSFS_FALLBACK="$FW_PROC/force_sysfs_fallback"
+	FW_IGNORE_SYSFS_FALLBACK="$FW_PROC/ignore_sysfs_fallback"
+
+	if [ -f $FW_FORCE_SYSFS_FALLBACK ]; then
+		PROC_FW_FORCE_SYSFS_FALLBACK="$(cat $FW_FORCE_SYSFS_FALLBACK)"
+	fi
+
+	if [ -f $FW_IGNORE_SYSFS_FALLBACK ]; then
+		PROC_FW_IGNORE_SYSFS_FALLBACK="$(cat $FW_IGNORE_SYSFS_FALLBACK)"
+	fi
+
+	if [ "$PROC_FW_FORCE_SYSFS_FALLBACK" = "1" ]; then
+		HAS_FW_LOADER_USER_HELPER="yes"
+		HAS_FW_LOADER_USER_HELPER_FALLBACK="yes"
+	fi
+
+	if [ "$PROC_FW_IGNORE_SYSFS_FALLBACK" = "1" ]; then
+		HAS_FW_LOADER_USER_HELPER_FALLBACK="no"
+		HAS_FW_LOADER_USER_HELPER="no"
+	fi
 
 	if [ "$HAS_FW_LOADER_USER_HELPER" = "yes" ]; then
 	       OLD_TIMEOUT="$(cat /sys/class/firmware/timeout)"
@@ -76,6 +104,28 @@ setup_tmp_file()
 	fi
 }
 
+proc_set_force_sysfs_fallback()
+{
+	if [ -f $FW_FORCE_SYSFS_FALLBACK ]; then
+		echo -n $1 > $FW_FORCE_SYSFS_FALLBACK
+		check_setup
+	fi
+}
+
+proc_set_ignore_sysfs_fallback()
+{
+	if [ -f $FW_IGNORE_SYSFS_FALLBACK ]; then
+		echo -n $1 > $FW_IGNORE_SYSFS_FALLBACK
+		check_setup
+	fi
+}
+
+proc_restore_defaults()
+{
+	proc_set_force_sysfs_fallback 0
+	proc_set_ignore_sysfs_fallback 0
+}
+
 test_finish()
 {
 	if [ "$HAS_FW_LOADER_USER_HELPER" = "yes" ]; then
@@ -93,6 +143,7 @@ test_finish()
 	if [ -d $FWPATH ]; then
 		rm -rf "$FWPATH"
 	fi
+	proc_restore_defaults
 }
 
 kconfig_has()
diff --git a/tools/testing/selftests/firmware/fw_run_tests.sh b/tools/testing/selftests/firmware/fw_run_tests.sh
new file mode 100755
index 000000000000..06d638e9dc62
--- /dev/null
+++ b/tools/testing/selftests/firmware/fw_run_tests.sh
@@ -0,0 +1,70 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# This runs all known tests across all known possible configurations we could
+# emulate in one run.
+
+set -e
+
+TEST_DIR=$(dirname $0)
+source $TEST_DIR/fw_lib.sh
+
+export HAS_FW_LOADER_USER_HELPER=""
+export HAS_FW_LOADER_USER_HELPER_FALLBACK=""
+
+run_tests()
+{
+	proc_set_force_sysfs_fallback $1
+	proc_set_ignore_sysfs_fallback $2
+	$TEST_DIR/fw_filesystem.sh
+
+	proc_set_force_sysfs_fallback $1
+	proc_set_ignore_sysfs_fallback $2
+	$TEST_DIR/fw_fallback.sh
+}
+
+run_test_config_0001()
+{
+	echo "-----------------------------------------------------"
+	echo "Running kernel configuration test 1 -- rare"
+	echo "Emulates:"
+	echo "CONFIG_FW_LOADER=y"
+	echo "CONFIG_FW_LOADER_USER_HELPER=n"
+	echo "CONFIG_FW_LOADER_USER_HELPER_FALLBACK=n"
+	run_tests 0 1
+}
+
+run_test_config_0002()
+{
+	echo "-----------------------------------------------------"
+	echo "Running kernel configuration test 2 -- distro"
+	echo "Emulates:"
+	echo "CONFIG_FW_LOADER=y"
+	echo "CONFIG_FW_LOADER_USER_HELPER=y"
+	echo "CONFIG_FW_LOADER_USER_HELPER_FALLBACK=n"
+	proc_set_ignore_sysfs_fallback 0
+	run_tests 0 0
+}
+
+run_test_config_0003()
+{
+	echo "-----------------------------------------------------"
+	echo "Running kernel configuration test 3 -- android"
+	echo "Emulates:"
+	echo "CONFIG_FW_LOADER=y"
+	echo "CONFIG_FW_LOADER_USER_HELPER=y"
+	echo "CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y"
+	run_tests 1 0
+}
+
+check_mods
+check_setup
+
+if [ -f $FW_FORCE_SYSFS_FALLBACK ]; then
+	run_test_config_0001
+	run_test_config_0002
+	run_test_config_0003
+else
+	echo "Running basic kernel configuration, working with your config"
+	run_test
+fi
-- 
2.16.2
