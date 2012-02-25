Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64080 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab2BYCln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 21:41:43 -0500
Received: by pbcup15 with SMTP id up15so114106pbc.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2012 18:41:42 -0800 (PST)
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: hauke@hauke-m.de, nbd@nbd.name, linville@tuxdriver.com,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH] compat: fix compilation on latest kernels
Date: Fri, 24 Feb 2012 18:41:38 -0800
Message-Id: <1330137698-12940-1-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120225_034146_621467_6C6CE875)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@frijolero.org>

The variables wasn't being set in shell. By defining
the variables in shell and outputing them once onto
a .config we avoid having to do release kernel checks
every single time.

We're back in business with the latest kernels.

mcgrof@tux ~/compat (git::master)$ ckmake
Trying kernel                  3.3.0-030300rc2-generic  [OK]
Trying kernel                     3.2.2-030202-generic  [OK]
Trying kernel                    3.1.10-030110-generic  [OK]
Trying kernel                    3.0.18-030018-generic  [OK]
Trying kernel                  2.6.39-02063904-generic  [OK]
Trying kernel                         2.6.38-8-generic  [OK]
Trying kernel                        2.6.38-13-generic  [OK]
Trying kernel                        2.6.38-12-generic  [OK]
Trying kernel                        2.6.38-11-generic  [OK]
Trying kernel                        2.6.38-10-generic  [OK]
Trying kernel                  2.6.38-02063808-generic  [OK]
Trying kernel                  2.6.37-02063706-generic  [OK]
Trying kernel                  2.6.36-02063604-generic  [OK]
Trying kernel                  2.6.35-02063512-generic  [OK]
Trying kernel                  2.6.34-02063410-generic  [OK]
Trying kernel                  2.6.33-02063305-generic  [OK]
Trying kernel                  2.6.32-02063255-generic  [OK]
Trying kernel                        2.6.31-22-generic  [OK]
Trying kernel                  2.6.31-02063113-generic  [OK]
Trying kernel                  2.6.30-02063010-generic  [OK]
Trying kernel                  2.6.29-02062906-generic  [OK]
Trying kernel                  2.6.28-02062810-generic  [OK]
Trying kernel                    2.6.27-020627-generic  [OK]
Trying kernel                    2.6.26-020626-generic  [OK]
Trying kernel                    2.6.25-020625-generic  [FAILED]

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---

OK one final fix.

 scripts/gen-compat-config.sh |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/scripts/gen-compat-config.sh b/scripts/gen-compat-config.sh
index 656e8d3..423d595 100755
--- a/scripts/gen-compat-config.sh
+++ b/scripts/gen-compat-config.sh
@@ -32,12 +32,14 @@ else
 	let KERNEL_26SUBLEVEL=${KERNEL_26SUBLEVEL}+1
 
 	for i in $(seq ${KERNEL_26SUBLEVEL} ${COMPAT_26LATEST_VERSION}); do
+		eval CONFIG_COMPAT_KERNEL_2_6_${i}=y
 		echo "CONFIG_COMPAT_KERNEL_2_6_${i}=y"
 	done
 fi
 
 let KERNEL_SUBLEVEL=${KERNEL_SUBLEVEL}+1
 for i in $(seq ${KERNEL_SUBLEVEL} ${COMPAT_LATEST_VERSION}); do
+	eval CONFIG_COMPAT_KERNEL_3_${i}=y
 	echo "CONFIG_COMPAT_KERNEL_3_${i}=y"
 done
 
@@ -47,14 +49,15 @@ RHEL_MAJOR=$(grep ^RHEL_MAJOR ${KLIB_BUILD}/Makefile | sed -n 's/.*= *\(.*\)/\1/
 if [[ ! -z ${RHEL_MAJOR} ]]; then
 	RHEL_MINOR=$(grep ^RHEL_MINOR $(KLIB_BUILD)/Makefile | sed -n 's/.*= *\(.*\)/\1/p')
 	for i in $(seq 0 ${RHEL_MINOR}); do
+		eval CONFIG_COMPAT_${RHEL_MAJOR}_${i}=y
 		echo "CONFIG_COMPAT_${RHEL_MAJOR}_${i}=y"
 	done
 fi
 
-if [[ ${CONFIG_COMPAT_KERNEL_2_6_33} -eq "y" ]]; then
+if [[ ${CONFIG_COMPAT_KERNEL_2_6_33} = "y" ]]; then
 	echo "CONFIG_COMPAT_FIRMWARE_CLASS=m"
 fi
 
-if [[ ${CONFIG_COMPAT_KERNEL_2_6_36} -eq "y" ]]; then
+if [[ ${CONFIG_COMPAT_KERNEL_2_6_36} = "y" ]]; then
 	echo "CONFIG_COMPAT_KFIFO=m"
 fi
-- 
1.7.4.15.g7811d

