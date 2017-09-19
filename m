Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:36250 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751623AbdISOZV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Sep 2017 10:25:21 -0400
From: Colin King <colin.king@canonical.com>
To: Robert Baldyga <r.baldyga@samsung.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-nfc@lists.01.org,
        linux-wireless@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nfc: s3fwrn5: make array match static const, reduces object code size
Date: Tue, 19 Sep 2017 15:25:15 +0100
Message-Id: <20170919142515.23196-1-colin.king@canonical.com> (sfid-20170919_162540_331537_439F3437)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate the read-only array match on the stack, instead make
it static const.  Makes the object code smaller by over 310 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
   8304	   1084	    128	   9516	   252c	drivers/nfc/s3fwrn5/firmware.o

After:
   text	   data	    bss	    dec	    hex	filename
   7894	   1180	    128	   9202	   23f2	drivers/nfc/s3fwrn5/firmware.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/nfc/s3fwrn5/firmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/s3fwrn5/firmware.c b/drivers/nfc/s3fwrn5/firmware.c
index 38548bd970cd..b7828fb252f2 100644
--- a/drivers/nfc/s3fwrn5/firmware.c
+++ b/drivers/nfc/s3fwrn5/firmware.c
@@ -336,7 +336,7 @@ static int s3fwrn5_fw_get_base_addr(
 	struct s3fwrn5_fw_cmd_get_bootinfo_rsp *bootinfo, u32 *base_addr)
 {
 	int i;
-	struct {
+	static const struct {
 		u8 version[4];
 		u32 base_addr;
 	} match[] = {
-- 
2.14.1
