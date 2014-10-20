Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:55024 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaJTM2i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 08:28:38 -0400
Received: by mail-lb0-f169.google.com with SMTP id 10so3814576lbg.28
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 05:28:36 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 6/6] ath10k: don't reset chip on power_down
Date: Mon, 20 Oct 2014 14:14:42 +0200
Message-Id: <1413807282-27951-7-git-send-email-michal.kazior@tieto.com> (sfid-20141020_142842_458653_FBD09393)
In-Reply-To: <1413807282-27951-1-git-send-email-michal.kazior@tieto.com>
References: <1413807282-27951-1-git-send-email-michal.kazior@tieto.com>
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
index afd6056..c1a2b84 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1909,7 +1909,9 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
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

