Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:33635 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756799AbdGYBO2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 21:14:28 -0400
Received: by mail-pf0-f177.google.com with SMTP id s70so53109386pfs.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2017 18:14:28 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 18/20] mwifiex: pcie: remove unnecessary 'pdev' check
Date: Mon, 24 Jul 2017 18:13:34 -0700
Message-Id: <20170725011336.99993-19-briannorris@chromium.org> (sfid-20170725_031731_314445_CEF56EF8)
In-Reply-To: <20170725011336.99993-1-briannorris@chromium.org>
References: <20170725011336.99993-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'card->dev' is initialized once and is never cleared. Drop the
unnecessary "safety" check, as it simply obscures things, and we don't
do this check everywhere (and therefore it's not really "safe").

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
new in v2
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index a1907e8e620f..1993b9b339df 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2958,15 +2958,12 @@ static void mwifiex_cleanup_pcie(struct mwifiex_adapter *adapter)
 				    "Failed to write driver not-ready signature\n");
 	}
 
-	if (pdev) {
-		pci_disable_device(pdev);
+	pci_disable_device(pdev);
 
-		pci_iounmap(pdev, card->pci_mmap);
-		pci_iounmap(pdev, card->pci_mmap1);
-		pci_disable_device(pdev);
-		pci_release_region(pdev, 2);
-		pci_release_region(pdev, 0);
-	}
+	pci_iounmap(pdev, card->pci_mmap);
+	pci_iounmap(pdev, card->pci_mmap1);
+	pci_release_region(pdev, 2);
+	pci_release_region(pdev, 0);
 
 	mwifiex_pcie_free_buffers(adapter);
 }
-- 
2.14.0.rc0.284.gd933b75aa4-goog
