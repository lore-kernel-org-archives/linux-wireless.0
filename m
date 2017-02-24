Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36233 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751125AbdBXN3p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 08:29:45 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: fix kernel crash after shutdown command timeout
Date: Fri, 24 Feb 2017 18:59:24 +0530
Message-ID: <1487942964-3193-1-git-send-email-akarwar@marvell.com> (sfid-20170224_142950_056098_022BEA9F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We observed a SHUTDOWN command timeout during reboot stress test due
to a corner case firmware bug. It leads to use-after-free on adapter
structure pointer and crash.

We already have a cancel_work_sync() call in teardown thread. This
issue is fixed by having this call just before mwifiex_remove_card().
At this point no further work will be scheduled.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 3 +--
 drivers/net/wireless/marvell/mwifiex/sdio.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index a0d9180..f31c5ea 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -294,8 +294,6 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	if (!adapter || !adapter->priv_num)
 		return;
 
-	cancel_work_sync(&card->work);
-
 	reg = card->pcie.reg;
 	if (reg)
 		ret = mwifiex_read_reg(adapter, reg->fw_status, &fw_status);
@@ -312,6 +310,7 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 		mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
 	}
 
+	cancel_work_sync(&card->work);
 	mwifiex_remove_card(adapter);
 }
 
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index a4b356d..9534b47 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -387,8 +387,6 @@ static int mwifiex_check_winner_status(struct mwifiex_adapter *adapter)
 	if (!adapter || !adapter->priv_num)
 		return;
 
-	cancel_work_sync(&card->work);
-
 	mwifiex_dbg(adapter, INFO, "info: SDIO func num=%d\n", func->num);
 
 	ret = mwifiex_sdio_read_fw_status(adapter, &firmware_stat);
@@ -400,6 +398,7 @@ static int mwifiex_check_winner_status(struct mwifiex_adapter *adapter)
 		mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
 	}
 
+	cancel_work_sync(&card->work);
 	mwifiex_remove_card(adapter);
 }
 
-- 
1.9.1
