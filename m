Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:43656 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab3J3LpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 07:45:19 -0400
Received: by mail-ee0-f44.google.com with SMTP id c4so571974eek.31
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 04:45:16 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH/RFT 07/12] ath10k: remove meaningless check
Date: Wed, 30 Oct 2013 12:42:21 +0100
Message-Id: <1383133346-8135-8-git-send-email-michal.kazior@tieto.com> (sfid-20131030_124555_682829_ED13D8F7)
In-Reply-To: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
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
index 1e430d0..5a1ac9e 100644
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

