Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35033 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbbCBJK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 04:10:26 -0500
Received: by lbjf15 with SMTP id f15so696397lbj.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2015 01:10:25 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/3] ath10k: re-enable pci device upon resume
Date: Mon,  2 Mar 2015 10:09:04 +0100
Message-Id: <1425287344-30594-3-git-send-email-michal.kazior@tieto.com> (sfid-20150302_101034_780337_34D9FC4B)
In-Reply-To: <1425287344-30594-1-git-send-email-michal.kazior@tieto.com>
References: <1425287344-30594-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This balances out pci_disable_device() from
ath10k_pci_hif_suspend().

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index d06b264..1295345 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2079,6 +2079,12 @@ static int ath10k_pci_hif_resume(struct ath10k *ar)
 		return ret;
 	}
 
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		ath10k_err(ar, "failed to enable pci device: %d\n", ret);
+		return ret;
+	}
+
 	pci_restore_state(pdev);
 
 	/* Suspend/Resume resets the PCI configuration space, so we have to
-- 
1.8.5.3

