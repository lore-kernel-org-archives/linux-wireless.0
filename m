Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:41255 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbbAXRrd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 12:47:33 -0500
Received: by mail-wi0-f169.google.com with SMTP id h11so2247135wiw.0
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2015 09:47:31 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: detect SPROM revision 11
Date: Sat, 24 Jan 2015 18:47:20 +0100
Message-Id: <1422121640-9227-2-git-send-email-zajec5@gmail.com> (sfid-20150124_184736_163780_A7AD9761)
In-Reply-To: <1422121640-9227-1-git-send-email-zajec5@gmail.com>
References: <1422121640-9227-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Extracting values from it is still unsupported, but at least we'll
display some meaningful error now.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/sprom.c         | 3 ++-
 include/linux/ssb/ssb_regs.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index efb037f..206edd3 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -579,7 +579,8 @@ int bcma_sprom_get(struct bcma_bus *bus)
 	u16 offset = BCMA_CC_SPROM;
 	u16 *sprom;
 	size_t sprom_sizes[] = { SSB_SPROMSIZE_WORDS_R4,
-				 SSB_SPROMSIZE_WORDS_R10, };
+				 SSB_SPROMSIZE_WORDS_R10,
+				 SSB_SPROMSIZE_WORDS_R11, };
 	int i, err = 0;
 
 	if (!bus->drv_cc.core)
diff --git a/include/linux/ssb/ssb_regs.h b/include/linux/ssb/ssb_regs.h
index f7b9100..c0f707a 100644
--- a/include/linux/ssb/ssb_regs.h
+++ b/include/linux/ssb/ssb_regs.h
@@ -173,6 +173,7 @@
 #define SSB_SPROMSIZE_BYTES_R123	(SSB_SPROMSIZE_WORDS_R123 * sizeof(u16))
 #define SSB_SPROMSIZE_BYTES_R4		(SSB_SPROMSIZE_WORDS_R4 * sizeof(u16))
 #define SSB_SPROMSIZE_WORDS_R10		230
+#define SSB_SPROMSIZE_WORDS_R11		234
 #define SSB_SPROM_BASE1			0x1000
 #define SSB_SPROM_BASE31		0x0800
 #define SSB_SPROM_REVISION		0x007E
-- 
1.8.4.5

