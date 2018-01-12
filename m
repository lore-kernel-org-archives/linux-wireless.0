Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:42302 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965244AbeALVIo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Jan 2018 16:08:44 -0500
Received: by mail-pf0-f195.google.com with SMTP id d23so5285036pfe.9
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jan 2018 13:08:43 -0800 (PST)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Ellie Reeves <ellierevves@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Brian Norris <briannorris@chromium.org>,
        "Signed-off-by : Xinming Hu" <huxm@marvell.com>
Subject: [PATCH 1/2] Revert "mwifiex: cancel pcie/sdio work in remove/shutdown handler"
Date: Fri, 12 Jan 2018 13:08:36 -0800
Message-Id: <20180112210837.112628-1-briannorris@chromium.org> (sfid-20180112_220906_122842_D11F2ACF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit b713bbf1471b56b572ce26bd02b81a85c2b007f4.

The "fix" in question does not actually fix all related problems, and it
also introduces new deadlock possibilities. Since commit b014e96d1abb
("PCI: Protect pci_error_handlers->reset_notify() usage with
device_lock()"), the race in question is actually resolved (PCIe reset
cannot happen at the same time as remove()). Instead, this "fix" just
introduces a deadlock where mwifiex_pcie_card_reset_work() is waiting on
device_lock, which is held by PCIe device remove(), which is waiting
on...mwifiex_pcie_card_reset_work().

The proper thing to do is just to fix the deadlock. Patch for this will
come separately.

Cc: Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 2 --
 drivers/net/wireless/marvell/mwifiex/sdio.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 23209c5cab05..f666cb2ea7e0 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -310,8 +310,6 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 		mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
 	}
 
-	cancel_work_sync(&card->work);
-
 	mwifiex_remove_card(adapter);
 }
 
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 248858723753..a82880132af4 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -399,8 +399,6 @@ mwifiex_sdio_remove(struct sdio_func *func)
 		mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
 	}
 
-	cancel_work_sync(&card->work);
-
 	mwifiex_remove_card(adapter);
 }
 
-- 
2.16.0.rc1.238.g530d649a79-goog
