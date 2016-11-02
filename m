Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35514 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754604AbcKBC0A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Nov 2016 22:26:00 -0400
Received: by mail-pf0-f193.google.com with SMTP id i88so269860pfk.2
        for <linux-wireless@vger.kernel.org>; Tue, 01 Nov 2016 19:26:00 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 08/12] mwifiex: reset card->adapter during device unregister
Date: Wed,  2 Nov 2016 10:24:44 +0800
Message-Id: <1478053488-16042-6-git-send-email-huxinming820@marvell.com> (sfid-20161102_032616_517656_AE302999)
In-Reply-To: <1478053488-16042-1-git-send-email-huxinming820@marvell.com>
References: <1478053488-16042-1-git-send-email-huxinming820@marvell.com>
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

---
v2: Same as v1
---
Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 1 +
 drivers/net/wireless/marvell/mwifiex/sdio.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index b635563..04b9961 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -3017,6 +3017,7 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 			if (card->msi_enable)
 				pci_disable_msi(pdev);
 	       }
+		card->adapter = NULL;
 	}
 }
 
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 4d314c1..375d0a5 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -2070,6 +2070,7 @@ mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 	struct sdio_mmc_card *card = adapter->card;
 
 	if (adapter->card) {
+		card->adapter = NULL;
 		sdio_claim_host(card->func);
 		sdio_disable_func(card->func);
 		sdio_release_host(card->func);
-- 
1.8.1.4
