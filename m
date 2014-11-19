Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40851 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932166AbaKSURc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 15:17:32 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nfc drivers: don't include linux/unaligned/access_ok.h
Date: Wed, 19 Nov 2014 21:17:22 +0100
Message-Id: <1416428242-9942-1-git-send-email-johannes@sipsolutions.net> (sfid-20141119_211747_436533_EB111305)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is a specific implementation, <asm/unaligned.h> is the
multiplexer that has the arch-specific knowledge of which
of the implementations needs to be used, so include that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/nfc/pn544/i2c.c    | 2 +-
 drivers/nfc/st21nfca/i2c.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 440291ab7263..fc02e8d6a193 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -29,8 +29,8 @@
 #include <linux/delay.h>
 #include <linux/nfc.h>
 #include <linux/firmware.h>
-#include <linux/unaligned/access_ok.h>
 #include <linux/platform_data/pn544.h>
+#include <asm/unaligned.h>
 
 #include <net/nfc/hci.h>
 #include <net/nfc/llc.h>
diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index 0ea756b77519..ff6dacb4d482 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -28,8 +28,8 @@
 #include <linux/delay.h>
 #include <linux/nfc.h>
 #include <linux/firmware.h>
-#include <linux/unaligned/access_ok.h>
 #include <linux/platform_data/st21nfca.h>
+#include <asm/unaligned.h>
 
 #include <net/nfc/hci.h>
 #include <net/nfc/llc.h>
-- 
2.1.1

