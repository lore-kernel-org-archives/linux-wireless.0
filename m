Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34880 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755266AbcLNONH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 09:13:07 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 5/5] mwifiex: get rid of global save_adapter and sdio_work
Date: Wed, 14 Dec 2016 19:40:51 +0530
Message-ID: <1481724651-30397-5-git-send-email-akarwar@marvell.com> (sfid-20161214_151313_788744_D35DC65B)
In-Reply-To: <1481724651-30397-1-git-send-email-akarwar@marvell.com>
References: <1481724651-30397-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch moves sdio_work to card structure, in this way we can get
adapter structure in the work, so save_adapter won't be needed.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 39 ++++++++++++++++-------------
 drivers/net/wireless/marvell/mwifiex/sdio.h |  3 +++
 2 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 0fda87a..a4b356d 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -32,10 +32,8 @@
 #define SDIO_VERSION	"1.0"
 
 static void mwifiex_sdio_work(struct work_struct *work);
-static DECLARE_WORK(sdio_work, mwifiex_sdio_work);
 
 static struct mwifiex_if_ops sdio_ops;
-static unsigned long iface_work_flags;
 
 static struct memory_type_mapping generic_mem_type_map[] = {
 	{"DUMP", NULL, 0, 0xDD},
@@ -123,6 +121,7 @@ static int mwifiex_sdio_probe_of(struct device *dev)
 		card->fw_dump_enh = data->fw_dump_enh;
 		card->can_auto_tdls = data->can_auto_tdls;
 		card->can_ext_scan = data->can_ext_scan;
+		INIT_WORK(&card->work, mwifiex_sdio_work);
 	}
 
 	sdio_claim_host(func);
@@ -388,7 +387,7 @@ static int mwifiex_check_winner_status(struct mwifiex_adapter *adapter)
 	if (!adapter || !adapter->priv_num)
 		return;
 
-	cancel_work_sync(&sdio_work);
+	cancel_work_sync(&card->work);
 
 	mwifiex_dbg(adapter, INFO, "info: SDIO func num=%d\n", func->num);
 
@@ -2190,7 +2189,6 @@ static void mwifiex_cleanup_sdio(struct mwifiex_adapter *adapter)
 		    port, card->mp_data_port_mask);
 }
 
-static struct mwifiex_adapter *save_adapter;
 static void mwifiex_sdio_card_reset_work(struct mwifiex_adapter *adapter)
 {
 	struct sdio_mmc_card *card = adapter->card;
@@ -2206,8 +2204,8 @@ static void mwifiex_sdio_card_reset_work(struct mwifiex_adapter *adapter)
 	/* Previous save_adapter won't be valid after this. We will cancel
 	 * pending work requests.
 	 */
-	clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &iface_work_flags);
-	clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &iface_work_flags);
+	clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags);
+	clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags);
 
 	mwifiex_reinit_sw(adapter);
 }
@@ -2513,35 +2511,40 @@ static void mwifiex_sdio_device_dump_work(struct mwifiex_adapter *adapter)
 
 static void mwifiex_sdio_work(struct work_struct *work)
 {
+	struct sdio_mmc_card *card =
+		container_of(work, struct sdio_mmc_card, work);
+
 	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP,
-			       &iface_work_flags))
-		mwifiex_sdio_device_dump_work(save_adapter);
+			       &card->work_flags))
+		mwifiex_sdio_device_dump_work(card->adapter);
 	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET,
-			       &iface_work_flags))
-		mwifiex_sdio_card_reset_work(save_adapter);
+			       &card->work_flags))
+		mwifiex_sdio_card_reset_work(card->adapter);
 }
 
 /* This function resets the card */
 static void mwifiex_sdio_card_reset(struct mwifiex_adapter *adapter)
 {
-	save_adapter = adapter;
-	if (test_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &iface_work_flags))
+	struct sdio_mmc_card *card = adapter->card;
+
+	if (test_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags))
 		return;
 
-	set_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &iface_work_flags);
+	set_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags);
 
-	schedule_work(&sdio_work);
+	schedule_work(&card->work);
 }
 
 /* This function dumps FW information */
 static void mwifiex_sdio_device_dump(struct mwifiex_adapter *adapter)
 {
-	save_adapter = adapter;
-	if (test_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &iface_work_flags))
+	struct sdio_mmc_card *card = adapter->card;
+
+	if (test_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags))
 		return;
 
-	set_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &iface_work_flags);
-	schedule_work(&sdio_work);
+	set_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags);
+	schedule_work(&card->work);
 }
 
 /* Function to dump SDIO function registers and SDIO scratch registers in case
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.h b/drivers/net/wireless/marvell/mwifiex/sdio.h
index afa10d5..dccf7fd 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.h
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.h
@@ -267,6 +267,9 @@ struct sdio_mmc_card {
 
 	struct mwifiex_sdio_mpa_tx mpa_tx;
 	struct mwifiex_sdio_mpa_rx mpa_rx;
+
+	struct work_struct work;
+	unsigned long work_flags;
 };
 
 struct mwifiex_sdio_device {
-- 
1.9.1
