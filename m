Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932372AbeCJOP2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 09:15:28 -0500
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
Subject: [PATCH v3 12/20] test_firmware: expand on library with shared helpers
Date: Sat, 10 Mar 2018 06:14:53 -0800
Message-Id: <20180310141501.2214-13-mcgrof@kernel.org> (sfid-20180310_151700_849439_A6907E8E)
In-Reply-To: <20180310141501.2214-1-mcgrof@kernel.org>
References: <20180310141501.2214-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This expands our library with as many things we could find which
both scripts we use share.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 tools/testing/selftests/firmware/fw_fallback.sh   | 31 +++-----------
 tools/testing/selftests/firmware/fw_filesystem.sh | 41 +++---------------
 tools/testing/selftests/firmware/fw_lib.sh        | 52 +++++++++++++++++++++++
 3 files changed, 63 insertions(+), 61 deletions(-)

diff --git a/tools/testing/selftests/firmware/fw_fallback.sh b/tools/testing/selftests/firmware/fw_fallback.sh
index 323c921a2469..9337a0328627 100755
--- a/tools/testing/selftests/firmware/fw_fallback.sh
+++ b/tools/testing/selftests/firmware/fw_fallback.sh
@@ -6,30 +6,17 @@
 # won't find so that we can do the load ourself manually.
 set -e
 
+TEST_REQS_FW_SYSFS_FALLBACK="yes"
+TEST_REQS_FW_SET_CUSTOM_PATH="no"
 TEST_DIR=$(dirname $0)
 source $TEST_DIR/fw_lib.sh
 
 check_mods
+check_setup
+verify_reqs
+setup_tmp_file
 
-HAS_FW_LOADER_USER_HELPER=$(kconfig_has CONFIG_FW_LOADER_USER_HELPER=y)
-HAS_FW_LOADER_USER_HELPER_FALLBACK=$(kconfig_has CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y)
-
-if [ "$HAS_FW_LOADER_USER_HELPER" = "yes" ]; then
-       OLD_TIMEOUT=$(cat /sys/class/firmware/timeout)
-else
-	echo "usermode helper disabled so ignoring test"
-	exit 0
-fi
-
-FWPATH=$(mktemp -d)
-FW="$FWPATH/test-firmware.bin"
-
-test_finish()
-{
-	echo "$OLD_TIMEOUT" >/sys/class/firmware/timeout
-	rm -f "$FW"
-	rmdir "$FWPATH"
-}
+trap "test_finish" EXIT
 
 load_fw()
 {
@@ -168,12 +155,6 @@ load_fw_fallback_with_child()
 	return $RET
 }
 
