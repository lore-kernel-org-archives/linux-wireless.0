Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60331 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752399AbdBJM2E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Feb 2017 07:28:04 -0500
Subject: [PATCH v2 2/4] ath10k: add directory to board data error message
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Fri, 10 Feb 2017 14:26:44 +0200
Message-ID: <148672960431.8556.7607639090307029208.stgit@potku.adurom.net> (sfid-20170210_132809_932290_4B813503)
In-Reply-To: <148672934198.8556.5588600166627442652.stgit@potku.adurom.net>
References: <148672934198.8556.5588600166627442652.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This way user has a better idea what file exactly is missing.
This is needed when we switch to using request_firmware_direct() which doesn't
print any errors anymore.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 9674c08464ab..f395d3a98bc5 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1168,7 +1168,8 @@ static int ath10k_core_fetch_board_file(struct ath10k *ar)
 	ar->bd_api = 1;
 	ret = ath10k_core_fetch_board_data_api_1(ar);
 	if (ret) {
-		ath10k_err(ar, "failed to fetch board data\n");
+		ath10k_err(ar, "failed to fetch board-2.bin or board.bin from %s\n",
+			   ar->hw_params.fw.dir);
 		return ret;
 	}
 
