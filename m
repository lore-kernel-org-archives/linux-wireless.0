Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:35890 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933279AbdELQmf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 12:42:35 -0400
Received: by mail-pg0-f49.google.com with SMTP id x64so13284200pgd.3
        for <linux-wireless@vger.kernel.org>; Fri, 12 May 2017 09:42:34 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 11/11] mwifiex: pcie: stop setting/clearing 'surprise_removed'
Date: Fri, 12 May 2017 09:42:08 -0700
Message-Id: <20170512164208.38725-11-briannorris@chromium.org> (sfid-20170512_184320_928251_B845FEA5)
In-Reply-To: <20170512164208.38725-1-briannorris@chromium.org>
References: <20170512164208.38725-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are already handled by mwifiex_shutdown_sw() and
mwifiex_reinit_sw(). Ideally, we'll kill the flag entirely eventually,
as I suspect it breeds race conditions.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index d7e563a622f7..da042d15f8f0 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -370,7 +370,6 @@ static void mwifiex_pcie_reset_notify(struct pci_dev *pdev, bool prepare)
 		 * PCIe and HW.
 		 */
 		mwifiex_shutdown_sw(adapter);
-		adapter->surprise_removed = true;
 		clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags);
 		clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags);
 	} else {
@@ -378,7 +377,6 @@ static void mwifiex_pcie_reset_notify(struct pci_dev *pdev, bool prepare)
 		 * after performing FLR respectively. Reconfigure the software
 		 * and firmware including firmware redownload
 		 */
-		adapter->surprise_removed = false;
 		ret = mwifiex_reinit_sw(adapter);
 		if (ret) {
 			dev_err(&pdev->dev, "reinit failed: %d\n", ret);
-- 
2.13.0.rc2.291.g57267f2277-goog
