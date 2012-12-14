Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37810 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab2LNIKl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 03:10:41 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: qca-linux-team@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] qca-swiss-army-knife: allow to refresh/verify external ath9k headers
Date: Fri, 14 Dec 2012 09:10:27 +0100
Message-Id: <1355472627-13326-1-git-send-email-juhosg@openwrt.org> (sfid-20121214_091047_159603_4400EE2C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows to refresh/verify ath9k specific initvals
existing in an external directory.

  $ make clean refresh ATHEROS=1 TH9K_DIR=/devel/wireless-testing/drivers/net/wireless/ath/ath9k
  rm -f initvals
  gcc  -I"/devel/wireless-testing/drivers/net/wireless/ath/ath9k" DATHEROS -o initvals initvals.c sha1.c
  ./initvals -w -f ar5008 > /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
  ./initvals -w -f ar9001 > /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar9001_initvals.h
  ./initvals -w -f ar9002 > /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
  ./initvals -w -f ar9003-2p2 > /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
  ./initvals -w -f ar9330-1p1 > /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar9330_1p1_initvals.h
  ./initvals -w -f ar9330-1p2 > /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar9330_1p2_initvals.h
  ./initvals -w -f ar9340 > /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar9340_initvals.h
  ./initvals -w -f ar9485 > /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
  ./initvals -w -f ar955x-1p0 > /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar955x_1p0_initvals.h
  ./initvals -w -f ar9580-1p0 > /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
  ./initvals -w -f ar9462-2p0 > /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h
  ./initvals -w -f ar9565-1p0 > /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h
  ./initvals > checksums.txt
  $

  $ ATH9K_DIR=/devel/wireless-testing/drivers/net/wireless/ath/ath9k ./verify_checksums.sh
  ar5008         7340125997ffffe26a3bfc854c5b9dce74b86152 pass
  ar9001         8a4557f6a4e5ad2b01a40ca0519940ab775572aa pass
  ar9002         67813ac6decf14f5221dd3c41126f23f4d333fc4 pass
  ar9003-2p2     fdcc27a4327c6bb5e82bc7ded7387e06a2c82bb0 pass
  ar9330-1p1     e01b965b87c98d865b43e5febf37cb067644e56b pass
  ar9330-1p2     ab7e2aa014d2a9bd5cefad261999868888fc570e pass
  ar9340         038a5891dc5074686e02485e6b027a8daf0dfe14 pass
  ar9462-1p0     da39a3ee5e6b4b0d3255bfef95601890afd80709 pass
  ar9485         bbe34977a5de7a913333149ff322e767b53ec9e3 pass
  ar955x-1p0     ae1b560d1201e94c494653de3a7ecbe72e609098 pass
  ar9565-1p0     89ba21cad9233c461311ef0256945b8f03a93313 pass
  ar9580-1p0     cbdf2a5efad22be6694b586f8bd9c6605697cb9f pass
  $

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
For the record, it causes a build error if the external
headers were not refreshed first:

  $ make clean all ATH9K_DIR=/devel/wireless-testing/drivers/net/wireless/ath/ath9k
  rm -f initvals
  gcc  -I"/devel/wireless-testing/drivers/net/wireless/ath/ath9k" -o initvals initvals.c sha1.c
  initvals.c: In function ‘ar9001_hw_print_initvals’:
  initvals.c:562:2: error: ‘ar5416Bank0_9100’ undeclared (first use in this function)
  initvals.c:562:2: note: each undeclared identifier is reported only once for each function it appears in
  initvals.c:563:2: error: ‘ar5416BB_RfGain_9100’ undeclared (first use in this function)
  initvals.c:564:2: error: ‘ar5416Bank1_9100’ undeclared (first use in this function)
  initvals.c:565:2: error: ‘ar5416Bank2_9100’ undeclared (first use in this function)
  initvals.c:566:2: error: ‘ar5416Bank3_9100’ undeclared (first use in this function)
  initvals.c:569:2: error: ‘ar5416Bank7_9100’ undeclared (first use in this function)
  initvals.c:573:2: error: ‘ar5416Bank0_9160’ undeclared (first use in this function)
  initvals.c:574:2: error: ‘ar5416BB_RfGain_9160’ undeclared (first use in this function)
  initvals.c:575:2: error: ‘ar5416Bank1_9160’ undeclared (first use in this function)
  initvals.c:576:2: error: ‘ar5416Bank2_9160’ undeclared (first use in this function)
  initvals.c:577:2: error: ‘ar5416Bank3_9160’ undeclared (first use in this function)
  initvals.c:578:2: error: ‘ar5416Bank6_9160’ undeclared (first use in this function)
  initvals.c:579:2: error: ‘ar5416Bank6TPC_9160’ undeclared (first use in this function)
  initvals.c:580:2: error: ‘ar5416Bank7_9160’ undeclared (first use in this function)
  initvals.c: In function ‘ar9002_hw_print_initvals’:
  initvals.c:597:2: error: ‘ar9285PciePhy_clkreq_always_on_L1_9285’ undeclared (first use in this function)
  initvals.c:598:2: error: ‘ar9285PciePhy_clkreq_off_L1_9285’ undeclared (first use in this function)
  initvals.c:605:2: error: ‘ar9285PciePhy_clkreq_always_on_L1_9285_1_2’ undeclared (first use in this function)
  initvals.c:606:2: error: ‘ar9285PciePhy_clkreq_off_L1_9285_1_2’ undeclared (first use in this function)
  initvals.c:613:2: error: ‘ar9287PciePhy_clkreq_always_on_L1_9287_1_1’ undeclared (first use in this function)
  initvals.c:614:2: error: ‘ar9287PciePhy_clkreq_off_L1_9287_1_1’ undeclared (first use in this function)
  initvals.c:617:2: error: ‘ar9271Common_normal_cck_fir_coeff_9271’ undeclared (first use in this function)
  initvals.c:618:2: error: ‘ar9271Common_japan_2484_cck_fir_coeff_9271’ undeclared (first use in this function)
  initvals.c:619:2: error: ‘ar9271Modes_9271_1_0_only’ undeclared (first use in this function)
  make: *** [initvals] Error 1
  $

The root cause is that some of the ath9k initval
headers are different from the ones found in the
current wireless-testing tree.

  $ for f in *initvals.h; do diff -qs $f /devel/wireless-testing/drivers/net/wireless/ath/ath9k/$f; done
  Files ar5008_initvals.h and /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar5008_initvals.h differ
  Files ar9001_initvals.h and /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar9001_initvals.h differ
  Files ar9002_initvals.h and /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar9002_initvals.h differ
  Files ar9003_2p2_initvals.h and /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h differ
  Files ar9330_1p1_initvals.h and /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar9330_1p1_initvals.h are identical
  Files ar9330_1p2_initvals.h and /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar9330_1p2_initvals.h differ
  Files ar9340_initvals.h and /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar9340_initvals.h are identical
  Files ar9462_2p0_initvals.h and /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h are identical
  Files ar9485_initvals.h and /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar9485_initvals.h are identical
  Files ar955x_1p0_initvals.h and /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar955x_1p0_initvals.h are identical
  Files ar9565_1p0_initvals.h and /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar9565_1p0_initvals.h are identical
  Files ar9580_1p0_initvals.h and /devel/wireless-testing/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h are identical
  $
---
 tools/initvals/Makefile            |    7 ++++---
 tools/initvals/initvals.c          |   24 ++++++++++++------------
 tools/initvals/verify_checksums.sh |    1 +
 3 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/tools/initvals/Makefile b/tools/initvals/Makefile
index 884eeeb..065f410 100644
--- a/tools/initvals/Makefile
+++ b/tools/initvals/Makefile
@@ -1,6 +1,7 @@
 CFLAGS=
+ATH9K_DIR=.
 
-LOCAL_CFLAGS=$(CFLAGS)
+LOCAL_CFLAGS=$(CFLAGS) -I"$(ATH9K_DIR)"
 ifdef ATHEROS
 LOCAL_CFLAGS += -DATHEROS
 
@@ -41,7 +42,7 @@ ATH9K_HEADERS = \
 	ar9565-1p0:ar9565_1p0_initvals.h
 
 ifndef ATHEROS
-ATH9K_DEPS := $(foreach header,$(ATH9K_HEADERS),$(word 2,$(subst :, ,$(header))))
+ATH9K_DEPS := $(foreach header,$(ATH9K_HEADERS),$(word 2,$(subst :, $(ATH9K_DIR)/,$(header))))
 endif
 
 SOURCES:=initvals.c sha1.c
@@ -50,7 +51,7 @@ initvals: $(ATH9K_DEPS) $(ATHEROS_DEPS) $(SOURCES)
 	gcc $(LOCAL_CFLAGS) -o $@ $(SOURCES)
 
 define refresh_command
-	./initvals -w -f $(word 1,$(subst :, ,$(1))) > $(word 2,$(subst :, ,$(1)))
+	./initvals -w -f $(word 1,$(subst :, ,$(1))) > $(word 2,$(subst :, $(ATH9K_DIR)/,$(1)))
 
 endef
 
diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 3f2c7cd..066b06d 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -27,18 +27,18 @@ struct initval_family {
  */
 #ifndef ATHEROS
 
-#include "ar5008_initvals.h"
-#include "ar9001_initvals.h"
-#include "ar9002_initvals.h"
-#include "ar9003_2p2_initvals.h"
-#include "ar9330_1p1_initvals.h"
-#include "ar9330_1p2_initvals.h"
-#include "ar9340_initvals.h"
-#include "ar9485_initvals.h"
-#include "ar955x_1p0_initvals.h"
-#include "ar9580_1p0_initvals.h"
-#include "ar9462_2p0_initvals.h"
-#include "ar9565_1p0_initvals.h"
+#include <ar5008_initvals.h>
+#include <ar9001_initvals.h>
+#include <ar9002_initvals.h>
+#include <ar9003_2p2_initvals.h>
+#include <ar9330_1p1_initvals.h>
+#include <ar9330_1p2_initvals.h>
+#include <ar9340_initvals.h>
+#include <ar9485_initvals.h>
+#include <ar955x_1p0_initvals.h>
+#include <ar9580_1p0_initvals.h>
+#include <ar9462_2p0_initvals.h>
+#include <ar9565_1p0_initvals.h>
 
 #else
 
diff --git a/tools/initvals/verify_checksums.sh b/tools/initvals/verify_checksums.sh
index fcc6db6..ee5f019 100755
--- a/tools/initvals/verify_checksums.sh
+++ b/tools/initvals/verify_checksums.sh
@@ -8,6 +8,7 @@ get_family_checksum()
 	local flag
 
 	[ "$suffix" == "hal" ] && flag="ATHEROS=1"
+	[ -n "$ATH9K_DIR" ] && flag="$flag ATH9K_DIR=$ATH9K_DIR"
 
 	make clean all $flag >/dev/null
 	./initvals -f $family > "$CSUM_DIR/${family}_$suffix.txt"
-- 
1.7.10

