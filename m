Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.zhinst.com ([212.126.164.98]:44900 "EHLO mail.zhinst.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964896AbcJZJAT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 05:00:19 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Cuissard <cuissard@marvell.com>
Subject: [PATCH] NFC: nfcmrvl: Include unaligned.h instead of access_ok.h
Date: Wed, 26 Oct 2016 11:00:12 +0200
Message-Id: <20161026090012.29747-1-tklauser@distanz.ch> (sfid-20161026_110043_517902_7CA479AA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Including linux/unaligned/access_ok.h causes the allmodconfig build on
ia64 (and maybe others) to fail with the following warnings:

include/linux/unaligned/access_ok.h:7:19: error: redefinition of 'get_unaligned_le16'
include/linux/unaligned/access_ok.h:12:19: error: redefinition of 'get_unaligned_le32'
include/linux/unaligned/access_ok.h:17:19: error: redefinition of 'get_unaligned_le64'
include/linux/unaligned/access_ok.h:22:19: error: redefinition of 'get_unaligned_be16'
include/linux/unaligned/access_ok.h:27:19: error: redefinition of 'get_unaligned_be32'
include/linux/unaligned/access_ok.h:32:19: error: redefinition of 'get_unaligned_be64'
include/linux/unaligned/access_ok.h:37:20: error: redefinition of 'put_unaligned_le16'
include/linux/unaligned/access_ok.h:42:20: error: redefinition of 'put_unaligned_le32'
include/linux/unaligned/access_ok.h:42:20: error: redefinition of 'put_unaligned_le64'
include/linux/unaligned/access_ok.h:42:20: error: redefinition of 'put_unaligned_be16'
include/linux/unaligned/access_ok.h:42:20: error: redefinition of 'put_unaligned_be32'
include/linux/unaligned/access_ok.h:42:20: error: redefinition of 'put_unaligned_be64'

Fix these by including asm/unaligned.h instead and leave it up to the
architecture to decide how to implement unaligned accesses.

Fixes: 3194c6870158 ("NFC: nfcmrvl: add firmware download support")
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Link: https://lkml.org/lkml/2016/10/22/247
Cc: Vincent Cuissard <cuissard@marvell.com>
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/nfc/nfcmrvl/fw_dnld.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcmrvl/fw_dnld.c b/drivers/nfc/nfcmrvl/fw_dnld.c
index f8dcdf4b24f6..441c1b0ec7b5 100644
--- a/drivers/nfc/nfcmrvl/fw_dnld.c
+++ b/drivers/nfc/nfcmrvl/fw_dnld.c
@@ -17,7 +17,7 @@
  */
 
 #include <linux/module.h>
-#include <linux/unaligned/access_ok.h>
+#include <asm/unaligned.h>
 #include <linux/firmware.h>
 #include <linux/nfc.h>
 #include <net/nfc/nci.h>
-- 
2.9.0