-trap "test_finish" EXIT
-
-# This is an unlikely real-world firmware content. :)
-echo "ABCD0123" >"$FW"
-NAME=$(basename "$FW")
-
 test_syfs_timeout()
 {
 	DEVPATH="$DIR"/"nope-$NAME"/loading
diff --git a/tools/testing/selftests/firmware/fw_filesystem.sh b/tools/testing/selftests/firmware/fw_filesystem.sh
index 748f2f5737e9..7f47877fa7fa 100755
--- a/tools/testing/selftests/firmware/fw_filesystem.sh
+++ b/tools/testing/selftests/firmware/fw_filesystem.sh
@@ -6,38 +6,15 @@
 # know so we can be sure we're not accidentally testing the user helper.
 set -e
 
+TEST_REQS_FW_SYSFS_FALLBACK="no"
+TEST_REQS_FW_SET_CUSTOM_PATH="yes"
 TEST_DIR=$(dirname $0)
 source $TEST_DIR/fw_lib.sh
 
 check_mods
-
-# CONFIG_FW_LOADER_USER_HELPER has a sysfs class under /sys/class/firmware/
-# These days most distros enable CONFIG_FW_LOADER_USER_HELPER but disable
-# CONFIG_FW_LOADER_USER_HELPER_FALLBACK. We use /sys/class/firmware/ as an
-# indicator for CONFIG_FW_LOADER_USER_HELPER.
-HAS_FW_LOADER_USER_HELPER=$(if [ -d /sys/class/firmware/ ]; then echo yes; else echo no; fi)
-
-if [ "$HAS_FW_LOADER_USER_HELPER" = "yes" ]; then
-	OLD_TIMEOUT=$(cat /sys/class/firmware/timeout)
-fi
-
-OLD_FWPATH=$(cat /sys/module/firmware_class/parameters/path)
-
-FWPATH=$(mktemp -d)
-FW="$FWPATH/test-firmware.bin"
-
-test_finish()
-{
-	if [ "$HAS_FW_LOADER_USER_HELPER" = "yes" ]; then
-		echo "$OLD_TIMEOUT" >/sys/class/firmware/timeout
-	fi
-	if [ "$OLD_FWPATH" = "" ]; then
-		OLD_FWPATH=" "
-	fi
-	echo -n "$OLD_FWPATH" >/sys/module/firmware_class/parameters/path
-	rm -f "$FW"
-	rmdir "$FWPATH"
-}
+check_setup
+verify_reqs
+setup_tmp_file
 
 trap "test_finish" EXIT
 
@@ -46,14 +23,6 @@ if [ "$HAS_FW_LOADER_USER_HELPER" = "yes" ]; then
 	echo 1 >/sys/class/firmware/timeout
 fi
 
-# Set the kernel search path.
-echo -n "$FWPATH" >/sys/module/firmware_class/parameters/path
-
-# This is an unlikely real-world firmware content. :)
-echo "ABCD0123" >"$FW"
-
-NAME=$(basename "$FW")
-
 if printf '\000' >"$DIR"/trigger_request 2> /dev/null; then
 	echo "$0: empty filename should not succeed" >&2
 	exit 1
diff --git a/tools/testing/selftests/firmware/fw_lib.sh b/tools/testing/selftests/firmware/fw_lib.sh
index 467567c758b9..e3cc4483fdba 100755
--- a/tools/testing/selftests/firmware/fw_lib.sh
+++ b/tools/testing/selftests/firmware/fw_lib.sh
@@ -43,6 +43,58 @@ check_mods()
 	fi
 }
 
+check_setup()
+{
+	HAS_FW_LOADER_USER_HELPER="$(kconfig_has CONFIG_FW_LOADER_USER_HELPER=y)"
+	HAS_FW_LOADER_USER_HELPER_FALLBACK="$(kconfig_has CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y)"
+
+	if [ "$HAS_FW_LOADER_USER_HELPER" = "yes" ]; then
+	       OLD_TIMEOUT="$(cat /sys/class/firmware/timeout)"
+	fi
+
+	OLD_FWPATH="$(cat /sys/module/firmware_class/parameters/path)"
+}
+
+verify_reqs()
+{
+	if [ "$TEST_REQS_FW_SYSFS_FALLBACK" = "yes" ]; then
+		if [ ! "$HAS_FW_LOADER_USER_HELPER" = "yes" ]; then
+			echo "usermode helper disabled so ignoring test"
+			exit 0
+		fi
+	fi
+}
+
+setup_tmp_file()
+{
+	FWPATH=$(mktemp -d)
+	FW="$FWPATH/test-firmware.bin"
+	echo "ABCD0123" >"$FW"
+	NAME=$(basename "$FW")
+	if [ "$TEST_REQS_FW_SET_CUSTOM_PATH" = "yes" ]; then
+		echo -n "$FWPATH" >/sys/module/firmware_class/parameters/path
+	fi
+}
+
+test_finish()
+{
+	if [ "$HAS_FW_LOADER_USER_HELPER" = "yes" ]; then
+		echo "$OLD_TIMEOUT" >/sys/class/firmware/timeout
+	fi
+	if [ "$OLD_FWPATH" = "" ]; then
+		OLD_FWPATH=" "
+	fi
+	if [ "$TEST_REQS_FW_SET_CUSTOM_PATH" = "yes" ]; then
+		echo -n "$OLD_FWPATH" >/sys/module/firmware_class/parameters/path
+	fi
+	if [ -f $FW ]; then
+		rm -f "$FW"
+	fi
+	if [ -d $FWPATH ]; then
+		rm -rf "$FWPATH"
+	fi
+}
+
 kconfig_has()
 {
 	if [ -f $PROC_CONFIG ]; then
-- 
2.16.2
