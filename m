Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:36469 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbdEASpz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 May 2017 14:45:55 -0400
Received: by mail-pf0-f173.google.com with SMTP id q66so33751913pfi.3
        for <linux-wireless@vger.kernel.org>; Mon, 01 May 2017 11:45:54 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 2/2] mwifiex: pcie: add card_reset() support
Date: Mon,  1 May 2017 11:45:49 -0700
Message-Id: <20170501184549.52896-2-briannorris@chromium.org> (sfid-20170501_204559_452981_80062981)
In-Reply-To: <20170501184549.52896-1-briannorris@chromium.org>
References: <20170501184549.52896-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Similar to the SDIO driver, we should implement this so that we will
automatically reset the device whenever there's a command timeout or
similar.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
v2: use atomic test/set, based on Dmitry's suggestion
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 8e7d6f41a952..78688ff6ecd0 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2822,6 +2822,13 @@ static void mwifiex_pcie_device_dump_work(struct mwifiex_adapter *adapter)
 	mwifiex_upload_device_dump(adapter, drv_info, drv_info_size);
 }
 
+static void mwifiex_pcie_card_reset_work(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+
+	pci_reset_function(card->dev);
+}
+
 static void mwifiex_pcie_work(struct work_struct *work)
 {
 	struct pcie_service_card *card =
@@ -2830,6 +2837,9 @@ static void mwifiex_pcie_work(struct work_struct *work)
 	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP,
 			       &card->work_flags))
 		mwifiex_pcie_device_dump_work(card->adapter);
+	if (test_and_clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET,
+			       &card->work_flags))
+		mwifiex_pcie_card_reset_work(card->adapter);
 }
 
 /* This function dumps FW information */
@@ -3279,6 +3289,7 @@ static struct mwifiex_if_ops pcie_ops = {
 	.cleanup_mpa_buf =		NULL,
 	.init_fw_port =			mwifiex_pcie_init_fw_port,
 	.clean_pcie_ring =		mwifiex_clean_pcie_ring_buf,
+	.card_reset =			mwifiex_pcie_card_reset,
 	.reg_dump =			mwifiex_pcie_reg_dump,
 	.device_dump =			mwifiex_pcie_device_dump,
 	.down_dev =			mwifiex_pcie_down_dev,
-- 
2.13.0.rc0.306.g87b477812d-goog
