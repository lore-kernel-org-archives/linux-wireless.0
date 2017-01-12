Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:35991 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750761AbdALVCn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 16:02:43 -0500
Received: by mail-pf0-f172.google.com with SMTP id 189so18655229pfu.3
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jan 2017 13:02:43 -0800 (PST)
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 1/2] mwifiex: pcie: use posted write to wake up firmware
Date: Thu, 12 Jan 2017 13:02:31 -0800
Message-Id: <20170112210232.18554-1-briannorris@chromium.org> (sfid-20170112_220312_672441_1AAEE113)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Depending on system factors (e.g., the PCIe link PM state), the first
read to wake up the Wifi firmware can take a long time. There is no
reason to use a (blocking, non-posted) read at this point, so let's just
use a write instead. Write vs. read doesn't matter functionality-wise --
it's just a dummy operation.

This has been shown to decrease the time spent blocking in this function
on a Rockchip RK3399 SoC.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 66226c615be0..435ba879ef29 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -458,7 +458,6 @@ static void mwifiex_delay_for_sleep_cookie(struct mwifiex_adapter *adapter,
 /* This function wakes up the card by reading fw_status register. */
 static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 {
-	u32 fw_status;
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
 
@@ -468,10 +467,10 @@ static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 	if (reg->sleep_cookie)
 		mwifiex_pcie_dev_wakeup_delay(adapter);
 
-	/* Reading fw_status register will wakeup device */
-	if (mwifiex_read_reg(adapter, reg->fw_status, &fw_status)) {
+	/* Accessing fw_status register will wakeup device */
+	if (mwifiex_write_reg(adapter, reg->fw_status, 0)) {
 		mwifiex_dbg(adapter, ERROR,
-			    "Reading fw_status register failed\n");
+			    "Writing fw_status register failed\n");
 		return -1;
 	}
 
-- 
2.11.0.390.gc69c2f50cf-goog
