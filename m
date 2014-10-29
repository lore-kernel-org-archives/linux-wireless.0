Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29378 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934256AbaJ2Psp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 11:48:45 -0400
Date: Wed, 29 Oct 2014 18:48:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	kernel-janitors@vger.kernel.org
Subject: [patch] ath9k: fix some debugfs output
Message-ID: <20141029154805.GC5290@mwanda> (sfid-20141029_164859_514487_752484C9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The right shift operation has higher precedence than the mask so we
left shift by "(i * 3)" and then immediately right shift by "(i * 3)"
then we mask.  It should be left shift, mask, and then right shift.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 2a2a17d..c9afc15 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -455,7 +455,7 @@ static ssize_t read_file_dma(struct file *file, char __user *user_buf,
 			 "%2d          %2x      %1x     %2x           %2x\n",
 			 i, (*qcuBase & (0x7 << qcuOffset)) >> qcuOffset,
 			 (*qcuBase & (0x8 << qcuOffset)) >> (qcuOffset + 3),
-			 val[2] & (0x7 << (i * 3)) >> (i * 3),
+			 (val[2] & (0x7 << (i * 3))) >> (i * 3),
 			 (*dcuBase & (0x1f << dcuOffset)) >> dcuOffset);
 	}
 
