Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:51373 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab3JBGtB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 02:49:01 -0400
Received: by mail-ee0-f47.google.com with SMTP id d49so154554eek.6
        for <linux-wireless@vger.kernel.org>; Tue, 01 Oct 2013 23:49:00 -0700 (PDT)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 1/2] ath10k: advestise 10.X fw support on wmi_attach
Date: Wed,  2 Oct 2013 08:48:51 +0200
Message-Id: <1380696532-4147-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20131002_084908_146113_9B7496A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the WMI API has been added and we can detect from the
FW IEs what firmware variant we deal with, turn on 10.X support.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index be75571..416dabb 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1970,26 +1970,21 @@ static void ath10k_wmi_process_rx(struct ath10k *ar, struct sk_buff *skb)
 /* WMI Initialization functions */
 int ath10k_wmi_attach(struct ath10k *ar)
 {
-	int ret;
-
 	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
-		ath10k_warn("Firmware 10.X is not yet supported\n");
 		ar->wmi.cmd = &wmi_10x_cmd_map;
 		ar->wmi.vdev_param = &wmi_10x_vdev_param_map;
 		ar->wmi.pdev_param = &wmi_10x_pdev_param_map;
-		ret = -ENOTSUPP;
 	} else {
 		ar->wmi.cmd = &wmi_cmd_map;
 		ar->wmi.vdev_param = &wmi_vdev_param_map;
 		ar->wmi.pdev_param = &wmi_pdev_param_map;
-		ret = 0;
 	}
 
 	init_completion(&ar->wmi.service_ready);
 	init_completion(&ar->wmi.unified_ready);
 	init_waitqueue_head(&ar->wmi.tx_credits_wq);
 
-	return ret;
+	return 0;
 }
 
 void ath10k_wmi_detach(struct ath10k *ar)
-- 
1.7.9.5

