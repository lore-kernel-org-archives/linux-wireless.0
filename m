Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46680 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964775Ab2GCQyi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 12:54:38 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 10/10] qca-swiss-army-knife: allow to verify AR955X initvals
Date: Tue,  3 Jul 2012 18:42:55 +0200
Message-Id: <1341333775-14091-11-git-send-email-juhosg@openwrt.org> (sfid-20120703_185445_506848_F44A08AE)
In-Reply-To: <1341333775-14091-1-git-send-email-juhosg@openwrt.org>
References: <1341333775-14091-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/Makefile            |    1 +
 tools/initvals/initvals.c          |    1 +
 tools/initvals/verify_checksums.sh |    2 +-
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/initvals/Makefile b/tools/initvals/Makefile
index a4e375e..89169c1 100644
--- a/tools/initvals/Makefile
+++ b/tools/initvals/Makefile
@@ -34,6 +34,7 @@ ATH9K_HEADERS = \
 	ar9330-1p2:ar9330_1p2_initvals.h	\
 	ar9340:ar9340_initvals.h	\
 	ar9485:ar9485_initvals.h		\
+	ar955x-1p0:ar955x_1p0_initvals.h	\
 	ar9580-1p0:ar9580_1p0_initvals.h \
 	ar9462-2p0:ar9462_2p0_initvals.h
 
diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 4327f0d..f0b582c 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -35,6 +35,7 @@ struct initval_family {
 #include "ar9330_1p2_initvals.h"
 #include "ar9340_initvals.h"
 #include "ar9485_initvals.h"
+#include "ar955x_1p0_initvals.h"
 #include "ar9580_1p0_initvals.h"
 #include "ar9462_2p0_initvals.h"
 
diff --git a/tools/initvals/verify_checksums.sh b/tools/initvals/verify_checksums.sh
index fd03478..a6d4b32 100755
--- a/tools/initvals/verify_checksums.sh
+++ b/tools/initvals/verify_checksums.sh
@@ -31,7 +31,7 @@ verify_family_checksum()
 }
 
 FAMILIES="$@"
-[ -z "$FAMILIES" ] && FAMILIES="ar5008 ar9001 ar9002 ar9003-2p2 ar9330-1p1 ar9330-1p2 ar9462-2p0 ar9485 ar9580-1p0"
+[ -z "$FAMILIES" ] && FAMILIES="ar5008 ar9001 ar9002 ar9003-2p2 ar9330-1p1 ar9330-1p2 ar9462-2p0 ar9485 ar955x-1p0 ar9580-1p0"
 
 mkdir -p "$CSUM_DIR"
 for family in $FAMILIES; do
-- 
1.7.2.1

