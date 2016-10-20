Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53903 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935962AbcJTN0p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Oct 2016 09:26:45 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <briannorris@google.com>, <dmitry.torokhov@gmail.com>,
        Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v5 1/4] mwifiex: reset card->adapter during device unregister
Date: Thu, 20 Oct 2016 18:56:16 +0530
Message-ID: <1476969979-28554-1-git-send-email-akarwar@marvell.com> (sfid-20161020_152648_827540_544F37FE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

card->adapter gets initialized in mwifiex_register_dev(). As it's not
cleared in mwifiex_unregister_dev(), we may end up accessing the memory
which is already free in below scenario.

Scenario: Driver initialization is failed due to incorrect firmware or
some other reason. Meanwhile device reboot/unload occurs.

Please note that we have 'add_remove_card_sem' semaphore. So if there
is a race betweem init and remove threads, they will execute one after
another. This patch ensures that "card->adapter" is set to NULL when
all cleanup is performed in init failure thread. Later remove thread
can return immediately if "card->adapter" is NULL

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v4: Same as v1, v2, v3
v5: Patch description is updated to get clear picture. There is no race
for init and remove threads as per design. This patch just adds missing
"card->adapter= NULL" change to avoid accessing already freed memory which
leads to a crash.
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 1 +
 drivers/net/wireless/marvell/mwifiex/sdio.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 063c707..302ffd1 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -3021,6 +3021,7 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 			if (card->msi_enable)
 				pci_disable_msi(pdev);
 	       }
+		card->adapter = NULL;
 	}
 }
 
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
