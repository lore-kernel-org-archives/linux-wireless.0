Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:53633 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbaJ1JoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 05:44:08 -0400
Received: by mail-la0-f52.google.com with SMTP id hz20so235906lab.39
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2014 02:44:06 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 4/4] ath10k: don't reset chip on power_down
Date: Tue, 28 Oct 2014 10:32:08 +0100
Message-Id: <1414488728-31489-5-git-send-email-michal.kazior@tieto.com> (sfid-20141028_104417_422599_EFF25F4E)
In-Reply-To: <1414488728-31489-1-git-send-email-michal.kazior@tieto.com>
References: <1414488728-31489-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently hif_power_up performs effectively a
reset and hif_stop resets the chip as well so
there's no point in resetting here.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * this patch replaces `replace power up/down with reset callback` [Kalle]

 drivers/net/wireless/ath/ath10k/pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 117e14d..63f374ed 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1919,7 +1919,9 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
 {
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot hif power down\n");
 
-	ath10k_pci_warm_reset(ar);
+	/* Currently hif_power_up performs effectively a reset and hif_stop
+	 * resets the chip as well so there's no point in resetting here.
+	 */
 }
 
 #ifdef CONFIG_PM
-- 
1.8.5.3

