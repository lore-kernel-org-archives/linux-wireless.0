Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:63998 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbbATK1V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2015 05:27:21 -0500
Received: by mail-wi0-f169.google.com with SMTP id bs8so22312865wib.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2015 02:27:19 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: disable irqs after fw crash
Date: Tue, 20 Jan 2015 11:26:43 +0100
Message-Id: <1421749603-11424-1-git-send-email-michal.kazior@tieto.com> (sfid-20150120_112723_884840_8CAEFCB9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It makes little sense to keep handling irqs if fw
is dead.

This prevents multiple fw register dumps upon
crash on some devices (seen on QCA6174).

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 3b40a86..fba6618 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2047,6 +2047,7 @@ static void ath10k_msi_err_tasklet(unsigned long data)
 		return;
 	}
 
+	ath10k_pci_irq_disable(ar);
 	ath10k_pci_fw_crashed_clear(ar);
 	ath10k_pci_fw_crashed_dump(ar);
 }
@@ -2116,6 +2117,7 @@ static void ath10k_pci_tasklet(unsigned long data)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
 	if (ath10k_pci_has_fw_crashed(ar)) {
+		ath10k_pci_irq_disable(ar);
 		ath10k_pci_fw_crashed_clear(ar);
 		ath10k_pci_fw_crashed_dump(ar);
 		return;
-- 
1.8.5.3

