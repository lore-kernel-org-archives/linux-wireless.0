Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43824 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751367AbdISUkX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Sep 2017 16:40:23 -0400
From: Colin King <colin.king@canonical.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k: make const array reg_hole_list static, reduces object code size
Date: Tue, 19 Sep 2017 21:40:19 +0100
Message-Id: <20170919204019.30804-1-colin.king@canonical.com> (sfid-20170919_224040_177044_F4CAD1C0)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate the read-only array reg_hole_list on the stack, instead make
it static.  Makes the object code smaller by over 200 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
  57518	  15248	      0	  72766	  11c3e	debug.o

After:
   text	   data	    bss	    dec	    hex	filename
  57218	  15344	      0	  72562	  11b72	debug.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath9k/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 01fa30117288..5a0a05abd51a 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -916,7 +916,7 @@ static int open_file_regdump(struct inode *inode, struct file *file)
 	u8 *buf;
 	int i, j = 0;
 	unsigned long num_regs, regdump_len, max_reg_offset;
-	const struct reg_hole {
+	static const struct reg_hole {
 		u32 start;
 		u32 end;
 	} reg_hole_list[] = {
-- 
2.14.1
