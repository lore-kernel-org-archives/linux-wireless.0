Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44463 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751342AbdCPK3X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 06:29:23 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <dmitry.torokhov@gmail.com>,
        <briannorris@chromium.org>, Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2] mwifiex: fix kernel crash after shutdown command timeout
Date: Thu, 16 Mar 2017 15:58:52 +0530
Message-ID: <1489660132-27352-1-git-send-email-akarwar@marvell.com> (sfid-20170316_112926_654604_08DD1863)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We observed a SHUTDOWN command timeout during reboot stress test
due to a corner case firmware bug. It leads to use-after-free on
adapter structure pointer and crash.

Let's add MWIFIEX_IFACE_WORK_DONT_RUN work flag to avoid executing
any work scheduled after cancel_work_sync() call in teardown path
to resolve the issue.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v2: New work_flag has been added to resolve the issue cleanly as per
Brian's suggestion.
---
 drivers/net/wireless/marvell/mwifiex/main.h | 1 +
 drivers/net/wireless/marvell/mwifiex/pcie.c | 4 ++++
 drivers/net/wireless/marvell/mwifiex/sdio.c | 4 ++++
 3 files changed, 9 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 5c82972..d5b1fd6 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -510,6 +510,7 @@ struct mwifiex_roc_cfg {
 enum mwifiex_iface_work_flags {
 	MWIFIEX_IFACE_WORK_DEVICE_DUMP,
 	MWIFIEX_IFACE_WORK_CARD_RESET,
+	MWIFIEX_IFACE_WORK_DONT_RUN,
 };
 
 struct mwifiex_private {
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index a0d9180..bb3d798 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -294,6 +294,7 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	if (!adapter || !adapter->priv_num)
 		return;
 
+	set_bit(MWIFIEX_IFACE_WORK_DONT_RUN, &card->work_flags);
 	cancel_work_sync(&card->work);
 
 	reg = card->pcie.reg;
@@ -2721,6 +2722,9 @@ static void mwifiex_pcie_work(struct work_struct *work)
 	struct pcie_service_card *card =
 		container_of(work, struct pcie_service_card, work);
 
+	if (test_bit(MWIFIEX_IFACE_WORK_DONT_RUN, &card->work_flags))
+		return;
+
 	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP,
 			       &card->work_flags))
 		mwifiex_pcie_device_dump_work(card->adapter);
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index a4b356d..8140bb4 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -387,6 +387,7 @@ static int mwifiex_check_winner_status(struct mwifiex_adapter *adapter)
 	if (!adapter || !adapter->priv_num)
 		return;
 
+	set_bit(MWIFIEX_IFACE_WORK_DONT_RUN, &card->work_flags);
 	cancel_work_sync(&card->work);
 
 	mwifiex_dbg(adapter, INFO, "info: SDIO func num=%d\n", func->num);
@@ -2514,6 +2515,9 @@ static void mwifiex_sdio_work(struct work_struct *work)
 	struct sdio_mmc_card *card =
 		container_of(work, struct sdio_mmc_card, work);
 
+	if (test_bit(MWIFIEX_IFACE_WORK_DONT_RUN, &card->work_flags))
+		return;
+
 	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP,
 			       &card->work_flags))
 		mwifiex_sdio_device_dump_work(card->adapter);
-- 
1.9.1
