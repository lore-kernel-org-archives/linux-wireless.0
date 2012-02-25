Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24856 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab2BYBwR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 20:52:17 -0500
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <hauke@hauke-m.de>, <nbd@nbd.name>, <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 2/5] compat: add some initial RHEL support
Date: Fri, 24 Feb 2012 17:52:03 -0800
Message-ID: <1330134726-1634-3-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120225_025223_363951_398844EA)
In-Reply-To: <1330134726-1634-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1330134726-1634-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@frijolero.org>

This adds a series of CONFIG_COMPAT_${RHEL_MAJOR}_${i} tags
for each known RHEL version that we supercede. I cannot
verify if this is correct but this is my translation of
this to script:

RHEL_MAJOR := $(shell grep ^RHEL_MAJOR $(KLIB_BUILD)/Makefile | sed -n 's/.*= *\(.*\)/\1/p')
ifneq ($(RHEL_MAJOR),)
RHEL_MINOR := $(shell grep ^RHEL_MINOR $(KLIB_BUILD)/Makefile | sed -n 's/.*= *\(.*\)/\1/p')
COMPAT_RHEL_VERSIONS := $(shell I=$(RHEL_MINOR); while [ "$$I" -ge 0 ]; do echo $$I; I=$$(($$I - 1)); done)
$(foreach ver,$(COMPAT_RHEL_VERSIONS),$(eval CONFIG_COMPAT_RHEL_$(RHEL_MAJOR)_$(ver)=y))

Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 scripts/gen-compat-config.sh |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/scripts/gen-compat-config.sh b/scripts/gen-compat-config.sh
index 82b439c..656e8d3 100755
--- a/scripts/gen-compat-config.sh
+++ b/scripts/gen-compat-config.sh
@@ -41,6 +41,16 @@ for i in $(seq ${KERNEL_SUBLEVEL} ${COMPAT_LATEST_VERSION}); do
 	echo "CONFIG_COMPAT_KERNEL_3_${i}=y"
 done
 
+# The purpose of these seem to be the inverse of the above other varibales.
+# The RHEL checks seem to annotate the existance of RHEL minor versions.
+RHEL_MAJOR=$(grep ^RHEL_MAJOR ${KLIB_BUILD}/Makefile | sed -n 's/.*= *\(.*\)/\1/p')
+if [[ ! -z ${RHEL_MAJOR} ]]; then
+	RHEL_MINOR=$(grep ^RHEL_MINOR $(KLIB_BUILD)/Makefile | sed -n 's/.*= *\(.*\)/\1/p')
+	for i in $(seq 0 ${RHEL_MINOR}); do
+		echo "CONFIG_COMPAT_${RHEL_MAJOR}_${i}=y"
+	done
+fi
+
 if [[ ${CONFIG_COMPAT_KERNEL_2_6_33} -eq "y" ]]; then
 	echo "CONFIG_COMPAT_FIRMWARE_CLASS=m"
 fi
-- 
1.7.4.15.g7811d

