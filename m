Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:65300 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758178AbaDIKNY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 06:13:24 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so1690230eei.14
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 03:13:22 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/3] ath10k: don't wait for device init if it crashed
Date: Wed,  9 Apr 2014 12:07:07 +0200
Message-Id: <1397038028-7665-3-git-send-email-michal.kazior@tieto.com> (sfid-20140409_121330_628052_4BAEC1EC)
In-Reply-To: <1397038028-7665-1-git-send-email-michal.kazior@tieto.com>
References: <1397038028-7665-1-git-send-email-michal.kazior@tieto.com>
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
 drivers/net/wireless/ath/ath10k/pci.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index cd3b00c..8337608 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2452,6 +2452,9 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 		if (val == 0xffffffff)
 			continue;
 
+		if (val & FW_IND_EVENT_PENDING)
+			break;
+
 		if (val & FW_IND_INITIALIZED)
 			break;
 
@@ -2470,6 +2473,12 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
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

