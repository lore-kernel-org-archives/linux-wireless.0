Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15058 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441AbaFTEjK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2014 00:39:10 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/7] mwifiex: use generic 'iface_work' workqueue for SDIO interface
Date: Thu, 19 Jun 2014 21:38:53 -0700
Message-ID: <1403239138-3113-2-git-send-email-bzhao@marvell.com> (sfid-20140620_063913_976786_7B608B8A)
In-Reply-To: <1403239138-3113-1-git-send-email-bzhao@marvell.com>
References: <1403239138-3113-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Existing dedicated card_reset work queue is replaced with the
interface specific workqueue pointer provided by mwifiex module.
Also new work flag is added for card reset task.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.h |  1 +
 drivers/net/wireless/mwifiex/sdio.c | 24 ++++++++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 24791e2..582a9f9 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -431,6 +431,7 @@ enum rdwr_status {
 
 enum mwifiex_iface_work_flags {
 	MWIFIEX_IFACE_WORK_FW_DUMP,
+	MWIFIEX_IFACE_WORK_CARD_RESET,
 };
 
 struct mwifiex_adapter;
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 4ce3d7b..2ae4dd7 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -179,6 +179,8 @@ mwifiex_sdio_remove(struct sdio_func *func)
 	if (!adapter || !adapter->priv_num)
 		return;
 
+	cancel_work_sync(&adapter->iface_work);
+
 	if (user_rmmod) {
 		if (adapter->is_suspended)
 			mwifiex_sdio_resume(adapter->dev);
@@ -1915,7 +1917,7 @@ mwifiex_update_mp_end_port(struct mwifiex_adapter *adapter, u16 port)
 }
 
 static struct mmc_host *reset_host;
-static void sdio_card_reset_worker(struct work_struct *work)
+static void mwifiex_sdio_card_reset_work(struct work_struct *work)
 {
 	struct mmc_host *target = reset_host;
 
@@ -1933,15 +1935,29 @@ static void sdio_card_reset_worker(struct work_struct *work)
 	mdelay(20);
 	mmc_add_host(target);
 }
-static DECLARE_WORK(card_reset_work, sdio_card_reset_worker);
+
+static void mwifiex_sdio_work(struct work_struct *work)
+{
+	struct mwifiex_adapter *adapter =
+			container_of(work, struct mwifiex_adapter, iface_work);
+
+	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET,
+			       &adapter->iface_work_flags))
+		mwifiex_sdio_card_reset_work(work);
+}
 
 /* This function resets the card */
 static void mwifiex_sdio_card_reset(struct mwifiex_adapter *adapter)
 {
 	struct sdio_mmc_card *card = adapter->card;
 
+	if (test_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &adapter->iface_work_flags))
+		return;
+
+	set_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &adapter->iface_work_flags);
+
 	reset_host = card->func->card->host;
-	schedule_work(&card_reset_work);
+	schedule_work(&adapter->iface_work);
 }
 
 static struct mwifiex_if_ops sdio_ops = {
@@ -1964,6 +1980,7 @@ static struct mwifiex_if_ops sdio_ops = {
 	.cmdrsp_complete = mwifiex_sdio_cmdrsp_complete,
 	.event_complete = mwifiex_sdio_event_complete,
 	.card_reset = mwifiex_sdio_card_reset,
+	.iface_work = mwifiex_sdio_work,
 };
 
 /*
@@ -2001,7 +2018,6 @@ mwifiex_sdio_cleanup_module(void)
 	/* Set the flag as user is removing this module. */
 	user_rmmod = 1;
 
-	cancel_work_sync(&card_reset_work);
 	sdio_unregister_driver(&mwifiex_sdio);
 }
 
-- 
1.8.2.3

