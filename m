Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37275 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760851AbbKTReb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2015 12:34:31 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath10k: fix board data fetch error message
Date: Fri, 20 Nov 2015 09:33:14 -0800
Message-ID: <1448040794-1139-1-git-send-email-poh@qca.qualcomm.com> (sfid-20151120_183434_852579_169EF582)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The error message order of board data fetch is board info,
directory, and then file name, hence place print arguments
in the order.

Fixes: 0a51b343abfe ("ath10k: add board 2 API support")
Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index dc4fc4e..6b5ece7 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -844,7 +844,7 @@ out:
 	if (!ar->board_data || !ar->board_len) {
 		ath10k_err(ar,
 			   "failed to fetch board data for %s from %s/%s\n",
-			   ar->hw_params.fw.dir, boardname, filename);
+			   boardname, ar->hw_params.fw.dir, filename);
 		ret = -ENODATA;
 		goto err;
 	}
-- 
1.9.1

