Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:45615 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaDNH2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 03:28:48 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so6271857eei.28
        for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2014 00:28:47 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 2/3] ath10k: don't wait for device init if it crashed
Date: Mon, 14 Apr 2014 09:22:25 +0200
Message-Id: <1397460146-19450-3-git-send-email-michal.kazior@tieto.com> (sfid-20140414_092853_069847_586C19AD)
In-Reply-To: <1397460146-19450-1-git-send-email-michal.kazior@tieto.com>
References: <1397038028-7665-1-git-send-email-michal.kazior@tieto.com>
 <1397460146-19450-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When warm resetting it's possible for device to
crash during initialization. Instead of waiting 3
seconds just return failure as soon as
FW_IND_EVENT_PENDING is set.

This speeds up device bootup and recovery in some
cases.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 * add a comment before if() [Kalle]

 drivers/net/wireless/ath/ath10k/pci.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index cd3b00c..66b1f30 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2452,6 +2452,10 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 		if (val == 0xffffffff)
 			continue;
 
+		/* the device has crashed so don't bother trying anymore */
+		if (val & FW_IND_EVENT_PENDING)
+			break;
+
 		if (val & FW_IND_INITIALIZED)
 			break;
 
@@ -2470,6 +2474,12 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 		goto out;
 	}
 
+	if (val & FW_IND_EVENT_PENDING) {
+		ath10k_warn("device has crashed during init\n");
+		ret = -ECOMM;
+		goto out;
+	}
+
 	if (!(val & FW_IND_INITIALIZED)) {
 		ath10k_err("failed to receive initialized event from target: %08x\n",
 			   val);
-- 
1.8.5.3

