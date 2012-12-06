Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37209 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab2LFSRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 13:17:36 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 13/13] qca-swiss-army-knife: allow to verify AR955X initvals
Date: Thu,  6 Dec 2012 19:17:27 +0100
Message-Id: <1354817847-23440-14-git-send-email-juhosg@openwrt.org> (sfid-20121206_191750_591286_BA921AB1)
In-Reply-To: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
References: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/Makefile            |    1 +
 tools/initvals/verify_checksums.sh |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/initvals/Makefile b/tools/initvals/Makefile
index 010b68c..884eeeb 100644
--- a/tools/initvals/Makefile
+++ b/tools/initvals/Makefile
@@ -35,6 +35,7 @@ ATH9K_HEADERS = \
 	ar9330-1p2:ar9330_1p2_initvals.h	\
 	ar9340:ar9340_initvals.h	\
 	ar9485:ar9485_initvals.h		\
+	ar955x-1p0:ar955x_1p0_initvals.h	\
 	ar9580-1p0:ar9580_1p0_initvals.h \
 	ar9462-2p0:ar9462_2p0_initvals.h	\
 	ar9565-1p0:ar9565_1p0_initvals.h
diff --git a/tools/initvals/verify_checksums.sh b/tools/initvals/verify_checksums.sh
index 46fff90..fcc6db6 100755
--- a/tools/initvals/verify_checksums.sh
+++ b/tools/initvals/verify_checksums.sh
@@ -31,7 +31,7 @@ verify_family_checksum()
 }
 
 FAMILIES="$@"
-[ -z "$FAMILIES" ] && FAMILIES="ar5008 ar9001 ar9002 ar9003-2p2 ar9330-1p1 ar9330-1p2 ar9340 ar9462-1p0 ar9485 ar9565-1p0 ar9580-1p0"
+[ -z "$FAMILIES" ] && FAMILIES="ar5008 ar9001 ar9002 ar9003-2p2 ar9330-1p1 ar9330-1p2 ar9340 ar9462-1p0 ar9485 ar955x-1p0 ar9565-1p0 ar9580-1p0"
 
 mkdir -p "$CSUM_DIR"
 for family in $FAMILIES; do
-- 
1.7.10

