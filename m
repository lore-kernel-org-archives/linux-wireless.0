Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32847 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935508AbcKXB1C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 20:27:02 -0500
Received: by mail-pf0-f194.google.com with SMTP id 144so1181929pfv.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2016 17:27:02 -0800 (PST)
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Wed, 23 Nov 2016 17:26:57 -0800
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Zhaoyang Liu <liuzy@marvell.com>,
        Bing Zhao <bzhao@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Avinash Patil <patila@marvell.com>
Subject: [PATCH v2 6/7] mwifiex: Removed unused 'pkt_type' variable
Message-ID: <34137703e30c2578ba138261d825874a753c88e4.1479950323.git.kirtika@google.com> (sfid-20161124_022706_616167_F44BBEA8)
References: <cover.1479950323.git.kirtika@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <cover.1479950323.git.kirtika@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 92263a841b15 introduced mwifiex_deaggr_sdio_pkt which initializes
variable pkt_type but does not use it. Compiling with W=1 gives the following
warning, fix it.
mwifiex/sdio.c: In function ‘mwifiex_deaggr_sdio_pkt’:
mwifiex/sdio.c:1198:6: warning: variable ‘pkt_type’ set but not used [-Wunused-but-set-variable]

Fixes: 92263a841b15 ("mwifiex: add SDIO rx single port aggregation")
Cc: Zhaoyang Liu <liuzy@marvell.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kirtika Ruchandani <kirtika@google.com>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 6c9f16e..09c586f 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -1134,7 +1134,6 @@ static void mwifiex_deaggr_sdio_pkt(struct mwifiex_adapter *adapter,
 {
 	u32 total_pkt_len, pkt_len;
 	struct sk_buff *skb_deaggr;
-	u32 pkt_type;
 	u16 blk_size;
 	u8 blk_num;
 	u8 *data;
@@ -1155,8 +1154,6 @@ static void mwifiex_deaggr_sdio_pkt(struct mwifiex_adapter *adapter,
 			break;
 		}
 		pkt_len = le16_to_cpu(*(__le16 *)(data + SDIO_HEADER_OFFSET));
-		pkt_type = le16_to_cpu(*(__le16 *)(data + SDIO_HEADER_OFFSET +
-					 2));
 		if ((pkt_len + SDIO_HEADER_OFFSET) > blk_size) {
 			mwifiex_dbg(adapter, ERROR,
 				    "%s: error in pkt_len,\t"
-- 
2.8.0.rc3.226.g39d4020
