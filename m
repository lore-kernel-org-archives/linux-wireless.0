Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751113AbeCJOPP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 09:15:15 -0500
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
Subject: [PATCH v3 01/20] test_firmware: add simple firmware firmware test library
Date: Sat, 10 Mar 2018 06:14:42 -0800
Message-Id: <20180310141501.2214-2-mcgrof@kernel.org> (sfid-20180310_152128_361593_466814B5)
In-Reply-To: <20180310141501.2214-1-mcgrof@kernel.org>
References: <20180310141501.2214-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We'll expland on this later, for now just add basic module checker.
While at it, move this all to use /bin/bash as we'll have much more
flexibility with it.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 tools/testing/selftests/firmware/fw_fallback.sh   |  7 ++--
 tools/testing/selftests/firmware/fw_filesystem.sh | 20 ++---------
 tools/testing/selftests/firmware/fw_lib.sh        | 44 +++++++++++++++++++++++
 3 files changed, 51 insertions(+), 20 deletions(-)
 create mode 100755 tools/testing/selftests/firmware/fw_lib.sh

diff --git a/tools/testing/selftests/firmware/fw_fallback.sh b/tools/testing/selftests/firmware/fw_fallback.sh
index 722cad91df74..755147a8c967 100755
--- a/tools/testing/selftests/firmware/fw_fallback.sh
+++ b/tools/testing/selftests/firmware/fw_fallback.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 # This validates that the kernel will fall back to using the fallback mechanism
 # to load firmware it can't find on disk itself. We must request a firmware
@@ -6,9 +6,10 @@
 # won't find so that we can do the load ourself manually.
 set -e
 
-modprobe test_firmware
+TEST_DIR=$(dirname $0)
+source $TEST_DIR/fw_lib.sh
 
-DIR=/sys/devices/virtual/misc/test_firmware
+check_mods
 
 # CONFIG_FW_LOADER_USER_HELPER has a sysfs class under /sys/class/firmware/
 # These days no one enables CONFIG_FW_LOADER_USER_HELPER so check for that
diff --git a/tools/testing/selftests/firmware/fw_filesystem.sh b/tools/testing/selftests/firmware/fw_filesystem.sh
index f9508e1a4058..748f2f5737e9 100755
--- a/tools/testing/selftests/firmware/fw_filesystem.sh
+++ b/tools/testing/selftests/firmware/fw_filesystem.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 # This validates that the kernel will load firmware out of its list of
 # firmware locations on disk. Since the user helper does similar work,
@@ -6,24 +6,10 @@
 # know so we can be sure we're not accidentally testing the user helper.
 set -e
 
-DIR=/sys/devices/virtual/misc/test_firmware
 TEST_DIR=$(dirname $0)
+source $TEST_DIR/fw_lib.sh
 
-test_modprobe()
-{
-	if [ ! -d $DIR ]; then
-		echo "$0: $DIR not present"
-		echo "You must have the following enabled in your kernel:"
-		cat $TEST_DIR/config
-		exit 1
-	fi
-}
-
-trap "test_modprobe" EXIT
-
-if [ ! -d $DIR ]; then
-	modprobe test_firmware
-fi
+check_mods
 
 # CONFIG_FW_LOADER_USER_HELPER has a sysfs class under /sys/class/firmware/
 # These days most distros enable CONFIG_FW_LOADER_USER_HELPER but disable
diff --git a/tools/testing/selftests/firmware/fw_lib.sh b/tools/testing/selftests/firmware/fw_lib.sh
new file mode 100755
index 000000000000..c14bbca7ecf9
--- /dev/null
+++ b/tools/testing/selftests/firmware/fw_lib.sh
@@ -0,0 +1,44 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# Library of helpers for test scripts.
+set -e
+
+DIR=/sys/devices/virtual/misc/test_firmware
+
+PROC_CONFIG="/proc/config.gz"
+TEST_DIR=$(dirname $0)
+
+print_reqs_exit()
+{
+	echo "You must have the following enabled in your kernel:" >&2
+	cat $TEST_DIR/config >&2
+	exit 1
+}
+
+test_modprobe()
+{
+	if [ ! -d $DIR ]; then
+		print_reqs_exit
+	fi
+}
+
+check_mods()
+{
+	trap "test_modprobe" EXIT
+	if [ ! -d $DIR ]; then
+		modprobe test_firmware
+	fi
+	if [ ! -f $PROC_CONFIG ]; then
+		if modprobe configs 2>/dev/null; then
+			echo "Loaded configs module"
+			if [ ! -f $PROC_CONFIG ]; then
+				echo "You must have the following enabled in your kernel:" >&2
+				cat $TEST_DIR/config >&2
+				echo "Resorting to old heuristics" >&2
+			fi
+		else
+			echo "Failed to load configs module, using old heuristics" >&2
+		fi
+	fi
+}
-- 
2.16.2
