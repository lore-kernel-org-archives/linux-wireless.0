Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63078 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab2BNPDE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 10:03:04 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 1/2] ath6kl: Fix missing release of semaphore in ath6kl_stop_txrx()
Date: Tue, 14 Feb 2012 20:32:59 +0530
Message-ID: <1329231780-18929-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120214_160309_869976_0AF72F42)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes smatch warning "inconsistent returns sem:&ar->sem".

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 72f1b4f..6fed628 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1733,5 +1733,7 @@ void ath6kl_stop_txrx(struct ath6kl *ar)
 	ath6kl_reset_device(ar, ar->target_type, true, true);
 
 	clear_bit(WLAN_ENABLED, &ar->flag);
+
+	up(&ar->sem);
 }
 EXPORT_SYMBOL(ath6kl_stop_txrx);
-- 
1.7.0.4

