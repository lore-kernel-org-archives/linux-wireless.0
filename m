Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751194AbeCJOPQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 09:15:16 -0500
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
Subject: [PATCH v3 02/20] test_firmware: enable custom fallback testing on limited kernel configs
Date: Sat, 10 Mar 2018 06:14:43 -0800
Message-Id: <20180310141501.2214-3-mcgrof@kernel.org> (sfid-20180310_152151_921292_BE2A261B)
In-Reply-To: <20180310141501.2214-1-mcgrof@kernel.org>
References: <20180310141501.2214-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a kernel is not built with:

CONFIG_HAS_FW_LOADER_USER_HELPER_FALLBACK=y

We don't currently enable testing fw_fallback.sh. For kernels that
still enable the fallback mechanism, its possible to use the async
request firmware API call request_firmware_nowait() using the custom
interface to use the fallback mechanism, so we should be able to test
this but we currently cannot.

We can enable testing without CONFIG_HAS_FW_LOADER_USER_HELPER_FALLBACK=y
by relying on /proc/config.gz (CONFIG_IKCONFIG_PROC), if present. If you
don't have this we'll have no option but to rely on old heuristics for now.

We stuff the new kconfig_has() helper into our shared library as we'll
later expando on its use elsewhere.

Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 tools/testing/selftests/firmware/config         |  4 ++++
 tools/testing/selftests/firmware/fw_fallback.sh |  6 +++++-
 tools/testing/selftests/firmware/fw_lib.sh      | 24 ++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/firmware/config b/tools/testing/selftests/firmware/config
index c8137f70e291..bf634dda0720 100644
--- a/tools/testing/selftests/firmware/config
+++ b/tools/testing/selftests/firmware/config
@@ -1 +1,5 @@
 CONFIG_TEST_FIRMWARE=y
+CONFIG_FW_LOADER=y
+CONFIG_FW_LOADER_USER_HELPER=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
diff --git a/tools/testing/selftests/firmware/fw_fallback.sh b/tools/testing/selftests/firmware/fw_fallback.sh
index 755147a8c967..bf850050e5e9 100755
--- a/tools/testing/selftests/firmware/fw_fallback.sh
+++ b/tools/testing/selftests/firmware/fw_fallback.sh
@@ -15,6 +15,7 @@ check_mods
 # These days no one enables CONFIG_FW_LOADER_USER_HELPER so check for that
 # as an indicator for CONFIG_FW_LOADER_USER_HELPER.
 HAS_FW_LOADER_USER_HELPER=$(if [ -d /sys/class/firmware/ ]; then echo yes; else echo no; fi)
+HAS_FW_LOADER_USER_HELPER_FALLBACK=$(kconfig_has CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y)
 
 if [ "$HAS_FW_LOADER_USER_HELPER" = "yes" ]; then
        OLD_TIMEOUT=$(cat /sys/class/firmware/timeout)
@@ -287,7 +288,10 @@ run_sysfs_custom_load_tests()
 	fi
 }
 
-run_sysfs_main_tests
+if [ "$HAS_FW_LOADER_USER_HELPER_FALLBACK" = "yes" ]; then
+	run_sysfs_main_tests
+fi
+
 run_sysfs_custom_load_tests
 
 exit 0
diff --git a/tools/testing/selftests/firmware/fw_lib.sh b/tools/testing/selftests/firmware/fw_lib.sh
index c14bbca7ecf9..467567c758b9 100755
--- a/tools/testing/selftests/firmware/fw_lib.sh
+++ b/tools/testing/selftests/firmware/fw_lib.sh
@@ -42,3 +42,27 @@ check_mods()
 		fi
 	fi
 }
+
+kconfig_has()
+{
+	if [ -f $PROC_CONFIG ]; then
+		if zgrep -q $1 $PROC_CONFIG 2>/dev/null; then
+			echo "yes"
+		else
+			echo "no"
+		fi
+	else
+		# We currently don't have easy heuristics to infer this
+		# so best we can do is just try to use the kernel assuming
+		# you had enabled it. This matches the old behaviour.
+		if [ "$1" = "CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y" ]; then
+			echo "yes"
+		elif [ "$1" = "CONFIG_FW_LOADER_USER_HELPER=y" ]; then
+			if [ -d /sys/class/firmware/ ]; then
+				echo yes
+			else
+				echo no
+			fi
+		fi
+	fi
+}
-- 
2.16.2
