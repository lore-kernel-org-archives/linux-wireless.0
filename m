Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:2407 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441AbaFTEjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2014 00:39:07 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/7] mwifiex: get rid of global pointer reset_host
Date: Thu, 19 Jun 2014 21:38:54 -0700
Message-ID: <1403239138-3113-3-git-send-email-bzhao@marvell.com> (sfid-20140620_063911_803218_36662AB3)
In-Reply-To: <1403239138-3113-1-git-send-email-bzhao@marvell.com>
References: <1403239138-3113-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

As we can derive host pointer from adapter, maintaining
a global variable doesn't make sense.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 2ae4dd7..b34270d 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1916,10 +1916,10 @@ mwifiex_update_mp_end_port(struct mwifiex_adapter *adapter, u16 port)
 		port, card->mp_data_port_mask);
 }
 
-static struct mmc_host *reset_host;
-static void mwifiex_sdio_card_reset_work(struct work_struct *work)
+static void mwifiex_sdio_card_reset_work(struct mwifiex_adapter *adapter)
 {
-	struct mmc_host *target = reset_host;
+	struct sdio_mmc_card *card = adapter->card;
+	struct mmc_host *target = card->func->card->host;
 
 	/* The actual reset operation must be run outside of driver thread.
 	 * This is because mmc_remove_host() will cause the device to be
@@ -1943,20 +1943,17 @@ static void mwifiex_sdio_work(struct work_struct *work)
 
 	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET,
 			       &adapter->iface_work_flags))
-		mwifiex_sdio_card_reset_work(work);
+		mwifiex_sdio_card_reset_work(adapter);
 }
 
 /* This function resets the card */
 static void mwifiex_sdio_card_reset(struct mwifiex_adapter *adapter)
 {
-	struct sdio_mmc_card *card = adapter->card;
-
 	if (test_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &adapter->iface_work_flags))
 		return;
 
 	set_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &adapter->iface_work_flags);
 
-	reset_host = card->func->card->host;
 	schedule_work(&adapter->iface_work);
 }
 
-- 
1.8.2.3

