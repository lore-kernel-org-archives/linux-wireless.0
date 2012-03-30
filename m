Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46053 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759310Ab2C3LLq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 07:11:46 -0400
Message-ID: <1333105904.3908.13.camel@jlt3.sipsolutions.net> (sfid-20120330_131149_388263_87CACD45)
Subject: [PATCH 2/2] compat: explicitly export generated variables
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 30 Mar 2012 13:11:44 +0200
In-Reply-To: <1333105815.3908.11.camel@jlt3.sipsolutions.net> (sfid-20120330_131022_444171_B95DE05C)
References: <1333105815.3908.11.camel@jlt3.sipsolutions.net>
	 (sfid-20120330_131022_444171_B95DE05C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Doing the blanket "export" statement at the beginning
of the generated file confuses the kernel's Makefiles
and causes extreme build slowdowns.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 scripts/gen-compat-config.sh |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/scripts/gen-compat-config.sh b/scripts/gen-compat-config.sh
index 5d6e34c..6cdac12 100755
--- a/scripts/gen-compat-config.sh
+++ b/scripts/gen-compat-config.sh
@@ -20,9 +20,10 @@ KERNEL_VERSION=$(${MAKE} -C ${KLIB_BUILD} kernelversion | sed -n 's/^\([0-9]\)\.
 COMPAT_LATEST_VERSION="3"
 KERNEL_SUBLEVEL="-1"
 
-# This allows all these variables to be propagated through
-# all of our Makefiles
-echo export
+# Note that this script will export all variables explicitly,
+# trying to export all with a blanket "export" statement at
+# the top of the generated file causes the build to slow down
+# by an order of magnitude.
 
 if [[ ${KERNEL_VERSION} -eq "3" ]]; then
 	KERNEL_SUBLEVEL=$(${MAKE} -C ${KLIB_BUILD} kernelversion | sed -n 's/^3\.\([0-9]\+\).*/\1/p')
@@ -33,14 +34,14 @@ else
 
 	for i in $(seq ${KERNEL_26SUBLEVEL} ${COMPAT_26LATEST_VERSION}); do
 		eval CONFIG_COMPAT_KERNEL_2_6_${i}=y
-		echo "CONFIG_COMPAT_KERNEL_2_6_${i}=y"
+		echo "export CONFIG_COMPAT_KERNEL_2_6_${i}=y"
 	done
 fi
 
 let KERNEL_SUBLEVEL=${KERNEL_SUBLEVEL}+1
 for i in $(seq ${KERNEL_SUBLEVEL} ${COMPAT_LATEST_VERSION}); do
 	eval CONFIG_COMPAT_KERNEL_3_${i}=y
-	echo "CONFIG_COMPAT_KERNEL_3_${i}=y"
+	echo "export CONFIG_COMPAT_KERNEL_3_${i}=y"
 done
 
 # The purpose of these seem to be the inverse of the above other varibales.
@@ -50,14 +51,14 @@ if [[ ! -z ${RHEL_MAJOR} ]]; then
 	RHEL_MINOR=$(grep ^RHEL_MINOR $(KLIB_BUILD)/Makefile | sed -n 's/.*= *\(.*\)/\1/p')
 	for i in $(seq 0 ${RHEL_MINOR}); do
 		eval CONFIG_COMPAT_${RHEL_MAJOR}_${i}=y
-		echo "CONFIG_COMPAT_${RHEL_MAJOR}_${i}=y"
+		echo "export CONFIG_COMPAT_${RHEL_MAJOR}_${i}=y"
 	done
 fi
 
 if [[ ${CONFIG_COMPAT_KERNEL_2_6_33} = "y" ]]; then
-	echo "CONFIG_COMPAT_FIRMWARE_CLASS=m"
+	echo "export CONFIG_COMPAT_FIRMWARE_CLASS=m"
 fi
 
 if [[ ${CONFIG_COMPAT_KERNEL_2_6_36} = "y" ]]; then
-	echo "CONFIG_COMPAT_KFIFO=y"
+	echo "export CONFIG_COMPAT_KFIFO=y"
 fi
-- 
1.7.9.1



