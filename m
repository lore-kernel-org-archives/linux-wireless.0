Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42739 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750998AbcKPNKU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 08:10:20 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v3 4/5] mwifiex: wait firmware dump complete during card remove process
Date: Wed, 16 Nov 2016 18:39:08 +0530
Message-ID: <1479301749-14803-4-git-send-email-akarwar@marvell.com> (sfid-20161116_141023_142639_3214011D)
In-Reply-To: <1479301749-14803-1-git-send-email-akarwar@marvell.com>
References: <1479301749-14803-1-git-send-email-akarwar@marvell.com>
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
v3: same as [v2,5/5]. The improvement of 'moving pcie_work to card struct'
suggested by Brian is taken care in next patch.
---
 drivers/net/wireless/marvell/mwifiex/pcie.c |  6 +++++-
 drivers/net/wireless/marvell/mwifiex/sdio.c | 15 ++++++++++++---
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index dd8f7aa..c8e69a4 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -51,6 +51,9 @@ static int mwifiex_pcie_probe_of(struct device *dev)
 	return 0;
 }
 
+static void mwifiex_pcie_work(struct work_struct *work);
+static DECLARE_WORK(pcie_work, mwifiex_pcie_work);
+
 static int
 mwifiex_map_pci_memory(struct mwifiex_adapter *adapter, struct sk_buff *skb,
 		       size_t size, int flags)
@@ -254,6 +257,8 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	if (!adapter || !adapter->priv_num)
 		return;
 
+	cancel_work_sync(&pcie_work);
+
 	if (user_rmmod && !adapter->mfg_mode) {
 		mwifiex_deauthenticate_all(adapter);
 
@@ -2722,7 +2727,6 @@ static void mwifiex_pcie_work(struct work_struct *work)
 		mwifiex_pcie_device_dump_work(save_adapter);
 }
 
-static DECLARE_WORK(pcie_work, mwifiex_pcie_work);
 /* This function dumps FW information */
 static void mwifiex_pcie_device_dump(struct mwifiex_adapter *adapter)
 {
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 16d1d30..78f2cc9 100644
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
 
@@ -220,7 +223,7 @@ static int mwifiex_sdio_resume(struct device *dev)
  * This function removes the interface and frees up the card structure.
  */
 static void
-mwifiex_sdio_remove(struct sdio_func *func)
+__mwifiex_sdio_remove(struct sdio_func *func)
 {
 	struct sdio_mmc_card *card;
 	struct mwifiex_adapter *adapter;
@@ -249,6 +252,13 @@ static int mwifiex_sdio_resume(struct device *dev)
 	mwifiex_remove_card(adapter);
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
@@ -2227,7 +2237,7 @@ static void mwifiex_recreate_adapter(struct sdio_mmc_card *card)
 	 * discovered and initializes them from scratch.
 	 */
 
-	mwifiex_sdio_remove(func);
+	__mwifiex_sdio_remove(func);
 
 	/*
 	 * Normally, we would let the driver core take care of releasing these.
@@ -2568,7 +2578,6 @@ static void mwifiex_sdio_work(struct work_struct *work)
 		mwifiex_sdio_card_reset_work(save_adapter);
 }
 
-static DECLARE_WORK(sdio_work, mwifiex_sdio_work);
 /* This function resets the card */
 static void mwifiex_sdio_card_reset(struct mwifiex_adapter *adapter)
 {
-- 
1.9.1
