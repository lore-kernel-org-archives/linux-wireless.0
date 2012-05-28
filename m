Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34453 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab2E1GVa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 02:21:30 -0400
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath6kl: Fix typo in htc mbox debug print msg
Date: Mon, 28 May 2012 11:51:13 +0530
Message-ID: <1338186073-4986-2-git-send-email-rmani@qca.qualcomm.com> (sfid-20120528_082132_501774_33FCC508)
In-Reply-To: <1338186073-4986-1-git-send-email-rmani@qca.qualcomm.com>
References: <1338186073-4986-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Add missing ZERO (x%x to 0x%x) in the format specifier
while printing hex value in htc module.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc_mbox.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
index 2798624..cd0e1ba 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
@@ -1309,7 +1309,7 @@ static int ath6kl_htc_rx_packet(struct htc_target *target,
 	}
 
 	ath6kl_dbg(ATH6KL_DBG_HTC,
-		   "htc rx 0x%p hdr x%x len %d mbox 0x%x\n",
+		   "htc rx 0x%p hdr 0x%x len %d mbox 0x%x\n",
 		   packet, packet->info.rx.exp_hdr,
 		   padded_len, dev->ar->mbox_info.htc_addr);
 
-- 
1.7.1

