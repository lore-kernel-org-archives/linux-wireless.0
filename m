Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:23837 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab2KPMvV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 07:51:21 -0500
To: <ath6kl-devel@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	wei-jen jlin <jenlin@qca.qualcomm.com>
Subject: [PATCH 1/8] ath6kl: Remove erroneous flag clearing
Date: Fri, 16 Nov 2012 18:21:12 +0530
Message-ID: <1353070272-5865-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20121116_135125_588392_5175D509)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

WLAN_ENABLED is vif specific, not part of
the driver's struct ath6kl. Proper clearing
of this flag is already taken care in
ath6kl_cleanup_vif.

Cc: wei-jen jlin <jenlin@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 424676e..4fddf12 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1798,8 +1798,6 @@ void ath6kl_stop_txrx(struct ath6kl *ar)
 		   "attempting to reset target on instance destroy\n");
 	ath6kl_reset_device(ar, ar->target_type, true, true);
 
-	clear_bit(WLAN_ENABLED, &ar->flag);
-
 	up(&ar->sem);
 }
 EXPORT_SYMBOL(ath6kl_stop_txrx);
-- 
1.7.0.4

