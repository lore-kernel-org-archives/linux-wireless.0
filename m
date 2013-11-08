Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:38448 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab3KHHEu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 02:04:50 -0500
Received: by mail-ee0-f45.google.com with SMTP id l10so150211eei.18
        for <linux-wireless@vger.kernel.org>; Thu, 07 Nov 2013 23:04:49 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 07/13] ath10k: remove meaningless check
Date: Fri,  8 Nov 2013 08:01:29 +0100
Message-Id: <1383894095-27998-8-git-send-email-michal.kazior@tieto.com> (sfid-20131108_080457_139274_CBF79EF9)
In-Reply-To: <1383894095-27998-1-git-send-email-michal.kazior@tieto.com>
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
 <1383894095-27998-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The check doesn't make much sense. If the address
were to be 0x0000 the check would fail. In this
case a 0 address isn't wrong.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 4aa7992..62df0dd 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2307,9 +2307,6 @@ static void ath10k_pci_device_reset(struct ath10k *ar)
 	int i;
 	u32 val;
 
-	if (!SOC_GLOBAL_RESET_ADDRESS)
-		return;
-
 	ath10k_pci_reg_write32(ar, PCIE_SOC_WAKE_ADDRESS,
 			       PCIE_SOC_WAKE_V_MASK);
 	for (i = 0; i < ATH_PCI_RESET_WAIT_MAX; i++) {
-- 
1.8.4.rc3

