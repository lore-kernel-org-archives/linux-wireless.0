Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47886 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752605AbcKRODS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 09:03:18 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v4 07/11] mwifiex: reset card->adapter during device unregister
Date: Fri, 18 Nov 2016 19:30:30 +0530
Message-ID: <1479477634-27841-7-git-send-email-akarwar@marvell.com> (sfid-20161118_150320_827555_26E0ACBE)
In-Reply-To: <1479477634-27841-1-git-send-email-akarwar@marvell.com>
References: <1479477634-27841-1-git-send-email-akarwar@marvell.com>
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

This is safe, now that we've properly synchronized suspend() and
remove() with the FW initialization thread; now that code can simply
check for 'card->adapter == NULL' and exit safely.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Tested-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
v4: Same as v1, v2, v3
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 1 +
 drivers/net/wireless/marvell/mwifiex/sdio.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 6176cb78..f6d28d9 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -3042,6 +3042,7 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 			if (card->msi_enable)
 				pci_disable_msi(pdev);
 	       }
+		card->adapter = NULL;
 	}
 }
 
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 5077d56..69542f8 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -2017,6 +2017,7 @@ static int mwifiex_alloc_sdio_mpa_buffers(struct mwifiex_adapter *adapter,
 	struct sdio_mmc_card *card = adapter->card;
 
 	if (adapter->card) {
+		card->adapter = NULL;
 		sdio_claim_host(card->func);
 		sdio_disable_func(card->func);
 		sdio_release_host(card->func);
-- 
1.9.1
