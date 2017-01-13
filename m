Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:32878 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751513AbdAMXfu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 18:35:50 -0500
Received: by mail-pf0-f172.google.com with SMTP id y143so38055962pfb.0
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2017 15:35:50 -0800 (PST)
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 1/3] mwifiex: pcie: use posted write to wake up firmware
Date: Fri, 13 Jan 2017 15:35:36 -0800
Message-Id: <20170113233538.36196-1-briannorris@chromium.org> (sfid-20170114_003623_440307_6F4EAEA1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Depending on system factors (e.g., the PCIe link PM state), the first
read to wake up the Wifi firmware can take a long time. There is no
reason to use a (blocking, non-posted) read at this point, so let's just
use a write instead. Write vs. read doesn't matter functionality-wise --
it's just a dummy operation. But let's make sure to re-write with the
correct "ready" signature, since we check for that in other parts of the
driver.

This has been shown to decrease the time spent blocking in this function
on RK3399.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
v2:
 * write FIRMWARE_READY_PCIE instead of 0
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 66226c615be0..3f4cda2d3b61 100644
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
+	if (mwifiex_write_reg(adapter, reg->fw_status, FIRMWARE_READY_PCIE)) {
 		mwifiex_dbg(adapter, ERROR,
-			    "Reading fw_status register failed\n");
+			    "Writing fw_status register failed\n");
 		return -1;
 	}
 
-- 
2.11.0.483.g087da7b7c-goog
