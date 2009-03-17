Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2117 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbZCQDEv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 23:04:51 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/2] ath5k: remove dummy PCI "retry timeout" fix
Date: Mon, 16 Mar 2009 22:34:03 -0400
Message-Id: <1237257243-18660-2-git-send-email-me@bobcopeland.com> (sfid-20090317_040454_856801_6A596DF4)
In-Reply-To: <1237257243-18660-1-git-send-email-me@bobcopeland.com>
References: <1237257243-18660-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the PCI retry timeout code, for all the same reasons that
Luis Rodriguez removed it for ath9k (wireless-testing commit
3149fde1bf083d32d5190cdc7f2bf8d0035966b1).

Changes-licensed-under: 3-Clause-BSD

Cc: Luis Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 8eec155..ef9825f 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -685,13 +685,6 @@ ath5k_pci_resume(struct pci_dev *pdev)
 	if (err)
 		return err;
 
-	/*
-	 * Suspend/Resume resets the PCI configuration space, so we have to
-	 * re-disable the RETRY_TIMEOUT register (0x41) to keep
-	 * PCI Tx retries from interfering with C3 CPU state
-	 */
-	pci_write_config_byte(pdev, 0x41, 0);
-
 	err = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
 	if (err) {
 		ATH5K_ERR(sc, "request_irq failed\n");
-- 
1.6.0.6


