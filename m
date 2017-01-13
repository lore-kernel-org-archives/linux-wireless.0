Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:53571 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752064AbdAMPfx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 10:35:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Brian Norris <briannorris@chromium.org>,
        Xinming Hu <huxm@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Shengzhen Li <szli@marvell.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mwifiex: fix uninitialized variable access in pcie_remove
Date: Fri, 13 Jan 2017 16:35:03 +0100
Message-Id: <20170113153534.2617372-1-arnd@arndb.de> (sfid-20170113_163616_787898_88A555B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Checking the firmware status from PCIe register only works
if the register is available, otherwise we end up with
random behavior:

drivers/net/wireless/marvell/mwifiex/pcie.c: In function 'mwifiex_pcie_remove':
drivers/net/wireless/marvell/mwifiex/pcie.c:585:5: error: 'fw_status' may be used uninitialized in this function [-Werror=maybe-uninitialized]

This makes sure we treat the absence of the register as a failure.

Fixes: 045f0c1b5e26 ("mwifiex: get rid of global user_rmmod flag")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 031141663fc0..eebc68caecdd 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -581,6 +581,8 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	reg = card->pcie.reg;
 	if (reg)
 		ret = mwifiex_read_reg(adapter, reg->fw_status, &fw_status);
+	else
+		fw_status = -1;
 
 	if (fw_status == FIRMWARE_READY_PCIE && !adapter->mfg_mode) {
 		mwifiex_deauthenticate_all(adapter);
-- 
2.9.0
