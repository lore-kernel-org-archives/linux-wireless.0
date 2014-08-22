Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:57708 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269AbaHVMnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 08:43:08 -0400
Received: by mail-lb0-f171.google.com with SMTP id l4so9401670lbv.2
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 05:43:07 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/5] ath10k: update comment regarding warm reset
Date: Fri, 22 Aug 2014 14:33:15 +0200
Message-Id: <1408710798-25198-3-git-send-email-michal.kazior@tieto.com> (sfid-20140822_144312_962633_EBE70BFA)
In-Reply-To: <1408710798-25198-1-git-send-email-michal.kazior@tieto.com>
References: <1408710798-25198-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The old comment was a little out of date. HTT Rx
ring is a more relevant problem when stopping
transport layer.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * don't remove the warm_reset, instead update the comment
     * this replaces patch named `ath10k: dont reset the chip on hif_stop`

 drivers/net/wireless/ath/ath10k/pci.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 21f7dc3..daa38ce 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1243,11 +1243,10 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 	ath10k_pci_irq_disable(ar);
 	ath10k_pci_flush(ar);
 
-	/* Make the sure the device won't access any structures on the host by
-	 * resetting it. The device was fed with PCI CE ringbuffer
-	 * configuration during init. If ringbuffers are freed and the device
-	 * were to access them this could lead to memory corruption on the
-	 * host. */
+	/* Most likely the device has HTT Rx ring configured. The only way to
+	 * prevent the device from accessing (and possible corrupting) host
+	 * memory is to reset the chip now.
+	 */
 	ath10k_pci_warm_reset(ar);
 
 	ar_pci->started = 0;
-- 
1.8.5.3

