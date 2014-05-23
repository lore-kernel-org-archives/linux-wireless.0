Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:42150 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbaEWKf7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 06:35:59 -0400
Received: by mail-ee0-f53.google.com with SMTP id c13so3468956eek.40
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 03:35:58 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/3] ath10k: remove unnecessary tasklet_kill()
Date: Fri, 23 May 2014 12:28:46 +0200
Message-Id: <1400840927-14272-3-git-send-email-michal.kazior@tieto.com> (sfid-20140523_123605_847730_1EE49A3B)
In-Reply-To: <1400840927-14272-1-git-send-email-michal.kazior@tieto.com>
References: <1400767955-16313-1-git-send-email-michal.kazior@tieto.com>
 <1400840927-14272-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The tasklet is already guaranteed to be killed on
the teardown path.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * split from another patch [Kalle]

 drivers/net/wireless/ath/ath10k/pci.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 7d72b9c..dadf4ce 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2758,8 +2758,6 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
 	if (!ar_pci)
 		return;
 
-	tasklet_kill(&ar_pci->msi_fw_err);
-
 	ath10k_core_unregister(ar);
 	ath10k_pci_free_ce(ar);
 
-- 
1.8.5.3

