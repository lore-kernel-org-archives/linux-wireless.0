Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33217 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751476AbcJFRbF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Oct 2016 13:31:05 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v3 1/3] mwifiex: reset card->adapter during device unregister
Date: Thu, 6 Oct 2016 23:00:26 +0530
Message-ID: <1475775028-20306-1-git-send-email-akarwar@marvell.com> (sfid-20161006_193110_100454_B83A2ACC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

card->adapter gets initialized during device registration.
As it's not cleared, we may end up accessing invalid memory
in some corner cases. This patch fixes the problem.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v3: Same as v1 and v2
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 1 +
 drivers/net/wireless/marvell/mwifiex/sdio.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index f1eeb73..ba9e068 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -3042,6 +3042,7 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 				pci_disable_msi(pdev);
 	       }
 	}
+	card->adapter = NULL;
 }
 
 /* This function initializes the PCI-E host memory space, WCB rings, etc.
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 8718950..4cad1c2 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -2066,6 +2066,7 @@ mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 	struct sdio_mmc_card *card = adapter->card;
 
 	if (adapter->card) {
+		card->adapter = NULL;
 		sdio_claim_host(card->func);
 		sdio_disable_func(card->func);
 		sdio_release_host(card->func);
-- 
1.9.1
