Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36692 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755182AbcLNONH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 09:13:07 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 4/5] mwifiex: get rid of __mwifiex_sdio_remove helper
Date: Wed, 14 Dec 2016 19:40:50 +0530
Message-ID: <1481724651-30397-4-git-send-email-akarwar@marvell.com> (sfid-20161214_151311_977178_EDEF5711)
In-Reply-To: <1481724651-30397-1-git-send-email-akarwar@marvell.com>
References: <1481724651-30397-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

__mwifiex_sdio_remove helper is not needed after
our enhancements in SDIO card reset.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index b3aca10..0fda87a 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -370,7 +370,7 @@ static int mwifiex_check_winner_status(struct mwifiex_adapter *adapter)
  * This function removes the interface and frees up the card structure.
  */
 static void
-__mwifiex_sdio_remove(struct sdio_func *func)
+mwifiex_sdio_remove(struct sdio_func *func)
 {
 	struct sdio_mmc_card *card;
 	struct mwifiex_adapter *adapter;
@@ -388,6 +388,8 @@ static int mwifiex_check_winner_status(struct mwifiex_adapter *adapter)
 	if (!adapter || !adapter->priv_num)
 		return;
 
+	cancel_work_sync(&sdio_work);
+
 	mwifiex_dbg(adapter, INFO, "info: SDIO func num=%d\n", func->num);
 
 	ret = mwifiex_sdio_read_fw_status(adapter, &firmware_stat);
@@ -402,13 +404,6 @@ static int mwifiex_check_winner_status(struct mwifiex_adapter *adapter)
 	mwifiex_remove_card(adapter);
 }
 
-static void
-mwifiex_sdio_remove(struct sdio_func *func)
-{
-	cancel_work_sync(&sdio_work);
-	__mwifiex_sdio_remove(func);
-}
-
 /*
  * SDIO suspend.
  *
-- 
1.9.1
