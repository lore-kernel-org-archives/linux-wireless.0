Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37153 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674AbaDIKNW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 06:13:22 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so1675627eei.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 03:13:21 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/3] ath10k: differentiate between target init failures
Date: Wed,  9 Apr 2014 12:07:06 +0200
Message-Id: <1397038028-7665-2-git-send-email-michal.kazior@tieto.com> (sfid-20140409_121327_033680_70D0D6C2)
In-Reply-To: <1397038028-7665-1-git-send-email-michal.kazior@tieto.com>
References: <1397038028-7665-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This just makes it easier to tell apart different
kinds of bringup failure.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index bf1083d..cd3b00c 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2464,7 +2464,13 @@ static int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 		mdelay(10);
 	} while (time_before(jiffies, timeout));
 
-	if (val == 0xffffffff || !(val & FW_IND_INITIALIZED)) {
+	if (val == 0xffffffff) {
+		ath10k_err("failed to read device register, device is gone\n");
+		ret = -EIO;
+		goto out;
+	}
+
+	if (!(val & FW_IND_INITIALIZED)) {
 		ath10k_err("failed to receive initialized event from target: %08x\n",
 			   val);
 		ret = -ETIMEDOUT;
-- 
1.8.5.3

