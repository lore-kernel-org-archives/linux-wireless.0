Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35348 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188AbcHBLTh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 07:19:37 -0400
Received: by mail-lf0-f68.google.com with SMTP id l89so9773487lfi.2
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2016 04:19:36 -0700 (PDT)
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R . Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] ath5k: fix EEPROM dumping via debugfs
Date: Tue,  2 Aug 2016 14:19:28 +0300
Message-Id: <1470136768-28077-1-git-send-email-ryazanov.s.a@gmail.com> (sfid-20160802_132634_501952_F69F2F30)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

EEPROM size calculated in 16-bit words, so we should take into account
this fact during buffer allocation.

CC: Jiri Slaby <jirislaby@gmail.com>
CC: Nick Kossifidis <mickflemm@gmail.com>
CC: Luis R. Rodriguez <mcgrof@do-not-panic.com>
Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wireless/ath/ath5k/debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 929d7cc..4f8d9ed 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -909,7 +909,7 @@ static int open_file_eeprom(struct inode *inode, struct file *file)
 	struct ath5k_hw *ah = inode->i_private;
 	bool res;
 	int i, ret;
-	u32 eesize;
+	u32 eesize;	/* NB: in 16-bit words */
 	u16 val, *buf;
 
 	/* Get eeprom size */
@@ -932,7 +932,7 @@ static int open_file_eeprom(struct inode *inode, struct file *file)
 
 	/* Create buffer and read in eeprom */
 
-	buf = vmalloc(eesize);
+	buf = vmalloc(eesize * 2);
 	if (!buf) {
 		ret = -ENOMEM;
 		goto err;
@@ -952,7 +952,7 @@ static int open_file_eeprom(struct inode *inode, struct file *file)
 	}
 
 	ep->buf = buf;
-	ep->len = i;
+	ep->len = eesize * 2;
 
 	file->private_data = (void *)ep;
 
-- 
2.7.3

