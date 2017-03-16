Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:35142 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752178AbdCPVgQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 17:36:16 -0400
Received: by mail-pg0-f53.google.com with SMTP id b129so31017764pgc.2
        for <linux-wireless@vger.kernel.org>; Thu, 16 Mar 2017 14:36:15 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        dmitry.torokhov@gmail.com, Amitkumar Karwar <akarwar@marvell.com>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v3] mwifiex: fix kernel crash after shutdown command timeout
Date: Thu, 16 Mar 2017 14:36:07 -0700
Message-Id: <20170316213607.62386-1-briannorris@chromium.org> (sfid-20170316_223619_320419_1C105F66)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We observed a SHUTDOWN command timeout during reboot stress test due to
a corner case firmware bug. It can lead to either a use-after-free +
OOPS (on either the adapter structure, or the 'card' structure) or an
abort (where, e.g., the PCI device is "disabled" before we're done
dumping the FW).

We can avoid this by canceling/flushing the FW dump work:

(a) after we've terminated all other work queues (e.g., for processing
    commands which could time out)
(b) after we've disabled all interrupts (which could also queue more
    work for us)
(c) after we've unregistered the netdev and wiphy structures (and
    implicitly, and debugfs entries which could manually trigger FW dumps)
(d) before we've actually disabled the device (e.g.,
    pci_device_disable())

Altogether, this means no card->work will be scheduled if we sync at
a point that satisfies the above. This can be done at the beginning of
the .cleanup_if() callback.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
v3:
 * rewrote Amit's patch, to ensure this work won't get *scheduled*
   again, pointed out by Dmitry

Amit's work:

v2:
 * New work_flag has been added to resolve the issue cleanly as per
   Brian's suggestion.
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 4 ++--
 drivers/net/wireless/marvell/mwifiex/sdio.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index a0d918094889..bfe597837985 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -294,8 +294,6 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	if (!adapter || !adapter->priv_num)
 		return;
 
-	cancel_work_sync(&card->work);
-
 	reg = card->pcie.reg;
 	if (reg)
 		ret = mwifiex_read_reg(adapter, reg->fw_status, &fw_status);
@@ -2866,6 +2864,8 @@ static void mwifiex_cleanup_pcie(struct mwifiex_adapter *adapter)
 	int ret;
 	u32 fw_status;
 
+	cancel_work_sync(&card->work);
+
 	ret = mwifiex_read_reg(adapter, reg->fw_status, &fw_status);
 	if (fw_status == FIRMWARE_READY_PCIE) {
 		mwifiex_dbg(adapter, INFO,
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index a4b356d267f9..3a52f02dc434 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -387,8 +387,6 @@ mwifiex_sdio_remove(struct sdio_func *func)
 	if (!adapter || !adapter->priv_num)
 		return;
 
-	cancel_work_sync(&card->work);
-
 	mwifiex_dbg(adapter, INFO, "info: SDIO func num=%d\n", func->num);
 
 	ret = mwifiex_sdio_read_fw_status(adapter, &firmware_stat);
@@ -2155,6 +2153,8 @@ static void mwifiex_cleanup_sdio(struct mwifiex_adapter *adapter)
 {
 	struct sdio_mmc_card *card = adapter->card;
 
+	cancel_work_sync(&card->work);
+
 	kfree(card->mp_regs);
 	kfree(card->mpa_rx.skb_arr);
 	kfree(card->mpa_rx.len_arr);
-- 
2.12.0.367.g23dc2f6d3c-goog
