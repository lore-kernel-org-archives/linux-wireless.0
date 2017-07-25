Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:34005 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756780AbdGYBOY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 21:14:24 -0400
Received: by mail-pf0-f174.google.com with SMTP id q85so53114763pfq.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2017 18:14:23 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 14/20] mwifiex: pcie: remove unnecessary masks
Date: Mon, 24 Jul 2017 18:13:30 -0700
Message-Id: <20170725011336.99993-15-briannorris@chromium.org> (sfid-20170725_032027_193201_B1CFE18C)
In-Reply-To: <20170725011336.99993-1-briannorris@chromium.org>
References: <20170725011336.99993-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After removing the interrupt loop in commit 5d5ddb5e0d9b ("mwifiex:
pcie: don't loop/retry interrupt status checks"), we don't need to keep
track of the cleared interrupts (actually, we didn't need to do that
before, but we *really* don't need to now).

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
new in v2
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 5c07edd4e094..2f4da08f127c 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2460,28 +2460,24 @@ static int mwifiex_process_pcie_int(struct mwifiex_adapter *adapter)
 	}
 
 	if (pcie_ireg & HOST_INTR_DNLD_DONE) {
-		pcie_ireg &= ~HOST_INTR_DNLD_DONE;
 		mwifiex_dbg(adapter, INTR, "info: TX DNLD Done\n");
 		ret = mwifiex_pcie_send_data_complete(adapter);
 		if (ret)
 			return ret;
 	}
 	if (pcie_ireg & HOST_INTR_UPLD_RDY) {
-		pcie_ireg &= ~HOST_INTR_UPLD_RDY;
 		mwifiex_dbg(adapter, INTR, "info: Rx DATA\n");
 		ret = mwifiex_pcie_process_recv_data(adapter);
 		if (ret)
 			return ret;
 	}
 	if (pcie_ireg & HOST_INTR_EVENT_RDY) {
-		pcie_ireg &= ~HOST_INTR_EVENT_RDY;
 		mwifiex_dbg(adapter, INTR, "info: Rx EVENT\n");
 		ret = mwifiex_pcie_process_event_ready(adapter);
 		if (ret)
 			return ret;
 	}
 	if (pcie_ireg & HOST_INTR_CMD_DONE) {
-		pcie_ireg &= ~HOST_INTR_CMD_DONE;
 		if (adapter->cmd_sent) {
 			mwifiex_dbg(adapter, INTR,
 				    "info: CMD sent Interrupt\n");
-- 
2.14.0.rc0.284.gd933b75aa4-goog
