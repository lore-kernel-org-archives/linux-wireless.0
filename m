Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:35628 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418AbcDLLqz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 07:46:55 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>,
	Christian Daudt <csd@broadcom.com>
Subject: [PATCH v2] mwifiex: fix possible NULL dereference
Date: Tue, 12 Apr 2016 17:16:37 +0530
Message-Id: <1460461597-7309-1-git-send-email-sudipm.mukherjee@gmail.com> (sfid-20160412_134719_741369_5A2D2173)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

We have a check for card just after dereferencing it. So if it is NULL
we have already dereferenced it before its check. Lets dereference it
after checking card for NULL.

Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index edf8b07..d4db9db 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2884,10 +2884,11 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg;
-	struct pci_dev *pdev = card->dev;
 	int i;
 
 	if (card) {
+		struct pci_dev *pdev = card->dev;
+
 		if (card->msix_enable) {
 			for (i = 0; i < MWIFIEX_NUM_MSIX_VECTORS; i++)
 				synchronize_irq(card->msix_entries[i].vector);
-- 
1.9.1

