Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47438 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755183AbcJ0JNz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Oct 2016 05:13:55 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2 5/5] mwifiex: wait firmware dump complete during card remove process
Date: Thu, 27 Oct 2016 14:42:43 +0530
Message-ID: <1477559563-18328-5-git-send-email-akarwar@marvell.com> (sfid-20161027_111536_791543_0A2B3A61)
In-Reply-To: <1477559563-18328-1-git-send-email-akarwar@marvell.com>
References: <1477559563-18328-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Wait for firmware dump complete in card remove function.
For sdio interface, there are two diffenrent cases,
card reset trigger sdio_work and firmware dump trigger sdio_work.
Do code rearrangement for distinguish between these two cases.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v2: 1. Get rid of reset_triggered flag. Instead split the code and use
    __mwifiex_sdio_remove() (Brian Norris/Dmitry Torokhov)
    2. "v1 4/5 mwifiex: firmware dump code rearrangement.." is dropped. So
    rebased accordingly.
---
 drivers/net/wireless/marvell/mwifiex/pcie.c |  6 +++++-
 drivers/net/wireless/marvell/mwifiex/sdio.c | 15 ++++++++++++---
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 9025af7..6c421ad 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -37,6 +37,9 @@ static struct mwifiex_if_ops pcie_ops;
 
 static struct semaphore add_remove_card_sem;
 
+static void mwifiex_pcie_work(struct work_struct *work);
+static DECLARE_WORK(pcie_work, mwifiex_pcie_work);
+
 static int
 mwifiex_map_pci_memory(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 		       size_t size, int flags)
@@ -249,6 +252,8 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	if (!adapter || !adapter->priv_num)
 		return;
 
+	cancel_work_sync(&pcie_work);
+
 	if (user_rmmod && !adapter->mfg_mode) {
 #ifdef CONFIG_PM_SLEEP
 		if (adapter->is_suspended)
@@ -2716,7 +2721,6 @@ static void mwifiex_pcie_work(struct work_struct *work)
 		mwifiex_pcie_device_dump_work(save_adapter);
 }
 
-static DECLARE_WORK(pcie_work, mwifiex_pcie_work);
 /* This function dumps FW information */
 static void mwifiex_pcie_device_dump(struct mwifiex_adapter *adapter)
 {
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 241d2b3..5d84c563 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -46,6 +46,9 @@
  */
 static u8 user_rmmod;
 
+static void mwifiex_sdio_work(struct work_struct *work);
+static DECLARE_WORK(sdio_work, mwifiex_sdio_work);
+
 static struct mwifiex_if_ops sdio_ops;
 static unsigned long iface_work_flags;
 
@@ -275,7 +278,7 @@ static int mwifiex_sdio_resume(struct device *dev)
  * This function removes the interface and frees up the card structure.
  */
 static void
-mwifiex_sdio_remove(struct sdio_func *func)
+__mwifiex_sdio_remove(struct sdio_func *func)
 {
 	struct sdio_mmc_card *card;
 	struct mwifiex_adapter *adapter;
@@ -305,6 +308,13 @@ mwifiex_sdio_remove(struct sdio_func *func)
 	mwifiex_remove_card(card->adapter, &add_remove_card_sem);
 }
 
+static void
+mwifiex_sdio_remove(struct sdio_func *func)
+{
+	cancel_work_sync(&sdio_work);
+	__mwifiex_sdio_remove(func);
+}
+
 /*
  * SDIO suspend.
  *
@@ -2290,7 +2300,7 @@ static void mwifiex_recreate_adapter(struct sdio_mmc_card *card)
 	 * discovered and initializes them from scratch.
 	 */
 
-	mwifiex_sdio_remove(func);
+	__mwifiex_sdio_remove(func);
 
 	/* power cycle the adapter */
 	sdio_claim_host(func);
@@ -2623,7 +2633,6 @@ static void mwifiex_sdio_work(struct work_struct *work)
 		mwifiex_sdio_card_reset_work(save_adapter);
 }
 
-static DECLARE_WORK(sdio_work, mwifiex_sdio_work);
 /* This function resets the card */
 static void mwifiex_sdio_card_reset(struct mwifiex_adapter *adapter)
 {
-- 
1.9.1
