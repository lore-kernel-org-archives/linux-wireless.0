Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:34985 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1422830AbdD1R3x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 13:29:53 -0400
Received: by mail-pf0-f181.google.com with SMTP id v14so51554646pfd.2
        for <linux-wireless@vger.kernel.org>; Fri, 28 Apr 2017 10:29:53 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] mwifiex: pcie: add card_reset() support
Date: Fri, 28 Apr 2017 10:28:47 -0700
Message-Id: <20170428172847.34888-1-briannorris@chromium.org> (sfid-20170428_193048_612269_EA9DEE53)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Similar to the SDIO driver, we should implement this so that we will
automatically reset the device whenever there's a command timeout or
similar.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
I still haven't found the reset sequence to work 100% reliably, but it's
definitely better than nothing.

 drivers/net/wireless/marvell/mwifiex/pcie.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index ac62bce50e96..aaec4fdd7777 100644
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
@@ -2845,6 +2855,18 @@ static void mwifiex_pcie_device_dump(struct mwifiex_adapter *adapter)
 	schedule_work(&card->work);
 }
 
+static void mwifiex_pcie_card_reset(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+
+	if (test_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags))
+		return;
+
+	set_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags);
+
+	schedule_work(&card->work);
+}
+
 static void mwifiex_pcie_free_buffers(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
@@ -3274,6 +3296,7 @@ static struct mwifiex_if_ops pcie_ops = {
 	.cleanup_mpa_buf =		NULL,
 	.init_fw_port =			mwifiex_pcie_init_fw_port,
 	.clean_pcie_ring =		mwifiex_clean_pcie_ring_buf,
+	.card_reset =			mwifiex_pcie_card_reset,
 	.reg_dump =			mwifiex_pcie_reg_dump,
 	.device_dump =			mwifiex_pcie_device_dump,
 	.down_dev =			mwifiex_pcie_down_dev,
-- 
2.13.0.rc0.306.g87b477812d-goog
