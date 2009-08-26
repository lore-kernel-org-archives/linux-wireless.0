Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17576 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756673AbZHZFl0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 01:41:26 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 22:41:29 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19092.52005.977714.645846@gargle.gargle.HOWL>
Date: Wed, 26 Aug 2009 11:11:57 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Wrap DMA dump function with PS wakeup/restore
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When dumping register contents, HW has to be awake.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 9e36920..2be4c22 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -93,6 +93,8 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 	int i, qcuOffset = 0, dcuOffset = 0;
 	u32 *qcuBase = &val[0], *dcuBase = &val[4];
 
+	ath9k_ps_wakeup(sc);
+
 	REG_WRITE(ah, AR_MACMISC,
 		  ((AR_MACMISC_DMA_OBS_LINE_8 << AR_MACMISC_DMA_OBS_S) |
 		   (AR_MACMISC_MISC_OBS_BUS_1 <<
@@ -159,6 +161,8 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"AR_CR: 0x%x \n", REG_READ(ah, AR_CR));
 
+	ath9k_ps_restore(sc);
+
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
-- 
1.6.4

