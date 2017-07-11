Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:40753 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753647AbdGKLrh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Jul 2017 07:47:37 -0400
From: Colin King <colin.king@canonical.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] rt2x00: make const array glrt_table static
Date: Tue, 11 Jul 2017 12:47:33 +0100
Message-Id: <20170711114733.15387-1-colin.king@canonical.com> (sfid-20170711_134801_533102_6BE24414)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate array glrt_table on the stack but make it static.
Makes the object code a smaller by over 670 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
 131772	   4733	      0	 136505	  21539	rt2800lib.o

After:
   text	   data	    bss	    dec	    hex	filename
 131043	   4789	      0	 135832	  21298	rt2800lib.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 6e2e760d98b1..0b75def39c6c 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -5704,7 +5704,7 @@ static void rt2800_init_freq_calibration(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_bbp_5592_glrt(struct rt2x00_dev *rt2x00dev)
 {
-	const u8 glrt_table[] = {
+	static const u8 glrt_table[] = {
 		0xE0, 0x1F, 0X38, 0x32, 0x08, 0x28, 0x19, 0x0A, 0xFF, 0x00, /* 128 ~ 137 */
 		0x16, 0x10, 0x10, 0x0B, 0x36, 0x2C, 0x26, 0x24, 0x42, 0x36, /* 138 ~ 147 */
 		0x30, 0x2D, 0x4C, 0x46, 0x3D, 0x40, 0x3E, 0x42, 0x3D, 0x40, /* 148 ~ 157 */
-- 
2.11.0
