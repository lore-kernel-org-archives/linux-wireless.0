Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:54904 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202AbaHGJO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 05:14:29 -0400
Received: by mail-we0-f171.google.com with SMTP id p10so3911690wes.16
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2014 02:14:28 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/5] ath10k: dont reset the chip on hif_stop
Date: Thu,  7 Aug 2014 11:05:05 +0200
Message-Id: <1407402308-29899-3-git-send-email-michal.kazior@tieto.com> (sfid-20140807_111434_654849_05534452)
In-Reply-To: <1407402308-29899-1-git-send-email-michal.kazior@tieto.com>
References: <1407402308-29899-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The copy engine structures are never changed until
driver unregisters the device so it is not
necessary to reset the device chip anymore when
stopping.

This reduces driver register time approx. by 200ms.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 7efcf8e..6a5ca9e 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1192,13 +1192,6 @@ static void ath10k_pci_hif_stop(struct ath10k *ar)
 
 	ath10k_pci_buffer_cleanup(ar);
 
-	/* Make the sure the device won't access any structures on the host by
-	 * resetting it. The device was fed with PCI CE ringbuffer
-	 * configuration during init. If ringbuffers are freed and the device
-	 * were to access them this could lead to memory corruption on the
-	 * host. */
-	ath10k_pci_warm_reset(ar);
-
 	ar_pci->started = 0;
 }
 
-- 
1.8.5.3

