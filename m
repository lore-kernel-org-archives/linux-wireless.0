Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57570 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab2ALJcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 04:32:22 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 1/2] ath6kl: Remove useless initialization in ath6kl_read_fwlogs()
Date: Thu, 12 Jan 2012 15:01:48 +0530
Message-ID: <1326360708-9362-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20120112_103232_503809_F75D4323)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

ath6kl_read_fwlogs() assigns the value zero to the variable 'ret'
at the time of declaration. Later, return value of ath6kl_diag_read32()
repalces the init value. Hence removing useless zero assignment.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index eea3c74..51baec4 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -252,7 +252,7 @@ int ath6kl_read_fwlogs(struct ath6kl *ar)
 	struct ath6kl_dbglog_hdr debug_hdr;
 	struct ath6kl_dbglog_buf debug_buf;
 	u32 address, length, dropped, firstbuf, debug_hdr_addr;
-	int ret = 0, loop;
+	int ret, loop;
 	u8 *buf;
 
 	buf = kmalloc(ATH6KL_FWLOG_PAYLOAD_SIZE, GFP_KERNEL);
-- 
1.7.1

